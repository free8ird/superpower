# Filesystem Configuration for Fish Shell
# This file contains filesystem-related aliases and abbreviations

# =============================================================================
# FILESYSTEM ABBREVIATIONS (expandable shortcuts)
# =============================================================================

# Directory navigation
abbr -a .. cd ..
abbr -a ... cd ../..
abbr -a .... cd ../../..
abbr -a ..... cd ../../../..

# Directory listing
abbr -a ll ls -la
abbr -a la ls -A
abbr -a lt ls -ltr
abbr -a lh ls -lh

# File operations
abbr -a cp cp -i
abbr -a mv mv -i
abbr -a rm rm -i

# Directory shortcuts
abbr -a home cd ~
abbr -a dtop cd ~/Desktop
abbr -a dlds cd ~/Downloads
abbr -a docs cd ~/Documents
abbr -a apps cd ~/Applications

# File searching
abbr -a ff find . -name
abbr -a ffc grep -r

# Archive operations
abbr -a tgz tar -czf
abbr -a untgz tar -xzf
abbr -a zip zip -r

# =============================================================================
# FILESYSTEM ALIASES (direct command replacements)
# =============================================================================

# Enhanced directory listing
alias l 'ls -CF'
alias lt 'ls -ltr'  # Sort by time, newest last
alias lh 'ls -lh'   # Human readable sizes
alias lsize 'ls -lhS'  # Sort by size
alias ltree 'tree -C'  # Colorized tree

# Directory navigation shortcuts
alias home 'cd ~'
alias root 'cd /'

# File operations with safety
alias rm 'rm -i'     # Prompt before removing
alias cp 'cp -i'     # Prompt before overwriting
alias mv 'mv -i'     # Prompt before overwriting
alias mkdir 'mkdir -p'  # Create parent directories as needed

# Disk usage
alias du 'du -h'     # Human readable
alias df 'df -h'     # Human readable
alias dus 'du -sh'   # Directory size summary
alias dush 'du -sh *'  # Size of all items in current directory

# File permissions
alias chx 'chmod +x'
alias ch755 'chmod 755'
alias ch644 'chmod 644'

# File searching and content
alias ff 'find . -name'
alias ffc 'grep -r'
alias locate 'mdfind'  # macOS spotlight search

# Archive operations
alias untar 'tar -xf'
alias targz 'tar -czf'
alias untargz 'tar -xzf'

# File editing shortcuts
alias edit 'code ~/.config/fish/custom.fish'  # Edit custom Fish config

# Reload Fish configuration
function reload --description 'Reload Fish configuration'
    source ~/.config/fish/config.fish
    echo "✅ Fish configuration reloaded!"
end

# System information
alias sysinfo 'system_profiler SPSoftwareDataType SPHardwareDataType'

# Network information
alias localip 'ipconfig getifaddr en0'
alias publicip 'curl -s https://httpbin.org/ip | jq -r .origin'

# Process management
alias ps 'ps aux'
alias psg 'ps aux | grep'  # Search processes
alias top 'htop'  # Use htop if available

# =============================================================================
# CONDITIONAL ALIASES (only if commands exist)
# =============================================================================

# Use exa instead of ls if available
if command -v exa >/dev/null
    alias ls 'exa'
    alias ll 'exa -la'
    alias la 'exa -a'
    alias lt 'exa -la --sort=modified'
    alias tree 'exa --tree'
end

# Use bat instead of cat if available
if command -v bat >/dev/null
    alias cat 'bat'
    alias less 'bat'
end

# Use fd instead of find if available
if command -v fd >/dev/null
    alias find 'fd'
end

# Use ripgrep instead of grep if available
if command -v rg >/dev/null
    alias grep 'rg'
end

# Use dust instead of du if available
if command -v dust >/dev/null
    alias du 'dust'
end
