#!/usr/bin/env bash

# Check if rofi is running

if pidof rofi; then
  kill "$(pidof rofi)"
fi

IMG_PATH=$HOME/Pictures/wallpapers/

readarray -t IMGS < <(find "${IMG_PATH}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \))

selected=$(for IMG in "${IMGS[@]}"; do
  # STRIP EXTENSION AND GET NAME
  NAME=$(basename "$IMG")
  # PRINT IMAGE AS ICON
  echo -ne "$NAME\x00icon\x1f$IMG\n"
done | rofi -i -show -dmenu -config "$HOME/.config/rofi/config-wallpaper.rasi")

if [[ -z $selected ]]; then
  exit 0
fi

# Change Wallpaper
swww img "$IMG_PATH/$selected"

# Change SDDM theme
cp "$IMG_PATH/$selected" /usr/share/sddm/themes/sddm-astronaut-theme/backgrounds/background.png
