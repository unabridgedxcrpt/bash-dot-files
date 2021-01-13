#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Sections:
#  1.   Environment Configuration
#  2.   Make Terminal Better (remapping defaults and adding functionality)
#  3.   File and Folder Management
#  4.   Searching
#  5.   Process Management
#  6.   Networking
#  7.   System Operations & Information
#  8.   Web Development
#  9.   Reminders & Notes
#  10.  Shortcuts and aliases
#  11.  Utility Functions
#
#  ---------------------------------------------------------------------------

#   -------------------------------
#   1.  ENVIRONMENT CONFIGURATION
#   -------------------------------

#   Change Prompt
#   ------------------------------------------------------------
    export PS1="________________________________________________________________________________\n| \w @ \h (\u) \n| => "
    export PS2="| => "

#   Set Paths
#   ------------------------------------------------------------
    export PATH="$PATH:/usr/local/bin"
    export PATH="/usr/local/git/bin:/sw/bin:/usr/local/bin:/usr/local:/usr/local/sbin:/usr/local/mysql/bin:$PATH"
    export PATH="/usr/local/opt/python@3.8/bin:$PATH"


#   Set Default Editor (change 'Nano' to the editor of your choice)
#   ------------------------------------------------------------
    export EDITOR=/usr/bin/nano

#   Set default blocksize for ls, df, du
#   from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
#   ------------------------------------------------------------
    export BLOCKSIZE=1k

#   Add color to terminal
#   (this is all commented out as I use Mac Terminal Profiles)
#   from http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
#   ------------------------------------------------------------
#   export CLICOLOR=1
#   export LSCOLORS=ExFxBxDxCxegedabagacad

#  add bash-completion
#   from http://blog.jeffterrace.com/2012/09/bash-completion-for-mac-os-x.html
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
    fi

#   -----------------------------
#   2.  MAKE TERMINAL BETTER
#   -----------------------------

alias cp='cp -iv'                           # Preferred 'cp' implementation
cpb() { cp "$1"{,.$(date -r "$1" "+%Y%m%d")}; }
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
alias lt='echo "------Newest--" && ls -At1 && echo "------Oldest--"'
alias ltr='echo "------Oldest--" && ls -Art1 && echo "------Newest--"'
alias less='less -FSRXc'                    # Preferred 'less' implementation
cd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias edit='bbedit'                         # edit:         Opens any file in bbedit editor
alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias o.='open .'							# Opens current directory in the MacOS Finder.
alias ~="cd ~"                              # ~:            Go Home
alias c='clear'                             # c:            Clear terminal display
alias which='type -all'                     # which:        Find executables
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop
#alias youtube-dl='youtube-dl --write-thumbnail'  # Preferred 'youtube-dl' implementation
alias audiotube='youtube-dl -x --embed-thumbnail --audio-format mp3 --audio-quality 0'	# Preferred 'youtube-dl' implementation to download audio/music
alias t='todo.sh -d /Users/jbird03/.todo.cfg'			# Todo CLI from todotxt.org
alias python='python3.8'					# I rarely run the older python2.7 and mapping to the Brew controlled VERSION

#   lr:  Full Recursive Directory Listing
#   ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

#   mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#           displays paginated result with colored search terms and two lines surrounding each hit.             Example: mans mplayer codec
#   --------------------------------------------------------------------
    mans () {
        man $1 | grep -iC2 --color=always $2 | less
    }

#   showa: to remind yourself of an alias (given some part of it)
#   ------------------------------------------------------------
    showa () { /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; }


#   -------------------------------
#   3.  FILE AND FOLDER MANAGEMENT
#   -------------------------------

zipf () { zip -r "$1".zip "$1" ; }          # zipf:         To create a ZIP archive of a folder
alias numFiles='echo $(ls -1 | wc -l)'      # numFiles:     Count of non-hidden files in current dir
alias make1mb='mkfile 1m ./1MB.dat'         # make1mb:      Creates a file of 1mb size (all zeros)
alias make5mb='mkfile 5m ./5MB.dat'         # make5mb:      Creates a file of 5mb size (all zeros)
alias make10mb='mkfile 10m ./10MB.dat'      # make10mb:     Creates a file of 10mb size (all zeros)

#   cdf:  'Cd's to frontmost window of MacOS Finder
#   ------------------------------------------------------
    cdf () {
        currFolderPath=$( /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
EOT
        )
        echo "cd to \"$currFolderPath\""
        cd "$currFolderPath"
    }

#   ------------------------------------------------------
extract () { #unarchive various compression formats based on extension
        if [ -f $1 ] ; then
                case $1 in
                        *.tar.bz2)          tar xjf $1       ;;
                        *.tar.gz)           tar xzf $1       ;;
                        *.bz2)              bunzip2 $1       ;;
                        *.rar)              rar x $1         ;;
                        *.gz)               gunzip $1        ;;
                        *.tar)              tar xf $1        ;;
                        *.tbz2)             tar xjf $1       ;;
                        *.tgz)              tar xzf $1       ;;
                        *.zip)              unzip $1         ;;
                        *.Z)                uncompress $1    ;;
                        *.7z)        7z x $1        ;;
                        *.dmg)              hdiutil mount $1 ;;
                        *)                  echo "'$1' cannot be extracted via extract()" ;;
                esac
        else
                echo "'$1' is not a valid file"
        fi
}


#   ---------------------------
#   4.  SEARCHING
#   ---------------------------

alias qfind="find . -name "                 # qfind:    Quickly search for file name
ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

#   spotlight: Search for a file using MacOS Spotlight's metadata
#   -----------------------------------------------------------
    spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }


#   ---------------------------
#   5.  PROCESS MANAGEMENT
#   ---------------------------

#   findPid: find out the pid of a specified process
#   -----------------------------------------------------
#       Note that the command name can be specified via a regex
#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#       Without the 'sudo' it will only find processes of the current user
#   -----------------------------------------------------
    findPid () { lsof -t -c "$@" ; }

#   memHogsTop, memHogsPs:  Find memory hogs
#   -----------------------------------------------------
    alias memHogsTop='top -l 1 -o rsize | head -20'
    alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#   cpuHogs:  Find CPU hogs
#   -----------------------------------------------------
    alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#   topForever:  Continual 'top' listing (every 10 seconds)
#   -----------------------------------------------------
    alias topForever='top -l 9999999 -s 10 -o cpu'

#   ttop:  Recommended 'top' invocation to minimize resources
#   ------------------------------------------------------------
#       Taken from this macosxhints article
#       http://www.macosxhints.com/article.php?story=20060816123853639
#   ------------------------------------------------------------
    alias ttop="top -R -F -s 10 -o rsize"

#   my_ps: List processes owned by my user:
#   ------------------------------------------------------------
    my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }


#   ---------------------------
#   6.  NETWORKING
#   ---------------------------

#alias myip='curl ip.appspot.com'                    # myip:         Public facing IP Address
alias myip='curl https://api.ipify.org'		# other host above is regularly "over quota"
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
#alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
#alias flush='sudo discoveryutil mdnsflushcache; sudo discoveryutil udnsflushcaches' #updated 21JAN2015 
                                            #reference: https://twitter.com/ttscoff/status/555884498429030400
#alias flush='sudo killall -HUP mDNSResponder' #updated 6SEP2015 as per https://support.apple.com/en-ca/HT202516
#alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"
alias flush='sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;say flushed' #per:http://blog.chlaird.com/2016/06/macos-1012-sierra-flush-dns.html
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
    ii() {
        echo -e "\nYou are logged on ${RED}$HOST"
        echo -e "\nAdditionnal information:$NC " ; uname -a
        echo -e "\n${RED}Users logged on:$NC " ; w -h
        echo -e "\n${RED}Current date :$NC " ; date
        echo -e "\n${RED}Machine stats :$NC " ; uptime
        echo -e "\n${RED}Current network location :$NC " ; scselect
        echo -e "\n${RED}Public facing IP Address :$NC " ;myip
        #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
        echo
    }


#   ---------------------------------------
#   7.  SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------

	alias mountReadWrite='/sbin/mount -uw /'    # mountReadWrite:   For use when booted into single-user

#   cleanupDS:  Recursively delete .DS_Store files
#   -------------------------------------------------------------------
    alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

#   finderShowHidden:   Show hidden files in Finder
#   finderHideHidden:   Hide hidden files in Finder
#   -------------------------------------------------------------------
    alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
    alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

#   cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
#   -----------------------------------------------------------------------------------
    alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

#    screensaverDesktop: Run a screensaver on the Desktop
#   -----------------------------------------------------------------------------------
    alias screensaverDesktop='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'
    alias stfu="osascript -e 'set volume output muted true'"
    alias rsync="rsync -avz"

#   ---------------------------------------
#   8.  WEB DEVELOPMENT
#   ---------------------------------------

alias apacheEdit='sudo edit /etc/httpd/httpd.conf'      # apacheEdit:       Edit httpd.conf
alias apacheRestart='sudo apachectl graceful'           # apacheRestart:    Restart Apache
alias editHosts='sudo edit /etc/hosts'                  # editHosts:        Edit /etc/hosts file
alias herr='tail /var/log/httpd/error_log'              # herr:             Tails HTTP error logs
alias apacheLogs="less +F /var/log/apache2/error_log"   # Apachelogs:   Shows apache error logs
httpHeaders () { /usr/bin/curl -I -L $@ ; }             # httpHeaders:      Grabs headers from web page

#   httpDebug:  Download a web page and show info on what took time
#   -------------------------------------------------------------------
    httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }

####################
#   ---------------------------------------
#   9.  REMINDERS & NOTES
#   ---------------------------------------

#   remove_disk: spin down unneeded disk
#   ---------------------------------------
#   diskutil eject /dev/disk1s3

#   to change the password on an encrypted disk image:
#   ---------------------------------------
#   hdiutil chpass /path/to/the/diskimage

#   to mount a read-only disk image as read-write:
#   ---------------------------------------
#   hdiutil attach example.dmg -shadow /tmp/example.shadow -noverify

#   mounting a removable drive (of type msdos or hfs)
#   ---------------------------------------
#   mkdir /Volumes/Foo
#   ls /dev/disk*   to find out the device to use in the mount command)
#   mount -t msdos /dev/disk1s1 /Volumes/Foo
#   mount -t hfs /dev/disk1s1 /Volumes/Foo

#   to create a file of a given size: /usr/sbin/mkfile or /usr/bin/hdiutil
#   ---------------------------------------
#   e.g.: mkfile 10m 10MB.dat
#   e.g.: hdiutil create -size 10m 10MB.dmg
#   the above create files that are almost all zeros - if random bytes are desired
#   then use: ~/Dev/Perl/randBytes 1048576 > 10MB.dat


####################
#   ---------------------------------------
#   10.  Shortcuts and aliases
#   ---------------------------------------

#   Sounds
alias waves='play -n synth brownnoise synth pinknoise mix synth 0 0 0 10 10 40 trapezium amod 0.1 30'	# soothing background "white"-wave noise
alias wn='play -n synth 00:00:05 whitenoise'

####################
#   ---------------------------------------
#  11.  Utility Functions
#   ---------------------------------------

h() {

	_usage() {
		echo "usage: YOUR_COMMAND | h [-idn] args...
	-i : ignore case
	-d : disable regexp
	-n : invert colors"
	}

	local _OPTS

	# detect pipe or tty
	if test -t 0; then
		_usage
		return
	fi

	# manage flags
	while getopts ":idnQ" opt; do
		case $opt in
			i) _OPTS+=" -i " ;;
			d)  _OPTS+=" -Q " ;;
			n) n_flag=true ;;
			Q)  _OPTS+=" -Q " ;;
				# let's keep hidden compatibility with -Q for original ack users
			\?) _usage
				return ;;
		esac
	done

	shift $(($OPTIND - 1))

	# check maximum allowed input
	if (( ${#@} > 12)); then
		echo "Too many terms. h supports a maximum of 12 groups. Consider relying on regular expression supported patterns like \"word1\\|word2\""
		exit -1
	fi;

	# set zsh compatibility
	[[ -n $ZSH_VERSION ]] && setopt localoptions && setopt ksharrays && setopt ignorebraces

	local _i=0

	if [ -z $n_flag ]; then
		#inverted-colors-last scheme
		_COLORS=( "underline bold red" "underline bold green" "underline bold yellow" "underline bold blue" "underline bold magenta" "underline bold cyan" "bold on_red" "bold on_green" "bold black on_yellow" "bold on_blue" "bold on_cyan" "bold on_magenta" )
	else
		#inverted-colors-first scheme
		_COLORS=( "bold on_red" "bold on_green" "bold black on_yellow" "bold on_blue" "bold on_magenta" "bold on_cyan" "bold black on_white" "underline bold red" "underline bold green" "underline bold yellow" "underline bold blue" "underline bold magenta" )
	fi

	local ACK=ack
	if ! which $ACK >/dev/null 2>&1; then
		ACK=ack-grep
		if ! which $ACK >/dev/null 2>&1; then
			echo "Could not find ack or ack-grep"
			exit -1
		fi
	fi

	# build the filtering command
	for keyword in "$@"
	do
		local _COMMAND=$_COMMAND"$ACK $_OPTS --noenv --flush --passthru --color --color-match=\"${_COLORS[$_i]}\" '$keyword' |"
		_i=$_i+1
	done
	#trim ending pipe
	_COMMAND=${_COMMAND%?}
	#echo "$_COMMAND"
	cat - | eval $_COMMAND
}



urlenc () { #url encode the passed string
  echo -n "$1" | perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'
}

# Just an experiment, but I really like it
# reads input from STDIN and keeps a running tally of numbers
function tally() {
  if [[ $# == 0 ]]; then
    echo "Enter numbers, press = for sum:"
    read -d "="
    input=$REPLY
    echo
    echo "================"
  else
    input="$@"
  fi
  sum=0
  for i in $input; do
    sum=$sum+$i
  done
  echo $sum|bc -l
}

function webtext() {
  curl -s "$1"|php -r "echo trim(html_entity_decode(preg_replace('/([\n\s])+/misx',' ',strip_tags(preg_replace('/<script.*?\/script>/misx','',file_get_contents('php://stdin')))),ENT_QUOTES));"
}

function randseed1() {
	od -vAn -N4 -tx4 < /dev/urandom | tr -d [[:space:]]
}

function randseed2() {
	cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9@#$%!?*&' | fold -w 32 | head -n 1
}

function randseed3() {
	date | md5
}

function randseed4() { 
	curl "https://www.random.org/strings/?num=1&len=20&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new"
}

function gapg() {
	apg -a 1 -c randseed2 -n 10 -m 20 -M SNCL
}

capitalize_remove_punctuation()
{
  local words IFS=$' \t\n-\'.,;!:*?' #Handle hyphenated names and punctuation
  read -ra words <<< "${@,,}"
  IFS=''
  echo "${words[*]^}"
}

alias xkcd2='xkcdpass --count=5 --acrostic="entropy" --delimiter="-" --min=3 --max=5 --case capitalize'

xkcd() {
str=`gshuf /usr/share/dict/words  | grep "^[^']\{4,8\}$" | head -n6`
#str=`gshuf ~/bin/xkcd-words.txt | head -n6`

res=""
split=`echo $str | sed -e 's/\s\+/\n/g'` # Split with space as delimiter (any whitespace)

for word in $split; do
	delimit=`gshuf -i1-9 -n1` # delimit the words with a random # between 1-9
    word=${word,,} # Lowercase
    word=${word^} # Uppercase first letter
    res=$res$word$delimit # Concatenate result
done

echo $res
}

lcase() {
  if [[ $# == 0 ]]; then
    echo "Err"
    echo "==="
  else
    input="$@"
   	echo "${input,,}" #BASH v4 method to convert to lowercase
  fi
	input="";
}

#title case of argument string
tcase() { set ${*,,} ; set ${*^} ; echo -n "$1 " ; shift 1 ; \
        for f in ${*} ; do \
            case $f in  A|The|Is|Of|And|Or|But|About) echo -n "${f,,} " ;; \
                                                   *) echo -n "$f " ;; \
            esac ; \
        done ; echo ; 
}


#    uuid: generate a lowercase uuid
#   -----------------------------------------------------------------------------------
# 		Could use "lcase $(uuidgen)" using the above lcase function, but typing uuid is simpler to type :)
uuid() { 
	input=$(uuidgen)
    	echo "${input,,}" #BASH v4 method to convert to lowercase
	input="";
}

#https://github.com/caskroom/homebrew-cask/issues/13256
brew-cask-upgrade() {
  if [ "$1" != '--quick' ]; then
    echo "Removing brew cache"
    rm -rf "$(brew --cache)"
    echo "Running brew update"
    brew update
  fi
  for c in $(brew cask list); do
    echo -e "\n\nInstalled versions of $c: "
    ls /opt/homebrew-cask/Caskroom/$c
    echo "Cask info for $c"
    brew cask info $c
    select ynx in "Yes" "No" "Exit"; do
      case $ynx in
        "Yes") echo "Uninstalling $c"; brew cask uninstall --force "$c"; echo "Re-installing $c"; brew cask install "$c"; break;;
        "No") echo "Skipping $c"; break;;
        "Exit") echo "Exiting brew-cask-upgrade"; return;;
      esac
    done
  done
}

#from http://www.kossboss.com/linux---bytes-to-human-readable-command
b2h()
{
    # By: Simon Sweetwater
    # Spotted Script @: http://www.linuxjournal.com/article/9293?page=0,1 
    # Convert input parameter (number of bytes) 
    # to Human Readable form
    #
    SLIST="bytes,KB,MB,GB,TB,PB,EB,ZB,YB"

    POWER=1
    VAL=$( echo "scale=2; $1 / 1" | bc)
    VINT=$( echo $VAL / 1024 | bc )
    while [ ! $VINT = "0" ]
    do
        let POWER=POWER+1
        VAL=$( echo "scale=2; $VAL / 1024" | bc)
        VINT=$( echo $VAL / 1024 | bc )
    done

    echo $VAL$( echo $SLIST | cut -f$POWER -d, )
}

#encode images base64 for inclusion in html web pages
img64() {
  if [[ $# == 0 ]]; then
    echo "Err"
    echo "==="
  else
	echo '<img src="data:image/png;base64,'$(cat $1 | base64)'">'
  fi
	input="";
}

static() {
	while true; do 
		printf "$(awk -v c="$(tput cols)" -v s="$RANDOM" 'BEGIN{srand(s);
		while(--c>=0){printf("\xe2\x96\\%s",sprintf("%o",150+int(10*rand())));}}')";
	done
}

#Bash function that saves bash functions to file from shell session  
#https://www.commandlinefu.com/commands/view/24621/bash-function-that-saves-bash-functions-to-file-from-shell-session
save_function ()
{
    while [[ $# > 0 ]]; do
        {
            date +"# %F.%T $1";
            declare -f "$1"
        } | tee -a ~/.bash_functions;
        shift;
    done
}

list_functions () {
	declare -F | cut -d ' ' -f 3
	}
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/Users/jbird03/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/Users/jbird03/opt/anaconda3/etc/profile.d/conda.sh" ]; then
#         . "/Users/jbird03/opt/anaconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/Users/jbird03/opt/anaconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

