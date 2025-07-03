#!/bin/env bash

# GPU Screen Recorder Region/Area Selection Script for Hyprland

# Configuration
VIDEOS_DIR="$HOME/Videos"
# Audio options:
# "default_input" = microphone only
# "default_output" = system audio only  
# "default_input|default_output" = both microphone and system audio
AUDIO_DEVICE="default_input|default_output"  # Record both mic and system audio
FRAMERATE="60"
CODEC="h264"
QUALITY="very_high"
CONTAINER="mp4"
RECORD_CURSOR="yes"

# Create videos directory if it doesn't exist
mkdir -p "$VIDEOS_DIR"

# Function to check if GPU Screen Recorder is installed
check_gsr_installed() {
    if ! command -v gpu-screen-recorder &> /dev/null; then
        notify-send -h string:gpu-screen-recorder:record -t 5000 "❌ Error" "GPU Screen Recorder is not installed"
        exit 1
    fi
}

# Function to check if slurp is installed
check_slurp_installed() {
    if ! command -v slurp &> /dev/null; then
        notify-send -h string:gpu-screen-recorder:record -t 5000 "❌ Error" "slurp is not installed. Install with: sudo pacman -S slurp"
        exit 1
    fi
}

# Function to get recording status
get_recording_status() {
    if pgrep -f "gpu-screen-recorder" > /dev/null; then
        return 0  # Recording
    else
        return 1  # Not recording
    fi
}

# Function to stop recording
stop_recording() {
    if pgrep -f "gpu-screen-recorder" > /dev/null; then
        pkill -SIGINT -f "gpu-screen-recorder"
        notify-send -h string:gpu-screen-recorder:record -t 3000 "🔴 Recording Stopped" "Video saved to $VIDEOS_DIR"
        return 0
    else
        notify-send -h string:gpu-screen-recorder:record -t 2000 "⚠️ Warning" "No recording in progress"
        return 1
    fi
}

# Function to start region recording
start_region_recording() {
    check_slurp_installed
    
    # Let user select region
    notify-send -h string:gpu-screen-recorder:record -t 2000 "📋 Select Region" "Draw a rectangle to select recording area"
    
    # Get region selection from slurp
    region=$(slurp -f "%wx%h+%x+%y" -b "#45475a66" -c "#cdd6f4" -s "#00000000" -w 2)
    
    if [ -z "$region" ]; then
        notify-send -h string:gpu-screen-recorder:record -t 2000 "❌ Cancelled" "No region selected"
        exit 1
    fi
    
    # Generate filename with timestamp
    dateTime=$(date +%Y-%m-%d_%H-%M-%S)
    filename="$VIDEOS_DIR/gpu_region_$dateTime.$CONTAINER"
    
    # Check audio availability
    audio_available=false
    if command -v pactl &> /dev/null; then
        if pactl info &> /dev/null; then
            audio_available=true
        fi
    fi
    
    # Countdown notifications
    notify-send -h string:gpu-screen-recorder:record -t 1000 "🎬 Region Recording in:" "<span color='#ff6b6b' font='26px'><i><b>3</b></i></span>"
    sleep 1
    
    notify-send -h string:gpu-screen-recorder:record -t 1000 "🎬 Region Recording in:" "<span color='#ffa500' font='26px'><i><b>2</b></i></span>"
    sleep 1
    
    notify-send -h string:gpu-screen-recorder:record -t 950 "🎬 Region Recording in:" "<span color='#90a4f4' font='26px'><i><b>1</b></i></span>"
    sleep 1
    
    # Build command
    cmd="gpu-screen-recorder -w region -region $region -f $FRAMERATE -k $CODEC -q $QUALITY"
    
    # Add audio if available
    if $audio_available; then
        cmd="$cmd -a \"$AUDIO_DEVICE\""
        notify-send -h string:gpu-screen-recorder:record -t 2000 "🎯 Region Recording Started" "With microphone + system audio • Hardware accelerated"
    else
        notify-send -h string:gpu-screen-recorder:record -t 2000 "🎯 Region Recording Started" "Video only (no audio) • Hardware accelerated"
    fi
    
    # Add cursor recording
    if [ "$RECORD_CURSOR" = "yes" ]; then
        cmd="$cmd -cursor yes"
    else
        cmd="$cmd -cursor no"
    fi
    
    # Add output file
    cmd="$cmd -o \"$filename\""
    
    # Start recording in background
    eval "$cmd" &
    
    # Wait a moment to check if recording started successfully
    sleep 2
    if ! pgrep -f "gpu-screen-recorder" > /dev/null; then
        notify-send -h string:gpu-screen-recorder:record -t 5000 "❌ Recording Failed" "Check terminal for errors"
        return 1
    fi
}

# Main script logic
check_gsr_installed

case "${1:-region}" in
    "region")
        if get_recording_status; then
            stop_recording
        else
            start_region_recording
        fi
        ;;
    "start")
        if get_recording_status; then
            notify-send -h string:gpu-screen-recorder:record -t 2000 "⚠️ Warning" "Recording already in progress"
        else
            start_region_recording
        fi
        ;;
    "stop")
        stop_recording
        ;;
    "status")
        if get_recording_status; then
            notify-send -h string:gpu-screen-recorder:record -t 2000 "🔴 Recording Status" "Currently recording"
        else
            notify-send -h string:gpu-screen-recorder:record -t 2000 "⚫ Recording Status" "Not recording"
        fi
        ;;
    *)
        echo "Usage: $0 [region|start|stop|status]"
        echo "  region - Select region to record (default)"
        echo "  start  - Start region recording"
        echo "  stop   - Stop recording"
        echo "  status - Check recording status"
        exit 1
        ;;
esac 