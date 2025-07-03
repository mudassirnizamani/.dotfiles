#!/bin/env bash

# Configuration
VIDEOS_DIR="$HOME/Videos"
AUDIO_DEVICE="" # Leave empty for default audio device
CODEC="h264_vaapi" # Hardware acceleration (change to "libx264" for software encoding)
PIXEL_FORMAT="yuv420p"
FRAMERATE="30"
AUDIO_CODEC="aac"

# Create videos directory if it doesn't exist
mkdir -p "$VIDEOS_DIR"

# Check if wf-recorder is running and stop it if so
if pgrep -x "wf-recorder" > /dev/null; then
    pkill -INT -x wf-recorder
    notify-send -h string:wf-recorder:record -t 2000 "🔴 Recording Stopped" "Video saved to $VIDEOS_DIR"
    exit 0
fi

# Check if wf-recorder is installed
if ! command -v wf-recorder &> /dev/null; then
    notify-send -h string:wf-recorder:record -t 3000 "❌ Error" "wf-recorder is not installed"
    exit 1
fi

# Check audio setup
audio_available=false
if command -v pactl &> /dev/null; then
    # Check if PulseAudio/PipeWire is running
    if pactl info &> /dev/null; then
        audio_available=true
    fi
fi

# Notify recording start with countdown
notify-send -h string:wf-recorder:record -t 1000 "🎬 Recording in:" "<span color='#ff6b6b' font='26px'><i><b>3</b></i></span>"
sleep 1

notify-send -h string:wf-recorder:record -t 1000 "🎬 Recording in:" "<span color='#ffa500' font='26px'><i><b>2</b></i></span>"
sleep 1

notify-send -h string:wf-recorder:record -t 950 "🎬 Recording in:" "<span color='#90a4f4' font='26px'><i><b>1</b></i></span>"
sleep 1

# Generate filename with timestamp
dateTime=$(date +%Y-%m-%d_%H-%M-%S)
filename="$VIDEOS_DIR/screen_recording_$dateTime.mp4"

# Build wf-recorder command
cmd="wf-recorder"

# Add audio recording if available
if $audio_available; then
    cmd="$cmd --audio"
    if [ -n "$AUDIO_DEVICE" ]; then
        cmd="$cmd=$AUDIO_DEVICE"
    fi
    cmd="$cmd --audio-codec $AUDIO_CODEC"
    notify-send -h string:wf-recorder:record -t 2000 "🎬 Recording Started" "With audio • Press same key to stop"
else
    notify-send -h string:wf-recorder:record -t 2000 "🎬 Recording Started" "Video only (no audio detected) • Press same key to stop"
fi

# Add video options
cmd="$cmd --codec $CODEC --pixel-format $PIXEL_FORMAT --framerate $FRAMERATE"

# Add output file
cmd="$cmd --file $filename"

# Add additional options for better quality
cmd="$cmd --bframes max_b_frames"

# Start recording
eval $cmd

# Check if recording was successful
if [ $? -eq 0 ]; then
    notify-send -h string:wf-recorder:record -t 3000 "✅ Recording Complete" "Saved: $(basename "$filename")"
else
    notify-send -h string:wf-recorder:record -t 3000 "❌ Recording Failed" "Check terminal for errors"
fi
