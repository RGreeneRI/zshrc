#!/bin/bash

clear;

echo "********************************************************************************"
echo "********************************************************************************"
echo "******                                                                    ******"
echo "******   This script will install a customized zshrc file and backup      ******"
echo "******   any existing one to zshrc.bak                                    ******"
echo "******                                                                    ******"
echo "********************************************************************************"
echo "********************************************************************************"
echo ""
echo ""

# prompt user to press enter or not
read -r -p "Press ENTER to continue, or Control-C to abort..." key

#Download customized zshrc from grml and customize 
cd
cp .zshrc zshrc.bak
wget -O .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc;
echo "screenFetch" >> .zshrc;
sed -i "s/alias ll='command ls -l/alias ll='command ls -lahF/" .zshrc;
sed -i 's/alias ll="command ls -l/alias ll="command ls -lahF/' .zshrc;

echo ""
echo ""
echo "********************************************************************************"
echo "********************************************************************************"
echo "******                                                                    ******"
echo "******   Done! Don't forget to make sure zsh is installed.                ******"
echo "******   Change your shell by typing chsh -s /bin/zsh                     ******"
echo "******                                                                    ******"
echo "********************************************************************************"
echo "********************************************************************************"
echo ""
echo ""
