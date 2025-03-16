swayidle -w lock "pidof swaylock || swaylock -f" \
  before-sleep "loginctl lock-session" \
  timeout 300 'loginctl lock-session' resume 'notify-send "Idle Manager" "Welcome back"' \
  timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' \
  timeout 900 'systemctl suspend' resume 'hyprctl dispatch dpms on' \
  after-resume 'hyprctl dispatch dpms on'
