#!/usr/bin/env bash

# Variables
OS="`uname`"
DOWNLOADER="None"

# Prereq check
which wget
if [ "$?" == "0" ]; then
	DOWNLOADER="wget";
else
which curl
	if [ "$?" == "0" ]; then
		DOWNLOADER="curl";
	else
	which fetch
	        if [ "$?" == "0" ]; then
        	        DOWNLOADER="fetch";
		fi
	fi
fi

if [ "$DOWNLOADER" == "None" ]; then
	echo "You do not have wget, curl, or fetch.  You need one of these to use this script.";
	exit 1;
fi

clear;
echo "********************************************************************************"
echo "******   This script will install a customized .zshrc file and backup     ******"
echo "******   any existing one to zshrc.bak.  It will set zsh as your login    ******"
echo "******   shell if it is present.                                          ******"
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
	echo "screenfetch is not installed.  You should get it!";
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

# See if zsh is installed, and set as login shell if true
echo "Checking if zsh is installed";
which zsh
if [ "$?" == "0" ]; then
	ZSH_LOC="`which zsh`";
	echo "********************************************************************************";
	echo -e "zsh is installed, setting it as your login shell.  \nYou may be prompted for your password.";
	echo "********************************************************************************";
	chsh -s $ZSH_LOC;
else 
	echo "********************************************************************************";
	echo -e "zsh is not installed! Install it, then use\n 'chsh -s /bin/zsh'\nto make it your login shell.";
	echo "********************************************************************************";
fi

echo ""
echo ""
echo "********************************************************************************"
echo "********************************************************************************"
echo "******                                                                    ******"
echo "******   Done!  See above for any errors.                                 ******"
echo "******   You'll have to logout and back in for changes to take effect.    ******"
echo "******                                                                    ******"
echo "********************************************************************************"
echo "********************************************************************************"
echo ""
echo ""
