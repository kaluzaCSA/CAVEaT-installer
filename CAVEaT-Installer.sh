#!/bin/bash

# CAVEaT Toolkit Installer for macOS
# Cloud Adversarial Vectors, Exploits, and Threats Setup
# Version 1.0

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                    CAVEaT Toolkit Installer                   ║"
echo "║           Cloud Security Alliance Development Setup           ║"
echo "║                         Version 1.0                          ║"
echo "║                          macOS                                ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "🔧 Setting up your CAVEaT development environment..."
echo ""

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_info() {
    echo -e "${BLUE}📝${NC} $1"
}

# Check if running with appropriate permissions
if [[ $EUID -eq 0 ]]; then
    print_error "This script should NOT be run as root/sudo"
    print_info "Please run without sudo: ./CAVEaT-Installer.sh"
    exit 1
fi

print_status "User permissions confirmed"
echo ""

# Set installation directory
INSTALL_DIR="$HOME/caveat-toolkit"
echo "📁 Creating installation directory: $INSTALL_DIR"

if [ -d "$INSTALL_DIR" ]; then
    print_warning "Directory already exists. Cleaning up..."
    rm -rf "$INSTALL_DIR" 2>/dev/null || true
fi

mkdir -p "$INSTALL_DIR"
if [ $? -ne 0 ]; then
    print_error "Failed to create installation directory"
    exit 1
fi

cd "$INSTALL_DIR"
print_status "Installation directory ready"
echo ""

# Check for Homebrew and install if needed
echo "🔍 Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for this session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        # Apple Silicon Mac
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        # Intel Mac
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    if ! command -v brew &> /dev/null; then
        print_error "Failed to install Homebrew"
        print_info "Please install Homebrew manually from: https://brew.sh/"
        exit 1
    fi
    print_status "Homebrew installed successfully"
else
    print_status "Homebrew is already installed"
fi
echo ""

# Check for Git
echo "🔍 Checking for Git..."
if ! command -v git &> /dev/null; then
    echo "📦 Installing Git..."
    brew install git
    if [ $? -ne 0 ]; then
        print_error "Failed to install Git"
        print_info "Please install Git manually: brew install git"
        exit 1
    fi
    print_status "Git installed successfully"
else
    print_status "Git is already installed"
fi
echo ""

# Check for Node.js
echo "🔍 Checking for Node.js..."
if ! command -v node &> /dev/null; then
    echo "📦 Installing Node.js..."
    brew install node
    if [ $? -ne 0 ]; then
        print_error "Failed to install Node.js"
        print_info "Please install Node.js manually: brew install node"
        exit 1
    fi
    print_status "Node.js installed successfully"
    print_info "🔄 You may need to restart your terminal after installation"
else
    print_status "Node.js is already installed"
fi
echo ""

# Clone the CAVEaT toolkit
echo "📡 Downloading CAVEaT toolkit..."
if ! git clone https://github.com/CloudSecurityAlliance-WG/CAVEaT.git . 2>/dev/null; then
    print_error "Failed to download CAVEaT toolkit"
    print_info "Please check your internet connection and try again"
    exit 1
fi
print_status "CAVEaT toolkit downloaded successfully"
echo ""

# Skip npm install since there's no package.json in the CAVEaT repository
print_status "CAVEaT content ready (no dependencies needed)"
echo ""

# Clone CTI repository for additional threat intelligence data
echo "📡 Downloading CTI repository..."
cd "$HOME"
if [ ! -d "caveat-workspace" ]; then
    mkdir -p caveat-workspace
fi
cd caveat-workspace

if [ ! -d "cti" ]; then
    if ! git clone https://github.com/CloudSecurityAlliance/cti.git 2>/dev/null; then
        print_warning "Could not clone CTI repository"
        print_info "You can manually clone it later if needed"
    else
        print_status "CTI repository downloaded successfully"
    fi
fi

if [ ! -d "CAVEaT" ]; then
    if ! git clone https://github.com/CloudSecurityAlliance-WG/CAVEaT.git 2>/dev/null; then
        print_warning "Could not clone CAVEaT to workspace"
    else
        print_status "CAVEaT repository cloned to workspace"
    fi
fi

# Create helpful reference files
echo ""
echo "📄 Creating reference files..."

cat > "$HOME/caveat-workspace/QUICK-REFERENCE.md" << 'EOF'
# CAVEaT Quick Reference

## Your Configuration
- **Platform**: macOS
- **Installation**: ~/caveat-toolkit
- **Workspace**: ~/caveat-workspace

## Repository Locations
- **CTI Repository**: ~/caveat-workspace/cti
- **CAVEaT Repository**: ~/caveat-workspace/CAVEaT

## Important Paths
- **CAVEaT Prompts**: CAVEaT/prompts/
- **STIX Objects**: cti/ (if available)
- **CAVEaT Data**: CAVEaT/data/

## Next Steps
1. Open Claude (https://claude.ai)
2. Load CAVEaT context from prompts
3. Start creating STIX objects!

## Useful Commands
```bash
# Navigate to workspace
cd ~/caveat-workspace

# Update repositories
cd CAVEaT && git pull origin main && cd ..
cd cti && git pull origin main && cd .. 2>/dev/null || true

# Create new branch for work
cd CAVEaT && git checkout -b feature/my-new-threat