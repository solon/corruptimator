#!/bin/bash

#if [ $# -eq 0 ]  # Must have command-line args to demo script.
#then
#  echo "Usage: $0 number-of-images-to-process"
#  exit -1
#fi 


base_dir="/Volumes/Recyclism/Benjamin/CORRUPT/corrupt_uploads"
corrupt_images_dir="$base_dir/allcorrupted"
timestamped_images_dir="$base_dir/corruptimator/images_timestamped"
resized_images_dir="$base_dir/corruptimator/images_resized"
sequenced_images_dir="$base_dir/corruptimator/images_sequenced"
log_dir="$base_dir/corruptimator/logs"
timestamped_image_log="$log_dir/timestamps-and-filenames.txt"
imgcount=$1

# Create directories if not present
if [ ! -d "$timestamped_images_dir" ]; then
  mkdir -p "$timestamped_images_dir"
fi
if [ ! -d "$resized_images_dir" ]; then
  mkdir -p "$resized_images_dir"
fi
if [ ! -d "$sequenced_images_dir" ]; then
  mkdir -p "$sequenced_images_dir"
fi
if [ ! -d "$log_dir" ]; then
  mkdir -p "$log_dir"
fi

# Clean all images to remove illegal characters from filenames
#shopt -s extglob; 
#cd "$corrupt_images_dir"
#for file in *; do
#  file_clean=${file//[^[:alnum:]_.]/_}; 
#  echo "Renaming $file --> $file_clean"
#  mv "$file" "$file_clean"
#done
#cd ..

# Get timestamp for each corrupted image if log file is not present
#if [ ! -e "$timestamped_image_log" ]; then
#  echo "Getting timestamps from corrupt images in $corrupt_images_dir"
#  cd "$corrupt_images_dir"
#  find . -type f -name '[0-9]\.jpg' | while read file
#  do 
#    timestamp=`gdate -r "$file" +%Y%m%d-%H%M%S`
#    filename=`echo $file | sed 's/\.\///g'`
#    entry="$timestamp,$filename"
#    echo $entry
#    echo $entry >> "$timestamped_image_log"
#  done
#fi

# Create timestamped images (symbolic links to corrupt images, so no extra disk space needed)
N=0
cat "$timestamped_image_log" | while read line; do 
  N=$((N+1))

  #echo "Line $N = $LINE"

  timestamp="${line:0:15}"
  #echo "Timestamp: $timestamp"

  source_image=`echo "${line:16}" | sed 's:[0-9]\{8\}-[0-9]\{6\},::g'`
  #echo "Source: $source_image"

  image_no=`echo "${source_image}" | sed 's/.*\/\([0-9]\{1\}\)\.jpg$/\1/g'`
  #echo "Image no: $image_no"

  target_image="${timestamp}-${image_no}.jpg"
  #echo "Target: $target_image"

  output_path="${timestamped_images_dir}/${target_image}"

  # Gracefully accept any number of duplicated image timestamps
  # and append a counter to the end of the filename
  COUNTER=0
  while [ -e "$output_path" ]; do
    #echo "***************** FILE EXISTS ********************"
    # if we have image-4_1.jpg this will strip it to image-4
    #echo "OUTPUT = "$output_path
    output_path=${timestamp}$COUNTER-${image_no}.jpg
    COUNTER=$((COUNTER+1))
  done

  echo "$N  Linking $source_image to $output_path"
  ln -s "$corrupt_images_dir/$source_image" "$output_path"

done 


# Image conversion
cd $timestamped_images_dir
for img in * ; do

  # Have we already processed this image?
  if [ -e "$resized_images_dir/$img" ]; then

    echo "Already processed $img"
    
  else

    w=`identify -quiet -ping -format "%w" "$img"`
    h=`identify -quiet -ping -format "%h" "$img"`
    echo "Processing image: "$img" "$w"x"$h

    if [ $w -gt $h ]
    then
      aspect='portrait'
    else
      aspect='landscape'
    fi

    function deleteimage() {
      E_PARAM_ERR=-199
      E_FILEMISSING_ERR=-198
      if [ -z "$1" ]; then
        return $E_PARAM_ERR
      else
        if [ ! -e "$1" ]; then
          echo "Cannot delete, file not found: $1"
          return $E_FILEMISSING_ERR
        else
          echo "Deleting $1"
          rm "$1"
        fi
      fi
    }

    # if we get any errors when trying to convert the image, delete the image
    #trap "deleteimage $img" ERR

    echo "Converting $timestamped_images_dir/$img --> $resized_images_dir/$img"
    convert "$timestamped_images_dir/$img" -resize 1024x768^ -gravity center -extent 1024x768 -filter point "$resized_images_dir/$img" 

    # clear the trap
    #trap - ERR

  fi

done
cd ..

#ls "$source_images_dir" | sed -e '/-corrupted/!d' > "$log_dir/corrupted-images-folders-list.txt"

#find "$source_images_dir" -type f -name '[0-9]\.jpg' | awk 'echo "`gdate -r "${source_images_dir}/${clean_folder_name}" +%Y%M%d-%I%M%S`

