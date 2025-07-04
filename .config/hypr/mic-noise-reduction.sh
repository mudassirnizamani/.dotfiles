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
    
    # Install RNNoise if not present
    if ! command_exists "rnnoise"; then
        echo -e "${YELLOW}Installing RNNoise...${NC}"
        
        # Check if available in repos
        if pacman -Ss rnnoise >/dev/null 2>&1; then
            sudo pacman -S rnnoise --noconfirm
        else
            echo -e "${YELLOW}RNNoise not in repos, installing from AUR...${NC}"
            if command_exists "yay"; then
                yay -S rnnoise --noconfirm
            elif command_exists "paru"; then
                paru -S rnnoise --noconfirm
            else
                echo -e "${RED}❌ AUR helper not found. Please install yay or paru first${NC}"
                return 1
            fi
        fi
    fi
    
    # Load PulseAudio module with RNNoise
    pactl load-module module-ladspa-sink \
        sink_name=mic_rnnoise_out \
        sink_properties=device.description='"Microphone RNNoise Output"' \
        master="$MIC_SOURCE" \
        plugin=rnnoise_ladspa \
        label=noise_suppressor_mono
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ RNNoise activated${NC}"
        echo -e "${CYAN}AI-based noise reduction is now active${NC}"
        
        # Send notification
        notify-send -h string:mic-noise:control -t 3000 "🤖 AI Noise Reduction" "RNNoise AI noise suppression activated"
        return 0
    else
        echo -e "${RED}❌ Failed to setup RNNoise${NC}"
        return 1
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

# Function to remove noise reduction
remove_noise_reduction() {
    echo -e "${BLUE}Removing noise reduction modules...${NC}"
    
    # Unload PulseAudio modules
    pactl unload-module module-echo-cancel 2>/dev/null || true
    pactl unload-module module-ladspa-sink 2>/dev/null || true
    
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
    
    # Show loaded modules
    echo -e "${CYAN}Loaded noise reduction modules:${NC}"
    pactl list modules short | grep -E "(echo-cancel|ladspa|rnnoise)" || echo "  None"
    
    # Show available sources
    echo -e "${CYAN}Available microphone sources:${NC}"
    pactl list sources short | grep -E "(input|mic)" || echo "  None found"
    
    # Show recommendations
    echo ""
    echo -e "${YELLOW}💡 Tips for better audio quality:${NC}"
    echo "• Use a quiet environment"
    echo "• Position microphone 6-8 inches from your mouth"
    echo "• Avoid fans, air conditioning, and electronic devices"
    echo "• Use noise reduction for consistent background noise"
    echo "• Use EasyEffects for advanced processing"
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
        echo "  enable/on/start    - Enable basic PulseAudio noise reduction"
        echo "  rnnoise/ai         - Enable AI-based RNNoise suppression"
        echo "  easyeffects/advanced - Setup EasyEffects for advanced processing"
        echo "  disable/off/stop   - Disable all noise reduction"
        echo ""
        echo -e "${YELLOW}UTILITIES:${NC}"
        echo "  test/check         - Test microphone quality"
        echo "  status/show        - Show current noise reduction status"
        echo "  audacity/guide     - Create Audacity noise removal guide"
        echo ""
        echo -e "${YELLOW}RECOMMENDATIONS:${NC}"
        echo "• Start with 'enable' for basic noise reduction"
        echo "• Use 'rnnoise' for AI-powered noise suppression"
        echo "• Use 'easyeffects' for professional audio processing"
        echo "• Use 'audacity' for post-processing recorded files"
        echo ""
        echo -e "${CYAN}Current Status:${NC}"
        show_status
        ;;
esac 