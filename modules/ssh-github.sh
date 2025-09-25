#!/bin/bash

# SSH GitHub Setup Module
# This module sets up SSH keys for GitHub access

install_ssh-github() {
    log_info "Setting up SSH keys for GitHub access..."
    
    # Check if SSH directory exists
    local ssh_dir="$HOME/.ssh"
    if [[ ! -d "$ssh_dir" ]]; then
        log_info "Creating SSH directory..."
        mkdir -p "$ssh_dir"
        chmod 700 "$ssh_dir"
    fi
    
    # Default key names
    local key_name="id_ed25519"
    local private_key="$ssh_dir/$key_name"
    local public_key="$ssh_dir/$key_name.pub"
    
    # Check if SSH key already exists
    if [[ -f "$private_key" ]]; then
        log_warning "SSH key already exists at $private_key"
        log_info "Your existing public key:"
        cat "$public_key"
        log_info ""
        log_info "If you want to use this key, copy it to GitHub:"
        log_info "https://github.com/settings/ssh/new"
        
        # Ask if user wants to create a new key
        read -p "Do you want to create a new SSH key? (y/N): " create_new
        if [[ ! "$create_new" =~ ^[Yy]$ ]]; then
            log_info "Using existing SSH key"
            setup_ssh_config
            test_github_connection
            return 0
        fi
        
        # Create backup of existing key
        log_info "Backing up existing SSH key..."
        cp "$private_key" "$private_key.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$public_key" "$public_key.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Get user email for SSH key
    local email
    if command_exists git; then
        email=$(git config --global user.email 2>/dev/null)
    fi
    
    if [[ -z "$email" ]]; then
        read -p "Enter your email address for the SSH key: " email
        if [[ -z "$email" ]]; then
            log_error "Email address is required for SSH key generation"
            return 1
        fi
    fi
    
    log_info "Generating SSH key with email: $email"
    
    # Generate SSH key
    ssh-keygen -t ed25519 -C "$email" -f "$private_key" -N ""
    
    if [[ $? -eq 0 ]]; then
        log_success "SSH key generated successfully"
        
        # Set proper permissions
        chmod 600 "$private_key"
        chmod 644 "$public_key"
        
        # Display the public key
        log_info ""
        log_info "Your new SSH public key:"
        log_info "========================"
        cat "$public_key"
        log_info "========================"
        log_info ""
        
        # Copy to clipboard if pbcopy is available
        if command_exists pbcopy; then
            cat "$public_key" | pbcopy
            log_success "SSH public key copied to clipboard!"
        fi
        
        # Setup SSH config
        setup_ssh_config
        
        # Start SSH agent and add key
        setup_ssh_agent
        
        # Instructions for GitHub
        log_info "Next steps:"
        log_info "1. Go to GitHub SSH settings: https://github.com/settings/ssh/new"
        log_info "2. Click 'New SSH key'"
        log_info "3. Give it a title (e.g., 'MacBook Pro')"
        log_info "4. Paste the public key (already copied to clipboard)"
        log_info "5. Click 'Add SSH key'"
        log_info ""
        
        # Ask if user wants to open GitHub
        read -p "Open GitHub SSH settings in browser? (Y/n): " open_github
        if [[ ! "$open_github" =~ ^[Nn]$ ]]; then
            open "https://github.com/settings/ssh/new"
        fi
        
        # Wait for user to add key to GitHub
        log_info ""
        read -p "Press Enter after you've added the SSH key to GitHub..."
        
        # Test the connection
        test_github_connection
        
    else
        log_error "Failed to generate SSH key"
        return 1
    fi
}

setup_ssh_config() {
    local ssh_config="$HOME/.ssh/config"
    
    log_info "Setting up SSH config..."
    
    # Create SSH config if it doesn't exist
    if [[ ! -f "$ssh_config" ]]; then
        touch "$ssh_config"
        chmod 600 "$ssh_config"
    fi
    
    # Check if GitHub config already exists
    if grep -q "Host github.com" "$ssh_config"; then
        log_info "GitHub SSH config already exists"
        return 0
    fi
    
    # Add GitHub configuration
    cat >> "$ssh_config" << 'EOF'

# GitHub SSH Configuration
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    AddKeysToAgent yes
    UseKeychain yes
EOF
    
    log_success "SSH config updated with GitHub settings"
}

setup_ssh_agent() {
    log_info "Setting up SSH agent..."
    
    # Start SSH agent if not running
    if [[ -z "$SSH_AUTH_SOCK" ]]; then
        eval "$(ssh-agent -s)"
    fi
    
    # Add SSH key to agent
    ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519" 2>/dev/null || ssh-add "$HOME/.ssh/id_ed25519"
    
    if [[ $? -eq 0 ]]; then
        log_success "SSH key added to agent"
    else
        log_warning "Failed to add SSH key to agent, but continuing..."
    fi
}

test_github_connection() {
    log_info "Testing GitHub SSH connection..."
    
    # Test SSH connection to GitHub
    ssh_output=$(ssh -T git@github.com 2>&1)
    ssh_exit_code=$?
    
    if [[ $ssh_exit_code -eq 1 ]] && echo "$ssh_output" | grep -q "successfully authenticated"; then
        log_success "GitHub SSH connection successful!"
        log_info "You can now use SSH URLs for GitHub repositories"
        log_info "Example: git clone git@github.com:username/repository.git"
    elif echo "$ssh_output" | grep -q "Permission denied"; then
        log_error "GitHub SSH connection failed - Permission denied"
        log_info "Make sure you've added the SSH key to your GitHub account"
        log_info "Visit: https://github.com/settings/ssh"
    else
        log_warning "Unexpected SSH response:"
        log_info "$ssh_output"
    fi
}

# Function to display existing SSH keys
list_ssh_keys() {
    log_info "Existing SSH keys:"
    local ssh_dir="$HOME/.ssh"
    
    if [[ -d "$ssh_dir" ]]; then
        find "$ssh_dir" -name "*.pub" -exec basename {} \; 2>/dev/null | while read -r key; do
            log_info "  • $key"
            if [[ -f "$ssh_dir/${key%.pub}" ]]; then
                log_info "    $(ssh-keygen -l -f "$ssh_dir/$key" 2>/dev/null || echo "    Invalid key format")"
            fi
        done
    else
        log_info "No SSH directory found"
    fi
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_ssh-github
fi
