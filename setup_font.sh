#!/bin/bash


if [[ -z "$1" ]]
then
    echo "Please enter a URL to download font from: "
    read URL
else
    URL="$1"
fi

DL_ZIP=~/Downloads/new_fonts

echo "Downloading fonts..."
wget "$URL" -O "$DL_ZIP"

echo "Unzipping..."
unzip $DL_ZIP -d ~/.fonts

echo "Updating the font cache..."
fc-cache -fv

echo "Removing download zip..."
rm "$DL_ZIP"



