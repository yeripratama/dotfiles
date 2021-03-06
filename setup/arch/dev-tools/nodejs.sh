#!/bin/sh

echo "======================================"
echo "Installing Node.js..."
echo "======================================"

sudo -S pacman --noconfirm -Syu nodejs npm

echo "======================================"
echo "Installing npm packages..."
echo "======================================"

npm i -g intelephense \
    purescript spago \
    neovim \
    http-server \
    yarn \
    hexo-cli \
    gatsby-cli \
    pnpm \
    prettier \
    @prettier/plugin-php \
    eslint \
    ionic \
    @adonisjs/cli
