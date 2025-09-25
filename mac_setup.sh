#!/bin/bash

# macOS Setup Script
# A modular script to install development tools and applications

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This script is designed for macOS only."
        exit 1
    fi
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to run a module
run_module() {
    local module_name="$1"
    local module_path="./modules/${module_name}.sh"
    
    if [[ -f "$module_path" ]]; then
        log_info "Running module: $module_name"
        source "$module_path"
        if install_${module_name}; then
            log_success "$module_name installation completed"
        else
            log_error "$module_name installation failed"
            return 1
        fi
    else
        log_error "Module not found: $module_path"
        return 1
    fi
}

# Main installation function
main() {
    log_info "Starting macOS Setup Script"
    log_info "================================"
    
    # Check if we're on macOS
    check_macos
    
    # Create modules directory if it doesn't exist
    mkdir -p modules
    
    # Available modules
    local modules=("homebrew" "xcode" "sublime" "fish" "fish-config" "iterm2" "pyenv" "jenv" "ssh-github")
    
    # If no arguments provided, install all modules
    if [[ $# -eq 0 ]]; then
        log_info "No specific modules specified. Installing all modules..."
        for module in "${modules[@]}"; do
            run_module "$module"
        done
    else
        # Install only specified modules
        for module in "$@"; do
            if [[ " ${modules[*]} " =~ " ${module} " ]]; then
                run_module "$module"
            else
                log_warning "Unknown module: $module"
                log_info "Available modules: ${modules[*]}"
            fi
        done
    fi
    
    log_success "Setup completed!"
    log_info "You may need to restart your terminal or source your shell configuration."
}

# Show usage information
usage() {
    echo "Usage: $0 [module1] [module2] ..."
    echo ""
    echo "Available modules:"
    echo "  homebrew    - Install Homebrew package manager"
    echo "  xcode       - Install Xcode Command Line Tools"
    echo "  sublime     - Install Sublime Text"
    echo "  fish        - Install Fish shell"
    echo "  fish-config - Install Fish plugins (fisher, z, fzf, git, starship)"
    echo "  iterm2      - Install iTerm2"
    echo "  pyenv       - Install pyenv (Python version manager)"
    echo "  jenv        - Install jenv (Java version manager)"
    echo "  ssh-github  - Setup SSH keys for GitHub access"
    echo ""
    echo "Examples:"
    echo "  $0                       # Install all modules"
    echo "  $0 homebrew xcode        # Install only Homebrew and Xcode"
    echo "  $0 fish fish-config      # Install Fish shell with plugins"
    echo "  $0 pyenv jenv            # Install only Python and Java version managers"
    echo "  $0 ssh-github            # Setup SSH keys for GitHub"
}

# Handle command line arguments
case "${1:-}" in
    -h|--help)
        usage
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac
