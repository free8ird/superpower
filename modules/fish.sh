#!/bin/bash

# Fish Shell Installation Module

install_fish() {
    log_info "Installing Fish shell..."
    
    local fish_path
    local already_installed=false
    
    # Check if Fish is already installed
    if command_exists fish; then
        log_warning "Fish shell is already installed"
        fish --version
        already_installed=true
        fish_path=$(which fish)
    else
        # Ensure Homebrew is available
        if ! command_exists brew; then
            log_error "Homebrew is required to install Fish shell"
            log_info "Please install Homebrew first by running: ./mac_setup.sh homebrew"
            return 1
        fi
        
        # Install Fish using Homebrew
        log_info "Installing Fish shell via Homebrew..."
        brew install fish
        fish_path=$(which fish)
    fi
    
    # Add Fish to the list of valid shells if not already there
    if ! grep -q "$fish_path" /etc/shells; then
        log_info "Adding Fish to /etc/shells (requires administrator privileges)..."
        echo "$fish_path" | sudo tee -a /etc/shells
    fi
    
    # Check if Fish is already the default shell
    if [[ "$SHELL" == "$fish_path" ]]; then
        log_success "Fish is already your default shell!"
    else
        # Ask user if they want to set Fish as default shell
        if [[ "$already_installed" == true ]]; then
            log_info "Fish shell is installed but not set as default."
        else
            log_info "Fish shell installed successfully!"
        fi
        log_info "Current shell: $SHELL"
        
        read -p "Do you want to set Fish as your default shell? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "Setting Fish as default shell..."
            chsh -s "$fish_path"
            log_success "Fish is now your default shell. Please restart your terminal."
        else
            log_info "Fish installed but not set as default shell."
            log_info "You can run 'fish' to start a Fish session or run 'chsh -s $fish_path' to set it as default later."
        fi
    fi
    
    # Verify installation
    if command_exists fish; then
        log_success "Fish shell installation completed"
        fish --version
        return 0
    else
        log_error "Fish shell installation failed"
        return 1
    fi
}
