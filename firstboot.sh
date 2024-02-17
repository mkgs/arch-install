#! /bin/bash

echo "Generating SSH key..."
ssh-keygen

echo "Getting config files..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/mkgs/dotfiles.git ~/code
echo "Copying vim config..."
cp ~/code/dotfiles/.vimrc ~/
cp -r ~/code/dotfiles/.vim ~/
echo "Copying i3 config..."
cp -r ~/code/dotfiles/.config/i3 ~/.config/
cp -r ~/code/dotfiles/.config/i3status ~/.config/
read -p "i3 gaps? (y/n): " I3_GAPS
if [ $I3_GAPS = "n" ]; then
    sed -i 's/gaps inner 45/gaps inner 0/' ~/.config/i3/config
fi
echo "Copying bash config..."
cp ~/code/dotfiles/.bash_profile ~/
cp ~/code/dotfiles/.bashrc ~/

read -p "Are you using a DM? (y/n): " DM_CONFIG
if [ $DM_CONFIG = "n" ]; then
    cp ~/code/dotfiles/.xinitrc ~/
fi

echo "Copying alacritty config..."
cp -r ~/code/dotfiles/.config/alacritty ~/.config

echo "Installing Heroku CLI..."
sudo npm install -g heroku
