# Initialize pyenv (Python version manager)
if command -v pyenv >/dev/null
    pyenv init - | source
end

# Initialize jenv (Java version manager)
if command -v jenv >/dev/null
    status --is-interactive; and source (jenv init -|psub)
end

# Fish shell configuration added by mac_setup script

# Set greeting
set -g fish_greeting ''

# Initialize Starship prompt (if installed)
if command -v starship >/dev/null
    starship init fish | source
end

# Initialize direnv (if installed)
if command -v direnv >/dev/null
    direnv hook fish | source
end

# Source configuration files directly from project directory
if test -d ~/apps/dotfiles/fish_config
    set -l dotfiles_config ~/apps/dotfiles/fish_config
    
    # Source all config files from project
    if test -f $dotfiles_config/filesystem.fish
        source $dotfiles_config/filesystem.fish
    end
    
    if test -f $dotfiles_config/git.fish
        source $dotfiles_config/git.fish
    end
    
    if test -f $dotfiles_config/docker.fish
        source $dotfiles_config/docker.fish
    end
    
    if test -f $dotfiles_config/custom.fish
        source $dotfiles_config/custom.fish
    end
else
    # Fallback to installed files if project directory not available
    if test -f ~/.config/fish/filesystem.fish
        source ~/.config/fish/filesystem.fish
    end
    
    if test -f ~/.config/fish/git.fish
        source ~/.config/fish/git.fish
    end
    
    if test -f ~/.config/fish/docker.fish
        source ~/.config/fish/docker.fish
    end
    
    if test -f ~/.config/fish/custom.fish
        source ~/.config/fish/custom.fish
    end
end

# Enable vi key bindings (optional - comment out if you prefer default)
# fish_vi_key_bindings

# Set up colors for better visibility
set -g fish_color_command blue
set -g fish_color_param cyan
set -g fish_color_redirection yellow
set -g fish_color_comment red
set -g fish_color_error red --bold
set -g fish_color_escape cyan
set -g fish_color_operator cyan
set -g fish_color_quote green
set -g fish_color_autosuggestion 555
