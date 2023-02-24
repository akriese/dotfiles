# in VS Dev Powershell

# Make sure to be in the correct directory
#cd $HOME\Documents\neovim
# and execute this script from there
# To make it executable, do something like
# $env:PSExecutionPolicyPreference="Bypass"

$neovim_dir = $pwd

$env:DEPS_BUILD_DIR = "$neovim_dir\.deps\"
$env:LUAJIT_LIBRARY = "${env:DEPS_BUILD_DIR}usr\lib\luajit.lib"
$install_dir = "C:\tools\nvim_build\"
# echo $env:LUAJIT_LIBRARY $env:CMAKE_INSTALL_PREFIX

$build_dir="$neovim_dir\build\debug"

# load visual studio env variables
vsdevcmd.bat -arch=x64 -no_logo

# create dependency dir
cmake -S cmake.deps -B "$env:DEPS_BUILD_DIR" -G Ninja

# build dependencies
cmake --build "$env:DEPS_BUILD_DIR" -DCMAKE_C_COMPILER=clang

# prepare build dir; for some reason, the luajit.lib path has to be explicitly passed...
cmake -DCMAKE_INSTALL_PREFIX="$install_dir" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=clang -DCMAKE_C_FLAGS=-w -B $build_dir

# build
cmake --build $build_dir -DCMAKE_C_COMPILER=clang

# install the build
cmake --install $build_dir

# test some test file
# cmake -E env TEST_FILE=.\test\functional\vimscript\exepath_spec.lua cmake --build $build_dir --target functionaltest

