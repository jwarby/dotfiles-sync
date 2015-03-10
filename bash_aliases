#! /bin/bash
# Begin ~/.bash_aliases
# Personal alias commands.

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "'\''$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')'\'' has finished running."'

# Clear
alias cl='clear'

# Make directories with -p flag
alias mkdir='mkdir -p'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Exit vim-style
alias :q='exit'

# Log unpushed commits
alias glu='git log --name-status --no-merges --author="`git config user.name`" `git rev-parse --abbrev-ref --symbolic-full-name @{u}`..HEAD | vim -'
alias glu-diff='git show --no-merges --author="`git config user.name`" `git rev-parse --abbrev-ref --symbolic-full-name @{u}`..HEAD | vim -'

# End ~/.bash_aliases
