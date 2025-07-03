#!/bin/env bash

# Microphone Volume Control Script
# Easy adjustment of microphone input levels for recordings

# Your microphone device (identified from pactl list sources short)
MIC_SOURCE="alsa_input.pci-0000_05_00.6.analog-stereo"

# Function to get current volume
get_current_volume() {
    pactl get-source-volume "$MIC_SOURCE" | grep -oP 'Volume:.*?(\d+)%' | grep -oP '\d+(?=%)'
}

# Function to get current dB level
get_current_db() {
    pactl get-source-volume "$MIC_SOURCE" | grep -oP '[-+]?\d+\.\d+\s*dB' | head -1
}

# Function to set volume
set_volume() {
    local volume=$1
    pactl set-source-volume "$MIC_SOURCE" "${volume}%"
    
    current_vol=$(get_current_volume)
    current_db=$(get_current_db)
    
    notify-send -h string:mic-volume:control -t 2000 "🎤 Microphone Volume" "Set to: $current_vol% ($current_db)"
    echo "✅ Microphone volume set to: $current_vol% ($current_db)"
}

# Function to test microphone
test_microphone() {
    echo "🎤 Testing microphone for 3 seconds..."
    echo "Current volume: $(get_current_volume)% ($(get_current_db))"
    echo "Say something now..."
    
    # Record 3 seconds of audio
    timeout 3s parecord --device="$MIC_SOURCE" --file-format=wav /tmp/mic_test.wav
    
    echo "🔊 Playing back your recording..."
    paplay /tmp/mic_test.wav
    
    # Clean up
    rm -f /tmp/mic_test.wav
}

# Function to show current status
show_status() {
    current_vol=$(get_current_volume)
    current_db=$(get_current_db)
    
    echo "🎤 Current Microphone Status:"
    echo "Volume: $current_vol% ($current_db)"
    echo "Device: $MIC_SOURCE"
    echo ""
    echo "📊 Volume Guidelines:"
    echo "• 20-40%: Quiet/Whisper level"
    echo "• 50-70%: Normal speaking level"
    echo "• 80-100%: Loud/Close to mic"
    echo "• 100%+: May cause distortion"
}

# Main script
case "${1:-help}" in
    # Volume presets
    "quiet"|"low")
        set_volume 30
        echo "Set to QUIET level (30%) - Good for close microphone or quiet environments"
        ;;
    "normal"|"medium")
        set_volume 60
        echo "Set to NORMAL level (60%) - Good for typical recording distance"
        ;;
    "loud"|"high")
        set_volume 85
        echo "Set to LOUD level (85%) - Good for distant microphone or noisy environments"
        ;;
    "max")
        set_volume 100
        echo "Set to MAXIMUM level (100%) - Use carefully to avoid distortion"
        ;;
    
    # Custom volume (0-150%)
    [0-9]*)
        if [[ $1 =~ ^[0-9]+$ ]] && [ $1 -le 150 ]; then
            set_volume $1
            echo "Set to custom level ($1%)"
        else
            echo "❌ Invalid volume. Use 0-150 (numbers only)"
            exit 1
        fi
        ;;
    
    # Adjustment commands
    "up"|"+")
        current_vol=$(get_current_volume)
        new_vol=$((current_vol + 10))
        if [ $new_vol -le 150 ]; then
            set_volume $new_vol
            echo "Increased volume by 10%"
        else
            echo "❌ Cannot increase further (max 150%)"
        fi
        ;;
    "down"|"-")
        current_vol=$(get_current_volume)
        new_vol=$((current_vol - 10))
        if [ $new_vol -ge 0 ]; then
            set_volume $new_vol
            echo "Decreased volume by 10%"
        else
            echo "❌ Cannot decrease further (min 0%)"
        fi
        ;;
    
    # Utility commands
    "test"|"check")
        test_microphone
        ;;
    "status"|"show")
        show_status
        ;;
    "mute")
        pactl set-source-mute "$MIC_SOURCE" toggle
        is_muted=$(pactl get-source-mute "$MIC_SOURCE" | grep -o "yes\|no")
        if [ "$is_muted" = "yes" ]; then
            notify-send -h string:mic-volume:control -t 2000 "🔇 Microphone Muted" "Microphone is now muted"
            echo "🔇 Microphone muted"
        else
            notify-send -h string:mic-volume:control -t 2000 "🎤 Microphone Unmuted" "Microphone is now active"
            echo "🎤 Microphone unmuted"
        fi
        ;;
    
    # Help
    "help"|*)
        echo "🎤 Microphone Volume Control"
        echo ""
        echo "PRESETS:"
        echo "  quiet/low     - Set to 30% (quiet level)"
        echo "  normal/medium - Set to 60% (normal level)"
        echo "  loud/high     - Set to 85% (loud level)"
        echo "  max           - Set to 100% (maximum level)"
        echo ""
        echo "CUSTOM VOLUME:"
        echo "  [0-150]       - Set specific volume percentage"
        echo "  Examples: $0 75, $0 50, $0 90"
        echo ""
        echo "ADJUSTMENTS:"
        echo "  up/+          - Increase volume by 10%"
        echo "  down/-        - Decrease volume by 10%"
        echo ""
        echo "UTILITIES:"
        echo "  test/check    - Test microphone (3-second recording)"
        echo "  status/show   - Show current volume and guidelines"
        echo "  mute          - Toggle microphone mute"
        echo ""
        echo "CURRENT STATUS:"
        show_status
        echo ""
        echo "💡 TIP: Start with 'normal' then adjust up/down as needed"
        echo "💡 Use 'test' to check your levels before recording"
        ;;
esac 