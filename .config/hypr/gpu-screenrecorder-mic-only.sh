#!/bin/env bash

# GPU Screen Recorder - Microphone Only Full Screen Recording
# Records full screen with microphone audio only (no system audio)

# Configuration
VIDEOS_DIR="$HOME/Videos"
AUDIO_DEVICE="default_input"  # Microphone only
FRAMERATE="60"
CODEC="h264"  # Options: h264, h265, av1, vp8, vp9
QUALITY="very_high"  # Options: very_high, high, medium, low
CONTAINER="mp4"  # Options: mp4, mkv, webm
RECORD_CURSOR="yes"  # yes/no

# Create videos directory if it doesn't exist
mkdir -p "$VIDEOS_DIR"

# Function to check if GPU Screen Recorder is installed
check_gsr_installed() {
    if ! command -v gpu-screen-recorder &> /dev/null; then
        notify-send -h string:gpu-screen-recorder:record -t 5000 "❌ Error" "GPU Screen Recorder is not installed"
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
        notify-send -h string:gpu-screen-recorder:record -t 3000 "🔴 Mic Recording Stopped" "Video saved to $VIDEOS_DIR"
        return 0
    else
        notify-send -h string:gpu-screen-recorder:record -t 2000 "⚠️ Warning" "No recording in progress"
        return 1
    fi
}

# Function to start microphone-only recording
start_mic_recording() {
    # Generate filename with timestamp
    dateTime=$(date +%Y-%m-%d_%H-%M-%S)
    filename="$VIDEOS_DIR/gpu_mic_recording_$dateTime.$CONTAINER"
    
    # Check audio availability
    audio_available=false
    if command -v pactl &> /dev/null; then
        if pactl info &> /dev/null; then
            audio_available=true
        fi
    fi
    
    # Countdown notifications
    notify-send -h string:gpu-screen-recorder:record -t 1000 "🎤 Mic Recording in:" "<span color='#ff6b6b' font='26px'><i><b>3</b></i></span>"
    sleep 1
    
    notify-send -h string:gpu-screen-recorder:record -t 1000 "🎤 Mic Recording in:" "<span color='#ffa500' font='26px'><i><b>2</b></i></span>"
    sleep 1
    
    notify-send -h string:gpu-screen-recorder:record -t 950 "🎤 Mic Recording in:" "<span color='#90a4f4' font='26px'><i><b>1</b></i></span>"
    sleep 1
    
    # Build command
    cmd="gpu-screen-recorder -w screen -f $FRAMERATE -k $CODEC -q $QUALITY"
    
    # Add microphone audio if available
    if $audio_available; then
        cmd="$cmd -a \"$AUDIO_DEVICE\""
        notify-send -h string:gpu-screen-recorder:record -t 2000 "🎤 Mic Recording Started" "Full screen with microphone only • Hardware accelerated"
    else
        notify-send -h string:gpu-screen-recorder:record -t 2000 "🎤 Mic Recording Started" "Video only (no audio detected) • Hardware accelerated"
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
    
    # Store PID for later use
    echo $! > /tmp/gpu-screen-recorder-mic.pid
    
    # Wait a moment to check if recording started successfully
    sleep 2
    if ! pgrep -f "gpu-screen-recorder" > /dev/null; then
        notify-send -h string:gpu-screen-recorder:record -t 5000 "❌ Recording Failed" "Check terminal for errors"
        return 1
    fi
}

# Main script logic
check_gsr_installed

case "${1:-toggle}" in
    "toggle")
        if get_recording_status; then
            stop_recording
        else
            start_mic_recording
        fi
        ;;
    "start")
        if get_recording_status; then
            notify-send -h string:gpu-screen-recorder:record -t 2000 "⚠️ Warning" "Recording already in progress"
        else
            start_mic_recording
        fi
        ;;
    "stop")
        stop_recording
        ;;
    "status")
        if get_recording_status; then
            notify-send -h string:gpu-screen-recorder:record -t 2000 "🔴 Recording Status" "Currently recording (microphone only)"
        else
            notify-send -h string:gpu-screen-recorder:record -t 2000 "⚫ Recording Status" "Not recording"
        fi
        ;;
    *)
        echo "Usage: $0 [toggle|start|stop|status]"
        echo "  toggle - Toggle microphone-only recording on/off (default)"
        echo "  start  - Start microphone-only recording"
        echo "  stop   - Stop recording"
        echo "  status - Check recording status"
        echo ""
        echo "This script records full screen with microphone audio only (no system audio)"
        exit 1
        ;;
esac 