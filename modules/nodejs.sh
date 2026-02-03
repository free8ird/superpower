#!/bin/bash

# Node.js and NVM Module for Fish Shell

install_nodejs() {
    log_info "Setting up Node.js development environment..."
    
    # Check if Fish is installed
    if ! command_exists fish; then
        log_error "Fish shell is required for this module"
        log_info "Please install Fish first by running: ./mac_setup.sh fish"
        return 1
    fi
    
    # Check if Fisher is installed
    if ! fish -c "type -q fisher" 2>/dev/null; then
        log_error "Fisher is required for this module"
        log_info "Please install Fish configuration first by running: ./mac_setup.sh fish-config"
        return 1
    fi
    
    log_info "Fish shell found: $(fish --version)"
    
    # Install nvm.fish via Fisher
    log_info "Installing nvm.fish (Fish-compatible Node Version Manager)..."
    
    if fish -c "fisher list | grep -q 'jorgebucaran/nvm.fish'" 2>/dev/null; then
        log_warning "nvm.fish is already installed"
    else
        fish -c "fisher install jorgebucaran/nvm.fish"
        if fish -c "fisher list | grep -q 'jorgebucaran/nvm.fish'" 2>/dev/null; then
            log_success "nvm.fish installed successfully"
        else
            log_error "nvm.fish installation failed"
            return 1
        fi
    fi
    
    # Install latest LTS Node.js
    log_info "Installing latest LTS Node.js..."
    
    # Get latest LTS version
    local latest_lts=$(curl -s https://nodejs.org/dist/index.json | grep -o '"version":"v[^"]*"' | grep -v 'rc\|alpha\|beta' | head -1 | cut -d'"' -f4)
    
    if [[ -z "$latest_lts" ]]; then
        log_warning "Could not determine latest LTS version, using 'lts'"
        latest_lts="lts"
    else
        log_info "Latest LTS version detected: $latest_lts"
    fi
    
    # Install Node.js using nvm.fish
    fish -c "nvm install $latest_lts"
    
    # Set as default
    fish -c "nvm use $latest_lts"
    
    # Verify installation
    if fish -c "node --version" >/dev/null 2>&1; then
        local node_version=$(fish -c "node --version")
        log_success "Node.js installed successfully: $node_version"
    else
        log_error "Node.js installation verification failed"
        return 1
    fi
    
    # Verify npm
    if fish -c "npm --version" >/dev/null 2>&1; then
        local npm_version=$(fish -c "npm --version")
        log_success "npm installed successfully: v$npm_version"
    else
        log_warning "npm not found, this is unusual"
    fi
    
    # Install modern package managers
    log_info "Installing modern package managers..."
    
    # Install pnpm (fast, efficient package manager)
    if ! fish -c "command -v pnpm" >/dev/null 2>&1; then
        log_info "Installing pnpm..."
        fish -c "npm install -g pnpm"
        if fish -c "command -v pnpm" >/dev/null 2>&1; then
            log_success "pnpm installed successfully"
        else
            log_warning "pnpm installation failed, but continuing..."
        fi
    else
        log_info "pnpm is already installed"
    fi
    
    # Install yarn (alternative package manager)
    if ! fish -c "command -v yarn" >/dev/null 2>&1; then
        log_info "Installing yarn..."
        fish -c "npm install -g yarn"
        if fish -c "command -v yarn" >/dev/null 2>&1; then
            log_success "yarn installed successfully"
        else
            log_warning "yarn installation failed, but continuing..."
        fi
    else
        log_info "yarn is already installed"
    fi
    
    # Install useful global packages for development
    log_info "Installing useful global development packages..."
    
    local global_packages=(
        "@angular/cli"          # Angular CLI
        "create-react-app"      # React project generator
        "vue@next"              # Vue CLI
        "typescript"            # TypeScript compiler
        "ts-node"              # TypeScript execution engine
        "nodemon"              # Development server auto-restart
        "pm2"                  # Production process manager
        "http-server"          # Simple HTTP server
        "live-server"          # Development server with live reload
        "eslint"               # JavaScript linter
        "prettier"             # Code formatter
        "serve"                # Static file serving
    )
    
    for package in "${global_packages[@]}"; do
        log_info "Installing $package..."
        fish -c "npm install -g $package" >/dev/null 2>&1
        if fish -c "command -v ${package%@*}" >/dev/null 2>&1; then
            log_success "$package installed"
        else
            log_warning "$package installation may have failed"
        fi
    done
    
    # Create Node.js aliases and shortcuts
    local nodejs_config_file="$(dirname "$(dirname "$0")")/fish_config/nodejs.fish"
    
    log_info "Creating Node.js aliases and shortcuts..."
    
    cat > "$nodejs_config_file" << 'EOF'
# Node.js Development Aliases and Functions
# This file is sourced by the main Fish configuration

# Node.js shortcuts
abbr ni "npm install"
abbr nid "npm install --save-dev"
abbr nig "npm install -g"
abbr nu "npm uninstall"
abbr nud "npm uninstall --save-dev"
abbr nr "npm run"
abbr ns "npm start"
abbr nt "npm test"
abbr nb "npm run build"
abbr nd "npm run dev"
abbr nv "npm version"
abbr np "npm publish"
abbr nl "npm list"
abbr nls "npm list --depth=0"
abbr no "npm outdated"
abbr nc "npm cache clean --force"
abbr nau "npm audit"
abbr nauf "npm audit fix"

# pnpm shortcuts (if available)
if command -v pnpm >/dev/null
    abbr pi "pnpm install"
    abbr pa "pnpm add"
    abbr pad "pnpm add -D"
    abbr pr "pnpm run"
    abbr ps "pnpm start"
    abbr pt "pnpm test"
    abbr pb "pnpm build"
    abbr pd "pnpm dev"
    abbr pu "pnpm update"
    abbr pl "pnpm list"
    abbr po "pnpm outdated"
end

# Yarn shortcuts (if available)
if command -v yarn >/dev/null
    abbr yi "yarn install"
    abbr ya "yarn add"
    abbr yad "yarn add --dev"
    abbr yr "yarn run"
    abbr ys "yarn start"
    abbr yt "yarn test"
    abbr yb "yarn build"
    abbr yu "yarn upgrade"
    abbr yo "yarn outdated"
    abbr yg "yarn global"
end

# Node.js version management
abbr nvml "nvm list"
abbr nvmls "nvm list"
abbr nvmi "nvm install"
abbr nvmu "nvm use"
abbr nvmc "nvm current"
abbr nvmr "nvm uninstall"

# Useful development functions
function npm-check-updates
    if command -v ncu >/dev/null
        ncu $argv
    else
        echo "npm-check-updates not installed. Install with: npm install -g npm-check-updates"
    end
end

function node-version
    echo "Node.js: $(node --version)"
    echo "npm: v$(npm --version)"
    if command -v pnpm >/dev/null
        echo "pnpm: v$(pnpm --version)"
    end
    if command -v yarn >/dev/null
        echo "Yarn: v$(yarn --version)"
    end
end

function create-node-project
    if test -z "$argv[1]"
        echo "Usage: create-node-project <project-name> [template]"
        echo "Templates: react, vue, angular, express, typescript"
        return 1
    end
    
    set project_name $argv[1]
    set template $argv[2]
    
    switch $template
        case react
            npx create-react-app $project_name
        case vue
            npx @vue/cli create $project_name
        case angular
            npx @angular/cli new $project_name
        case express
            mkdir $project_name
            cd $project_name
            npm init -y
            npm install express
            echo 'const express = require("express");
const app = express();
const port = 3000;

app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});' > index.js
            echo "Express.js project created!"
        case typescript
            mkdir $project_name
            cd $project_name
            npm init -y
            npm install -D typescript @types/node ts-node nodemon
            npx tsc --init
            echo "TypeScript project created!"
        case '*'
            mkdir $project_name
            cd $project_name
            npm init -y
            echo "Basic Node.js project created!"
    end
end

function node-cleanup
    echo "Cleaning up Node.js cache and temporary files..."
    npm cache clean --force 2>/dev/null
    if command -v pnpm >/dev/null
        pnpm store prune 2>/dev/null
    end
    if command -v yarn >/dev/null
        yarn cache clean 2>/dev/null
    end
    echo "Node.js cleanup complete!"
end

# Quick serve functions
function serve-here
    if command -v serve >/dev/null
        serve . $argv
    else if command -v http-server >/dev/null
        http-server . $argv
    else if command -v live-server >/dev/null
        live-server $argv
    else
        echo "No static server available. Install with: npm install -g serve"
    end
end

function dev-server
    if test -f package.json
        if grep -q '"dev"' package.json
            npm run dev
        else if grep -q '"start"' package.json
            npm start
        else
            echo "No dev or start script found in package.json"
        end
    else
        echo "No package.json found in current directory"
    end
end
EOF
    
    # Update main config.fish to source nodejs.fish
    local main_config="$(dirname "$(dirname "$0")")/fish_config/config.fish"
    if ! grep -q "nodejs.fish" "$main_config"; then
        echo "" >> "$main_config"
        echo "if test -f \$config_dir/nodejs.fish" >> "$main_config"
        echo "    source \$config_dir/nodejs.fish" >> "$main_config"
        echo "end" >> "$main_config"
        log_success "Added Node.js configuration to main config"
    fi
    
    # Provide usage information
    log_success "Node.js development environment setup completed!"
    log_info ""
    log_info "Installed components:"
    log_info "  • nvm.fish - Fish-compatible Node Version Manager"
    log_info "  • Node.js $latest_lts - Latest LTS version"
    log_info "  • npm - Node Package Manager"
    log_info "  • pnpm - Fast, efficient package manager"
    log_info "  • yarn - Alternative package manager"
    log_info "  • Global development tools (TypeScript, ESLint, Prettier, etc.)"
    log_info "  • Node.js aliases and shortcuts"
    log_info ""
    log_info "Useful commands:"
    log_info "  nvm list              # List installed Node versions"
    log_info "  nvm install 18        # Install Node.js version 18"
    log_info "  nvm use 20            # Switch to Node.js version 20"
    log_info "  node-version          # Show all installed versions"
    log_info "  create-node-project   # Create new project with templates"
    log_info "  serve-here            # Serve current directory"
    log_info "  dev-server            # Run dev script from package.json"
    log_info "  node-cleanup          # Clean package manager caches"
    log_info ""
    log_info "Package manager shortcuts:"
    log_info "  ni / pi / yi          # npm/pnpm/yarn install"
    log_info "  nr / pr / yr          # npm/pnpm/yarn run"
    log_info "  ns / ps / ys          # npm/pnpm/yarn start"
    log_info "  nb / pb / yb          # npm/pnpm/yarn build"
    log_info ""
    log_info "Project templates available:"
    log_info "  create-node-project my-app react      # React app"
    log_info "  create-node-project my-app vue        # Vue app"
    log_info "  create-node-project my-app angular    # Angular app"
    log_info "  create-node-project my-app express    # Express server"
    log_info "  create-node-project my-app typescript # TypeScript project"
    log_info ""
    
    # Reload Fish configuration if we're in a Fish shell
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