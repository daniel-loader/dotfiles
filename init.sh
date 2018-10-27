#!/usr/bin/env bash
# elevate to root
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

apt update && \
apt upgrade -y && \
apt install htop tmux git -y && \
apt autoremove -y && \
apt autoclean -y

exit

git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
$HOME/.homesick/repos/homeshick/bin/homeshick clone danielloader/dotfiles
source $HOME/.bashrc

exit