#!/bin/sh

echo "======================================"
echo "Installing Haskell..."
echo "======================================"

sudo -S pacman --noconfirm -Syu stack

stack install hlint hindent
