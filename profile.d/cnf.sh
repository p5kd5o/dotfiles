# cnf.sh : command-not-found hooks for bash and zsh

# bash hook definition
command_not_found_handle()
{
  if command -v cnf-lookup > /dev/null
  then
    if test -t 1
    then
      cnf-lookup --colors -- "${1-}"
    else
      cnf-lookup -- "${1-}"
    fi
  elif test -x /usr/local/lib/command-not-found
  then
    /usr/local/lib/command-not-found -- "${1-}"
  elif test -x /usr/lib/command-not-found
  then
    /usr/lib/command-not-found -- "${1-}"
  else
    printf '%s: command not found\n' "${1-}"
  fi
  return 127
} >&2

# zsh hook definition
command_not_found_handler()
{
  if command -v cnf-lookup > /dev/null
  then
    if test -t 1
    then
      cnf-lookup --colors -- "${1-}"
    else
      cnf-lookup -- "${1-}"
    fi
  elif test -x /usr/local/lib/command-not-found
  then
    /usr/local/lib/command-not-found -- "${1-}"
  elif test -x /usr/lib/command-not-found
  then
    /usr/lib/command-not-found -- "${1-}"
  else
    printf '%s: command not found\n' "${1-}"
  fi
  return 127
} >&2

# vim:ft=sh
