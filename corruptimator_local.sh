#!/bin/bash

if [ $# -eq 0 ]  # Must have command-line args to demo script.
then
  echo "Usage: $0 number-of-images-to-process"
  exit -1
fi 


base_dir="/Volumes/Recyclism/Benjamin/CORRUPT/corrupt_uploads"
corrupt_images_dir="$base_dir/allcorrupted"
timestamped_images_dir="$base_dir/corruptimator/images-timestamped"
sequenced_images_dir="$base_dir/corruptimator/images-sequenced"
log_dir="$base_dir/corruptimator/logs"
timestamped_image_log="$log_dir/timestamps-and-filenames.txt"
imgcount=$1

# Create directories if not present
if [ ! -d "$image_sequence_dir" ]; then
  mkdir -p "$image_sequence_dir"
fi
if [ ! -d "$log_dir" ]; then
  mkdir -p "$log_dir"
fi

# Get timestamp for each corrupted image if log file is not present
if [ ! -e "$timestamped_image_log" ]; then
  echo "Getting timestamps from corrupt images in $corrupt_images_dir"
  cd "$corrupt_images_dir"
  find . -type f -name '[0-9]\.jpg' | while read file
  do 
    timestamp=`gdate -r "$file" +%Y%M%d-%H%M%S`
    filename=`echo $file | sed 's/\.\///g'`
    entry="$timestamp,$filename"
    echo $entry
    echo $entry >> "$timestamped_image_log"
  done

fi

# Create timestamped images (symbolic links to corrupt images, so no extra disk space needed)
let counter=0
while read line; do

  echo $counter
  ((counter++))
  #timestamp="${line:0:15}"
  #echo "Timestamp: $timestamp"

  #source_image=`echo "${line:16}" | sed 's:[0-9]\{8\}-[0-9]\{6\},::g'`
  #echo "Source: $source_image"

  #image_no=`echo "${source_image}" | sed 's/.*\/\([0-9]\{1\}\)\.jpg$/\1/g'`
  #echo "Image no: $image_no"

  #target_image="${timestamp}-${image_no}.jpg"
  #echo "Target: $target_image"

  #echo "Linking $source_image to\r\t\t $target_image"
  #ln -s "${source_image}" "${timestamped_images_dir}/${target_image}"

done < "$timestamped_image_log"

#ls "$source_images_dir" | sed -e '/-corrupted/!d' > "$log_dir/corrupted-images-folders-list.txt"

#find "$source_images_dir" -type f -name '[0-9]\.jpg' | awk 'echo "`gdate -r "${source_images_dir}/${clean_folder_name}" +%Y%M%d-%I%M%S`

