# Begin ~/.bash_functions
# Personal bash functions.


function coffee() {
    echo ""

    # Calculate timeout
    TIMEOUT=$(echo "60*$1" | bc | sed 's/[.].*//')

    # Counter
    TIMER=0

    # Start brewing message
    echo -n "Your coffee is brewing"

    # Timer function
    function brew() {

        # Show progress dot every 5 seconds
        MOD=$(($TIMER%5))
        if [ $MOD -eq 0 ]; then
            echo -n "."
        fi

        # If timer not done, sleep for 1 second and then re-run brew
        if [ $TIMER -lt $TIMEOUT ]; then
            sleep 1
            let TIMER=$TIMER+1
            brew

        # Timer finished
        else

            echo -n " ready!"
            echo ""
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
    echo "("${ref#refs/heads/}")"
}
# End ~/.bash_functions
