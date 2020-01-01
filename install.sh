#!/bin/bash

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
	fi
fi

if [ "$DOWNLOADER" == "None" ]; then
	echo "You do not have wget or curl.  You need one of these to use this script.";
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
else
	wget -O .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc;
fi

# Check if screenfetch is installed, and add to .zshrc if so
echo "Checking if screenfetch is installed";
which screenfetch
if [ "$?" == "0" ]; then
	echo "screenfetch is installed, adding to .zshrc";
	echo "screenfetch" >> .zshrc;
fi

# Customize ll command
if [ "$OS" == "Darwin" ]; then
	sed -i.sed "s/alias ll='command ls -l/alias ll='command ls -lahFG/" .zshrc;
	sed -i.sed 's/alias ll="command ls -l/alias ll="command ls -lahFG/' .zshrc;
	rm .zshrc.sed;
else
	sed -i "s/alias ll='command ls -l/alias ll='command ls -lahF/" .zshrc;
	sed -i 's/alias ll="command ls -l/alias ll="command ls -lahF/' .zshrc;
fi

# See if zsh is installed, and set as login shell if true
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
echo "******                                                                    ******"
echo "********************************************************************************"
echo "********************************************************************************"
echo ""
echo ""
