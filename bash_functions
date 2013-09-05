#! /bin/bash
# Begin ~/.bash_functions

# Coffee timer
function coffee() {
    echo ""

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
        fi
    }

    # Start brewing
    brew
}

# Cd's to a directory in the current path above the pwd  with the supplied name.
function ..s() {
    CUR_PATH=`pwd`

    if [[ "$CUR_PATH" =~ /$1/ ]]; then
        
        # Path to cd to
        [[ "$CUR_PATH" =~ ^.*/$1 ]]

        cd ${BASH_REMATCH[0]}
    else
        echo "Directory '$1' not found in current path"
    fi
}


# Cd's to a directory path n directories above the pwd, e.g.: 
#     ..n 3 translates to cd ../../..
#
#  @param n    The number of directories above the current directory to cd to
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

# Counts the number of insertions/deletions in a diff file
function diffstat() {
    PIPED_INPUT=`cat -`
    FILES=`echo "$PIPED_INPUT" | grep -E ^index -i | wc -l`
    INSERTIONS=`echo "$PIPED_INPUT" | grep -E ^[+]{1}[^+]+ | wc -l`
    DELETIONS=`echo "$PIPED_INPUT" | grep -E ^[-]{1}[^-]+ | wc -l`

    echo "${FILES} files modified, ${INSERTIONS} insertions(+), ${DELETIONS} deletions(-)"
}

# Make directory and cd into it. Also creates any directories leading up to specified dir if they don't exist (mkdir -p flag)
# Credit: https://coderwall.com/p/-cycbq
function mkdircd () { 
    mkdir -p "$@" && cd "$@"; 
}

# Git branch info
# Credit: http://railstips.org/blog/archives/2009/02/02/bedazzle-your-bash-prompt-with-git-info/
function parse_git_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  if [ "$ref" != '' ]; then
      echo "${ref#refs/heads/}"
  else
      echo ""
  fi
}

function print_git_branch() {
    branch=$(parse_git_branch)
    isRepo=$(git rev-parse --is-inside-work-tree 2> /dev/null)

    if [ ! "$isRepo" ]; then
        return
    fi

    if [ "$branch" == "" ]; then
        echo "(no branch)"
    else
        echo "(${branch})"
    fi
}

# Reminder system
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

# End ~/.bash_functions
