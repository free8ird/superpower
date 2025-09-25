#!/bin/bash

# Sublime Text Installation Module

install_sublime() {
    log_info "Installing Sublime Text..."
    
    # Check if Sublime Text is already installed
    if [[ -d "/Applications/Sublime Text.app" ]] || command_exists subl; then
        log_warning "Sublime Text is already installed"
        return 0
    fi
    
    # Ensure Homebrew is available
    if ! command_exists brew; then
        log_error "Homebrew is required to install Sublime Text"
        log_info "Please install Homebrew first by running: ./mac_setup.sh homebrew"
        return 1
    fi
    
    # Install Sublime Text using Homebrew Cask
    log_info "Installing Sublime Text via Homebrew Cask..."
    brew install --cask sublime-text
    
    # Create symlink for command line usage
    if [[ -d "/Applications/Sublime Text.app" ]]; then
        log_info "Creating command line symlink..."
        
        # Create symlink directory if it doesn't exist
        mkdir -p /usr/local/bin
        
        # Create symlink (may require sudo)
        if ! ln -sf "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl 2>/dev/null; then
            log_info "Creating symlink requires administrator privileges..."
            sudo ln -sf "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
        fi
    fi
    
    # Verify installation
    if [[ -d "/Applications/Sublime Text.app" ]]; then
        log_success "Sublime Text installed successfully"
        log_info "You can launch it from Applications or use 'subl' command in terminal"
        return 0
    else
        log_error "Sublime Text installation failed"
        return 1
    fi
}
