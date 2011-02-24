#!/bin/bash

base_dir="/tmp/CORRUPTIMATOR/test01"
sequenced_images_dir="$base_dir/04_all_sequenced/1024x768"
video_dir="$base_dir/05_video"
log_dir="$base_dir/logs"

if [ ! -d "$video_dir" ]; then
  mkdir -p "$video_dir"
fi

# Use ffmpeg to create a movie from the image sequence 
# '-r 10' indicates 10fps
#ffmpeg -f image2 -r 10 -i "$sequenced_images_dir"/img%08d.jpg -vcodec copy -sameq "$video_dir"/output.mpg
#ffmpeg -r 5 -b 1800 -i "$sequenced_images_dir"/img%08d.jpg "$video_dir"/test_5fps_1800kbps.mp4
#ffmpeg -r 10 -b 1800 -i "$sequenced_images_dir"/img%08d.jpg "$video_dir"/test_10fps_1800kbps.mp4
#ffmpeg -r 15 -b 1800 -i "$sequenced_images_dir"/img%08d.jpg "$video_dir"/test_15fps_1800kbps.mp4
#ffmpeg -r 20 -b 1800 -i "$sequenced_images_dir"/img%08d.jpg "$video_dir"/test_20fps_1800kbps.mp4
#ffmpeg -r 24 -b 1800 -i "$sequenced_images_dir"/img%08d.jpg "$video_dir"/test_24fps_1800kbps.mp4


