#! /bin/bash

echo "Installing virtualenv..."
sudo pip install virtualenvwrapper

echo "Generating SSH key..."
ssh-keygen

echo "Getting config files..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/mkgs/dotfiles.git ~/.config/dotfiles
echo "Copying vim config..."
cp ~/.config/dotfiles/.vimrc ~/
cp -r ~/.config/dotfiles/.vim ~/
echo "Copying i3 config..."
cp -r ~/.config/dotfiles/.config/i3 ~/.config/
cp -r ~/.config/dotfiles/.config/i3status ~/.config/
read -p "i3 gaps? (y/n): " I3_GAPS
if [ $I3_GAPS = "n" ]; then
    sed -i 's/gaps inner 45/gaps inner 0/' ~/.config/i3/config
fi
echo "Copying bash config..."
cp ~/.config/dotfiles/.bash_profile ~/
cp ~/.config/dotfiles/.bashrc ~/
cp ~/.config/dotfiles/runhack ~/
chmod +x ~/runhack

read -p "Are you using a DM? (y/n): " DM_CONFIG
if [ $DM_CONFIG = "n" ]; then
    cp ~/.config/dotfiles/.xinitrc ~/
fi

echo "Copying termite config..."
cp -r ~/.config/dotfiles/.config/termite ~/.config

echo "Installing Heroku CLI..."
sudo npm install -g heroku
