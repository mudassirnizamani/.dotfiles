# Microphone Noise Reduction Guide

## Overview
This guide provides comprehensive solutions for reducing background noise and improving microphone audio quality in your Hyprland setup. Whether you're recording with GPU Screen Recorder or using your microphone for other purposes, these methods will help you achieve cleaner audio.

## 🎯 Quick Start

### Method 1: Basic PulseAudio Noise Reduction (Recommended)
```bash
# Enable noise reduction
./mic-noise-reduction.sh enable

# Test the result
./mic-noise-reduction.sh test

# Check status
./mic-noise-reduction.sh status
```

### Method 2: AI-Powered Noise Reduction (Best Quality)
```bash
# Enable RNNoise AI processing
./mic-noise-reduction.sh rnnoise

# Test the result
./mic-noise-reduction.sh test
```

### Method 3: Post-Processing with Audacity
```bash
# Create Audacity guide
./mic-noise-reduction.sh audacity

# Follow the guide in ~/mic-noise-removal-audacity.txt
```

## 📋 Available Methods

### 1. Real-Time Noise Reduction

#### PulseAudio Echo Cancellation
- **Best for**: Consistent background noise (fans, AC, electrical hum)
- **Resource usage**: Low
- **Quality**: Good for most scenarios

```bash
./mic-noise-reduction.sh enable
```

Features:
- WebRTC-based noise suppression
- Voice activity detection
- Automatic gain control
- Creates `mic_denoised` source

#### RNNoise AI Processing
- **Best for**: Complex noise patterns and speech enhancement
- **Resource usage**: Medium
- **Quality**: Excellent for speech clarity

```bash
./mic-noise-reduction.sh rnnoise
```

Features:
- Machine learning-based noise reduction
- Trained on human speech patterns
- Excellent for voice recordings
- Superior to traditional methods

#### EasyEffects Professional Processing
- **Best for**: Advanced users wanting full control
- **Resource usage**: Medium-High
- **Quality**: Professional-grade with fine-tuning

```bash
./mic-noise-reduction.sh easyeffects
```

Features:
- Complete audio processing pipeline
- Compressor, gate, EQ, and filters
- Real-time visual feedback
- Preset-based configuration

### 2. Post-Processing Methods

#### Audacity Noise Reduction
- **Best for**: Recorded audio cleanup
- **Resource usage**: N/A (offline processing)
- **Quality**: Very good with proper technique

**Quick Steps:**
1. Record 5-10 seconds of room tone (silence)
2. Select the noise-only portion
3. Effect → Noise Reduction → Get Noise Profile
4. Select entire recording
5. Effect → Noise Reduction → Adjust settings → OK

**Recommended Settings:**
- **Noise Reduction (dB)**: 12-15 (start conservative)
- **Sensitivity**: 6.00 (balance between noise removal and voice quality)
- **Frequency Smoothing**: 3 (keeps voice natural)

## 🎛️ Script Commands

### Noise Reduction Control
```bash
# Real-time noise reduction
./mic-noise-reduction.sh enable          # Basic PulseAudio noise reduction
./mic-noise-reduction.sh rnnoise         # AI-powered RNNoise
./mic-noise-reduction.sh easyeffects     # Advanced processing setup

# Control
./mic-noise-reduction.sh disable         # Turn off noise reduction
./mic-noise-reduction.sh test           # Test current setup
./mic-noise-reduction.sh status         # Show current configuration

# Guides
./mic-noise-reduction.sh audacity       # Create Audacity guide
./mic-noise-reduction.sh help           # Show all options
```

### Audio Configuration
```bash
# Configure recording audio
./audio-config.sh both                  # Mic + system audio
./audio-config.sh mic                   # Microphone only
./audio-config.sh system                # System audio only
./audio-config.sh none                  # No audio

# Utilities
./audio-config.sh test                  # Test audio setup
./audio-config.sh current               # Show current configuration
./audio-config.sh volume 60             # Set microphone volume
./audio-config.sh noise                 # Noise reduction options
```

### Microphone Volume Control
```bash
# Volume presets
./mic-volume-control.sh normal          # 60% (recommended)
./mic-volume-control.sh loud            # 85% (if too quiet)
./mic-volume-control.sh quiet           # 30% (if too loud)

# Fine adjustments
./mic-volume-control.sh up              # Increase by 10%
./mic-volume-control.sh down            # Decrease by 10%
./mic-volume-control.sh 75              # Set to specific percentage

# Utilities
./mic-volume-control.sh test            # Test with 3-second recording
./mic-volume-control.sh status          # Show current volume
./mic-volume-control.sh mute            # Toggle mute
```

## 🔧 Troubleshooting

### Common Issues and Solutions

#### 1. No Audio After Enabling Noise Reduction
**Symptoms**: Complete silence or no input detected
**Solutions**:
```bash
# Check available sources
./mic-noise-reduction.sh status

# Disable and re-enable
./mic-noise-reduction.sh disable
./mic-noise-reduction.sh enable

# Check microphone volume
./mic-volume-control.sh status
```

#### 2. Audio Sounds Robotic or Distorted
**Symptoms**: Unnatural voice, artifacts, or metallic sound
**Solutions**:
```bash
# For PulseAudio: Try different method
./mic-noise-reduction.sh disable
./mic-noise-reduction.sh rnnoise

# For Audacity: Reduce settings
# - Lower Noise Reduction to 8-10 dB
# - Reduce Sensitivity to 4-5
# - Increase Frequency Smoothing to 5-6
```

#### 3. High CPU Usage
**Symptoms**: System slowdown with noise reduction active
**Solutions**:
```bash
# Use lighter method
./mic-noise-reduction.sh disable
./mic-noise-reduction.sh enable  # Instead of rnnoise

# Close EasyEffects if running
pkill easyeffects
```

#### 4. Microphone Not Detected
**Symptoms**: No microphone sources found
**Solutions**:
```bash
# List all audio sources
pactl list sources short

# Check hardware detection
arecord -l

# Restart audio system
systemctl --user restart pipewire
```

#### 5. Blue Yeti USB Whine
**Symptoms**: High-pitched whine or buzzing (common with Blue Yeti)
**Solutions**:
```bash
# Try different USB port
# Use powered USB hub
# For post-processing: Use Audacity with "Mosquito Killer 4" plugin
```

### Performance Optimization

#### For Real-Time Processing
```bash
# Check current CPU usage
top -p $(pgrep -f "pulseaudio\|pipewire")

# Optimize settings
# - Use 'enable' instead of 'rnnoise' for lower CPU usage
# - Close unnecessary audio applications
# - Use lower sample rates if needed
```

#### For Recording Quality
```bash
# Set optimal microphone volume
./mic-volume-control.sh normal

# Test before recording
./mic-noise-reduction.sh test

# Record room tone for post-processing
# Always record 10 seconds of silence at the start
```

## 📊 Method Comparison

| Method | CPU Usage | Quality | Latency | Best For |
|--------|-----------|---------|---------|----------|
| PulseAudio | Low | Good | Very Low | Live streaming, gaming |
| RNNoise | Medium | Excellent | Low | Voice recording, podcasts |
| EasyEffects | Medium-High | Professional | Low | Professional content |
| Audacity | N/A | Very Good | N/A | Post-production |

## 🎚️ Advanced Configuration

### Custom PulseAudio Module Settings
```bash
# Manual module loading with custom settings
pactl load-module module-echo-cancel \
    source_name=mic_custom \
    aec_method=webrtc \
    aec_args='"noise_suppression=1 analog_gain_control=0"'
```

### EasyEffects Custom Presets
Location: `~/.config/easyeffects/input/`
- Create custom JSON presets
- Import/export configurations
- Fine-tune compressor, gate, and EQ settings

### Recording with Different Sample Rates
```bash
# High-quality recording
parecord --device=mic_denoised --rate=48000 --format=s24le output.wav

# Lower CPU usage
parecord --device=mic_denoised --rate=22050 --format=s16le output.wav
```

## 🔍 Monitoring and Analysis

### Real-Time Audio Monitoring
```bash
# Monitor audio levels
pavucontrol

# Command-line volume meter
pactl subscribe | grep --line-buffered source
```

### Audio Quality Analysis
```bash
# Check recording quality
file your_recording.wav

# Audio spectrum analysis (if available)
audacity your_recording.wav
```

## 💡 Best Practices

### Recording Environment
1. **Room Treatment**: Use soft furnishings to reduce echo
2. **Microphone Position**: 6-8 inches from mouth, slightly off-axis
3. **Background Noise**: Minimize fans, AC, and electronic devices
4. **Consistent Setup**: Same position and settings for all recordings

### Recording Technique
1. **Test First**: Always test audio before important recordings
2. **Room Tone**: Record 10 seconds of silence for post-processing
3. **Monitor Levels**: Keep input levels around 60-70% to avoid clipping
4. **Backup Method**: Have post-processing option ready

### System Optimization
1. **Audio Driver**: Use latest drivers for your audio interface
2. **Power Management**: Disable CPU power saving during recording
3. **Process Priority**: Set higher priority for audio processes if needed
4. **Buffer Settings**: Adjust buffer sizes for your use case

## 🎯 Recommended Workflow

### For Live Streaming/Gaming
```bash
# 1. Enable basic noise reduction
./mic-noise-reduction.sh enable

# 2. Set appropriate volume
./mic-volume-control.sh normal

# 3. Test setup
./mic-noise-reduction.sh test

# 4. Configure recording
./audio-config.sh both
```

### For Content Creation
```bash
# 1. Enable AI processing
./mic-noise-reduction.sh rnnoise

# 2. Set optimal volume
./mic-volume-control.sh normal

# 3. Test and adjust
./mic-noise-reduction.sh test
./mic-volume-control.sh up  # if needed

# 4. Record with room tone
# Always record 10 seconds of silence first
```

### For Professional Recording
```bash
# 1. Setup EasyEffects
./mic-noise-reduction.sh easyeffects

# 2. Open EasyEffects GUI for fine-tuning
easyeffects

# 3. Configure optimal settings
./mic-volume-control.sh normal

# 4. Test extensively
./mic-noise-reduction.sh test

# 5. Record with backup plan
# Enable post-processing in Audacity as backup
```

## 📞 Support and Additional Resources

### Useful Commands
```bash
# System information
./mic-noise-reduction.sh status
./audio-config.sh current
./mic-volume-control.sh status

# Reset everything
./mic-noise-reduction.sh disable
./mic-volume-control.sh normal
```

### External Resources
- [Audacity Manual](https://manual.audacityteam.org/)
- [EasyEffects Documentation](https://github.com/wwmm/easyeffects)
- [PulseAudio Wiki](https://wiki.archlinux.org/title/PulseAudio)
- [RNNoise Project](https://github.com/xiph/rnnoise)

### Community Solutions
- [Audacity Forum](https://forum.audacityteam.org/) - For advanced noise removal techniques
- [r/audio](https://reddit.com/r/audio) - General audio help
- [Arch Linux Forums](https://bbs.archlinux.org/) - System-specific issues

---

**Last Updated**: January 2025
**Compatible with**: Manjaro Linux, PulseAudio/PipeWire, Hyprland 