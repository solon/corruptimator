#!/bin/bash

base_dir="/tmp/CORRUPTIMATOR"
corrupt_images_dir="$base_dir/01_all_corrupted"
timestamped_images_dir="$base_dir/02_all_timestamped"
log_dir="$base_dir/logs"
timestamped_image_log="$log_dir/timestamps-and-filenames.txt"
imgcount=$1

# Create directories if not present
if [ ! -d "$timestamped_images_dir" ]; then
  mkdir -p "$timestamped_images_dir"
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
    timestamp=`gdate -r "$file" +%Y%m%d-%H%M%S`
    filename=`echo $file | sed 's/\.\///g'`
    entry="$timestamp,$filename"
    echo $entry
    echo $entry >> "$timestamped_image_log"
  done
fi

# Create timestamped images (symbolic links to corrupt images to conserve disk space)
N=0
cat "$timestamped_image_log" | while read line; do 
  N=$((N+1))

  timestamp="${line:0:15}"
  #echo "Timestamp: $timestamp"

  source_image=`echo "${line:16}" | sed 's:[0-9]\{8\}-[0-9]\{6\},::g'`
  #echo "Source: $source_image"

  image_no=`echo "${source_image}" | sed 's/.*\/\([0-9]\{1\}\)\.jpg$/\1/g'`
  #echo "Image no: $image_no"

  target_image="${timestamp}-${image_no}.jpg"
  #echo "Target: $target_image"

  # Gracefully accept any number of duplicated image timestamps
  # and append a counter to the end of the filename
  COUNTER=0
  while [ -e "${timestamped_images_dir}/${target_image}" ]; do
    #echo "***************** FILE EXISTS ********************"
    # if we have image-4_1.jpg this will strip it to image-4
    #echo "OUTPUT = "$output_path
    target_image=${timestamp}$COUNTER-${image_no}.jpg
    COUNTER=$((COUNTER+1))
  done

  echo "$N  Linking $corrupt_images_dir/$source_image to $target_image"
  ln -s "$corrupt_images_dir/$source_image" "${timestamped_images_dir}/$target_image"

done 
