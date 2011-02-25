#!/bin/bash

base_dir="/tmp/CORRUPTIMATOR"
sequenced_images_dir="$base_dir/04_all_sequenced/1024x576"
video_dir="$base_dir/05_video"
log_dir="$base_dir/logs"

if [ ! -d "$video_dir" ]; then
  mkdir -p "$video_dir"
fi

# Use ffmpeg to create a movie from the image sequence 
# '-r 24' indicates 24fps

#ffmpeg -f image2 -r 24 -i "$sequenced_images_dir"/img%08d.jpg -vcodec copy -sameq "$video_dir"/output.mpg

# MP4 high quality
ffmpeg -r 24 -b 1800 -i "$sequenced_images_dir"/img%08d.jpg "$video_dir"/corrupt.mp4
