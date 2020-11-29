#!/bin/bash

rsync -a ~/.emacs.d . --exclude .git --exclude semanticdb
rsync -a ~/.tmux . --exclude .git
rsync -a ~/.oh-my-zsh . --exclude .git

cp ~/.p10k.zsh .
cp ~/.zshrc .
cp ~/.bashrc .
cp ~/.tmux.conf .
