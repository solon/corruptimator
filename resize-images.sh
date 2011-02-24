#!/bin/bash

base_dir="/tmp/CORRUPTIMATOR"
timestamped_images_dir="$base_dir/02_all_timestamped"
resized_images_dir="$base_dir/03_all_resized/1024x576"
log_dir="$base_dir/logs"
timestamped_image_log="$log_dir/timestamps-and-filenames.txt"
imgcount=$1

# Create directories if not present
if [ ! -d "$base_dir" ]; then
  mkdir -p "$base_dir"
fi
if [ ! -d "$timestamped_images_dir" ]; then
  mkdir -p "$timestamped_images_dir"
fi
if [ ! -d "$resized_images_dir" ]; then
  mkdir -p "$resized_images_dir"
fi
if [ ! -d "$log_dir" ]; then
  mkdir -p "$log_dir"
fi

# Image conversion
cd $timestamped_images_dir
for img in * ; do

  # Have we already processed this image?
  if [ -e "$resized_images_dir/$img" ]; then
    echo "Already processed $img"
  else

    w=`identify -quiet -ping -format %w $img`
    h=`identify -quiet -ping -format %h $img`
    echo "Processing image: "$img" "$w"x"$h

    if [[ "$w" -gt "5000" ]] || [[ "$h" -gt "5000" ]]; then
      echo "Spurious dimensions detected in image. Deleting $img"
      rm $img
    else

      function deleteimage() {
        E_PARAM_ERR=-199
        E_FILEMISSING_ERR=-198
        if [ -z "$1" ]; then
          return $E_PARAM_ERR
        else
          if [ ! -e "$1" ]; then
            #echo "Cannot delete, file not found: $1"
            return $E_FILEMISSING_ERR
          else
            echo "Deleting $1"
            rm "$1"
          fi
        fi
      }

      # if we get any errors when trying to convert the image, delete the image
      trap "deleteimage $img" ERR

      echo "Converting $timestamped_images_dir/$img --> $resized_images_dir/$img"
      # Allow 7 seconds for conversion, kill it if it's stalled
      timeout3 -t 7 convert "$timestamped_images_dir/$img" -resize 1024x576^ -gravity center -extent 1024x576 -filter point "$resized_images_dir/$img" 

      # clear the trap
      trap - ERR
    fi

  fi

done
cd ..

