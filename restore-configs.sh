rsync -a --progress .emacs.d ~
# rsync -a --progress .tmux ~ --exclude .git
curl -L git.io/antigen > antigen.zsh
# rsync -a --progress .oh-my-zsh ~ --exclude .git

cp .p10k.zsh ~
cp .zshrc ~
cp .bashrc ~
cp .tmux.conf ~
