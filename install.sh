#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_NVIM=false
INSTALL_GO=false

for arg in "$@"; do
    case "$arg" in
        nvim) INSTALL_NVIM=true ;;
        go) INSTALL_GO=true ;;
    esac
done

OS="$(uname -s)"

ensure_git() {
    if command -v git &>/dev/null; then
        return
    fi
    echo "git not found, installing..."
    if [ "$OS" = "Darwin" ]; then
        brew install git
    elif command -v apt-get &>/dev/null; then
        sudo apt-get update -qq && sudo apt-get install -y git
    elif command -v pacman &>/dev/null; then
        sudo pacman -Sy --noconfirm git
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y git
    else
        echo "Cannot install git automatically. Please install it and re-run."
        exit 1
    fi
}

install_git_hook() {
    local hooks_dir="$HOME/.config/git/hooks"
    if [ ! -f "$hooks_dir/pre-commit" ]; then
	    mkdir -p "$hooks_dir"
	    cp "$DOTFILES_DIR/bin/nocheckin" "$hooks_dir/pre-commit" && chmod +x "$hooks_dir/pre-commit"
	    git config --global core.hooksPath "$hooks_dir"
	    echo "nocheckin -> $hooks_dir/pre-commit (global pre-commit hook)"
    fi
}

install_packages() {
    if [ "$OS" = "Darwin" ]; then
        if ! command -v brew &>/dev/null; then
            echo "Homebrew not found. Install it from https://brew.sh and re-run."
            exit 1
        fi
        brew install fzf ripgrep tmux koekeishiya/formulae/skhd rectangle
        # brew services start skhd
        if ! brew list --cask ghostty &>/dev/null 2>&1; then
            brew install --cask ghostty
        fi
        if ! brew list --cask docker-desktop &>/dev/null && [ ! -d /Applications/Docker.app ]; then
            brew install --cask docker-desktop
        fi
        if [ "$INSTALL_NVIM" = true ]; then
            brew install nvim
        fi
    elif [ "$OS" = "Linux" ]; then
        if command -v apt-get &>/dev/null; then
            sudo apt-get update -qq
            sudo apt-get install -y fzf ripgrep tmux openssh wireguard-tools xclip ghostty make gcc
            if [ "$INSTALL_NVIM" = true ]; then
                sudo apt-get install -y nvim
            fi
        elif command -v pacman &>/dev/null; then
            sudo pacman -Sy --noconfirm fzf ripgrep tmux openssh wireguard-tools xclip ghostty make gcc ttf-hack man-db man-pages
            if [ "$INSTALL_NVIM" = true ]; then
                sudo pacman -Sy --noconfirm nvim
            fi
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y fzf ripgrep tmux openssh wireguard-tools xclip ghostty make gcc
            if [ "$INSTALL_NVIM" = true ]; then
                sudo dnf install -y nvim
            fi
        else
            echo "Unsupported Linux package manager. Install fzf, ripgrep, openssh (and nvim) manually."
            exit 1
        fi

        # Ghostty on Linux: build from source via tarball release
        if ! command -v ghostty &>/dev/null; then
            echo "Ghostty is not available via package manager. Install it manually from https://ghostty.org/download and re-run."
        fi
    else
        echo "Unsupported OS: $OS"
        exit 1
    fi
}


install_ghostty_config() {
    local dest="$HOME/.config/ghostty"
    mkdir -p "$dest"
    cp "$DOTFILES_DIR/ghostty/config" "$dest/config"
    echo "ghostty config -> $dest/config"
}

install_bin() {
    mkdir -p "$HOME/bin"
    for f in "$DOTFILES_DIR/bin/"*; do
        [ -f "$f" ] || continue
        [[ "$(basename "$f")" == "osx_settings.sh" ]] && continue
        cp "$f" "$HOME/bin/$(basename "$f")"
        chmod +x "$HOME/bin/$(basename "$f")"
        echo "bin/$(basename "$f") -> $HOME/bin/"
    done
}

install_dotfiles() {
    local files=(.vimrc .bashrc .bash_profile .gitconfig .tmux.conf .rgignore .bash_functions .skhdrc .git-completion.bash)
    if [ "$OS" = "Darwin" ]; then
        files+=(.skhdrc)
    fi
    for f in "${files[@]}"; do
        if [ -f "$DOTFILES_DIR/$f" ]; then
            cp "$DOTFILES_DIR/$f" "$HOME/$f"
            echo "$f -> $HOME/$f"
        fi
    done

    if [ "$OS" = "Linux" ]; then
        for f in .xinitrc .xmodmap; do
            if [ -f "$DOTFILES_DIR/$f" ]; then
                cp "$DOTFILES_DIR/$f" "$HOME/$f"
                echo "$f -> $HOME/$f"
            fi
        done
    fi

    # tmux: prefer XDG location if the directory already exists, else use $HOME
    if [ -f "$DOTFILES_DIR/.tmux.conf" ]; then
        if [ -d "$HOME/.config/tmux" ]; then
            cp "$DOTFILES_DIR/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
            echo ".tmux.conf -> $HOME/.config/tmux/tmux.conf"
        else
            cp "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
            echo ".tmux.conf -> $HOME/.tmux.conf"
        fi
    fi
}

install_nvim() {
    local dest="$HOME/.config/nvim"
    mkdir -p "$dest"
    cp -r "$DOTFILES_DIR/nvim/"* "$dest/"
    echo "nvim config -> $dest"
}

install_go() {
    if [ "$OS" = "Darwin" ]; then
        brew install go
    elif [ "$OS" = "Linux" ]; then
        # distro packages are often outdated, so use the official tarball
        local version arch
        version="$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -n1)"
        case "$(uname -m)" in
            x86_64) arch=amd64 ;;
            aarch64|arm64) arch=arm64 ;;
            *) echo "Unsupported architecture for Go: $(uname -m)"; exit 1 ;;
        esac
        if [ "$(/usr/local/go/bin/go version 2>/dev/null | awk '{print $3}')" != "$version" ]; then
            curl -fsSL "https://go.dev/dl/$version.linux-$arch.tar.gz" -o /tmp/go.tar.gz
            sudo rm -rf /usr/local/go
            sudo tar -C /usr/local -xzf /tmp/go.tar.gz
            rm /tmp/go.tar.gz
        fi
        export PATH="/usr/local/go/bin:$PATH"
    fi
    echo "$(go version) installed"

    go install golang.org/x/tools/gopls@latest
    echo "gopls -> $(go env GOPATH)/bin/gopls"
}

echo "==> Ensuring git is installed..."
ensure_git

echo "==> Installing packages..."
install_packages

if [ "$OS" = "Darwin" ]; then
    echo "==> Applying macOS settings..."
    bash "$DOTFILES_DIR/bin/osx_settings.sh"
fi

echo "==> Installing ghostty config..."
install_ghostty_config

echo "==> Installing bin scripts..."
install_bin

echo "==> Installing git hook..."
install_git_hook

echo "==> Installing dotfiles..."
install_dotfiles

if [ "$INSTALL_NVIM" = true ]; then
    echo "==> Installing nvim config..."
    install_nvim
fi

if [ "$INSTALL_GO" = true ]; then
    echo "==> Installing go and gopls..."
    install_go
fi

echo "Done."
