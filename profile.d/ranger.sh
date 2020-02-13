## ranger.sh : setup ranger to skip the default rc if a user-specific rc exists

if test -d "${XDG_CONFIG_HOME:-${HOME-}/.config}/ranger"
then export RANGER_LOAD_DEFAULT_RC='FALSE'
else export RANGER_LOAD_DEFAULT_RC='TRUE'
fi

# vim:ft=sh
