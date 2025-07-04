# RNNoise Quick Reference Card

## 🚀 One-Time Setup
```bash
# Install packages
sudo pacman -S rnnoise noise-suppression-for-voice ladspa

# Make script executable
chmod +x mic-noise-reduction.sh

# Enable RNNoise
./mic-noise-reduction.sh rnnoise
```

## 🎛️ Essential Commands
```bash
# Enable AI noise reduction
./mic-noise-reduction.sh rnnoise

# Check status
./mic-noise-reduction.sh status

# Test microphone
./mic-noise-reduction.sh test

# Disable noise reduction
./mic-noise-reduction.sh disable

# Show all options
./mic-noise-reduction.sh help
```

## 📱 Application Settings
**Select microphone:** `Microphone (RNNoise Denoised)`

**Turn OFF** built-in noise reduction in:
- Discord (Voice & Video settings)
- Zoom (Audio settings)
- OBS (no additional filters needed)

## 🔧 Troubleshooting
```bash
# Plugin not found
sudo pacman -S noise-suppression-for-voice

# Audio issues
pulseaudio --kill && pulseaudio --start

# Reset everything
./mic-noise-reduction.sh disable
./mic-noise-reduction.sh rnnoise

# Check what's loaded
./mic-noise-reduction.sh status
```

## 🎯 Best Practices
- Position mic **6-8 inches** from mouth
- Use in **quiet environment**
- **Test before** important calls
- Turn off **app noise reduction**
- Microphone gain: **70-80%** (not 100%)

## 🔄 Auto-Start
```bash
# Add to hyprland.conf
echo 'exec-once = /home/mujheri/.config/hypr/mic-noise-reduction.sh rnnoise' >> ~/.config/hypr/hyprland.conf
```

## 📋 Status Check
```bash
./mic-noise-reduction.sh status
```
**Look for:** ✅ `RNNoise AI noise reduction is ACTIVE`

---
**🎤 AI-Powered Noise Cancellation in 3 Steps:**
1. `sudo pacman -S rnnoise noise-suppression-for-voice ladspa`
2. `./mic-noise-reduction.sh rnnoise`
3. Select "Microphone (RNNoise Denoised)" in apps 