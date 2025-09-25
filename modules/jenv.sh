#!/bin/bash

# jenv Installation Module

install_jenv() {
    log_info "Installing jenv (Java version manager)..."
    
    # Check if jenv is already installed
    if command_exists jenv; then
        log_warning "jenv is already installed"
        jenv --version
        return 0
    fi
    
    # Ensure Homebrew is available
    if ! command_exists brew; then
        log_error "Homebrew is required to install jenv"
        log_info "Please install Homebrew first by running: ./mac_setup.sh homebrew"
        return 1
    fi
    
    # Install jenv using Homebrew
    log_info "Installing jenv via Homebrew..."
    brew install jenv
    
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
            log_warning "Unknown shell: $current_shell. You may need to manually configure jenv."
            shell_config="$HOME/.profile"
            ;;
    esac
    
    # Add jenv to shell configuration
    log_info "Configuring jenv for $current_shell shell..."
    
    if [[ "$current_shell" == "fish" ]]; then
        # Fish shell configuration
        mkdir -p "$(dirname "$shell_config")"
        
        if ! grep -q "jenv init" "$shell_config" 2>/dev/null; then
            echo "" >> "$shell_config"
            echo "# jenv configuration" >> "$shell_config"
            echo "set -Ux JENV_ROOT \$HOME/.jenv" >> "$shell_config"
            echo "fish_add_path \$JENV_ROOT/bin" >> "$shell_config"
            echo "jenv init - | source" >> "$shell_config"
        fi
    else
        # Bash/Zsh configuration
        if ! grep -q "jenv init" "$shell_config" 2>/dev/null; then
            echo "" >> "$shell_config"
            echo "# jenv configuration" >> "$shell_config"
            echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> "$shell_config"
            echo 'eval "$(jenv init -)"' >> "$shell_config"
        fi
    fi
    
    # Set up jenv for current session
    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init -)" 2>/dev/null || true
    
    # Enable jenv plugins
    log_info "Enabling useful jenv plugins..."
    jenv enable-plugin export 2>/dev/null || true
    jenv enable-plugin maven 2>/dev/null || true
    jenv enable-plugin gradle 2>/dev/null || true
    
    # Check for existing Java installations
    log_info "Scanning for existing Java installations..."
    local java_homes=()
    
    # Common Java installation paths on macOS
    if [[ -d "/Library/Java/JavaVirtualMachines" ]]; then
        for java_dir in /Library/Java/JavaVirtualMachines/*/Contents/Home; do
            if [[ -d "$java_dir" ]]; then
                java_homes+=("$java_dir")
            fi
        done
    fi
    
    # Add system Java if available
    if /usr/libexec/java_home &>/dev/null; then
        local system_java=$(/usr/libexec/java_home 2>/dev/null)
        if [[ -n "$system_java" && -d "$system_java" ]]; then
            java_homes+=("$system_java")
        fi
    fi
    
    # Add found Java installations to jenv
    if [[ ${#java_homes[@]} -gt 0 ]]; then
        log_info "Found Java installations, adding to jenv:"
        for java_home in "${java_homes[@]}"; do
            local version_info=$("$java_home/bin/java" -version 2>&1 | head -n 1)
            log_info "  Adding: $java_home ($version_info)"
            jenv add "$java_home" 2>/dev/null || true
        done
    else
        log_warning "No Java installations found."
        log_info "You can install Java using Homebrew:"
        log_info "  brew install openjdk@11    # Install OpenJDK 11"
        log_info "  brew install openjdk@17    # Install OpenJDK 17"
        log_info "  brew install openjdk@21    # Install OpenJDK 21"
        log_info ""
        log_info "After installing Java, add it to jenv with:"
        log_info "  jenv add /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home"
    fi
    
    # Verify installation
    if command_exists jenv; then
        log_success "jenv installed successfully"
        jenv --version
        
        log_info "jenv has been configured for your shell ($shell_config)"
        log_info "To start using jenv in your current session, run:"
        log_info "  source $shell_config"
        log_info ""
        log_info "Common jenv commands:"
        log_info "  jenv versions           # List installed Java versions"
        log_info "  jenv global 11.0        # Set global Java version"
        log_info "  jenv local 17.0         # Set local Java version for current directory"
        log_info "  jenv add <java_home>    # Add a Java installation to jenv"
        
        return 0
    else
        log_error "jenv installation failed"
        return 1
    fi
}
