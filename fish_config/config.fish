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
# Get the directory where this config.fish file is located
set -l config_dir (dirname (status --current-filename))

# Source all config files from the same directory
if test -f $config_dir/filesystem.fish
    source $config_dir/filesystem.fish
end

if test -f $config_dir/git.fish
    source $config_dir/git.fish
end

if test -f $config_dir/docker.fish
    source $config_dir/docker.fish
end

if test -f $config_dir/custom.fish
    source $config_dir/custom.fish
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
