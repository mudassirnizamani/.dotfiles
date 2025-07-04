#!/bin/bash

# Microphone Noise Reduction Script
# Provides real-time noise reduction for your microphone using various methods

# Your microphone device (from mic-volume-control.sh)
MIC_SOURCE="alsa_input.pci-0000_05_00.6.analog-stereo"

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install packages
install_packages() {
    local packages=("$@")
    echo -e "${YELLOW}Installing required packages...${NC}"
    
    for pkg in "${packages[@]}"; do
        if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
            echo -e "${CYAN}Installing $pkg...${NC}"
            sudo pacman -S "$pkg" --noconfirm
        else
            echo -e "${GREEN}$pkg is already installed${NC}"
        fi
    done
}

# Function to setup PulseAudio noise reduction
setup_pulseaudio_noise_reduction() {
    echo -e "${BLUE}Setting up PulseAudio noise reduction...${NC}"
    
    # Check if module is already loaded
    if pactl list modules | grep -q "module-echo-cancel"; then
        echo -e "${YELLOW}Noise reduction module already loaded${NC}"
        return 0
    fi
    
    # Load echo-cancel module with noise reduction
    pactl load-module module-echo-cancel \
        source_name=mic_denoised \
        source_properties=device.description='"Microphone (Noise Reduced)"' \
        aec_method=webrtc \
        aec_args='"analog_gain_control=0 digital_gain_control=1 noise_suppression=1 voice_detection=1"' \
        source_master="$MIC_SOURCE"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ PulseAudio noise reduction enabled${NC}"
        echo -e "${CYAN}New noise-reduced microphone: mic_denoised${NC}"
        
        # Set as default source
        pactl set-default-source mic_denoised
        echo -e "${GREEN}✅ Set as default microphone${NC}"
        
        # Send notification
        notify-send -h string:mic-noise:control -t 3000 "🎤 Noise Reduction" "PulseAudio noise reduction activated"
        return 0
    else
        echo -e "${RED}❌ Failed to load noise reduction module${NC}"
        return 1
    fi
}

# Function to setup advanced noise reduction with RNNoise
setup_rnnoise() {
    echo -e "${BLUE}Setting up RNNoise (AI-based noise reduction)...${NC}"
    
    # Check if RNNoise LADSPA plugin is available
    if ! ls /usr/lib/ladspa/librnnoise_ladspa.so >/dev/null 2>&1; then
        echo -e "${YELLOW}RNNoise LADSPA plugin not found${NC}"
        echo -e "${CYAN}Installing required packages...${NC}"
        
        # Install RNNoise and noise-suppression-for-voice
        install_packages "rnnoise" "noise-suppression-for-voice" "ladspa"
        
        if ! ls /usr/lib/ladspa/librnnoise_ladspa.so >/dev/null 2>&1; then
            echo -e "${RED}❌ Failed to install RNNoise LADSPA plugin${NC}"
            echo -e "${CYAN}Using basic noise reduction instead...${NC}"
            setup_pulseaudio_noise_reduction
            return $?
        fi
    fi
    
    # Remove existing noise reduction modules first
    remove_noise_reduction_quiet
    
    # Create null sink for RNNoise processing
    pactl load-module module-null-sink \
        sink_name=mic_denoised_out \
        sink_properties=device.description='"Microphone Denoised Output"' \
        rate=48000
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to create null sink${NC}"
        setup_pulseaudio_noise_reduction
        return $?
    fi
    
    # Load LADSPA sink with RNNoise
    pactl load-module module-ladspa-sink \
        sink_name=mic_raw_in \
        sink_master=mic_denoised_out \
        plugin=/usr/lib/ladspa/librnnoise_ladspa.so \
        label=noise_suppressor_mono \
        control=50
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to load RNNoise LADSPA sink${NC}"
        pactl unload-module module-null-sink 2>/dev/null || true
        setup_pulseaudio_noise_reduction
        return $?
    fi
    
    # Create loopback from microphone to RNNoise input
    pactl load-module module-loopback \
        source="$MIC_SOURCE" \
        sink=mic_raw_in \
        channels=1 \
        source_dont_move=true \
        sink_dont_move=true
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to create loopback${NC}"
        pactl unload-module module-ladspa-sink 2>/dev/null || true
        pactl unload-module module-null-sink 2>/dev/null || true
        setup_pulseaudio_noise_reduction
        return $?
    fi
    
    # Create remapped source for applications to use
    pactl load-module module-remap-source \
        source_name=mic_denoised \
        source_properties=device.description='"Microphone (RNNoise Denoised)"' \
        master=mic_denoised_out.monitor \
        channels=1
    
    if [ $? -eq 0 ]; then
        # Set the denoised microphone as default
        pactl set-default-source mic_denoised
        
        echo -e "${GREEN}✅ RNNoise AI noise reduction activated${NC}"
        echo -e "${CYAN}New denoised microphone: mic_denoised${NC}"
        echo -e "${CYAN}You can now use this in Discord, Zoom, OBS, etc.${NC}"
        
        # Send notification
        notify-send -h string:mic-noise:control -t 3000 "🤖 AI Noise Reduction" "RNNoise AI noise suppression activated"
        return 0
    else
        echo -e "${RED}❌ Failed to create remapped source${NC}"
        # Clean up on failure
        pactl unload-module module-loopback 2>/dev/null || true
        pactl unload-module module-ladspa-sink 2>/dev/null || true
        pactl unload-module module-null-sink 2>/dev/null || true
        setup_pulseaudio_noise_reduction
        return $?
    fi
}

# Function to setup EasyEffects (formerly PulseEffects)
setup_easyeffects() {
    echo -e "${BLUE}Setting up EasyEffects for advanced audio processing...${NC}"
    
    # Install EasyEffects
    if ! command_exists "easyeffects"; then
        install_packages "easyeffects"
    fi
    
    # Create noise reduction preset
    mkdir -p ~/.config/easyeffects/input
    
    cat > ~/.config/easyeffects/input/noise_reduction.json << 'EOF'
{
    "input": {
        "blocklist": [],
        "compressor": {
            "attack": 20.0,
            "bypass": false,
            "hpf-frequency": 10.0,
            "hpf-mode": "off",
            "input-gain": 0.0,
            "knee": 2.5,
            "lpf-frequency": 20000.0,
            "lpf-mode": "off",
            "makeup": 0.0,
            "mode": "Downward",
            "output-gain": 0.0,
            "ratio": 4.0,
            "release": 100.0,
            "sidechain": {
                "lookahead": 0.0,
                "mode": "RMS",
                "preamp": 0.0,
                "reactivity": 10.0,
                "source": "Middle"
            },
            "threshold": -18.0
        },
        "gate": {
            "attack": 20.0,
            "bypass": false,
            "curve-source": "Internal",
            "curve-threshold": -24.0,
            "hpf-frequency": 10.0,
            "hpf-mode": "off",
            "hysteresis": false,
            "hysteresis-threshold": -12.0,
            "hysteresis-zone": 6.0,
            "input-gain": 0.0,
            "lpf-frequency": 20000.0,
            "lpf-mode": "off",
            "makeup": 0.0,
            "output-gain": 0.0,
            "ratio": 2.0,
            "release": 250.0,
            "sidechain": {
                "input": "Internal",
                "lookahead": 0.0,
                "mode": "RMS",
                "preamp": 0.0,
                "reactivity": 10.0,
                "source": "Middle"
            },
            "threshold": -18.0
        },
        "plugins_order": [
            "gate",
            "compressor",
            "filter"
        ]
    }
}
EOF

    echo -e "${GREEN}✅ EasyEffects noise reduction preset created${NC}"
    echo -e "${CYAN}Run 'easyeffects' to configure advanced audio processing${NC}"
    
    # Send notification
    notify-send -h string:mic-noise:control -t 3000 "🎛️ EasyEffects" "Advanced audio processing preset created"
}

# Function to quietly remove noise reduction (for internal use)
remove_noise_reduction_quiet() {
    # Unload all possible noise reduction modules
    pactl unload-module module-echo-cancel 2>/dev/null || true
    pactl unload-module module-ladspa-sink 2>/dev/null || true
    pactl unload-module module-remap-source 2>/dev/null || true
    pactl unload-module module-loopback 2>/dev/null || true
    pactl unload-module module-null-sink 2>/dev/null || true
}

# Function to remove noise reduction
remove_noise_reduction() {
    echo -e "${BLUE}Removing noise reduction modules...${NC}"
    
    # Unload all noise reduction modules
    remove_noise_reduction_quiet
    
    # Reset default source
    pactl set-default-source "$MIC_SOURCE"
    
    echo -e "${GREEN}✅ Noise reduction modules removed${NC}"
    echo -e "${CYAN}Microphone restored to original state${NC}"
    
    # Send notification
    notify-send -h string:mic-noise:control -t 3000 "🎤 Noise Reduction" "Noise reduction disabled"
}

# Function to test microphone quality
test_microphone() {
    echo -e "${BLUE}Testing microphone quality...${NC}"
    
    # Get current source
    current_source=$(pactl get-default-source)
    echo -e "${CYAN}Current microphone: $current_source${NC}"
    
    # Record test
    echo -e "${YELLOW}Recording 5 seconds of audio...${NC}"
    echo "Say something now (background noise will be captured too)..."
    
    timeout 5s parecord --device="$current_source" --file-format=wav /tmp/mic_test_processed.wav
    
    echo -e "${GREEN}Playing back your recording...${NC}"
    paplay /tmp/mic_test_processed.wav
    
    # Show audio info
    echo -e "${CYAN}Audio file info:${NC}"
    file /tmp/mic_test_processed.wav
    
    # Clean up
    rm -f /tmp/mic_test_processed.wav
}

# Function to show current status
show_status() {
    echo -e "${BLUE}🎤 Microphone Noise Reduction Status${NC}"
    echo ""
    
    # Show current default source
    current_source=$(pactl get-default-source)
    echo -e "${CYAN}Current default microphone:${NC} $current_source"
    
    # Check if RNNoise is active
    if pactl list modules short | grep -q "module-remap-source"; then
        echo -e "${GREEN}✅ RNNoise AI noise reduction is ACTIVE${NC}"
        echo -e "${CYAN}   Denoised microphone: mic_denoised${NC}"
    elif pactl list modules short | grep -q "module-echo-cancel"; then
        echo -e "${GREEN}✅ Basic noise reduction is ACTIVE${NC}"
        echo -e "${CYAN}   Denoised microphone: mic_denoised${NC}"
    else
        echo -e "${YELLOW}⚠️  No noise reduction is active${NC}"
    fi
    
    # Show loaded modules
    echo -e "${CYAN}Loaded noise reduction modules:${NC}"
    pactl list modules short | grep -E "(echo-cancel|ladspa|rnnoise|remap-source|loopback|null-sink)" || echo "  None"
    
    # Show available sources
    echo -e "${CYAN}Available microphone sources:${NC}"
    pactl list sources short | while read -r line; do
        source_id=$(echo "$line" | awk '{print $1}')
        source_name=$(echo "$line" | awk '{print $2}')
        source_state=$(echo "$line" | awk '{print $5}')
        
        if echo "$source_name" | grep -qE "(input|mic|denoised)" && ! echo "$source_name" | grep -q "monitor"; then
            if [ "$source_name" = "$current_source" ]; then
                echo -e "  ${GREEN}► $source_name${NC} (current default)"
            else
                echo "  $source_name"
            fi
        fi
    done
    
    # Check RNNoise availability
    echo ""
    echo -e "${CYAN}RNNoise Status:${NC}"
    if ls /usr/lib/ladspa/librnnoise_ladspa.so >/dev/null 2>&1; then
        echo -e "${GREEN}✅ RNNoise LADSPA plugin is available${NC}"
        echo -e "${CYAN}   Location: /usr/lib/ladspa/librnnoise_ladspa.so${NC}"
    else
        echo -e "${RED}❌ RNNoise LADSPA plugin not found${NC}"
        echo -e "${CYAN}   Run: ./mic-noise-reduction.sh rnnoise${NC}"
    fi
    
    # Show recommendations
    echo ""
    echo -e "${YELLOW}💡 Tips for better audio quality:${NC}"
    echo "• Use a quiet environment"
    echo "• Position microphone 6-8 inches from your mouth"
    echo "• Avoid fans, air conditioning, and electronic devices"
    echo "• Use 'rnnoise' command for AI-powered noise suppression"
    echo "• Use 'easyeffects' for advanced processing"
}

# Function to create post-processing script for Audacity
create_audacity_guide() {
    cat > ~/mic-noise-removal-audacity.txt << 'EOF'
# Audacity Noise Removal Guide

## Quick Steps:
1. Record 5-10 seconds of "silence" (room tone) before speaking
2. Select the silent portion (click and drag)
3. Go to Effect > Noise Reduction
4. Click "Get Noise Profile"
5. Select your entire recording (Ctrl+A)
6. Go to Effect > Noise Reduction again
7. Adjust settings:
   - Noise Reduction (dB): Start with 12-15
   - Sensitivity: Start with 6.00
   - Frequency Smoothing: Start with 3
8. Click "Preview" to test
9. Click "OK" to apply

## Advanced Settings:
- For heavy noise: Increase Noise Reduction to 20-25 dB
- For preserving voice quality: Lower Sensitivity to 4-5
- For natural sound: Keep Frequency Smoothing at 1-3

## Blue Yeti USB Whine Fix:
If you have a Blue Yeti with high-pitched whine:
1. Install "Mosquito Killer 4" plugin
2. Use setting of 8 for best results
3. Available at: https://forum.audacityteam.org/

## Additional Tips:
- Always work on a copy of your recording
- Use headphones to monitor changes
- Less is more - over-processing can sound unnatural
- Record in the quietest environment possible
EOF

    echo -e "${GREEN}✅ Audacity noise removal guide created${NC}"
    echo -e "${CYAN}Guide saved to: ~/mic-noise-removal-audacity.txt${NC}"
}

# Main script logic
case "${1:-help}" in
    "enable"|"on"|"start")
        setup_pulseaudio_noise_reduction
        ;;
    "rnnoise"|"ai")
        setup_rnnoise
        ;;
    "easyeffects"|"advanced")
        setup_easyeffects
        ;;
    "disable"|"off"|"stop")
        remove_noise_reduction
        ;;
    "test"|"check")
        test_microphone
        ;;
    "status"|"show")
        show_status
        ;;
    "audacity"|"guide")
        create_audacity_guide
        echo -e "${CYAN}Opening Audacity guide...${NC}"
        cat ~/mic-noise-removal-audacity.txt
        ;;
    "help"|*)
        echo -e "${BLUE}🎤 Microphone Noise Reduction Control${NC}"
        echo ""
        echo -e "${YELLOW}REAL-TIME NOISE REDUCTION:${NC}"
        echo "  enable/on/start      - Enable basic PulseAudio noise reduction"
        echo "  rnnoise/ai           - Enable AI-based RNNoise suppression (RECOMMENDED)"
        echo "  easyeffects/advanced - Setup EasyEffects for advanced processing"
        echo "  disable/off/stop     - Disable all noise reduction"
        echo ""
        echo -e "${YELLOW}UTILITIES:${NC}"
        echo "  test/check           - Test microphone quality"
        echo "  status/show          - Show current noise reduction status"
        echo "  audacity/guide       - Create Audacity noise removal guide"
        echo ""
        echo -e "${YELLOW}QUICK START:${NC}"
        echo -e "${GREEN}  ./mic-noise-reduction.sh rnnoise${NC}     - Best option for most users"
        echo -e "${CYAN}  ./mic-noise-reduction.sh status${NC}      - Check what's currently active"
        echo -e "${CYAN}  ./mic-noise-reduction.sh test${NC}        - Test your microphone"
        echo ""
        echo -e "${YELLOW}WHAT IS RNNoise?${NC}"
        echo "• AI-powered noise suppression using neural networks"
        echo "• Removes background noise, fans, typing, etc."
        echo "• Works with Discord, Zoom, OBS, and all applications"
        echo "• Much better than basic noise reduction"
        echo ""
        echo -e "${YELLOW}RECOMMENDATIONS:${NC}"
        echo "• Start with 'rnnoise' for best AI-powered noise suppression"
        echo "• Use 'easyeffects' for professional audio processing"
        echo "• Use 'audacity' for post-processing recorded files"
        echo "• Use 'disable' to return to original microphone"
        echo ""
        echo -e "${CYAN}Current Status:${NC}"
        show_status
        ;;
esac 