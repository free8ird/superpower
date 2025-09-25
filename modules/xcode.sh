#!/bin/bash

# Xcode Command Line Tools Installation Module

install_xcode() {
    log_info "Installing Xcode Command Line Tools..."
    
    # Check if Xcode Command Line Tools are already installed
    if xcode-select -p &>/dev/null; then
        log_warning "Xcode Command Line Tools are already installed"
        log_info "Current installation path: $(xcode-select -p)"
        return 0
    fi
    
    # Install Xcode Command Line Tools
    log_info "Installing Xcode Command Line Tools..."
    log_info "This may take several minutes and will require user interaction..."
    
    # Trigger the installation
    xcode-select --install
    
    # Wait for installation to complete
    log_info "Waiting for Xcode Command Line Tools installation to complete..."
    log_info "Please follow the prompts in the dialog box that appeared."
    
    # Check periodically if installation is complete
    while ! xcode-select -p &>/dev/null; do
        sleep 5
    done
    
    # Accept the license
    log_info "Accepting Xcode license..."
    sudo xcodebuild -license accept 2>/dev/null || true
    
    # Verify installation
    if xcode-select -p &>/dev/null; then
        log_success "Xcode Command Line Tools installed successfully"
        log_info "Installation path: $(xcode-select -p)"
        return 0
    else
        log_error "Xcode Command Line Tools installation failed"
        return 1
    fi
}
