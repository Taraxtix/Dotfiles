alias c='clear'

# Software Aliases
alias android-studio='/usr/local/android-studio/bin/studio.sh & disown'
alias firefox='firefox & disown'

# Git Aliases
alias g='git'
alias gstat='git status'
alias gadd='git add'
alias gcommitM='git commit -m'
alias glog='git log --oneline --graph'
alias gpull='git pull'
alias gpush='git pull -q && git push'
alias ef='eza -lh --git --no-user --no-time'
alias efa='eza -lha --git --no-user --no-time'
alias ascii='man ascii | grep -m 1 -A 66 --color=never Oct | bat --style grid,numbers -l vimrc'
alias cr='cargo r'
alias crq='cargo r -q'

efT(){
    eza -lhTL=$1 --git --no-user --no-time $2
}

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
