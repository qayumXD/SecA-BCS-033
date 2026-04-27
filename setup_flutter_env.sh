#!/bin/bash
# Flutter & Android Development Environment Setup Script
# This script configures the environment variables needed for Flutter development

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Flutter Development Environment Setup${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Set Flutter and Android environment variables
export PATH="/opt/flutter/bin:$PATH"
export ANDROID_HOME="/opt/android/sdk"
export ANDROID_SDK_ROOT="/opt/android/sdk"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"
export CHROME_EXECUTABLE=$(which chromium-browser)

# Verify installations
echo -e "${BLUE}Verifying installations...${NC}\n"

# Check Flutter
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    echo -e "${GREEN}✓${NC} Flutter: $FLUTTER_VERSION"
else
    echo -e "${YELLOW}✗${NC} Flutter not found"
fi

# Check Java
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1)
    echo -e "${GREEN}✓${NC} Java: $JAVA_VERSION"
else
    echo -e "${YELLOW}✗${NC} Java not found"
fi

# Check Android SDK
if [ -d "$ANDROID_HOME" ]; then
    echo -e "${GREEN}✓${NC} Android SDK: $ANDROID_HOME"
else
    echo -e "${YELLOW}✗${NC} Android SDK not found"
fi

# Check Chrome
if [ -n "$CHROME_EXECUTABLE" ]; then
    echo -e "${GREEN}✓${NC} Chrome: $CHROME_EXECUTABLE"
else
    echo -e "${YELLOW}!${NC} Chrome not found (optional)"
fi

echo -e "\n${BLUE}Running Flutter Doctor...${NC}\n"
flutter doctor

echo -e "\n${BLUE}========================================${NC}"
echo -e "${GREEN}Environment setup complete!${NC}"
echo -e "${BLUE}========================================${NC}\n"
echo -e "To use these settings in new terminals, add to ~/.bashrc:"
echo -e "${YELLOW}source ~/.bashrc${NC}\n"
