#!/bin/bash

rsync -a ~/.emacs.d . --exclude .git
rsync -a ~/.tmux . --exclude .git
rsync -a ~/.oh-my-zsh . --exclude .git

cp ~/.zshrc .
cp ~/.bashrc .
cp ~/.tmux.conf .
