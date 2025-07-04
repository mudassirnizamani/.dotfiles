#!/bin/env bash

# Audio Configuration Script for GPU Screen Recorder
# Manages microphone and system audio settings

# Function to get the best available microphone source
get_best_mic_source() {
    # Priority order: noise-reduced sources first, then regular mic
    local sources=(
        "mic_denoised"  # PulseAudio noise reduction
        "mic_rnnoise_out"  # RNNoise AI processing
        "alsa_input.pci-0000_05_00.6.analog-stereo"  # Your original mic
        "default_input"  # Fallback
    )
    
    for source in "${sources[@]}"; do
        if pactl list sources short | grep -q "$source"; then
            echo "$source"
            return 0
        fi
    done
    
    echo "default_input"  # Ultimate fallback
}

# Function to get current audio setup
get_current_setup() {
    local mic_source=$(get_best_mic_source)
    
    echo "🎤 Current Audio Setup:"
    echo "Best microphone: $mic_source"
    
    # Check if noise reduction is active
    if pactl list sources short | grep -q "mic_denoised"; then
        echo "✅ PulseAudio noise reduction: ACTIVE"
    elif pactl list sources short | grep -q "mic_rnnoise"; then
        echo "✅ RNNoise AI processing: ACTIVE"
    else
        echo "⚠️  No noise reduction active"
    fi
    
    # Check microphone volume
    local mic_vol=$(pactl get-source-volume "$mic_source" 2>/dev/null | grep -oP '\d+(?=%)' | head -1)
    if [ -n "$mic_vol" ]; then
        echo "🔊 Microphone volume: $mic_vol%"
    fi
}

# Function to configure audio for recording
configure_audio() {
    local mode="${1:-help}"
    local mic_source=$(get_best_mic_source)
    
    case "$mode" in
        "mic"|"microphone")
            echo "default_input"
            echo "🎤 Mode: Microphone only"
            echo "Using: $mic_source"
            ;;
        "system"|"desktop")
            echo "default_output"
            echo "🔊 Mode: System audio only"
            ;;
        "both"|"all")
            echo "default_input|default_output"
            echo "🎤🔊 Mode: Microphone + System audio"
            echo "Using mic: $mic_source"
            ;;
        "none"|"mute")
            echo ""
            echo "🔇 Mode: No audio"
            ;;
        "test")
            echo "🧪 Testing current audio setup..."
            get_current_setup
            echo ""
            echo "Testing microphone for 3 seconds..."
            timeout 3s parecord --device="$mic_source" --file-format=wav /tmp/audio_test.wav
            echo "Playing back recording..."
            paplay /tmp/audio_test.wav
            rm -f /tmp/audio_test.wav
            ;;
        "list")
            echo "📋 Available audio sources:"
            echo ""
            echo "Microphone sources:"
            pactl list sources short | grep -E "(input|mic)" || echo "  None found"
            echo ""
            echo "System audio sources:"
            pactl list sinks short | grep -E "(output|sink)" || echo "  None found"
            ;;
        "current")
            get_current_setup
            ;;
        "volume")
            if [ -n "$2" ]; then
                pactl set-source-volume "$mic_source" "$2%"
                echo "🔊 Microphone volume set to $2%"
            else
                local vol=$(pactl get-source-volume "$mic_source" 2>/dev/null | grep -oP '\d+(?=%)' | head -1)
                echo "🔊 Current microphone volume: $vol%"
                echo "Usage: $0 volume [0-150]"
            fi
            ;;
        "noise")
            echo "🎛️ Noise Reduction Options:"
            echo ""
            echo "To enable noise reduction, run:"
            echo "  ./mic-noise-reduction.sh enable     # Basic noise reduction"
            echo "  ./mic-noise-reduction.sh rnnoise   # AI-powered noise reduction"
            echo "  ./mic-noise-reduction.sh easyeffects # Advanced processing"
            echo ""
            echo "Current status:"
            if pactl list sources short | grep -q "mic_denoised\|mic_rnnoise"; then
                echo "✅ Noise reduction is active"
            else
                echo "⚠️  No noise reduction active"
                echo "💡 Run: ./mic-noise-reduction.sh enable"
            fi
            ;;
        "help"|*)
            echo "🎧 Audio Configuration Options:"
            echo ""
            echo "MODES:"
            echo "  mic/microphone    - Microphone only"
            echo "  system/desktop    - System audio only"
            echo "  both/all          - Microphone + System audio"
            echo "  none/mute         - No audio"
            echo ""
            echo "UTILITIES:"
            echo "  test              - Test current audio setup"
            echo "  list              - List available audio sources"
            echo "  current           - Show current audio configuration"
            echo "  volume [0-150]    - Set/check microphone volume"
            echo "  noise             - Noise reduction options"
            echo ""
            echo "EXAMPLES:"
            echo "  $0 both           # Configure for mic + system audio"
            echo "  $0 mic            # Configure for microphone only"
            echo "  $0 test           # Test current setup"
            echo "  $0 volume 60      # Set mic volume to 60%"
            echo ""
            get_current_setup
            ;;
    esac
}

# Main execution
configure_audio "$@" 