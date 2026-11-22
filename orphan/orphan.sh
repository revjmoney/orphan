# /etc/profile.d/orphan.sh: Orphan splash + menu as the login "home".
# The menu stays up: Shell opens a subshell (`exit` returns to the menu), programs return to it,
# only "Log out" ends the session. If the menu ever crashes you land at a normal shell.
# Plain terminal instead: echo plain > /etc/orphan/login-mode   (or Settings in the menu)
# Skip once:  ORPHAN_NOMENU=1   Scripted (non-interactive) ssh never sees any of this.
case $- in *i*) ;; *) return 0 ;; esac
[ -t 0 ] && [ -t 1 ] || return 0
[ -n "$ORPHAN_NOMENU" ] && return 0
[ -n "$ORPHAN_SHOWN" ] && return 0
export ORPHAN_SHOWN=1
_orphan_mode=$(cat /etc/orphan/login-mode 2>/dev/null || echo menu)
python3 /usr/local/share/orphan/orphan-splash.py 2>/dev/null
if [ "$_orphan_mode" = menu ]; then
	unset _orphan_mode
	sleep 1.5
	ORPHAN_HOME=1 orphan
	if [ $? -eq 10 ]; then
		exit 0                     # "Log out" picked in the menu
	fi
	printf '\033[38;5;214mOrphan\033[0m: the menu closed unexpectedly, here is a normal shell. Type \033[1morphan\033[0m to retry.\n'
fi
unset _orphan_mode
