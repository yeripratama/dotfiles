#!/bin/sh

# ========================
# DOTFILES

source "$(dirname $0)/helpers.sh"

# doftiles directory
DOTFILES="$HOME/dotfiles"
if [ "$1" != "" ]; then
    DOTFILES=$1
fi

echo "-> creating symlinks..."

# make sure there is .config folder
mkdir -p $HOME/.config

# tmux
link_home .tmux.conf
link_home .tmuxline.conf

# global config
link_home .toprc
link_home .ctags
link_home .gitconfig
link_home .gitignore_global
link_home .editorconfig
link_home .npmrc
link_home .prettierrc
link_home .xinitrc
link_home .ncmpcpp
link_home .spacemacs
link_home .railsrc
link_home .opam-helper

# sh
link_home .paths
link_home .env
link_home .aliases
link_home .functions
link_home .zshrc
link_home .zprofile

link_file $DOTFILES/home/.oh-my-zsh/custom/themes/pirey.zsh-theme $HOME/.oh-my-zsh/custom/themes/pirey.zsh-theme

# .config
link_xdg_config Dharkael
link_xdg_config nvim
link_xdg_config alacritty
link_xdg_config kitty
link_xdg_config polybar
link_xdg_config mpd
link_xdg_config i3
link_xdg_config i3status
link_xdg_config rofi
link_xdg_config picom
link_xdg_config dunst
link_xdg_config ranger

echo "OK config files linked"
