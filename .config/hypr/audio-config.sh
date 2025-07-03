#!/bin/env bash

# Audio Configuration Script for GPU Screen Recorder
# Allows easy switching between different audio recording modes

case "${1:-help}" in
    "mic")
        # Microphone only
        sed -i 's/AUDIO_DEVICE=.*/AUDIO_DEVICE="default_input"/' gpu-screenrecorder.sh
        sed -i 's/AUDIO_DEVICE=.*/AUDIO_DEVICE="default_input"/' gpu-screenrecorder-region.sh
        notify-send -h string:gpu-screen-recorder:audio -t 2000 "🎤 Audio Config" "Set to microphone only"
        echo "✅ Audio configured for microphone only"
        ;;
    "system")
        # System audio only
        sed -i 's/AUDIO_DEVICE=.*/AUDIO_DEVICE="default_output"/' gpu-screenrecorder.sh
        sed -i 's/AUDIO_DEVICE=.*/AUDIO_DEVICE="default_output"/' gpu-screenrecorder-region.sh
        notify-send -h string:gpu-screen-recorder:audio -t 2000 "🔊 Audio Config" "Set to system audio only"
        echo "✅ Audio configured for system audio only"
        ;;
    "both")
        # Both microphone and system audio
        sed -i 's/AUDIO_DEVICE=.*/AUDIO_DEVICE="default_input|default_output"/' gpu-screenrecorder.sh
        sed -i 's/AUDIO_DEVICE=.*/AUDIO_DEVICE="default_input|default_output"/' gpu-screenrecorder-region.sh
        notify-send -h string:gpu-screen-recorder:audio -t 2000 "🎧 Audio Config" "Set to microphone + system audio"
        echo "✅ Audio configured for microphone + system audio"
        ;;
    "none")
        # No audio
        sed -i 's/AUDIO_DEVICE=.*/AUDIO_DEVICE=""/' gpu-screenrecorder.sh
        sed -i 's/AUDIO_DEVICE=.*/AUDIO_DEVICE=""/' gpu-screenrecorder-region.sh
        notify-send -h string:gpu-screen-recorder:audio -t 2000 "🔇 Audio Config" "Set to no audio"
        echo "✅ Audio configured for no audio"
        ;;
    "test")
        # Test microphone
        echo "🎤 Testing microphone for 3 seconds..."
        echo "Speak into your microphone now..."
        timeout 3s parecord --device=alsa_input.pci-0000_05_00.6.analog-stereo test-mic.wav 2>/dev/null
        if [ -f test-mic.wav ] && [ -s test-mic.wav ]; then
            echo "✅ Microphone recorded successfully!"
            echo "🔊 Playing back recording..."
            paplay test-mic.wav 2>/dev/null
            rm -f test-mic.wav
            echo "✅ Microphone test complete!"
        else
            echo "❌ Microphone test failed!"
        fi
        ;;
    "list")
        # List available audio devices
        echo "📋 Available Audio Sources:"
        echo ""
        pactl list sources | grep -E "(Name|Description)" | sed 's/^\s*/  /'
        echo ""
        echo "📋 Available Audio Sinks:"
        echo ""
        pactl list sinks | grep -E "(Name|Description)" | sed 's/^\s*/  /'
        ;;
    "current")
        # Show current configuration
        echo "🔧 Current Audio Configuration:"
        echo ""
        echo "Main script:"
        grep "AUDIO_DEVICE=" gpu-screenrecorder.sh | head -1
        echo ""
        echo "Region script:"
        grep "AUDIO_DEVICE=" gpu-screenrecorder-region.sh | head -1
        echo ""
        echo "Microphone volume:"
        pactl get-source-volume alsa_input.pci-0000_05_00.6.analog-stereo | grep -oP '\d+(?=%)' | head -1 | xargs -I {} echo "  {}%"
        ;;
    "volume"|"vol")
        # Microphone volume control
        echo "🎛️ Microphone Volume Control:"
        echo ""
        echo "Use: ./mic-volume-control.sh [option]"
        echo ""
        echo "Quick options:"
        echo "  normal  - Set to 60% (recommended)"
        echo "  loud    - Set to 85% (if too quiet)"
        echo "  up      - Increase by 10%"
        echo "  down    - Decrease by 10%"
        echo "  test    - Test current level"
        echo "  status  - Show current volume"
        echo ""
        current_vol=$(pactl get-source-volume alsa_input.pci-0000_05_00.6.analog-stereo | grep -oP '\d+(?=%)' | head -1)
        echo "Current volume: ${current_vol}%"
        ;;
    *)
        echo "🎵 GPU Screen Recorder Audio Configuration"
        echo ""
        echo "Usage: $0 [option]"
        echo ""
        echo "Options:"
        echo "  mic     - Record microphone only"
        echo "  system  - Record system audio only"
        echo "  both    - Record microphone + system audio (default)"
        echo "  none    - No audio recording"
        echo "  test    - Test microphone recording"
        echo "  list    - List available audio devices"
        echo "  current - Show current audio configuration"
        echo "  volume  - Microphone volume control help"
        echo ""
        echo "Examples:"
        echo "  $0 both     # Record mic + system audio"
        echo "  $0 mic      # Record only microphone"
        echo "  $0 test     # Test microphone"
        echo "  $0 volume   # Show microphone volume control help"
        exit 1
        ;;
esac 