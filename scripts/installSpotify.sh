#!/bin/bash

# Install spotify
curl -sS https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client

# Install spotify ad block
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh

git clone https://github.com/Gspr-bit/Spotify-Tokyo-Night-Theme.git
mkdir ~/.config/spicetify/Themes/Tokyo
cd Spotify-Tokyo-Night-Theme
cp color.ini user.css ~/.config/spicetify/Themes/Tokyo
spicetify config current_theme Tokyo
spicetify config color_scheme Storm
spicetify apply
