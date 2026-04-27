#!/bin/bash
# Build all Flutter projects to APKs
# This script builds debug APKs for all Flutter projects in the workspace

# Set environment variables
export PATH="/opt/flutter/bin:$PATH"
export ANDROID_HOME="/opt/android/sdk"
export ANDROID_SDK_ROOT="/opt/android/sdk"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Arrays to track results
declare -a PROJECTS
declare -a BUILT_SUCCESSFULLY
declare -a FAILED_BUILDS

# Find all Flutter projects
echo -e "${BLUE}Scanning for Flutter projects...${NC}\n"

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check each directory for pubspec.yaml
check_flutter_project() {
    local dir=$1
    if [ -f "$dir/pubspec.yaml" ]; then
        PROJECTS+=("$dir")
        return 0
    fi
    return 1
}

# Scan directories
for dir in "$WORKSPACE_DIR"/*/ "$WORKSPACE_DIR"/*/*/; do
    if [ -d "$dir" ]; then
        if check_flutter_project "$dir"; then
            PROJECT_NAME=$(basename "$dir")
            echo -e "${YELLOW}Found:${NC} $PROJECT_NAME"
        fi
    fi
done

echo -e "\n${BLUE}Total projects found: ${#PROJECTS[@]}${NC}\n"

# Build each project
BUILD_TYPE="${1:-debug}"
COUNTER=1

for PROJECT in "${PROJECTS[@]}"; do
    PROJECT_NAME=$(basename "$PROJECT")
    echo -e "\n${BLUE}[$COUNTER/${#PROJECTS[@]}] Building $PROJECT_NAME (${BUILD_TYPE})...${NC}"
    echo "========================================="
    
    cd "$PROJECT" || continue
    
    # Get dependencies
    echo -e "${YELLOW}Getting dependencies...${NC}"
    if ! flutter pub get > /dev/null 2>&1; then
        echo -e "${RED}✗ Failed to get dependencies${NC}"
        FAILED_BUILDS+=("$PROJECT_NAME")
        COUNTER=$((COUNTER + 1))
        continue
    fi
    
    # Build APK
    echo -e "${YELLOW}Building APK...${NC}"
    if flutter build apk --$BUILD_TYPE > /dev/null 2>&1; then
        APK_PATH="$PROJECT/build/app/outputs/flutter-apk/app-${BUILD_TYPE}.apk"
        if [ -f "$APK_PATH" ]; then
            APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
            echo -e "${GREEN}✓ Build successful!${NC}"
            echo -e "${GREEN}APK: $APK_PATH${NC}"
            echo -e "${GREEN}Size: $APK_SIZE${NC}"
            BUILT_SUCCESSFULLY+=("$PROJECT_NAME")
        else
            echo -e "${RED}✗ APK not found${NC}"
            FAILED_BUILDS+=("$PROJECT_NAME")
        fi
    else
        echo -e "${RED}✗ Build failed${NC}"
        FAILED_BUILDS+=("$PROJECT_NAME")
    fi
    
    COUNTER=$((COUNTER + 1))
done

# Summary
echo -e "\n\n${BLUE}========================================${NC}"
echo -e "${BLUE}Build Summary${NC}"
echo -e "${BLUE}========================================${NC}\n"

if [ ${#BUILT_SUCCESSFULLY[@]} -gt 0 ]; then
    echo -e "${GREEN}Successfully built (${#BUILT_SUCCESSFULLY[@]}):${NC}"
    for project in "${BUILT_SUCCESSFULLY[@]}"; do
        echo -e "  ${GREEN}✓${NC} $project"
    done
fi

if [ ${#FAILED_BUILDS[@]} -gt 0 ]; then
    echo -e "\n${RED}Failed builds (${#FAILED_BUILDS[@]}):${NC}"
    for project in "${FAILED_BUILDS[@]}"; do
        echo -e "  ${RED}✗${NC} $project"
    done
fi

echo -e "\n${BLUE}========================================${NC}\n"

# Return success only if all builds succeeded
[ ${#FAILED_BUILDS[@]} -eq 0 ]
