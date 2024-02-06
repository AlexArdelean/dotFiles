#!/bin/bash

# Change to home directory
cd ~

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install make (assuming Debian-based system)
sudo apt-get update
sudo apt-get install -y make

# Install fd-find using cargo
cargo install fd-find

# Install ripgrep using cargo
cargo install ripgrep

# Print completion message
echo "Neovim tools installation completed. Make sure to restart your shell or run 'source ~/.bashrc' or 'source ~/.zshrc' for changes to take effect."
