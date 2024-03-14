#! /bin/bash

echo "Generating SSH key..."
ssh-keygen

echo "Getting config files..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/mkgs/dotfiles.git ~/code/dotfiles
echo "Copying vim config..."
cp ~/code/dotfiles/.vimrc ~/
cp -r ~/code/dotfiles/.vim ~/
echo "Copying i3 config..."
cp -r ~/code/dotfiles/.config/i3 ~/.config/
cp -r ~/code/dotfiles/.config/i3status ~/.config/
echo "Copying tmux config..."
cp -r ~/code/dotfiles/.config/tmux ~/.config/
echo "Copying bash config..."
cp ~/code/dotfiles/.bash_profile ~/
cp ~/code/dotfiles/.bashrc ~/
echo "Copying qutebrowser config..."
cp ~/code/dotfiles/.config/qutebrowser ~/.config/

read -p "Are you using a DM? (y/n): " DM_CONFIG
if [ $DM_CONFIG = "n" ]; then
    cp ~/code/dotfiles/.xinitrc ~/
fi

echo "Copying alacritty config..."
cp -r ~/code/dotfiles/.config/alacritty ~/.config

echo "Installing Heroku CLI..."
sudo npm install -g heroku
