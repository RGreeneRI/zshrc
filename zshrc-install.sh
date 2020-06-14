#!/usr/bin/env bash

# Variables
OS="`uname`"
DOWNLOADER="None"

# Title
cat <<'EOF'
 _________  _   _              ___           _        _ _
|__  / ___|| | | |_ __ ___    |_ _|_ __  ___| |_ __ _| | | ___ _ __
  / /\___ \| |_| | '__/ __|____| || '_ \/ __| __/ _` | | |/ _ \ '__|
 / /_ ___) |  _  | | | (_|_____| || | | \__ \ || (_| | | |  __/ |
/____|____/|_| |_|_|  \___|   |___|_| |_|___/\__\__,_|_|_|\___|_|

EOF

# Prereq check
echo "Looking for wget"
which wget
if [ "$?" == "0" ]; then
	DOWNLOADER="wget";
	echo "Found it!"
else
echo "Looking for curl"
which curl
	if [ "$?" == "0" ]; then
		DOWNLOADER="curl";
		echo "Found it!"
	else
	echo "Looking for fetch"
	which fetch
	        if [ "$?" == "0" ]; then
        	        DOWNLOADER="fetch";
			echo "Found it!"
		fi
	fi
fi

if [ "$DOWNLOADER" == "None" ]; then
	echo "You do not have wget, curl, or fetch.  You need one of these to use this script.";
	exit 1;
fi

echo "********************************************************************************"
echo "******   This script will install a customized .zshrc file and backup     ******"
echo "******   any existing one to zshrc.bak.                                   ******"
echo "********************************************************************************"
echo ""
echo ""

# Prompt user to press enter or not
read -r -p "Press ENTER to continue, or Control-C to abort..." key

# Download customized zshrc from grml and customize 
cd
if [ -f ".zshrc" ]; then
	echo "Backing up existing .zshrc file to zshrc.bak";
	cp .zshrc zshrc.bak;
fi

echo "Downloading GRML's zshrc config as a starting point."
if [ "$DOWNLOADER" == "curl" ]; then
	curl -L -o .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc;
elif [ "$DOWNLOADER" == "wget" ]; then
	wget -O .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc;
else
	fetch https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc -o .zshrc --no-verify-peer;
fi

# Check if screenfetch is installed, and add to .zshrc if so
echo "Checking if screenfetch is installed";
which screenfetch
if [ "$?" == "0" ]; then
	echo "screenfetch is installed, adding to .zshrc";
	echo "screenfetch" >> .zshrc;
else
	echo "screenfetch is not installed.";
fi

# Customize ll command
echo "Adding my customizations to the .zshrc file.";
if [ "$OS" == "Darwin" ] || [ "$OS" == "FreeBSD" ]; then
	sed -i.sed "s/alias ll='command ls -l/alias ll='command ls -lahFG/" .zshrc;
	sed -i.sed 's/alias ll="command ls -l/alias ll="command ls -lahFG/' .zshrc;
	rm .zshrc.sed;
else
	sed -i "s/alias ll='command ls -l/alias ll='command ls -lahF/" .zshrc;
	sed -i 's/alias ll="command ls -l/alias ll="command ls -lahF/' .zshrc;
fi

echo ".zshrc file creation is complete";

# See if zsh is installed
echo "Checking if zsh is installed";
which zsh
if [ "$?" == "0" ]; then
	ZSH_LOC="`which zsh`";
	echo "********************************************************************************";
	echo "zsh is installed, use the following commands to locate it and set it as your";
	echo "default login shell:";
	echo "cat /etc/shells  (to find it's location)";
	echo "chsh -s /path/to/zsh  (to set it as your shell)";
	echo "********************************************************************************";
else 
	echo "********************************************************************************";
	echo "zsh is not installed! Install it, then use the following commands to find it,";
	echo "and set it as your default login shell:";
	echo "cat /etc/shells  (to find it's location)";
	echo "chsh -s /path/to/zsh  (to set it as your shell)";
	echo "********************************************************************************";
fi
