#!/bin/bash
# This script will copy images from an input path and organize them in to folders
# Set the variables here:
DELETE=false # Delete the image after successful copy

# Make sure an input folder is given
if [ -z $1 ]; then
 
    FILEPATHS="./"
    
else

    FILEPATHS=$("pwd")/

fi
# Get list of file from argument
# Get the path and add a forward slash if needed
i=$((${#FILEPATHS}-1))
if [ "${FILEPATHS:$i:1}" != "/" ]; then
     FILEPATHS="$FILEPATHS/"
fi

# Scan for file types listed below
for FILE in $FILEPATHS{*.jpg,*.awr,*.JPG,*.jpeg,*.JPEG,*.mp4,*.mov,*.mts,*.MTS}; do
	# Don't include the file types that didn't match
	if [[ ! $FILE =~ '*' ]]; then
        		
        # Fix file dates of MTP transfers
        DATE=$(exiftool -p '$CreateDate' "$FILE" | sed 's/[: ]//g')
        touch -t $(echo $DATE | sed 's/\(..$\)/\.\1/') "$FILE"

        # Check date time of in file
        FILEDATE=$(stat -c %y "$FILE" | awk -F" " '{print $1}')
        FILETIME=$(stat -c %y "$FILE" | awk -F" " '{print $2}')
        FILENAME="${FILE##*/}"
        FILETYPE="${FILE##*.}"
        OUTPATH="./$FILEDATE"
        if [ "$FILETYPE" = "mov" ] ; then

        if [ ! -d "video" ]; then
            mkdir "video"
        fi
            OUTPATH="./video/$FILEDATE"
        fi
        if [ "$FILETYPE" = "mp4" ] ; then

        if [ ! -d "video" ]; then
            mkdir "video"
        fi
            OUTPATH="./video/$FILEDATE"
        fi
        # Check if the directory exist
        if [ ! -d "$OUTPATH" ]; then
            mkdir "$OUTPATH"
        fi
        
        if [ "$DELETE" = true ]; then
            mv -iv "$FILE" "$OUTPATH/$FILENAME"
        else
            # Copy using -a so the attributes are copied
            cp -avi "$FILE" "$OUTPATH/$FILENAME"
        fi
    fi
	 
done
