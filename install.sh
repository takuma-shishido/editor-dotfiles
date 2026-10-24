#!/usr/bin/env bash

# Editor dotfiles installation script
# Cross-platform installer for macOS and Linux

set -euo pipefail

# Colors for output, only when writing to a terminal
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

ASSUME_YES=false
DRY_RUN=false

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_HOME="${DOTFILES_TARGET_HOME:-$HOME}"
CONFIG_DIR="$TARGET_HOME/.config"

# Installable components, in installation order.
# Each record is "description|source:target|source:target|..."
COMPONENTS=(
    "Neovim configuration\
|$SCRIPT_DIR/nvim:$CONFIG_DIR/nvim"
    "Zellij configuration\
|$SCRIPT_DIR/zellij/config.kdl:$CONFIG_DIR/zellij/config.kdl\
|$SCRIPT_DIR/zellij/layouts:$CONFIG_DIR/zellij/layouts\
|$SCRIPT_DIR/zellij/plugins:$CONFIG_DIR/zellij/plugins"
    "Zsh configuration\
|$SCRIPT_DIR/zsh/.zshrc:$TARGET_HOME/.zshrc"
    "Starship prompt configuration\
|$SCRIPT_DIR/starship/starship.toml:$CONFIG_DIR/starship.toml"
    "Sheldon plugin manager configuration\
|$SCRIPT_DIR/sheldon/plugins.toml:$CONFIG_DIR/sheldon/plugins.toml"
)

# Print functions
print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

usage() {
    cat <<'USAGE'
Usage: ./install.sh [--yes] [--dry-run]

  --yes      Install every component without prompting.
  --dry-run  Print the planned changes without modifying files.
  --help     Show this help.
USAGE
}

parse_args() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --yes|-y)
                ASSUME_YES=true
                ;;
            --dry-run)
                DRY_RUN=true
                ;;
            --help|-h)
                usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                usage >&2
                exit 2
                ;;
        esac
        shift
    done
}

confirm() {
    local prompt=$1
    local reply

    if [ "$ASSUME_YES" = true ]; then
        return 0
    fi

    read -r -p "$prompt (Y/n) " reply
    [[ ! "$reply" =~ ^[Nn]$ ]]
}

run_change() {
    if [ "$DRY_RUN" = true ]; then
        printf '[DRY-RUN]'
        printf ' %q' "$@"
        printf '\n'
        return 0
    fi
    "$@"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        print_info "Detected Linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        print_info "Detected macOS"
    else
        print_error "Unsupported OS: $OSTYPE"
        exit 1
    fi
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

print_neovim_install_hint() {
    print_info "Install Neovim via package manager:"
    if [[ "$OS" == "macos" ]]; then
        echo "  brew install neovim"
    else
        echo "  # For Ubuntu/Debian:"
        echo "  sudo apt install neovim"
        echo ""
        echo "  # For Arch Linux:"
        echo "  sudo pacman -S neovim"
        echo ""
        echo "  # For Fedora:"
        echo "  sudo dnf install neovim"
    fi
}

# Check dependencies
check_dependencies() {
    print_info "Checking dependencies..."

    # Git is required for lazy.nvim and for the zsh plugins
    if command_exists git; then
        print_success "Git installed"
    else
        print_error "Git is required but not installed"
        exit 1
    fi

    if command_exists nvim; then
        print_success "Neovim installed"
        return 0
    fi

    print_warning "Neovim not found"
    echo ""
    print_neovim_install_hint
    echo ""

    local reply=y
    if [ "$ASSUME_YES" != true ]; then
        read -r -p "Continue without Neovim? (y/N) " reply
    fi
    if [[ ! "$reply" =~ ^[Yy]$ ]]; then
        exit 1
    fi
}

# Move an existing target out of the way
create_backup() {
    local target=$1

    if [ ! -e "$target" ] && [ ! -L "$target" ]; then
        return 0
    fi

    local backup="${target}.backup.$(date +%Y%m%d_%H%M%S).$$"
    local suffix=0
    while [ -e "$backup" ] || [ -L "$backup" ]; do
        suffix=$((suffix + 1))
        backup="${target}.backup.$(date +%Y%m%d_%H%M%S).$$.$suffix"
    done
    print_info "Creating backup: $backup"
    run_change mv "$target" "$backup"
}

create_symlink() {
    local source=$1
    local target=$2

    if [ ! -e "$source" ] && [ ! -L "$source" ]; then
        print_error "Symlink source does not exist: $source"
        return 1
    fi

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        print_success "Already linked: $target -> $source"
        return 0
    fi

    run_change mkdir -p "$(dirname "$target")"
    create_backup "$target"
    run_change ln -s "$source" "$target"
    print_success "Created symlink: $target -> $source"
}

install_components() {
    local record description link
    local -a fields

    for record in "${COMPONENTS[@]}"; do
        IFS='|' read -r -a fields <<<"$record"
        description=${fields[0]}

        echo ""
        if ! confirm "Install $description?"; then
            continue
        fi

        print_info "Installing $description..."
        for link in "${fields[@]:1}"; do
            create_symlink "${link%%:*}" "${link#*:}"
        done
    done
}

post_install() {
    echo ""
    print_success "Installation complete!"
    echo ""
    print_info "Next steps:"
    echo "  1. Download locked zsh plugins: 'sheldon lock'"
    echo "  2. Restart the terminal"
    echo "  3. Launch Neovim: 'nvim' (plugins auto-install)"
    echo ""
    print_info "Language servers are not included; install them per project with :Mason"
    echo ""
}

main() {
    parse_args "$@"

    echo "======================================"
    echo "  Editor Dotfiles Installation"
    echo "======================================"
    echo ""

    detect_os
    check_dependencies
    install_components
    post_install
}

main "$@"
