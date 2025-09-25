#!/bin/bash

# pyenv Installation Module

install_pyenv() {
    log_info "Installing pyenv (Python version manager)..."
    
    # Check if pyenv is already installed
    if command_exists pyenv; then
        log_warning "pyenv is already installed"
        pyenv --version
        return 0
    fi
    
    # Ensure Homebrew is available
    if ! command_exists brew; then
        log_error "Homebrew is required to install pyenv"
        log_info "Please install Homebrew first by running: ./mac_setup.sh homebrew"
        return 1
    fi
    
    # Install pyenv using Homebrew
    log_info "Installing pyenv via Homebrew..."
    brew install pyenv
    
    # Install pyenv-virtualenv for virtual environment support
    log_info "Installing pyenv-virtualenv for virtual environment support..."
    brew install pyenv-virtualenv
    
    # Get the current shell
    local current_shell=$(basename "$SHELL")
    local shell_config=""
    
    # Determine shell configuration file
    case "$current_shell" in
        "bash")
            shell_config="$HOME/.bash_profile"
            ;;
        "zsh")
            shell_config="$HOME/.zshrc"
            ;;
        "fish")
            shell_config="$HOME/.config/fish/config.fish"
            ;;
        *)
            log_warning "Unknown shell: $current_shell. You may need to manually configure pyenv."
            shell_config="$HOME/.profile"
            ;;
    esac
    
    # Add pyenv to shell configuration
    log_info "Configuring pyenv for $current_shell shell..."
    
    if [[ "$current_shell" == "fish" ]]; then
        # Fish shell configuration
        mkdir -p "$(dirname "$shell_config")"
        
        if ! grep -q "pyenv init" "$shell_config" 2>/dev/null; then
            echo "" >> "$shell_config"
            echo "# pyenv configuration" >> "$shell_config"
            echo "set -Ux PYENV_ROOT \$HOME/.pyenv" >> "$shell_config"
            echo "fish_add_path \$PYENV_ROOT/bin" >> "$shell_config"
            echo "pyenv init - | source" >> "$shell_config"
            echo "pyenv virtualenv-init - | source" >> "$shell_config"
        fi
    else
        # Bash/Zsh configuration
        if ! grep -q "pyenv init" "$shell_config" 2>/dev/null; then
            echo "" >> "$shell_config"
            echo "# pyenv configuration" >> "$shell_config"
            echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$shell_config"
            echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> "$shell_config"
            echo 'eval "$(pyenv init -)"' >> "$shell_config"
            echo 'eval "$(pyenv virtualenv-init -)"' >> "$shell_config"
        fi
    fi
    
    # Set up pyenv for current session
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)" 2>/dev/null || true
    eval "$(pyenv virtualenv-init -)" 2>/dev/null || true
    
    # Verify installation
    if command_exists pyenv; then
        log_success "pyenv installed successfully"
        pyenv --version
        
        log_info "pyenv has been configured for your shell ($shell_config)"
        log_info "To start using pyenv in your current session, run:"
        log_info "  source $shell_config"
        log_info ""
        log_info "Common pyenv commands:"
        log_info "  pyenv install --list    # List available Python versions"
        log_info "  pyenv install 3.11.0    # Install Python 3.11.0"
        log_info "  pyenv global 3.11.0     # Set global Python version"
        log_info "  pyenv local 3.9.0       # Set local Python version for current directory"
        
        return 0
    else
        log_error "pyenv installation failed"
        return 1
    fi
}
