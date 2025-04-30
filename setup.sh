#!/bin/bash

# Installs my programs for Ubuntu 24.04 

# Check if variety is installed
if ! command -v variety &> /dev/null; then
    echo "variety not found. Installing..."
    sudo sudo apt install variety
else
    echo "variety is already installed."
fi

# Check if golang is installed
if ! command -v golang &> /dev/null; then
    echo "golang not found. Installing..."
    sudo sudo apt install golang 
else
    echo "golang is already installed."
fi

# Check if alacritty is installed
if ! command -v alacritty &> /dev/null; then
    echo "alacritty not found. Installing..."
    sudo snap install alacritty --classic
else
    echo "alacritty is already installed."
fi

# Check if rofi is installed
if ! command -v rofi &> /dev/null; then
    echo "rofi not found. Installing..."
    sudo apt-get install rofi 
else
    echo "rofi is already installed."
fi
# Install the rofi theme
sudo cp ~/.config/rofi/tokyonight.rasi /usr/share/rofi/themes

# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    echo "tmux not found. Installing via snap..."
    sudo snap install tmux --classic --edge
else
    echo "tmux is already installed."
fi

# Check if neovim is installed
if ! command -v nvim &> /dev/null; then
    echo "neovim not found. Installing via snap..."
    sudo snap install nvim --classic --edge
else
    echo "neovim is already installed."
fi

# Check if TPM directory already exists
TPM_DIR=~/.tmux/plugins/tpm
if [ -d "$TPM_DIR" ]; then
    echo "TPM (Tmux Plugin Manager) is already installed."
else
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo "TPM (Tmux Plugin Manager) installed successfully."
fi

# Install all plugins
"$TPM_DIR/bin/install_plugins"

# Check if ripgrep (rg) is installed
if ! command -v rg &> /dev/null; then
    echo "ripgrep (rg) not found. Installing..."
    # Install ripgrep based on your distribution
    sudo apt update
    sudo apt install ripgrep
else
    echo "ripgrep (rg) is already installed."
fi

# Install make if not installed
if ! command -v make &> /dev/null; then
    echo "Installing make..."
    sudo apt-get install -y make
else
    echo "make is already installed."
fi

# Install Rust if not already installed
if ! command -v cargo &> /dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "Rust is already installed."
fi

# Install fd-find using cargo
cargo install fd-find

# Install ripgrep using cargo
cargo install ripgrep

# Install nodejs if not installed
if ! command -v node &> /dev/null; then
    echo "Installing nodejs..."
    sudo bash ~/dotFiles/scripts/nodesource_setup.sh
    sudo apt-get install -y nodejs
else
    echo "nodejs is already installed."
fi

# Install tree-sitter-cli globally for treesitter-textobjects
if ! npm list -g --depth=0 tree-sitter-cli &> /dev/null; then
    echo "Installing tree-sitter-cli..."
    sudo npm install -g tree-sitter-cli
else
    echo "tree-sitter-cli is already installed. Skipping."
fi

# Stuff needed to install
# sudo apt install gtk2-engines-murrine // for theme
# pip3 install i3ipc // for autotiling script

echo "Installing nerd font for symbols"
mkdir -p ~/.fonts
cp ~/dotFiles/alacritty/JetBrainsMonoNLNerdFont-Regular.ttf ~/.fonts/
cp ~/dotFiles/alacritty/JetBrainsMonoNLNerdFont-Italic.ttf ~/.fonts/
cp ~/dotFiles/alacritty/JetBrainsMonoNLNerdFont-Bold.ttf ~/.fonts/
cp ~/dotFiles/alacritty/JetBrainsMonoNLNerdFont-BoldItalic.ttf ~/.fonts/
fc-cache -fv > /dev/null 2>&1

echo "Linking config directories"
ln -s ~/dotFiles/nvim/ ~/.config/
ln -s ~/dotFiles/alacritty/ ~/.config/
ln -s ~/dotFiles/i3 ~/.config
ln -s ~/dotFiles/rofi ~/.config/
ln -s ~/dotFiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/dotFiles/bashrc ~/.bashrc
ln -s ~/dotFiles/rofi/tokyonight_big1.rasi /usr/share/rofi/themes/
