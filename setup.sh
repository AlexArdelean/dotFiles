#!/bin/bash


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

# Stuff needed to install
# sudo apt install gtk2-engines-murrine // for theme
# pip3 install i3ipc // for autotiling script

# Install nerd font for symbols
mkdir -p ~/.fonts
cp ~/dotFiles/alacritty/JetBrainsMonoNLNerdFont-Regular.ttf ~/.fonts/
cp ~/dotFiles/alacritty/JetBrainsMonoNLNerdFont-Italic.ttf ~/.fonts/
cp ~/dotFiles/alacritty/JetBrainsMonoNLNerdFont-Bold.ttf ~/.fonts/
cp ~/dotFiles/alacritty/JetBrainsMonoNLNerdFont-BoldItalic.ttf ~/.fonts/
fc-cache -fv

ln -s ~/dotFiles/nvim/ ~/.config/
ln -s ~/dotFiles/alacritty/ ~/.config/
ln -s ~/dotFiles/i3 ~/.config
ln -s ~/dotFiles/rofi ~/.config/
ln -s ~/dotFiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/dotFiles/bashrc ~/.bashrc
ln -s ~/dotFiles/rofi/tokyonight_big1.rasi /usr/share/rofi/themes/
