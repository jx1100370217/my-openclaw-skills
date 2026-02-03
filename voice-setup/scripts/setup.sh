#!/bin/bash
# Voice Setup Script for OpenClaw
# Installs and configures free TTS (Edge TTS) + STT (whisper-cpp)

set -e

echo "🎤 OpenClaw Voice Setup"
echo "======================"
echo ""

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Please install it first:"
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

echo "✅ Homebrew found"

# Install whisper-cpp
echo ""
echo "📦 Installing whisper-cpp..."
if brew list whisper-cpp &> /dev/null; then
    echo "   Already installed"
else
    brew install whisper-cpp
fi

# Install ffmpeg
echo ""
echo "📦 Installing ffmpeg..."
if brew list ffmpeg &> /dev/null; then
    echo "   Already installed"
else
    brew install ffmpeg
fi

# Download whisper model
echo ""
echo "🧠 Downloading whisper model (ggml-base.bin)..."
MODEL_DIR="$HOME/.openclaw/models"
MODEL_PATH="$MODEL_DIR/ggml-base.bin"

mkdir -p "$MODEL_DIR"

if [ -f "$MODEL_PATH" ]; then
    echo "   Model already exists at $MODEL_PATH"
else
    curl -L -o "$MODEL_PATH" \
        "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin"
    echo "   Downloaded to $MODEL_PATH"
fi

# Test installations
echo ""
echo "🔍 Verifying installations..."

if command -v whisper-cli &> /dev/null; then
    echo "   ✅ whisper-cli"
else
    echo "   ❌ whisper-cli not found"
fi

if command -v ffmpeg &> /dev/null; then
    echo "   ✅ ffmpeg"
else
    echo "   ❌ ffmpeg not found"
fi

if [ -f "$MODEL_PATH" ]; then
    echo "   ✅ whisper model ($(du -h "$MODEL_PATH" | cut -f1))"
else
    echo "   ❌ whisper model not found"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Apply the voice config to OpenClaw (see SKILL.md)"
echo "2. Restart OpenClaw gateway"
echo "3. Test by sending a voice message!"
