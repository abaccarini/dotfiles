# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# export PATH="/home/alessandro/libraries/vcpkg:$PATH"


export PATH="/usr/local/texlive/2024/bin/x86_64-linux:$PATH"
export IPELATEXPATH="/usr/local/texlive/2024/bin/x86_64-linux"

export MANPATH="/usr/local/texlive/2024/texmf-dist/doc/man:$MANPATH"
export INFOPATH="/usr/local/texlive/2024/texmf-dist/doc/info:$INFOPATH"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
# ZSH_THEME="powerlevel10k/powerlevel10k"
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"
# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(
    git
    zsh-autosuggestions
    F-Sy-H
    # zsh-vi-mode
    zsh-syntax-highlighting
)
zle_highlight=('paste:none')
source $ZSH/oh-my-zsh.sh

# unset zle_bracketed_paste

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# fpath=(~/.my_zsh_functions $fVpath);
# autoload -U $fpath[1]/*(.:t)
unalias ls 2>/dev/null
unalias la 2>/dev/null
unalias ll 2>/dev/null
# ls and ll are functions aliased to use exa by the ls plugin
alias llt='ll --tree'
alias llti='ll --tree --git-ignore'
alias lla='ll -a' 
alias vim='nvim' 
alias q='exit' 
alias qq='exit' 
alias py='python3' 
alias !!='sudo $(fc -ln -1)'
alias nvc='cd ~/dotfiles/.config/nvim' 
alias dfl='cd ~/dotfiles' 
alias est='cd ~/Dropbox/estimators' 
alias cry='cd ~/Dropbox/cryptography/' 
alias diss='cd ~/Dropbox/dissertation/' 
alias pc='cd ~/picco/compute' 
alias res='cd ~/Dropbox/resume/' 
alias rg3='./scripts/rigel_login.sh' 
alias ipev='$HOME/scripts/ipev.sh' 

fpath=( ~/.zsh_functions "${fpath[@]}" )
autoload -Uz $fpath[1]/*(.:t)

export VISUAL=nvim
export EDITOR="$VISUAL"
#
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#
# precmd () {print -Pn "\e]0;%~\a"}


# used to disable history sharing between splits in tmux
setopt noincappendhistory
setopt nosharehistory

