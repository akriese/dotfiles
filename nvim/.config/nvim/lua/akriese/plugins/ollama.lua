-- Ollama for Avante
-- Ollama API Documentation https://github.com/ollama/ollama/blob/main/docs/api.md#generate-a-completion
-- implementation suggested in https://github.com/yetone/avante.nvim/issues/1149
local role_map = {
    user = "user",
    assistant = "assistant",
    system = "system",
    tool = "tool",
}

---@param tool AvanteLLMTool
---@return AvanteOpenAITool
local transform_tool = function(tool)
    local input_schema_properties = {}
    local required = {}
    for _, field in ipairs(tool.param.fields) do
        input_schema_properties[field.name] = {
            type = field.type,
            description = field.description,
        }
        if not field.optional then
            table.insert(required, field.name)
        end
    end
    local res = {
        type = "function",
        ["function"] = {
            name = tool.name,
            description = tool.description,
        },
    }
    if vim.tbl_count(input_schema_properties) > 0 then
        res["function"].parameters = {
            type = "object",
            properties = input_schema_properties,
            required = required,
            additionalProperties = false,
        }
    end
    return res
end

---@param opts AvantePromptOptions
local parse_messages = function(self, opts)
    local messages = {}
    local has_images = opts.image_paths and #opts.image_paths > 0
    -- Ensure opts.messages is always a table
    local msg_list = opts.messages or {}
    -- Convert Avante messages to Ollama format
    for _, msg in ipairs(msg_list) do
        local role = role_map[msg.role] or "assistant"
        local content = msg.content or "" -- Default content to empty string
        -- Handle multimodal content if images are present
        -- *Experimental* not tested
        if has_images and role == "user" then
            local message_content = {
                role = role,
                content = content,
                images = {},
            }
            for _, image_path in ipairs(opts.image_paths) do
                local base64_content = vim.fn.system(string.format("base64 -w 0 %s", image_path)):gsub("\n", "")
                table.insert(message_content.images, "data:image/png;base64," .. base64_content)
            end
            table.insert(messages, message_content)
        else
            table.insert(messages, {
                role = role,
                content = content,
            })
        end
    end

    if opts.tool_histories then
        for _, tool_history in ipairs(opts.tool_histories) do
            table.insert(messages, {
                role = role_map["assistant"],
                tool_calls = {
                    {
                        id = tool_history.tool_use.id,
                        type = "function",
                        ["function"] = {
                            name = tool_history.tool_use.name,
                            arguments = vim.json.decode(tool_history.tool_use.input_json),
                        },
                    },
                },
            })
            local result_content = tool_history.tool_result.content or ""
            table.insert(messages, {
                role = "tool",
                tool_call_id = tool_history.tool_result.tool_use_id,
                content = tool_history.tool_result.is_error and "Error: " .. result_content or result_content,
            })
        end
    end

    return messages
end

local function parse_curl_args(self, code_opts)
    -- Create the messages array starting with the system message
    local messages = {
        { role = "system", content = code_opts.system_prompt },
    }
    -- Extend messages with the parsed conversation messages
    vim.list_extend(messages, self:parse_messages(code_opts))
    -- Construct options separately for clarity
    local options = {
        num_ctx = (self.options and self.options.num_ctx) or 4096,
        temperature = code_opts.temperature or (self.options and self.options.temperature) or 0,
    }
    -- Check if tools table is empty
    -- local tools = (code_opts.tools and next(code_opts.tools)) and code_opts.tools or nil
    local user_question = messages[#messages].content
    local first_word = string.lower(string.match(user_question, "\n(%a+)"))

    -- whitelist for prompts using tools, will grow over time
    local tool_keywords = { "replace", "add", "refactor", "fetch", "reason", "generate", "search" }

    local tools = nil
    local stream = true
    if code_opts.tools and vim.tbl_contains(tool_keywords, first_word) then
        tools = {}
        for _, tool in ipairs(code_opts.tools) do
            table.insert(tools, transform_tool(tool))
        end
        -- dont stream when using tools (see https://github.com/yetone/avante.nvim/issues/1149#issuecomment-2661287476)
        stream = false
    end

    -- Return the final request table
    return {
        url = self.endpoint .. "/api/chat",
        headers = {
            Accept = "application/json",
            ["Content-Type"] = "application/json",
        },
        body = {
            model = self.model,
            messages = messages,
            options = options,
            tools = tools, -- Optional tool support
            stream = stream, -- Keep streaming enabled
        },
    }
end

local function parse_response_without_stream(data, _, handler_opts)
    local json_data = vim.fn.json_decode(data)
    if json_data then
        if json_data.message then
            local content = json_data.message.content
            if content and content ~= "" then
                handler_opts.on_chunk(content)
                -- call a second time to prevent single-chunk-bug
                -- https://github.com/yetone/avante.nvim/issues/1149#issuecomment-2692750133
                handler_opts.on_chunk("")
            end
        end
        -- Handle tool calls if present
        if json_data.message.tool_calls then
            local ctx = {
                reason = "tool_use",
            }
            ctx.tool_use_list = {}

            for id, tool_call in ipairs(json_data.message.tool_calls) do
                local tool_use = {
                    name = tool_call["function"].name,
                    id = id,
                    input_json = vim.json.encode(tool_call["function"].arguments),
                }
                table.insert(ctx.tool_use_list, tool_use)
            end

            handler_opts.on_stop(ctx)
            return
        end
        if json_data.done then
            handler_opts.on_stop({ reason = json_data.done_reason or "stop" })
            return
        end
    end
end

-- buffering chunks as avante struggles with increasing content length rendering.
-- instead we collect many chunks and add them to the displayed content as bulk.
-- this avoid avante having to rerender the markdown on each received token.
local buffer_chunks = {}
local function parse_stream_data(data, handler_opts)
    local json_data = vim.fn.json_decode(data)
    if json_data then
        if json_data.done then
            handler_opts.on_chunk(table.concat(buffer_chunks))
            buffer_chunks = {}
            handler_opts.on_stop({ reason = json_data.done_reason or "stop" })
            return
        end
        if json_data.message then
            local content = json_data.message.content
            if content and content ~= "" then
                table.insert(buffer_chunks, content)
                -- at ~40 tokens per second, this will make avante render once per second
                if #buffer_chunks > 40 then
                    handler_opts.on_chunk(table.concat(buffer_chunks))
                    buffer_chunks = {}
                end
            end
        end
        -- Handle tool calls if present
        if json_data.tool_calls then
            for _, tool in ipairs(json_data.tool_calls) do
                handler_opts.on_tool(tool)
            end
        end
    end
end

local M = {}
---@type AvanteProvider
M.ollama = {
    endpoint = "http://127.0.0.1:11434",
    model = "qwen2.5-coder:14b",
    options = {
        num_ctx = 4096,
        temperature = 0,
    },
    parse_messages = parse_messages,
    parse_curl_args = parse_curl_args,
    parse_response_without_stream = parse_response_without_stream,
    parse_stream_data = parse_stream_data,
}

return M
