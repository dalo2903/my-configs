export XAUTHORITY=~/.Xauthority

# export DISPLAY=localhost:0.0
WINDOWS=/mnt/c/Windows
if [ -d "$WINDOWS" ] ; then
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
fi


# source $ZSH/oh-my-zsh.sh
source ~/my-configs/antigen.zsh

antigen use oh-my-zsh
antigen bundle pip
antigen bundle command-not-found
antigen bundle git
antigen bundle github
antigen bundle colorize
antigen bundle encode64

antigen bundle history-substring-search
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme romkatv/powerlevel10k

antigen apply
# User configuration

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'

autoload -U compinit && compinit
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# export MANPATH="/usr/local/man:$MANPATH"
export EDITOR='emacs'
# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Run emacsd
alias emacsc="~/my-configs/start-emacs.sh"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Connect to available sessions
if [[ $- == *i* ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
    tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux -d && tmux attach-session -t ssh_tmux
else
    if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
        tmux
    fi
fi
