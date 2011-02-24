#!/bin/bash

base_dir="/tmp/CORRUPTIMATOR/test01"
corrupt_images_dir="$base_dir/01_all_corrupted_since_20101209"
timestamped_images_dir="$base_dir/02_all_timestamped"
log_dir="$base_dir/logs"
timestamped_image_log="$log_dir/timestamps-and-filenames.txt"

# Create directories if not present
if [ ! -d "$timestamped_images_dir" ]; then
  mkdir -p "$timestamped_images_dir"
fi
if [ ! -d "$log_dir" ]; then
  mkdir -p "$log_dir"
fi

# Clean all images to remove illegal characters from filenames
shopt -s extglob; 
cd "$corrupt_images_dir"
for file in *; do
  file_clean=${file//[^[:alnum:]_.]/_}; 
  echo "Renaming $file --> $file_clean"
  mv "$file" "$file_clean"
done
cd ..

