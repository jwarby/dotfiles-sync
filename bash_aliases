#! /bin/bash
# Begin ~/.bash_aliases
# Personal alias commands.

# Reload the bashrc file
alias reload='. ~/.bashrc'

# Rem with Monday as default day
alias rem="rem -m"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "'\''$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')'\'' has finished running."'
# NES assembler
alias nesasm="/home/james/Programs/nes-dev/./nesasm"

# Frog Windows 7 VM
alias windows='rdesktop -T "Frog Windows 7 VM" -g 1920x900 -P -z -x l -r sound:off -u "Frog\james.warwood" vm-win7-x64'

# Clear
alias cl='clear'

# Asciiquarium
alias asciiquarium='perl /usr/local/bin/asciiquarium/asciiquarium'

# Twitter CL client
alias tweet='twidge update'

# Compile less files
alias lessall='sh /home/james/Scripts/compile-less.sh'

# Make directories with -p flag
alias mkdir='mkdir -p'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Exit vim-style
alias :q='exit'

# Log unpushed commits
alias glu='git log --no-merges --author="`git config user.name`" `git rev-parse --abbrev-ref --symbolic-full-name @{u}`..HEAD | vim -'
# End ~/.bash_aliases
