# Begin ~/.bash_profile
# Personal environment variables and startup programs.

if [ -f "~/.bashrc" ] ; then
  source ~/.bashrc
fi

# Turn off Ctrl-S binding so terminal programs can use it
bind -r '\C-s'

# End ~/.bash_profile

[[ -s /home/james/.nvm/nvm.sh ]] && . /home/james/.nvm/nvm.sh # This loads NVM
