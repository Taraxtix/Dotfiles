alias c='clear'
alias v='nvim'

# Git Aliases
alias g='git'
alias gstat='git status'
alias gadd='git add'
alias gcommitM='git commit -m'
alias glog='git log --oneline --graph --branches=*'
alias gpull='git pull'
alias gpush='git pull -q && git push'
alias lg='lazygit'

#Eza aliases
alias l='eza -h --git --no-time'
alias ll='eza -lh --git --no-time'
alias la='eza -ha --git --no-time'
alias lla='eza -lha --git --no-time'
lT() {
  SIZE=$1
  shift 1
  eza -lhTL=$SIZE --git --no-user --no-time --total-size $@
}
alias ls='ll --total-size'
alias las='lla --total-size'

#Zoxide aliases
#alias cd='zoxide'

alias ascii='man ascii | grep -m 1 -A 66 --color=never Oct | bat --style grid,numbers -l vimrc'

#Cargo aliases
alias cr='cargo r'
alias crq='cargo -q r'
alias ct='cargo test'
alias ctq='cargo -q test'

# Build System aliases
alias nj='ninja'
alias mk='make'
alias cmk='cmake'

mkcd() {
  mkdir $1 && cd $1
}

cdcode() {
  cd $1 && code .
}

install() {
  yay -Syu $@
}

untar() {
  tar -xf $1
}

batdiff() {
  git diff --name-only --relative | xargs bat --diff
}

clog() {
  INFO='\033[38;5;243m'
  DEBUG='\033[38;5;025m'
  TRACE='\033[38;5;028m'
  WARN='\033[38;5;214m'
  ERROR='\033[38;5;160m'
  SEVERE='\033[38;5;001m'
  RESET='\033[0m'

  $1 | awk -W interactive '{\
    gsub("INFO:", "'$INFO'INFO:'$RESET'");\
    gsub("DEBUG:", "'$DEBUG'DEBUG:'$RESET'")\
    gsub("TRACE:", "'$TRACE'TRACE:'$RESET'")\
    gsub("WARN:", "'$WARN'WARN:'$RESET'");\
    gsub("WARNING:", "'$WARN'WARNING:'$RESET'");\
    gsub("ERR:", "'$ERROR'ERR:'$RESET'");\
    gsub("ERROR:", "'$ERROR'ERROR:'$RESET'");\
    gsub("SEVERE:", "'$SEVERE'SEVERE:'$RESET'");\
    gsub("FATAL:", "'$SEVERE'FATAL:'$RESET'"); print $0\
    }'
}

standalone() {
  $@ </dev/null &>/dev/null &
  disown
}

alias evince='standalone evince'
