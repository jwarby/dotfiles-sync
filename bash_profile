#! /bin/bash
# Begin ~/.bash_profile
# Personal environment variables and startup programs.
if [ -e ~/.bashrc ]; then
    source ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

# Turn off Ctrl-S binding so terminal programs can use it
bind -r '\C-s'

[[ -s /home/james/.nvm/nvm.sh ]] && . /home/james/.nvm/nvm.sh # This loads NVM
[[ -s /srv/sites/james.warwood/.nvm/nvm.sh ]] && . /srv/sites/james.warwood/.nvm/nvm.sh # This loads NVM

# If we're using git-backed dotfiles, run the update script
if [ -e ~/dotfiles/update ]; then
    ~/dotfiles/./update
fi

# End ~/.bash_profile

