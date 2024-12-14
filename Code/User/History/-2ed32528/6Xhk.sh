#!/bin/bash

input_folder="/home/ibi/Downloads/CommitMono"
output_folder="$HOME/.local/share/fonts"
font_patcher_folder="/home/ibi/Downloads/FontPatcher"
# backup_folder="/home/ibi/Documents/GitHub/personal/dot/font/patched/commit-mono-nerd"
font_type="otf"         

if [ ! -d "$input_folder" ] || [ ! -d "$output_folder" ] || [ ! -d "$font_patcher_folder" ] || [ ! -d "$backup_folder" ]; then
  echo "One or more directories do not exist. Please check the paths."
  exit 1
fi

find "$input_folder" -type f -iname "*.$font_type" | while read -r font_file; do
  echo "Processing: $font_file"

  font_filename=$(basename "$font_file")
  font_basename="${font_filename%.*}"

  echo "Using FontForge to patch font: $font_basename"
  fontforge -script "$font_patcher_folder/font-patcher" "$font_file" -c --complete -out "$output_folder"

  # Find the most recently font installed as the patched font
  patched_font=$(find "$output_folder" -type f -iname "*.$font_type" -printf "%T@ %p\n" | sort -n | tail -1 | cut -d' ' -f2-)

  # if [ -f "$patched_font" ]; then
  #   echo "Copying patched font to backup: $backup_folder/$(basename "$patched_font")"
  #   cp "$patched_font" "$backup_folder/"
  # else
  #   echo "Error: Patched font not found. Skipping backup."
  #   continue
  # fi

  echo "Refreshing font cache..."
  fc-cache -fv

  echo "Font $font_basename processed successfully."
done

echo "All fonts processed."