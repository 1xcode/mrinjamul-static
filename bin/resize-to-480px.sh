#!/bin/bash

# Copyright (c) 2023 <mrinjamul@gmail.com>

# Functions
control_c() {
    #kill $PID
    exit
}

# function to check if imagemagick is installed
check_imagemagick() {
    if ! hash convert 2>/dev/null; then
        echo "ImageMagick is not installed. Please install it and try again."
        exit 1
    fi
}

# get extension name from a file
get_extension() {
    local filename="$1"
    local extension="${filename##*.}"
    echo "$extension"
}
# get filename without extension from a file
get_filename() {
    local filename="$1"
    local filename_no_ext="${filename%.*}"
    echo "$filename_no_ext"
}



main () {
    # declare -p toa=()
    toa=()
    # Get all *.jpg and store toa variable
    mapfile -t toa < <(find . -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.bmp" -o -name "*.JPG" -o -name "*.JPEG" -o -name "*.PNG" -o -name "*.GIF" -o -name "*.BMP")
    array_length=${#toa[@]}
    echo "Found $array_length images"
    # Trap keyboard interrupt (control-c)
    trap control_c SIGINT
    # Loop through all files in toa variable
    for file in "${toa[@]}"
    do
        # Echo the file name is processing
        echo "Processing $file"
        # Get the file name
        filename=$(get_filename "$file")
        # Get the file extension
        extension=$(get_extension "$file")
        # The file extension convert into
        fextension="png"

        # Convert image to 480px size with filename 'filename_small.fextension'
        convert "$file" -resize 480x480 "$filename"_small."$fextension"
    done

    # Check if error occurred
    if [ $? -eq 0 ]; then
        echo "Conversion successful"
    else
        echo "Conversion failed"
    fi

    # Prompt user to confirm removal of original files
    read -p "Remove original files? (y/n) " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        # Loop through all files in toa variable
        for file in "${toa[@]}"
        do
            # Remove the original file
            rm -v "$file"
        done
    fi
}

# Check if imagemagick is installed
check_imagemagick
# if imagemagick is not installed, exit
if [ $? -eq 0 ]; then
    # Run main function
    main
fi
