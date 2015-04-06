setenv LANG    en_US.UTF-8
umask 22

set path = (/sbin /bin \
            /usr/sbin /usr/bin \
            /usr/local/sbin /usr/local/bin)

set symlinks = expand
limit coredumpsize 0

alias rm	rm -i
alias cp	cp -i
alias mv	mv -i

alias h		history 25
alias j		jobs -l

alias ls	ls -FG
alias la	ls -alh
alias ll	ls -lh

alias grep	grep --color=auto
alias view	vim -R

if ($?prompt) then
	#set prompt = "%n@%m %c04 %# "
	set user_color = 36 # cyan
	if (`whoami` == root) set user_color = 31 # red
	set prompt = "%{\e[${user_color}m%}`whoami`%{\e[00m%}@%m %c04 %# "
	set promptchars = "%#"
	set ellipsis

	set histdup = erase
	set history = 1000
	set savehist = (1000 merge)

	set filec
	set autolist = ambiguous
	set color
	set autocorrect
	set complete = enhance

	set autoexpand
	set autorehash

	if ( $?tcsh ) then
		bindkey "^W" backward-delete-word
		bindkey -k up history-search-backward
		bindkey -k down history-search-forward
	endif

	bindkey ^r i-search-back
	bindkey "\e[3~" delete-char

	set nobeep
endif

if (-r $home/.cshrc.local) source $home/.cshrc.local
