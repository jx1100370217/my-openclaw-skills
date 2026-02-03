---
name: voice-setup
description: Set up free voice functionality (TTS + STT) for OpenClaw using Edge TTS and whisper-cpp. Use when: (1) User wants to add voice/audio capabilities, (2) Setting up speech-to-text transcription, (3) Configuring text-to-speech synthesis, (4) Enabling voice messages on Telegram/WhatsApp, (5) User asks about free TTS/STT solutions without API keys.
---

# Voice Setup Skill

This skill helps configure free, open-source voice capabilities for OpenClaw.

## Overview

| Component | Solution | Cost |
|-----------|----------|------|
| **TTS** (Text-to-Speech) | Edge TTS (Microsoft) | Free, no API key |
| **STT** (Speech-to-Text) | whisper-cpp | Free, local processing |

## Prerequisites

Check and install dependencies:

```bash
# Check for Homebrew
which brew || echo "Install Homebrew first: https://brew.sh"

# Install whisper-cpp (STT)
brew install whisper-cpp

# Install ffmpeg (audio conversion)
brew install ffmpeg

# Download whisper model (base is recommended for balance of speed/accuracy)
mkdir -p ~/.openclaw/models
curl -L -o ~/.openclaw/models/ggml-base.bin \
  "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin"
```

## Configuration

Apply this config patch to enable voice:

```json
{
  "messages": {
    "tts": {
      "auto": "inbound",
      "provider": "edge",
      "edge": {
        "enabled": true,
        "voice": "zh-CN-XiaoxiaoNeural",
        "lang": "zh-CN",
        "outputFormat": "audio-24khz-48kbitrate-mono-mp3"
      }
    }
  },
  "tools": {
    "media": {
      "audio": {
        "enabled": true,
        "maxBytes": 20971520,
        "models": [
          {
            "type": "cli",
            "command": "bash",
            "args": ["-c", "ffmpeg -i '{{MediaPath}}' -ar 16000 -ac 1 /tmp/whisper-input.wav -y >/dev/null 2>&1 && whisper-cli -m ~/.openclaw/models/ggml-base.bin -l auto -f /tmp/whisper-input.wav 2>/dev/null | grep -E '^\\[' | sed 's/\\[.*\\] //'"],
            "timeoutSeconds": 120
          }
        ]
      }
    }
  }
}
```

## TTS Voice Options

### Chinese Voices
- `zh-CN-XiaoxiaoNeural` - 女声，活泼 (recommended)
- `zh-CN-YunxiNeural` - 男声，自然
- `zh-CN-XiaoyiNeural` - 女声，温柔

### English Voices
- `en-US-JennyNeural` - Female, warm
- `en-US-GuyNeural` - Male, natural
- `en-GB-SoniaNeural` - British female

### Other Languages
- `ja-JP-NanamiNeural` - Japanese female
- `ko-KR-SunHiNeural` - Korean female
- `de-DE-KatjaNeural` - German female

List all voices: `npx node-edge-tts --list-voices`

## TTS Modes

| Mode | Behavior |
|------|----------|
| `off` | TTS disabled |
| `inbound` | Reply with voice only if user sent voice (recommended) |
| `always` | Always reply with voice |
| `tagged` | Only when reply contains `[[tts]]` tags |

## Whisper Models

| Model | Size | Speed | Accuracy |
|-------|------|-------|----------|
| `ggml-tiny.bin` | 75MB | Fastest | Basic |
| `ggml-base.bin` | 142MB | Fast | Good (recommended) |
| `ggml-small.bin` | 466MB | Medium | Better |
| `ggml-medium.bin` | 1.5GB | Slow | Best |

## Testing

### Test TTS
```bash
npx node-edge-tts -t '你好！语音测试' -v 'zh-CN-XiaoxiaoNeural' -f /tmp/test.mp3
```

### Test STT
```bash
ffmpeg -i input.ogg -ar 16000 -ac 1 /tmp/test.wav -y
whisper-cli -m ~/.openclaw/models/ggml-base.bin -l auto -f /tmp/test.wav
```

## Troubleshooting

### "whisper-cli not found"
```bash
brew install whisper-cpp
```

### "ffmpeg not found"
```bash
brew install ffmpeg
```

### Audio file format error
Telegram sends OGG/Opus, whisper needs WAV. The config handles conversion automatically.

### Model not found
```bash
curl -L -o ~/.openclaw/models/ggml-base.bin \
  "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin"
```
