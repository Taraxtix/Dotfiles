alias c='clear'

# Software Aliases
alias android-studio='/usr/local/android-studio/bin/studio.sh & disown'
alias firefox='firefox & disown'

# Git Aliases
alias g='git'
alias gstat='git status'
alias gadd='git add'
alias gcommitM='git commit -m'
alias glog='git log --oneline --graph --branches=*'
alias gpull='git pull'
alias gpush='git pull -q && git push'

#Eza aliases
alias ef='eza -lh --git --no-time'
alias efa='eza -lha --git --no-time'
efT(){
    eza -lhTL=$1 --git --no-user --no-time --total-size $2
}
alias efs='ef --total-size'
alias efas='efa --total-size'

alias ascii='man ascii | grep -m 1 -A 66 --color=never Oct | bat --style grid,numbers -l vimrc'

#Cargo aliases
alias cr='cargo r'
alias crq='cargo -q r'
alias ct='cargo test'
alias ctq='cargo -q test'

mkcd(){
    mkdir $1 && cd $1
}

cdcode(){
    cd $1 && code .
}

install(){
    sudo apt install $@ -y
}

untar(){
    tar -xf $1
}

batdiff() {
    git diff --name-only --relative | xargs bat --diff
}

clog(){
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
