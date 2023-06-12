alias k='kubectl'
alias wk='watch kubectl'
# alias act='gh extension exec act -- '
alias python='/usr/local/bin/python3.11'
alias pip='/usr/local/bin/pip3.11'

# map exa commands to normal ls commands
alias ll="exa -l -g --icons"
alias ls="exa --icons"
alias lt="exa --tree --icons -a -I '.git|__pycache__|.mypy_cache|.ipynb_checkpoints'"
alias la="exa -l -a -g --icons"

# show file previews for fzf using bat
alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

