#!/usr/bin/env bash

set -e

apt update && \
apt upgrade -y && \
apt install htop tmux git -y && \
apt autoremove -y && \
apt autoclean -y || exit 2


gitfunc(){
git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
$HOME/.homesick/repos/homeshick/bin/homeshick --batch clone danielloader/dotfiles && $HOME/.homesick/repos/homeshick/bin/homeshick link -f dotfiles
}

export -f gitfunc

su "$SUDO_USER" -c 'gitfunc'
echo "source ~/.bashrc"
exit
