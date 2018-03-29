## ~/.bashrc : bash config for interactive shells
## Patrick DeYoreo
## Make sure this doesn't display anything or bad things will happen!


## Confirm that this is an interactive shell
[[ $- != *i* ]] && return

## If {DISPLAY} is set update {LINES} and {COLUMNS} after each command
[[ ${DISPLAY} ]] && shopt -s checkwinsize


## Set GPG_TTY output of `tty' to and put GPG_TTY in the environment
wait $! && {
  read -r 'GPG_TTY'
  export GPG_TTY
} < <(command -p tty) 2> /dev/null


## Functions, command substitutions, and subshells inherit traps on `ERR' 
set -o errtrace
## Require the `>|' operator to overwrite existing files via redirection
set -o noclobber

## Pass directory names entered as commands as arguments to `cd'
shopt -s autocd
## Correct minor spelling mistakes in directory names passed to `cd'
shopt -s cdspell
## Verify existence of commands in the hashtable before executing them
shopt -s checkhash
## Print jobs upon exit and if any are running defer until second attempt
shopt -s checkjobs
## Attempt to save multiline commands as a single history entry
shopt -s cmdhist
## Expand directory names upon performing filename completion
shopt -s direxpand
## Attempt to correct mispelled directory names during word completion
shopt -s dirspell
## Enable extended pattern matching features
shopt -s extglob
## Match bracketed range expressions using the traditional C locale
shopt -s globasciiranges
## Let '**' match all files and 0 or more directories and subdirectories
shopt -s globstar
## Append to the history file instead of overwriting it
shopt -s histappend
## If using readline, allow user to re-edit a failed history substitution
shopt -s histreedit
## If using readline, load history substitution results into the editing buffer
shopt -s histverify
## Send SIGHUP to all jobs when an interactive login shell exits
shopt -s huponexit
## Command substitutions inherit the value of the `errexit' option
shopt -s inherit_errexit
## If job control is off, run the last cmd of a pipeline in the current shell
shopt -s lastpipe
## When `cmdhist' is enabled, save multiline commands with embedded newlines
shopt -s lithist


## Set GLOBIGNORE to match all instances of `.' and `..'
GLOBIGNORE='*(?(.)?(.|*)/).?(.)'
## Setting GLOBIGNORE enables `dotglob', so disable for original behavior
shopt -u dotglob


## Set the location of the history file
HISTFILE="${XDG_DATA_HOME:-"${HOME}"}/.bash_history"
## Set max number of entries to store on disk
HISTFILESIZE=10000
## Set max number of entries to store in memory
HISTSIZE=-1
## Erase duplicates before adding an entry
HISTCONTROL='ignorespace'
## Ignore immediate dups disregarding additional whitespace
HISTIGNORE='&*([[:blank:]])?(;)*([[:blank:]])'
## Set a timestamp format (1999-12-31 23:59:59 +0000)
HISTTIMEFORMAT='[%F %T %z] '


## Create an array to store terminal escape sequences
declare -A ti=(
  [bold]="$(tput bold)"    [dim]="$(tput dim)"
  [sitm]="$(tput sitm)"   [ritm]="$(tput ritm)"
  [smso]="$(tput rmso)"   [rmso]="$(tput rmso)"
  [smul]="$(tput smul)"   [rmul]="$(tput rmul)"
  [sgr0]="$(tput sgr0)"
)


## Limit depth of path generated by '\w' during prompt expansion
PROMPT_DIRTRIM=4

## Function to set the Primary Prompt
PS1() {
PS1=\
'\['\
"${ti[sgr0]:=$(tput sgr0)}${ti[dim]:=$(tput dim)}"\
"$( (($1)) && tput setaf "$(($(($1))%$((${ti[colors]:=$(tput colors)}))))")"\
'\]'\
'$(eval '"'"'printf \%.s\~ {1..'"'"'"$(("$(tput cols)"))"'"'"'}'"'"')'\
'\['"${ti[sgr0]:=$(tput sgr0)}"'\]\n'\
'\['"${ti[sgr0]:=$(tput sgr0)}${ti[bold]:=$(tput bold)}"'\]\u'\
'\['"${ti[dim]:=$(tput dim)}"'\]@'\
'\['"${ti[sgr0]:=$(tput sgr0)}${ti[bold]:=$(tput bold)}"'\]\h'\
'\['"${ti[dim]:=$(tput dim)}"'\]:'\
'\['"${ti[sgr0]:=$(tput sgr0)}${ti[bold]:=$(tput bold)}"'\]\w'\
'\['"${ti[sgr0]:=$(tput sgr0)}"'\]\n'\
'\['"${ti[sgr0]:=$(tput sgr0)}${ti[bold]:=$(tput bold)}"'\]\D{%A %d %B %Y}'\
'\['"${ti[sgr0]:=$(tput sgr0)}"'\] '\
'\['"${ti[sgr0]:=$(tput sgr0)}${ti[bold]:=$(tput bold)}"'\]\D{%I:%M %p}'\
'\['"${ti[sgr0]:=$(tput sgr0)}"'\]\n'\
'\['\
"${ti[sgr0]:=$(tput sgr0)}${ti[bold]:=$(tput bold)}"\
"$( (($1)) && tput setaf "$(($(($1))%$((${ti[colors]:=$(tput colors)}))))")"\
'\]'\
'\$λ'\
'\['"${ti[sgr0]:=$(tput sgr0)}"'\]'\
' '
}


## Function to set the Secondary Prompt
PS2() {
PS2=\
'\['\
"${ti[sgr0]:=$(tput sgr0)}${ti[bold]:=$(tput bold)}${ti[dim]:=$(tput dim)}"\
"$( (($1)) && tput setaf "$(($(($1))%$((${ti[colors]:=$(tput colors)}))))")"\
'\]'\
'$(( (LINENO - '"$(("${BASH_LINENO[-1]}"))"') / 10 ))'\
'$(( (LINENO - '"$(("${BASH_LINENO[-1]}"))"') % 10 ))'\
'\['"${ti[sgr0]:=$(tput sgr0)}"'\] '
} 


## Function to set the Select Prompt (does not undergo expansion)
PS3() {
PS3='•◆ '
}


## Function to set the Exec-Trace Prompt
PS4() {
PS4=\
'\['\
"${ti[sgr0]:=$(tput sgr0)}${ti[bold]:=$(tput bold)}${ti[dim]:=$(tput dim)}"\
"$( (($1)) && tput setaf "$(($(($1))%$((${ti[colors]:=$(tput colors)}))))")"\
'\]'\
'•'\
'\['"${ti[sgr0]:=$(tput sgr0)}${ti[bold]:=$(tput bold)}"'\]'\
'◆'\
'\['"${ti[sgr0]:=$(tput sgr0)}"'\]'\
' '
}

## Function to update all the prompts
PS_Update() {
  PS1 "$1"
  PS2 "$1"
  PS3 "$1"
  PS4 "$1"
  kill -28 $$
}

## Update prompt strings before each primary prompt
case "${PROMPT_COMMAND};" in
  'PS_Update $?;'*)
    ;;
  *)
    PROMPT_COMMAND='PS_Update $?'"${PROMPT_COMMAND:+; "${PROMPT_COMMAND}"}"
esac


## Load any additional config
[[ -d ~/.bashrc.d ]] &&
  for _ in ~/.bashrc.d/?*; do
    [[ -r "$_" ]] && . "$_"
  done
