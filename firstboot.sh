#! /bin/bash

echo "Installing virtualenv..."
sudo pip install virtualenvwrapper

echo "Generating SSH key..."
ssh-keygen

echo "Getting config files..."
git clone https://github.com/VundleVim/Vundle.vim.git /home/$USER_NAME/.vim/bundle/Vundle.vim
mkdir /home/$USER_NAME/.config && cd /home/$USER_NAME/.config
git clone https://github.com/mkgs/dotfiles.git
echo "Copying vim config..."
cp dotfiles/.vimrc ../
cp -r dotfiles/.vim ../

echo "Installing Heroku CLI..."
sudo npm install -g heroku
