# RNNoise AI Noise Cancellation Setup Guide for Manjaro Linux

## 🎤 What is RNNoise?

RNNoise is an **AI-powered noise suppression library** that uses neural networks to remove background noise from your microphone in real-time. It's much more effective than basic noise reduction and works with all applications.

### Why Use RNNoise?
- ✅ **AI-powered**: Machine learning distinguishes voice from noise
- ✅ **Real-time**: No latency during calls/streaming
- ✅ **Universal**: Works with Discord, Zoom, OBS, Teams, etc.
- ✅ **Removes**: Fan noise, typing, air conditioning, street noise
- ✅ **Free**: Open source alternative to expensive solutions

---

## 📥 Installation

### Step 1: Install Required Packages

```bash
# Update system
sudo pacman -Syu

# Install RNNoise and components
sudo pacman -S rnnoise noise-suppression-for-voice ladspa

# Optional audio tools
sudo pacman -S pavucontrol
```

### Step 2: Verify Installation

```bash
# Check if RNNoise plugin is installed
ls -la /usr/lib/ladspa/librnnoise_ladspa.so

# Should show the plugin file
```

---

## 🚀 Quick Start

### Enable RNNoise (One Command)

```bash
./mic-noise-reduction.sh rnnoise
```

**What this does:**
1. Creates virtual "denoised" microphone
2. Routes your mic through AI processing
3. Sets denoised mic as default
4. Shows success message

### Test Your Setup

```bash
# Test microphone quality
./mic-noise-reduction.sh test

# Check current status
./mic-noise-reduction.sh status
```

---

## 📱 Using in Applications

### Discord
1. Settings → Voice & Video
2. Select: **"Microphone (RNNoise Denoised)"**
3. Turn OFF Discord's noise suppression

### Zoom
1. Settings → Audio
2. Select: **"Microphone (RNNoise Denoised)"**
3. Disable Zoom's noise reduction

### OBS Studio
1. Add Audio Input Capture
2. Device: **"Microphone (RNNoise Denoised)"**

### Other Apps
Look for **"Microphone (RNNoise Denoised)"** in audio settings.

---

## 🎛️ Script Commands

```bash
# Enable AI noise reduction (RECOMMENDED)
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

---

## 🔧 Troubleshooting

### Plugin Not Found
```bash
# Reinstall packages
sudo pacman -S rnnoise noise-suppression-for-voice ladspa
```

### Audio Issues
```bash
# Restart audio system
pulseaudio --kill
pulseaudio --start

# Or for PipeWire
systemctl --user restart pipewire
```

### App Doesn't See Denoised Mic
```bash
# Check status
./mic-noise-reduction.sh status

# Restart the application
# Most apps need restart to see new audio devices
```

### Reset Everything
```bash
# Disable and re-enable
./mic-noise-reduction.sh disable
./mic-noise-reduction.sh rnnoise
```

---

## 🎯 Best Practices

### For Best Results:
1. **Position mic 6-8 inches from mouth**
2. **Use in quiet environment**
3. **Avoid pointing at fans/AC**
4. **Test before important calls**
5. **Turn off app noise reduction**

### Microphone Settings:
- **Gain**: 70-80% (not 100%)
- **Boost**: Disable if available
- **Sample Rate**: 48000 Hz

---

## 🔄 Auto-Start on Boot

### Add to Hyprland Config
```bash
# Edit hyprland.conf
echo 'exec-once = /home/mujheri/.config/hypr/mic-noise-reduction.sh rnnoise' >> ~/.config/hypr/hyprland.conf
```

### Create Systemd Service
```bash
# Create service
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/rnnoise.service << 'EOF'
[Unit]
Description=RNNoise Microphone Noise Reduction
After=pulseaudio.service

[Service]
Type=oneshot
ExecStart=/home/mujheri/.config/hypr/mic-noise-reduction.sh rnnoise
RemainAfterExit=yes

[Install]
WantedBy=default.target
EOF

# Enable service
systemctl --user enable rnnoise.service
```

---

## 📋 Quick Reference

### One-Time Setup:
1. `sudo pacman -S rnnoise noise-suppression-for-voice ladspa`
2. `chmod +x mic-noise-reduction.sh`
3. `./mic-noise-reduction.sh rnnoise`

### Daily Usage:
- **Enable**: `./mic-noise-reduction.sh rnnoise`
- **Status**: `./mic-noise-reduction.sh status`
- **Disable**: `./mic-noise-reduction.sh disable`

### In Applications:
- Select: **"Microphone (RNNoise Denoised)"**
- Turn OFF built-in noise reduction

---

## 🆘 Common Issues & Solutions

| Problem | Solution |
|---------|----------|
| Plugin not found | `sudo pacman -S noise-suppression-for-voice` |
| No audio | `./mic-noise-reduction.sh disable` then re-enable |
| Poor quality | Check mic positioning, quiet environment |
| App doesn't see mic | Restart application |
| High CPU usage | Normal, RNNoise is efficient |

---

## 🌟 Pro Tips

1. **Test first**: Always test before important calls
2. **Monitor quality**: Ask others about audio quality
3. **Keyboard shortcuts**: Create shortcuts for enable/disable
4. **Keep updated**: Update packages regularly
5. **Backup settings**: Note what works for your setup

---

**🎤 Enjoy crystal-clear audio with AI-powered noise cancellation!**

*For support, run `./mic-noise-reduction.sh help` or check the status with `./mic-noise-reduction.sh status`* 