#!/bin/bash 

CMD=$1 

if [ "$CMD" == "setup" ]; then
    git config --global --replace-all user.name  "mtdcy.chen"
    git config --global --replace-all user.email "mtdcy.chen@gmail.com"

    git config --global --replace-all core.pager "less -F -X"
    git config --global --replace-all push.default simple
    git config --global --replace-all core.editor vim
    git config --global --replace-all merge.tool vimdiff
    git config --global --replace-all merge.conflictstyle diff3
    git config --global --replace-all mergetool.prompt false
    git config --global --replace-all diff.tool vimdiff

    git config --global --replace-all core.autocrlf false
    git config --global --replace-all core.mergeoptions --no-edit
    git config --global --replace-all core.excludesfile '*.swp'
    echo "setting alias"
    git config --global --replace-all alias.pl "pull --rebase"
    git config --global --replace-all alias.st status 
    git config --global --replace-all alias.co checkout
    git config --global --replace-all alias.ci commit
    git config --global --replace-all alias.br branch 
    git config --global --replace-all alias.cp "cherry-pick --no-ff -x" 
    git config --global --replace-all alias.lg1 "log -n 1 --color --name-status --parents"
    git config --global --replace-all alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cn - %ci)'"
    git config --global --replace-all alias.lga "log --color --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cn - %cr)'"
    git config --global --replace-all alias.list "log --oneline --no-merges --reverse"
else
    git $@
fi
