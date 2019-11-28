#!/bin/bash

# Tested on Ubuntu 18.04 and CentOS 7

clear;

echo "********************************************************************************"
echo "********************************************************************************"
echo "******                                                                    ******"
echo "******   This script will install a customized .zshrc file and backup     ******"
echo "******   any existing one to zshrc.bak.  It will set zsh as your login    ******"
echo "******   shell if it is present.                                          ******"
echo "******                                                                    ******"
echo "********************************************************************************"
echo "********************************************************************************"
echo ""
echo ""

# Prompt user to press enter or not
read -r -p "Press ENTER to continue, or Control-C to abort..." key

# Download customized zshrc from grml and customize 
cd
if [ -f ".zshrc" ]; then
    echo "Backing up existing .zshrc file to zshrc.bak"
    cp .zshrc zshrc.bak
fi
wget -O .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc;

# Check if screenfetch is installed, and add to .zshrc if so
echo "********************************************************************************"
echo "Checking if screenfetch is installed";
echo "********************************************************************************"
which screenfetch
if [ "$?" == "0" ]; then echo "screenfetch" >> .zshrc; fi

# Customize ll command
sed -i "s/alias ll='command ls -l/alias ll='command ls -lahF/" .zshrc;
sed -i 's/alias ll="command ls -l/alias ll="command ls -lahF/' .zshrc;

# See if zsh is installed, and set as login shell if true
which zsh
if [ "$?" == "0" ]; then 
    echo "********************************************************************************"
    echo -e "zsh is installed, setting it as your login shell.  \nYou may be prompted for your password";
    echo "********************************************************************************"
    chsh -s /bin/zsh
else 
    echo "********************************************************************************"
    echo -e "zsh is not installed! Install it, then use\n 'chsh -s /bin/zsh'\nto make it your login shell.";
    echo "********************************************************************************"
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
