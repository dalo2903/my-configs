rsync -a --progress .emacs.d ~ --exclude .git
rsync -a --progress .tmux ~ --exclude .git
rsync -a --progress .oh-my-zsh ~ --exclude .git

cp .p10k.zsh ~
cp .zshrc ~
cp .bashrc ~
cp .tmux.conf ~
