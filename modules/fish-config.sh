#!/bin/bash

# Fish Shell Configuration and Plugins Module

install_fish-config() {
    log_info "Setting up Fish shell plugins and configuration..."
    
    # Check if Fish is installed
    if ! command_exists fish; then
        log_error "Fish shell is required for this module"
        log_info "Please install Fish first by running: ./mac_setup.sh fish"
        return 1
    fi
    
    log_info "Fish shell found: $(fish --version)"
    
    # Create Fish config directory if it doesn't exist
    local fish_config_dir="$HOME/.config/fish"
    mkdir -p "$fish_config_dir"
    
    # Check if fisher is already installed
    if fish -c "type -q fisher" 2>/dev/null; then
        log_warning "Fisher is already installed"
    else
        log_info "Installing Fisher (Fish plugin manager)..."
        # Install Fisher
        fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
        
        if fish -c "type -q fisher" 2>/dev/null; then
            log_success "Fisher installed successfully"
        else
            log_error "Fisher installation failed"
            return 1
        fi
    fi
    
    # List of plugins to install
    local plugins=(
        "jethrokuan/z"           # z - directory jumping
        "jethrokuan/fzf"         # fzf - fuzzy finder integration
        "jhillyerd/plugin-git"   # git - git aliases and functions
    )
    
    log_info "Installing Fish plugins..."
    
    # Install each plugin
    for plugin in "${plugins[@]}"; do
        local plugin_name=$(basename "$plugin")
        log_info "Installing $plugin_name..."
        
        # Check if plugin is already installed by looking for it in fisher list
        if fish -c "fisher list | grep -q '$plugin'" 2>/dev/null; then
            log_warning "$plugin_name is already installed"
        else
            fish -c "fisher install $plugin"
            if fish -c "fisher list | grep -q '$plugin'" 2>/dev/null; then
                log_success "$plugin_name installed successfully"
            else
                log_warning "Failed to install $plugin_name, but continuing..."
            fi
        fi
    done
    
    # Install fzf if not already installed (required for fzf plugin)
    if ! command_exists fzf; then
        log_info "Installing fzf (required for fzf Fish plugin)..."
        if command_exists brew; then
            brew install fzf
            
            # Install fzf key bindings and fuzzy completion
            if [[ -f "/opt/homebrew/opt/fzf/install" ]]; then
                /opt/homebrew/opt/fzf/install --key-bindings --completion --no-update-rc
            elif [[ -f "/usr/local/opt/fzf/install" ]]; then
                /usr/local/opt/fzf/install --key-bindings --completion --no-update-rc
            fi
        else
            log_warning "Homebrew not found. Please install fzf manually for full functionality."
        fi
    else
        log_info "fzf is already installed"
    fi
    
    # Install Starship prompt if not already installed
    if ! command_exists starship; then
        log_info "Installing Starship prompt..."
        if command_exists brew; then
            brew install starship
        else
            log_warning "Homebrew not found. Installing Starship via curl..."
            curl -sS https://starship.rs/install.sh | sh
        fi
        
        if command_exists starship; then
            log_success "Starship installed successfully"
        else
            log_warning "Starship installation failed, but continuing..."
        fi
    else
        log_info "Starship is already installed"
    fi
    
    # Install direnv if not already installed
    if ! command_exists direnv; then
        log_info "Installing direnv for automatic environment loading..."
        if command_exists brew; then
            brew install direnv
        else
            log_warning "Homebrew not found. Please install direnv manually."
        fi
        
        if command_exists direnv; then
            log_success "direnv installed successfully"
        else
            log_warning "direnv installation failed, but continuing..."
        fi
    else
        log_info "direnv is already installed"
    fi
    
    # Create or update Fish configuration with useful settings
    local config_file="$fish_config_dir/config.fish"
    
    log_info "Configuring Fish shell settings..."
    
    # Copy configuration files to Fish config directory
    local base_dir="$(dirname "$(dirname "$0")")"
    local fish_config_source="$base_dir/fish_config"
    local config_source="$fish_config_source/config.fish"
    local git_source="$fish_config_source/git.fish"
    local docker_source="$fish_config_source/docker.fish"
    local filesystem_source="$fish_config_source/filesystem.fish"
    local custom_source="$fish_config_source/custom.fish"
    local functions_source="$fish_config_source/fish_functions"
    
    local config_dest="$fish_config_dir/config.fish"
    local git_dest="$fish_config_dir/git.fish"
    local docker_dest="$fish_config_dir/docker.fish"
    local filesystem_dest="$fish_config_dir/filesystem.fish"
    local custom_dest="$fish_config_dir/custom.fish"
    local functions_dest="$fish_config_dir/functions"
    
    # Create a simple config.fish that sources from the project directory
    log_info "Setting up Fish configuration to source from project directory..."
    
    local simple_config="# Fish configuration - sources from dotfiles project
# This file is managed by the dotfiles project setup

# Source the main configuration from the dotfiles project
if test -f ~/apps/dotfiles/fish_config/config.fish
    source ~/apps/dotfiles/fish_config/config.fish
else
    echo 'Warning: Dotfiles project configuration not found at ~/apps/dotfiles/fish_config/config.fish'
end
"
    
    # Write the simple config that just sources from project
    echo "$simple_config" > "$config_dest"
    log_success "Fish configuration set up to source from project directory"
    
    # Copy functions directory (still needed for Fish to discover them)
    if [[ -d "$functions_source" ]]; then
        log_info "Copying Fish functions..."
        mkdir -p "$functions_dest"
        cp "$functions_source"/*.fish "$functions_dest"/ 2>/dev/null || true
        log_success "Fish functions copied to $functions_dest"
    else
        log_warning "Fish functions directory not found at $functions_source"
    fi

    
    # Provide usage information
    log_success "Fish shell plugins and configuration setup completed!"
    log_info ""
    log_info "Installed components:"
    log_info "  • Fisher - Plugin manager for Fish"
    log_info "  • z - Smart directory jumping (use 'z <partial_name>')"
    log_info "  • fzf - Fuzzy finder integration (Ctrl+R for history, Ctrl+T for files)"
    log_info "  • plugin-git - Git aliases and functions"
    log_info "  • Starship - Cross-shell prompt with beautiful themes"
    log_info "  • direnv - Automatic environment variable loading from .envrc files"
    log_info "  • Main configuration - sources directly from ~/apps/dotfiles/fish_config/"
    log_info "  • All config files managed from project directory"
    log_info "  • Custom functions - ~/.config/fish/functions/"
    log_info ""
    log_info "Useful commands:"
    log_info "  fisher list           # List installed plugins"
    log_info "  fisher install <pkg>  # Install a new plugin"
    log_info "  fisher remove <pkg>   # Remove a plugin"
    log_info "  z <directory>         # Jump to frequently used directory"
    log_info "  Ctrl+R               # Search command history with fzf"
    log_info "  Ctrl+T               # Search files with fzf"
    log_info "  starship config       # Configure Starship prompt"
    log_info "  edit                 # Edit your custom Fish configuration"
    log_info "  reload               # Reload Fish configuration"
    log_info "  direnv allow         # Allow .envrc file in current directory"
    log_info "  direnv deny          # Deny .envrc file in current directory"
    log_info ""
    log_info "Starship customization:"
    log_info "  ~/.config/starship.toml  # Starship configuration file"
    log_info "  starship preset          # List available presets"
    log_info "  starship explain         # Explain current prompt modules"
    log_info ""
    log_info "direnv usage:"
    log_info "  Create .envrc file in project directory with environment variables"
    log_info "  Example: echo 'export API_KEY=secret123' > .envrc"
    log_info "  Run 'direnv allow' to enable automatic loading"
    log_info "  Variables load/unload automatically when entering/leaving directory"
    log_info ""
    # Automatically reload Fish configuration if we're in a Fish shell
    if [[ "$SHELL" == *"fish"* ]] || [[ -n "$FISH_VERSION" ]]; then
        log_info "Reloading Fish configuration..."
        if command_exists fish; then
            fish -c "source ~/.config/fish/config.fish" 2>/dev/null || true
            log_success "Fish configuration reloaded!"
        fi
    else
        log_info "To see the changes, restart your Fish shell or run: source ~/.config/fish/config.fish"
    fi
    
    return 0
}
