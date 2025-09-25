# macOS Setup Script

A modular script to automatically install essential development tools and applications on macOS.

## Features

- **Modular Design**: Install individual tools or all at once
- **Error Handling**: Robust error checking and logging
- **Interactive**: Prompts for user preferences where appropriate
- **Safe**: Checks for existing installations to avoid conflicts

## Supported Tools

- **Xcode Command Line Tools**: Essential development tools from Apple
- **Homebrew**: The missing package manager for macOS
- **Sublime Text**: Sophisticated text editor for code, markup and prose
- **Fish Shell**: Smart and user-friendly command line shell
- **Fish Plugins**: Essential Fish shell plugins (fisher, z, fzf, git, starship, direnv)
- **iTerm2**: Terminal emulator for macOS
- **pyenv**: Python version management made simple
- **jenv**: Java version management for multiple Java versions

## Quick Start

1. Clone or download this repository
2. Make the script executable:
   ```bash
   chmod +x mac_setup.sh
   ```
3. Run the setup script:
   ```bash
   ./mac_setup.sh
   ```

## Usage

### Install All Tools
```bash
./mac_setup.sh
```

### Install Specific Tools
```bash
./mac_setup.sh homebrew xcode
./mac_setup.sh fish fish-config
./mac_setup.sh sublime
./mac_setup.sh pyenv jenv
```

### Available Modules
- `homebrew` - Install Homebrew package manager
- `xcode` - Install Xcode Command Line Tools
- `sublime` - Install Sublime Text
- `fish` - Install Fish shell
- `fish-config` - Install Fish plugins (fisher, z, fzf, git, starship)
- `iterm2` - Install iTerm2
- `pyenv` - Install pyenv (Python version manager)
- `jenv` - Install jenv (Java version manager)

### Help
```bash
./mac_setup.sh --help
```

## Installation Order

The script is designed to handle dependencies automatically:
1. **Xcode Command Line Tools** - Required for Homebrew
2. **Homebrew** - Required for other applications
3. **Applications** - Installed via Homebrew when available

## What Each Module Does

### Homebrew Module
- Installs Homebrew package manager
- Configures PATH for both Intel and Apple Silicon Macs
- Updates Homebrew if already installed

### Xcode Module
- Installs Xcode Command Line Tools
- Handles interactive installation process
- Accepts Xcode license automatically

### Sublime Text Module
- Installs Sublime Text via Homebrew Cask
- Creates command line symlink (`subl` command)
- Verifies installation

### Fish Shell Module
- Installs Fish shell via Homebrew
- Adds Fish to valid shells list
- Optionally sets Fish as default shell

### Fish Config Module
- Installs Fisher (Fish plugin manager)
- Installs essential plugins: z, fzf, plugin-git
- Installs and configures fzf for fuzzy finding
- Installs Starship prompt for beautiful cross-shell prompts
- Installs direnv for automatic environment loading
- Copies consolidated configuration files (filesystem, git, docker)
- Each file contains both aliases and abbreviations for its domain
- Copies custom functions to Fish functions directory
- Configures Fish with useful settings and colors
- Provides helpful usage examples and shortcuts

### iTerm2 Module
- Installs iTerm2 via Homebrew Cask
- Provides setup guidance for customization

### pyenv Module
- Installs pyenv and pyenv-virtualenv via Homebrew
- Configures shell integration for bash, zsh, and fish
- Automatically sets up PATH and initialization
- Provides usage examples and common commands

### jenv Module
- Installs jenv via Homebrew
- Configures shell integration for bash, zsh, and fish
- Enables useful plugins (export, maven, gradle)
- Automatically detects and adds existing Java installations
- Provides guidance for installing Java via Homebrew

## Requirements

- macOS (any recent version)
- Internet connection
- Administrator privileges (for some installations)

## Troubleshooting

### Permission Issues
Some installations may require administrator privileges. The script will prompt for your password when needed.

### Network Issues
If downloads fail, check your internet connection and try again.

### Existing Installations
The script detects existing installations and will skip or update them as appropriate.

## Customization

### Fish Shell Customization
After running the fish-config module, you can customize your Fish shell:

- **Edit custom configuration**: Run `fishedit` to open your personal customization file
- **Reload configuration**: Run `fishreload` to apply changes without restarting terminal
- **Custom file location**: `~/.config/fish/custom.fish`

The custom.fish file is perfect for:
- Personal aliases and abbreviations
- Project-specific shortcuts
- Environment variables
- Custom functions
- Workflow-specific configurations

**Note**: The custom.fish file is never overwritten by updates, preserving your personalizations.

## File Structure

```
.
├── mac_setup.sh          # Main setup script
├── fish_config/          # Fish shell configuration files
│   ├── filesystem.fish   # Filesystem aliases and abbreviations
│   ├── git.fish          # Git aliases and abbreviations
│   ├── docker.fish       # Docker aliases and abbreviations
│   ├── custom.fish       # User customizations template
│   └── fish_functions/   # Custom Fish functions
│       ├── extract.fish  # Archive extraction function
│       ├── weather.fish  # Weather information function
│       ├── mkcd.fish     # Create and cd into directory
│       └── backup.fish   # Create backup copies
├── modules/              # Individual installation modules
│   ├── homebrew.sh      # Homebrew installation
│   ├── xcode.sh         # Xcode Command Line Tools
│   ├── sublime.sh       # Sublime Text installation
│   ├── fish.sh          # Fish shell installation
│   ├── fish-config.sh   # Fish plugins and configuration
│   ├── iterm2.sh        # iTerm2 installation
│   ├── pyenv.sh         # Python version manager
│   └── jenv.sh          # Java version manager
└── README.md            # This file
```

## Contributing

Feel free to add more modules or improve existing ones. Each module should:
1. Be self-contained in the `modules/` directory
2. Implement an `install_<module_name>()` function
3. Use the logging functions for consistent output
4. Handle existing installations gracefully
5. Return 0 on success, 1 on failure

## License

This project is open source and available under the MIT License.