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
echo "Copying i3 config..."
cp -r dotfiles/.config/i3 ./
cp -r dotfiles/.config/i3status ./
read -p "i3 gaps? (y/n): " I3_GAPS
if [ $I3_GAPS = "n" ]; then
    sed -i 's/gaps inner 45/gaps inner 0/' i3/config
fi
echo "Copying bash config..."
cp dotfiles/.bash_profile ../
cp dotfiles/.bashrc ../
cp dotfiles/.xinitrc ../
cp dotfiles/runhack ../
chmod +x ../runhack

echo "Installing Heroku CLI..."
sudo npm install -g heroku
