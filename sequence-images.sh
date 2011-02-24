#!/bin/bash

base_dir="/tmp/CORRUPTIMATOR/test01"
resized_images_dir="$base_dir/03_all_resized"
sequenced_images_dir="$base_dir/04_all_sequenced"
log_dir="$base_dir/logs"
imgcount=$1

if [ ! -d "$sequenced_images_dir" ]; then
  mkdir -p "$sequenced_images_dir"
fi
if [ ! -d "$log_dir" ]; then
  mkdir -p "$log_dir"
fi

# Create a symbolically linked image sequence in the tmp directory, which maps onto the processed images
# Lifted straight from http://www.ffmpeg.org/faq.html#TOC14
cd "$resized_images_dir"
x=1; for i in *jpg; do counter=$(printf %08d $x); ln -f "$i" "$sequenced_images_dir"/img"$counter".jpg; x=$(($x+1)); done

