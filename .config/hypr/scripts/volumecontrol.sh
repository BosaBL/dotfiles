#!/usr/bin/env sh


# Check if SwayOSD is installed
use_swayosd=false
if command -v swayosd-client >/dev/null 2>&1 && pgrep -x swayosd-server >/dev/null; then
    use_swayosd=true
fi

# Define functions

print_usage() {
    cat <<EOF
Usage: $(basename "$0") -[device] <action> [step]

Devices/Actions:
    -i    Input device
    -o    Output device
    -p    Player application
    -s    Select output device
    -t    Toggle to next output device

Actions:
    i     Increase volume
    d     Decrease volume
    m     Toggle mute

Optional:
    step  Volume change step (default: 5)

Examples:
    $(basename "$0") -o i 5     # Increase output volume by 5
    $(basename "$0") -i m       # Toggle input mute
    $(basename "$0") -p spotify d 10  # Decrease Spotify volume by 10 
    $(basename "$0") -p '' d 10  # Decrease volume by 10 for all players 

EOF
    exit 1
}


change_volume() {
    local action=$1
    local step=$2
    local device=$3
    local delta="-"
    local mode="--output-volume"

    [ "${action}" = "i" ] && delta="+"
    [ "${srce}" = "--default-source" ] && mode="--input-volume"
    case $device in
        "pamixer")            
            $use_swayosd && swayosd-client ${mode} "${delta}${step}"  && exit 0
            pamixer $srce -"$action" "$step"
            vol=$(pamixer $srce --get-volume)
            ;;
        "playerctl")
            playerctl --player="$srce" volume "$(awk -v step="$step" 'BEGIN {print step/100}')${delta}"
            vol=$(playerctl --player="$srce" volume | awk '{ printf "%.0f\n", $0 * 100 }')
            ;;
    esac
    
}

toggle_mute() {
    local device=$1
    local mode="--output-volume"
    [ "${srce}" = "--default-source" ] && mode="--input-volume"
    case $device in
        "pamixer") 
            $use_swayosd && swayosd-client "${mode}" mute-toggle && exit 0
            pamixer $srce -t
            ;;
        "playerctl")
            local volume_file="/tmp/$(basename "$0")_last_volume_${srce:-all}"
            if [ "$(playerctl --player="$srce" volume | awk '{ printf "%.2f", $0 }')" != "0.00" ]; then
                playerctl --player="$srce" volume | awk '{ printf "%.2f", $0 }' > "$volume_file"
                playerctl --player="$srce" volume 0
            else
                if [ -f "$volume_file" ]; then
                    last_volume=$(cat "$volume_file")
                    playerctl --player="$srce" volume "$last_volume"
                else
                    playerctl --player="$srce" volume 0.5  # Default to 50% if no saved volume
                fi
            fi
            ;;
    esac
}

toggle_output() {
    local default_sink=$(pamixer --get-default-sink | awk -F '"' 'END{print $(NF - 1)}')
    mapfile -t sink_array < <(select_output)
    local current_index=$(printf '%s\n' "${sink_array[@]}" | grep -n "$default_sink" | cut -d: -f1)
    local next_index=$(( (current_index % ${#sink_array[@]}) + 1 ))
    local next_sink="${sink_array[next_index-1]}"
    select_output "$next_sink"
}

# Main script logic

# Set default variables
icodir="${confDir}/dunst/icons/vol"
step=5
# Parse options
while getopts "iop:st" opt; do
    case $opt in
        i) device="pamixer"; srce="--default-source"; nsink=$(pamixer --list-sources | awk -F '"' 'END {print $(NF - 1)}') ;;
        o) device="pamixer"; srce=""; nsink=$(pamixer --get-default-sink | awk -F '"' 'END{print $(NF - 1)}') ;;
        p) device="playerctl"; srce="${OPTARG}"; nsink=$(playerctl --list-all | grep -w "$srce") ;;
        s) select_output "$(select_output | rofi -dmenu -config "${confDir}/rofi/notification.rasi")"; exit ;;
        t) toggle_output; exit ;;
        *) print_usage ;;
    esac
done

shift $((OPTIND-1))

# Check if device is set
[ -z "$device" ] && print_usage

# Execute action
case $1 in
    i|d) change_volume "$1" "${2:-$step}" "$device" ;;
    m) toggle_mute "$device" ;;
    *) print_usage ;;
esac
