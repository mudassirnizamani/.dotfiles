#!/bin/env bash

# GPU Screen Recorder Script for Hyprland
# Features: Toggle recording, audio capture, notifications, instant replay

# Configuration
VIDEOS_DIR="$HOME/Videos"
# Audio options:
# "default_input" = microphone only
# "default_output" = system audio only  
# "default_input|default_output" = both microphone and system audio
AUDIO_DEVICE="default_input|default_output"  # Record both mic and system audio
FRAMERATE="60"
CODEC="h264"  # Options: h264, h265, av1, vp8, vp9
QUALITY="very_high"  # Options: very_high, high, medium, low
CONTAINER="mp4"  # Options: mp4, mkv, webm
INSTANT_REPLAY_DURATION="30"  # seconds for instant replay
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
        notify-send -h string:gpu-screen-recorder:record -t 3000 "🔴 Recording Stopped" "Video saved to $VIDEOS_DIR"
        return 0
    else
        notify-send -h string:gpu-screen-recorder:record -t 2000 "⚠️ Warning" "No recording in progress"
        return 1
    fi
}

# Function to start recording
start_recording() {
    # Generate filename with timestamp
    dateTime=$(date +%Y-%m-%d_%H-%M-%S)
    filename="$VIDEOS_DIR/gpu_recording_$dateTime.$CONTAINER"
    
    # Check audio availability
    audio_available=false
    if command -v pactl &> /dev/null; then
        if pactl info &> /dev/null; then
            audio_available=true
        fi
    fi
    
    # Countdown notifications
    notify-send -h string:gpu-screen-recorder:record -t 1000 "🎬 GPU Recording in:" "<span color='#ff6b6b' font='26px'><i><b>3</b></i></span>"
    sleep 1
    
    notify-send -h string:gpu-screen-recorder:record -t 1000 "🎬 GPU Recording in:" "<span color='#ffa500' font='26px'><i><b>2</b></i></span>"
    sleep 1
    
    notify-send -h string:gpu-screen-recorder:record -t 950 "🎬 GPU Recording in:" "<span color='#90a4f4' font='26px'><i><b>1</b></i></span>"
    sleep 1
    
    # Build command
    cmd="gpu-screen-recorder -w screen -f $FRAMERATE -k $CODEC -q $QUALITY"
    
    # Add audio if available
    if $audio_available; then
        cmd="$cmd -a \"$AUDIO_DEVICE\""
        notify-send -h string:gpu-screen-recorder:record -t 2000 "🚀 GPU Recording Started" "With microphone + system audio • Hardware accelerated"
    else
        notify-send -h string:gpu-screen-recorder:record -t 2000 "🚀 GPU Recording Started" "Video only (no audio) • Hardware accelerated"
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
    echo $! > /tmp/gpu-screen-recorder.pid
    
    # Wait a moment to check if recording started successfully
    sleep 2
    if ! pgrep -f "gpu-screen-recorder" > /dev/null; then
        notify-send -h string:gpu-screen-recorder:record -t 5000 "❌ Recording Failed" "Check terminal for errors"
        return 1
    fi
}

# Function to start instant replay
start_instant_replay() {
    # Stop any existing recording first
    if get_recording_status; then
        stop_recording
        sleep 1
    fi
    
    # Check audio availability
    audio_available=false
    if command -v pactl &> /dev/null; then
        if pactl info &> /dev/null; then
            audio_available=true
        fi
    fi
    
    # Build command for instant replay
    cmd="gpu-screen-recorder -w screen -f $FRAMERATE -k $CODEC -q $QUALITY"
    
    # Add audio if available
    if $audio_available; then
        cmd="$cmd -a \"$AUDIO_DEVICE\""
    fi
    
    # Add cursor recording
    if [ "$RECORD_CURSOR" = "yes" ]; then
        cmd="$cmd -cursor yes"
    else
        cmd="$cmd -cursor no"
    fi
    
    # Add instant replay settings
    cmd="$cmd -r $INSTANT_REPLAY_DURATION -c $CONTAINER -o \"$VIDEOS_DIR/\""
    
    # Start instant replay in background
    eval "$cmd" &
    
    notify-send -h string:gpu-screen-recorder:record -t 3000 "🔄 Instant Replay Active" "Last $INSTANT_REPLAY_DURATION seconds buffered • Press Ctrl+Shift+R to save"
}

# Function to save instant replay
save_instant_replay() {
    if pgrep -f "gpu-screen-recorder.*-r" > /dev/null; then
        pkill -SIGUSR1 -f "gpu-screen-recorder"
        notify-send -h string:gpu-screen-recorder:record -t 3000 "💾 Instant Replay Saved" "Last $INSTANT_REPLAY_DURATION seconds saved to $VIDEOS_DIR"
    else
        notify-send -h string:gpu-screen-recorder:record -t 2000 "⚠️ Warning" "Instant replay not active"
    fi
}

# Main script logic
check_gsr_installed

case "${1:-toggle}" in
    "toggle")
        if get_recording_status; then
            stop_recording
        else
            start_recording
        fi
        ;;
    "start")
        if get_recording_status; then
            notify-send -h string:gpu-screen-recorder:record -t 2000 "⚠️ Warning" "Recording already in progress"
        else
            start_recording
        fi
        ;;
    "stop")
        stop_recording
        ;;
    "replay")
        start_instant_replay
        ;;
    "save")
        save_instant_replay
        ;;
    "status")
        if get_recording_status; then
            notify-send -h string:gpu-screen-recorder:record -t 2000 "🔴 Recording Status" "Currently recording"
        else
            notify-send -h string:gpu-screen-recorder:record -t 2000 "⚫ Recording Status" "Not recording"
        fi
        ;;
    *)
        echo "Usage: $0 [toggle|start|stop|replay|save|status]"
        echo "  toggle - Toggle recording on/off (default)"
        echo "  start  - Start recording"
        echo "  stop   - Stop recording"
        echo "  replay - Start instant replay mode"
        echo "  save   - Save instant replay buffer"
        echo "  status - Check recording status"
        exit 1
        ;;
esac 