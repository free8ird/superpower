#!/bin/bash

# Homebrew Installation Module

install_homebrew() {
    log_info "Installing Homebrew..."
    
    # Check if Homebrew is already installed
    if command_exists brew; then
        log_warning "Homebrew is already installed"
        log_info "Updating Homebrew..."
        brew update
        return 0
    fi
    
    # Install Homebrew
    log_info "Downloading and installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    # Verify installation
    if command_exists brew; then
        log_success "Homebrew installed successfully"
        brew --version
        return 0
    else
        log_error "Homebrew installation failed"
        return 1
    fi
}
