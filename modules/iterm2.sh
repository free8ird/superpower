#!/bin/bash

# iTerm2 Installation Module

install_iterm2() {
    log_info "Installing iTerm2..."
    
    # Check if iTerm2 is already installed
    if [[ -d "/Applications/iTerm.app" ]]; then
        log_warning "iTerm2 is already installed"
        return 0
    fi
    
    # Ensure Homebrew is available
    if ! command_exists brew; then
        log_error "Homebrew is required to install iTerm2"
        log_info "Please install Homebrew first by running: ./mac_setup.sh homebrew"
        return 1
    fi
    
    # Install iTerm2 using Homebrew Cask
    log_info "Installing iTerm2 via Homebrew Cask..."
    brew install --cask iterm2
    
    # Verify installation
    if [[ -d "/Applications/iTerm.app" ]]; then
        log_success "iTerm2 installed successfully"
        log_info "You can launch iTerm2 from Applications"
        
        # Optional: Set iTerm2 preferences
        log_info "iTerm2 has been installed with default settings."
        log_info "You can customize it by going to iTerm2 > Preferences after launching."
        
        return 0
    else
        log_error "iTerm2 installation failed"
        return 1
    fi
}
