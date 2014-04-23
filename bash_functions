#! /bin/bash
# Begin ~/.bash_functions

# Cd's to a directory path n directories above the pwd, e.g.:
# Usage:
#   [someone@apc /var/www/mysite/mysubfolder] $ ..n 2
#   [someone@apc /var/www] $
function ..n() {

    if ! [[ "$1" =~ ^[0-9]+$ || -z "$1" ]]; then

        cat << EOF
Usage: $0 <integer>

Cd up by <integer> number of directories.  If integer is omitted, cds up one directory.

Examples:

  ..n 4 => cd ../../../..
  ..n 2 => cd ../..
  ..n 1 => cd ..
  ..n   => cd ..

EOF
    else

        # If 0 was passed as argument don't cd up
        if [[ "$1" == 0 ]]; then
            return
        fi

        NDIRPATH=".."
        COUNT=0
        let LEN=$1-1
        while [ $COUNT -lt $LEN ] ; do
            NDIRPATH="../"$NDIRPATH
            let COUNT+=1
        done

        cd $NDIRPATH
    fi
}

# Cd's to a directory in the current path above the pwd with the supplied name.
# Usage:
#   [someone@apc /var/www/mysite/mysubfolder] $ ..s www
#   [someone@apc /var/www] $
function ..s() {
    CUR_PATH=`pwd`

    query=`basename $1`
    if [[ "$CUR_PATH" =~ /$query/ ]]; then

        # Path to cd to
        [[ "$CUR_PATH" =~ ^.*/$query ]]

        cd ${BASH_REMATCH[0]}
    else
        echo "Directory '$1' not found in current path"
    fi
}

# Coffee timer.  Counts down the specified minutes and displays a notification.
# Usage:
#   coffee <minutes>, e.g. `coffee 4` or `coffee 3.5`
function coffee_timer() {
    echo ""
    tput civis

    # Calculate timeout
    total_time=$(echo "60*$1" | bc | sed 's/[.].*//')
    time_elapsed=0
    total_bars=50

    # Timer function
    function brew() {
        # Percentage complete
        percentage=$((($time_elapsed * 100 / $total_time * 100) / 100))
        # Number of solid bars that percentage translates to
        current_bars=$((($percentage * $total_bars) / 100))

        echo -ne "Your coffee is brewing ["
        for (( i=0; i<$total_bars; i++))
            do
                # Print a bar if current bars greater than index
                if [ $i -lt $current_bars ]; then
                    echo -ne "\xe2\x96\xaa"
                # Otherwise, print a space
                else
                    echo -ne " "
                fi
        done
        echo -ne "] $percentage%\r"

        # If timer not done, sleep for 1 second and then re-run brew
        if [ $time_elapsed -lt $total_time ]; then
            sleep 1
            let time_elapsed=$time_elapsed+1
            brew

        # Timer finished
        else
            echo ""
            echo "Ready!"
            echo ""

            # Send notification
            notify-send --urgency=low "Coffee has finished brewing."
            tput cvvis
        fi
    }

    # Start brewing
    brew
}

# Make directory and cd into it. Also creates any directories leading up to
# specified dir if they don't exist (mkdir -p flag)
# Usage:
#   [someone@apc /var/www] $ mkdircd mysite
#   [someone@apc /var/www/mysite] $
# Credit: https://coderwall.com/p/-cycbq
function mkdircd () {
    mkdir -p "$@" && cd "$@";
}

# Get the current git branch
# Usage:
#   parse_git_branch => 'master'
# Credit: http://railstips.org/blog/archives/2009/02/02/bedazzle-your-bash-prompt-with-git-info/
function parse_git_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  if [ "$ref" != '' ]; then
      echo "${ref#refs/heads/}"
  else
      echo ""
  fi
}

function isRepoDirty() {
    git status 2> /dev/null | grep "nothing to commit" > /dev/null 2>&1
    echo $?
}

# Prints the current git branch, or 'no branch' if inside a Git repo but not on
# any branch.  Can be passed optional wrapping chars as arguments 1 and 2
# Usage:
#   print_git_branch => 'master'
#   print_git_branch '(' ')' => '(master)'
#
function print_git_branch() {
    branch=$(parse_git_branch)
    isRepo=$(git rev-parse --is-inside-work-tree 2> /dev/null)

    # Do nothing if this is not a Git repo
    if [ ! "$isRepo" ]; then
        return
    fi

    if [ "$branch" == "" ]; then
        echo "(no branch"
    else
        echo "(${branch}"
    fi
}

function print_git_dirty_flag() {
    isRepo=$(git rev-parse --is-inside-work-tree 2> /dev/null)

    # Do nothing if this is not a Git repo
    if [ ! "$isRepo" ]; then
        return
    fi

    dirty=$(isRepoDirty)
    if [ "$dirty" != "0" ]; then
        echo "⚑"
    fi
}

function print_closing_bracket_if_git_repo() {
    isRepo=$(git rev-parse --is-inside-work-tree 2> /dev/null)

    # Do nothing if this is not a Git repo
    if [ "$isRepo" ]; then
        echo ")"
    fi
}

# Reminder system.  Displays reminders from the rem program in a cowsay bubble
# Usage:
#   showReminders
function showReminders {
    if command -v rem >/dev/null 2>&1 && command -v cowsay >/dev/null 2>&1; then
        OUTPUT=`rem`
        if [ "$OUTPUT" == "No reminders." ];
        then
            echo -en "\e[01;34m"
            cowsay -f bong $OUTPUT
            echo ""
        else
            echo -en "\e[01;33m"
            cowsay -f bong "$OUTPUT"
        fi
    fi

    echo -en "\e[00;m"
}

# Compress a directory string:
#   /home/james/workspace/something/aproject/ -> /h/j/w/s/aproject
# Usage:
#   dir_chomp <directory> <length>
dir_chomp () {
    local p=${1/#$HOME/\~} b s
    s=${#p}
    while [[ $p != ${p//\/} ]]&&(($s>$2))
    do
        p=${p#/}
        [[ $p =~ \.?. ]]
        b=$b/${BASH_REMATCH[0]}
        p=${p#*/}
        ((s=${#b}+${#p}))
    done
    echo ${b/\/~/\~}${b+/}$p
}

function check_battery() {
    local full=$(cat /sys/class/power_supply/BAT0/charge_full 2> /dev/null)
    local current=$(cat /sys/class/power_supply/BAT0/charge_now 2> /dev/null)

    if [ ! "$full" ]; then
        return 1
    fi

    percent=`echo "scale=2;${current} / ${full}" | bc`
    percent=$(echo "$percent*100" | bc)
    percent=${percent/.*}

    if [ $percent -lt 30 ]; then
        local colour="\033[38;5;124m"
    elif [ $percent -lt 60 ]; then
        local colour="\033[38;5;227m"
    else
        local colour="\033[38;5;156m"
    fi

    if [ "$colour" ]; then
        echo -e "${bold}$colour⚡ ${normal}$colour$percent%\033[0m${normal}"
    fi
}
# End ~/.bash_functions
