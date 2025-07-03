# GPU Screen Recorder Setup - Complete Documentation

## 🎯 Overview
This setup provides hardware-accelerated screen recording for Hyprland using GPU Screen Recorder, which is superior to wf-recorder in performance and features. It supports multiple recording modes with different audio configurations.

## 📦 Installation
```bash
# Install GPU Screen Recorder
sudo pamac build gpu-screen-recorder gpu-screen-recorder-gtk

# Install region selection tool
sudo pacman -S slurp

# Verify installation
which gpu-screen-recorder
which slurp
```

## 🎬 Recording Scripts Created

### 1. **gpu-screenrecorder.sh** - Main Full Screen Recording
- **Purpose**: Records entire screen with both microphone and system audio
- **Audio**: Microphone + System Audio (default_input|default_output)
- **Features**: 
  - Instant replay functionality (30-second buffer)
  - Hardware acceleration with h264_vaapi codec
  - Toggle, start, stop, replay, save, and status modes
  - Beautiful countdown notifications

### 2. **gpu-screenrecorder-mic-only.sh** - Microphone-Only Recording
- **Purpose**: Records entire screen with ONLY microphone audio (no system sounds)
- **Audio**: Microphone Only (default_input)
- **Features**:
  - Full screen recording without system audio
  - Hardware acceleration
  - Perfect for commentary/tutorials where you don't want system sounds
  - Distinctive "🎤 Mic Recording" notifications

### 3. **gpu-screenrecorder-region.sh** - Region Selection Recording
- **Purpose**: Records selected screen area with microphone and system audio
- **Audio**: Microphone + System Audio (default_input|default_output)
- **Features**:
  - Interactive region selection using slurp
  - Custom selection colors and styling
  - Same quality as full screen recording

### 4. **wf-screenrecorder.sh** - Backup wf-recorder Script
- **Purpose**: Fallback option using wf-recorder
- **Audio**: System audio support added
- **Features**: Basic recording with hardware acceleration support

### 5. **audio-config.sh** - Audio Configuration Helper
- **Purpose**: Manage audio settings for recordings
- **Options**:
  - `mic`: Microphone only
  - `system`: System audio only  
  - `both`: Both microphone and system audio
  - `none`: No audio
- **Features**: Test microphone, list devices, show current config

## ⌨️ Keybindings (Hyprland)

| Key Combination | Action | Script | Audio Mode |
|-----------------|--------|--------|------------|
| **Super + R** | Full screen recording | gpu-screenrecorder.sh | Mic + System |
| **Super + Shift + R** | Full screen mic-only | gpu-screenrecorder-mic-only.sh | **Mic Only** |
| **Super + Alt + R** | Region selection | gpu-screenrecorder-region.sh | Mic + System |
| **Super + Ctrl + R** | Start instant replay | gpu-screenrecorder.sh | Mic + System |
| **Super + Ctrl + Shift + R** | Save instant replay | gpu-screenrecorder.sh | Mic + System |
| **Super + F12** | Check recording status | gpu-screenrecorder.sh | N/A |

## 📁 File Naming Convention

All recordings are saved to `~/Videos/` with timestamps:

- **Regular recordings**: `gpu_recording_YYYY-MM-DD_HH-MM-SS.mp4`
- **Mic-only recordings**: `gpu_mic_recording_YYYY-MM-DD_HH-MM-SS.mp4`
- **Region recordings**: `gpu_region_YYYY-MM-DD_HH-MM-SS.mp4`
- **wf-recorder backups**: `screen_recording_YYYY-MM-DD_HH-MM-SS.mp4`

## 🔊 Audio Configuration Explained

### Current Audio Setup:
- **Microphone**: `alsa_input.pci-0000_05_00.6.analog-stereo`
- **System Audio**: `default_output`
- **Combined**: `default_input|default_output`

### Audio Modes:
1. **Both Sources** (`Super + R`, `Super + Alt + R`):
   - Records your voice AND system sounds
   - Perfect for gaming, streaming, or demonstrating software with sound
   
2. **Microphone Only** (`Super + Shift + R`):
   - Records ONLY your voice, no system sounds
   - Ideal for tutorials, commentary, or when you want clean audio

3. **System Only** (available via audio-config.sh):
   - Records only system sounds, no microphone
   - Good for capturing game audio or music

## 🛠️ Usage Instructions

### Basic Recording:
```bash
# Start/stop full screen recording with mic + system audio
Super + R

# Start/stop full screen recording with microphone only
Super + Shift + R

# Record selected region
Super + Alt + R
```

### Instant Replay:
```bash
# Start instant replay (30-second buffer)
Super + Ctrl + R

# Save the last 30 seconds
Super + Ctrl + Shift + R
```

### Manual Script Usage:
```bash
# Full screen recording modes
./gpu-screenrecorder.sh toggle      # Toggle recording
./gpu-screenrecorder.sh start       # Start recording
./gpu-screenrecorder.sh stop        # Stop recording
./gpu-screenrecorder.sh replay      # Start instant replay
./gpu-screenrecorder.sh save        # Save instant replay
./gpu-screenrecorder.sh status      # Check status

# Microphone-only recording
./gpu-screenrecorder-mic-only.sh toggle

# Region recording
./gpu-screenrecorder-region.sh toggle

# Audio configuration
./audio-config.sh mic              # Set microphone only
./audio-config.sh system           # Set system audio only
./audio-config.sh both             # Set both sources
./audio-config.sh test             # Test microphone
```

## ⚙️ Technical Configuration

### Video Settings:
- **Codec**: H264 with hardware acceleration (h264_vaapi)
- **Quality**: Very High
- **Framerate**: 60 FPS
- **Resolution**: Native screen resolution (1920x1080)
- **Container**: MP4
- **Cursor**: Recorded by default

### Audio Settings:
- **Codec**: Opus (high quality, efficient)
- **Sample Rate**: 48kHz
- **Channels**: Stereo
- **Bitrate**: Adaptive based on source

## 🎯 Use Cases

### When to Use Each Mode:

1. **Super + R** (Full Screen + Both Audio):
   - Gaming with commentary
   - Software tutorials with system sounds
   - Streaming preparation
   - General screen recording

2. **Super + Shift + R** (Full Screen + Mic Only):
   - Clean commentary recordings
   - Tutorials without system interference
   - Voice-over work
   - Professional presentations

3. **Super + Alt + R** (Region + Both Audio):
   - Specific application demos
   - Focused tutorials
   - Smaller file sizes
   - Highlighting specific areas

4. **Instant Replay** (Super + Ctrl + R):
   - Gaming highlights
   - Capturing unexpected moments
   - Performance monitoring
   - Bug reproduction

## 🔧 Troubleshooting

### Common Issues:

1. **No Audio in Recording**:
   ```bash
   # Check audio devices
   ./audio-config.sh list
   
   # Test microphone
   ./audio-config.sh test
   
   # Reset to both sources
   ./audio-config.sh both
   ```

2. **Recording Not Starting**:
   ```bash
   # Check if already recording
   ./gpu-screenrecorder.sh status
   
   # Stop any existing recording
   ./gpu-screenrecorder.sh stop
   ```

3. **Poor Performance**:
   - Ensure hardware acceleration is working
   - Check GPU utilization during recording
   - Verify NVIDIA drivers are up to date

4. **Region Selection Not Working**:
   ```bash
   # Verify slurp is installed
   which slurp
   
   # Install if missing
   sudo pacman -S slurp
   ```

### Log Files:
- Recordings save to: `~/Videos/`
- Temporary files: `/tmp/gpu-screen-recorder-*.pid`
- Check system logs: `journalctl -f` while recording

## 📊 Performance Impact

GPU Screen Recorder is designed for minimal performance impact:
- **GPU-only encoding**: Uses hardware acceleration
- **Low CPU usage**: Typically <5% CPU usage
- **Minimal memory**: Uses GPU memory for encoding
- **No dropped frames**: Hardware encoding prevents frame drops

## 🔄 Updating Configuration

To modify settings, edit the configuration variables at the top of each script:

```bash
# Example: Change framerate to 30 FPS
nano ~/.config/hypr/gpu-screenrecorder.sh
# Change: FRAMERATE="60" to FRAMERATE="30"

# Reload Hyprland configuration
hyprctl reload
```

## 📝 Notes

- All scripts are executable and located in `~/.config/hypr/`
- Keybindings are defined in `hyprland.conf`
- Audio configuration persists between sessions
- Hardware acceleration requires compatible GPU and drivers
- Instant replay uses system memory for buffering

## 🎉 Advantages Over wf-recorder

- **Hardware Acceleration**: GPU-based encoding vs CPU
- **Better Performance**: Minimal system impact
- **Instant Replay**: ShadowPlay-like functionality
- **Superior Audio**: Better audio handling and mixing
- **Wayland Native**: Designed specifically for Wayland/Hyprland
- **Active Development**: Regular updates and improvements

---

*Last Updated: January 2025*
*Setup tested on: Manjaro Linux with Hyprland + NVIDIA GPU*
