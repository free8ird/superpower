#!/bin/bash

# OpenJDK Installation Utility
# Standalone script for installing specific OpenJDK versions on demand

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Usage information
usage() {
    echo "OpenJDK Installation Utility"
    echo "============================="
    echo ""
    echo "Usage: $0 <command> [version]"
    echo ""
    echo "Commands:"
    echo "  install <version>    Install specific OpenJDK version"
    echo "  uninstall <version>  Uninstall specific OpenJDK version"
    echo "  list                 List all installed JDK versions"
    echo "  available            Show available JDK versions"
    echo "  set-default <ver>    Set default Java version globally"
    echo "  current              Show current Java version"
    echo "  help                 Show this help message"
    echo ""
    echo "Supported versions:"
    echo "  8, 11, 17, 21, 24"
    echo ""
    echo "Examples:"
    echo "  $0 install 17        # Install OpenJDK 17"
    echo "  $0 install 8         # Install OpenJDK 8"
    echo "  $0 list              # List installed versions"
    echo "  $0 set-default 17    # Set Java 17 as default"
    echo "  $0 uninstall 11      # Remove OpenJDK 11"
}

# Install specific JDK version
install_jdk() {
    local version="$1"
    
    if [[ -z "$version" ]]; then
        log_error "Version is required"
        echo ""
        usage
        return 1
    fi
    
    # Validate version
    if [[ ! "$version" =~ ^(8|11|17|21|24)$ ]]; then
        log_error "Unsupported version: $version"
        log_info "Supported versions: 8, 11, 17, 21, 24"
        return 1
    fi
    
    # Check if Homebrew is installed
    if ! command_exists brew; then
        log_error "Homebrew is required for OpenJDK installation"
        log_info "Install Homebrew first: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        return 1
    fi
    
    # Determine formula name
    local formula
    case "$version" in
        "8") formula="openjdk@8" ;;
        "11") formula="openjdk@11" ;;
        "17") formula="openjdk@17" ;;
        "21") formula="openjdk@21" ;;
        "24") formula="openjdk" ;;  # Latest version is usually just "openjdk"
    esac
    
    log_info "Installing OpenJDK $version..."
    
    # Check if already installed
    if brew list "$formula" &>/dev/null; then
        log_warning "OpenJDK $version is already installed"
        return 0
    fi
    
    # Install the JDK
    if brew install "$formula"; then
        log_success "OpenJDK $version installed successfully"
        
        # Install jenv if not available
        ensure_jenv_installed
        
        # Add to jenv
        add_jdk_to_jenv "$version"
        
        log_info "OpenJDK $version is now available"
        log_info "Use 'jenv local $version' to use it in current directory"
        log_info "Use '$0 set-default $version' to set it as global default"
        
    else
        log_error "Failed to install OpenJDK $version"
        return 1
    fi
}

# Ensure jenv is installed
ensure_jenv_installed() {
    if ! command_exists jenv; then
        log_info "Installing jenv for Java version management..."
        if brew install jenv; then
            log_success "jenv installed successfully"
            setup_jenv_integration
        else
            log_error "Failed to install jenv"
            return 1
        fi
    fi
}

# Add JDK to jenv
add_jdk_to_jenv() {
    local version="$1"
    local jdk_path
    
    case "$version" in
        "8")
            jdk_path="/opt/homebrew/opt/openjdk@8/libexec/openjdk.jdk/Contents/Home"
            if [[ ! -d "$jdk_path" ]]; then
                jdk_path="/usr/local/opt/openjdk@8/libexec/openjdk.jdk/Contents/Home"
            fi
            ;;
        "11")
            jdk_path="/opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home"
            if [[ ! -d "$jdk_path" ]]; then
                jdk_path="/usr/local/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home"
            fi
            ;;
        "17")
            jdk_path="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
            if [[ ! -d "$jdk_path" ]]; then
                jdk_path="/usr/local/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
            fi
            ;;
        "21")
            jdk_path="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
            if [[ ! -d "$jdk_path" ]]; then
                jdk_path="/usr/local/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
            fi
            ;;
        "24")
            jdk_path="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
            if [[ ! -d "$jdk_path" ]]; then
                jdk_path="/usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
            fi
            ;;
    esac
    
    if [[ -d "$jdk_path" ]]; then
        log_info "Adding OpenJDK $version to jenv..."
        if jenv add "$jdk_path" 2>/dev/null; then
            log_success "OpenJDK $version added to jenv"
        else
            log_warning "OpenJDK $version may already be in jenv"
        fi
    else
        log_warning "JDK $version path not found: $jdk_path"
    fi
}

# Setup jenv integration
setup_jenv_integration() {
    log_info "Setting up jenv shell integration..."
    
    # Enable jenv plugins
    local plugins=("export" "maven" "gradle")
    for plugin in "${plugins[@]}"; do
        if jenv enable-plugin "$plugin" 2>/dev/null; then
            log_success "Enabled jenv plugin: $plugin"
        else
            log_warning "Failed to enable jenv plugin: $plugin"
        fi
    done
}

# Uninstall specific JDK version
uninstall_jdk() {
    local version="$1"
    
    if [[ -z "$version" ]]; then
        log_error "Version is required"
        echo ""
        usage
        return 1
    fi
    
    # Validate version
    if [[ ! "$version" =~ ^(8|11|17|21|24)$ ]]; then
        log_error "Unsupported version: $version"
        log_info "Supported versions: 8, 11, 17, 21, 24"
        return 1
    fi
    
    # Determine formula name
    local formula
    case "$version" in
        "8") formula="openjdk@8" ;;
        "11") formula="openjdk@11" ;;
        "17") formula="openjdk@17" ;;
        "21") formula="openjdk@21" ;;
        "24") formula="openjdk" ;;
    esac
    
    log_info "Uninstalling OpenJDK $version..."
    
    if brew list "$formula" &>/dev/null; then
        if brew uninstall "$formula"; then
            log_success "OpenJDK $version uninstalled successfully"
            
            # Remove from jenv if available
            if command_exists jenv; then
                log_info "Removing from jenv..."
                # Find and remove the version from jenv
                jenv versions --bare | grep "^$version\." | head -1 | xargs -I {} jenv remove {} 2>/dev/null || true
            fi
        else
            log_error "Failed to uninstall OpenJDK $version"
        fi
    else
        log_warning "OpenJDK $version is not installed"
    fi
}

# List installed JDK versions
list_jdk_versions() {
    log_info "Installed Java versions:"
    log_info "========================"
    
    if command_exists jenv; then
        jenv versions
    else
        log_warning "jenv not available. Install jenv first."
        log_info "Checking for Java manually..."
        if command_exists java; then
            java -version
        else
            log_warning "No Java installation found"
        fi
    fi
}

# Show available JDK versions
show_available_versions() {
    log_info "Available OpenJDK versions for installation:"
    log_info "============================================="
    echo "  8  - OpenJDK 8 (LTS)"
    echo "  11 - OpenJDK 11 (LTS)"
    echo "  17 - OpenJDK 17 (LTS)"
    echo "  21 - OpenJDK 21 (LTS)"
    echo "  24 - OpenJDK 24 (Latest)"
    echo ""
    log_info "LTS = Long Term Support versions (recommended for production)"
}

# Set default Java version
set_default_java() {
    local version="$1"
    
    if [[ -z "$version" ]]; then
        log_error "Version is required"
        log_info "Available versions can be seen with: $0 list"
        return 1
    fi
    
    if ! command_exists jenv; then
        log_error "jenv is not installed"
        log_info "Install a JDK version first: $0 install <version>"
        return 1
    fi
    
    if jenv global "$version" 2>/dev/null; then
        log_success "Set Java $version as global default"
        log_info "Current Java version:"
        java -version 2>&1 | head -1
    else
        log_error "Failed to set Java $version as default"
        log_info "Available versions:"
        jenv versions
    fi
}

# Show current Java version
show_current_java() {
    log_info "Current Java version:"
    if command_exists java; then
        java -version
        echo ""
        if [[ -n "$JAVA_HOME" ]]; then
            log_info "JAVA_HOME: $JAVA_HOME"
        else
            log_warning "JAVA_HOME is not set"
        fi
    else
        log_warning "No Java installation found"
    fi
}

# Main command handler
main() {
    case "${1:-}" in
        "install")
            install_jdk "$2"
            ;;
        "uninstall")
            uninstall_jdk "$2"
            ;;
        "list")
            list_jdk_versions
            ;;
        "available")
            show_available_versions
            ;;
        "set-default")
            set_default_java "$2"
            ;;
        "current")
            show_current_java
            ;;
        "help"|"-h"|"--help"|"")
            usage
            ;;
        *)
            log_error "Unknown command: $1"
            echo ""
            usage
            exit 1
            ;;
    esac
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
