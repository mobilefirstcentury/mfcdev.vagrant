#!/usr/bin/env bash

echo "*** installing oh-my-zsh"
su -c "git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh" vagrant


echo "*** adding sur5r repository"
sudo sed -i "/http:\/\/debian.sur5r.net\/i3\//d"  /etc/apt/sources.list.d/debian.sur5.net.list
echo "deb http://debian.sur5r.net/i3/ $(lsb_release -c -s) universe" | sudo tee -a /etc/apt/sources.list.d/debian.sur5.net.list


echo "*** apt-get update"
sudo apt-get update

echo "*** install x11"
sudo apt-get -y --allow-unauthenticated install xorg

echo "*** install xclip"
sudo apt-get -y install xclip

echo "*** installing keyring"
sudo apt-get -y --allow-unauthenticated install sur5r-keyring

# We need vim-gtk to have clipboard support
echo "*** reinstalling vim"
apt-get remove vim-nox
apt-get install vim-gtk


echo "*** apt-get update"
sudo apt-get update

echo "*** install i3"
sudo apt-get -y install i3

echo "*** install Conky"
sudo apt-get -y install conky-all

echo "*** installing uxrvt"
sudo apt-get -y install rxvt-unicode


echo "*** installing urxvt perl extensions"
git clone https://github.com/mobilefirstcentury/perl.git /usr/lib/urxvt/perl


echo "*** installing xcompmgr"
sudo apt-get install xcompmgr

echo "*** installing feh"
sudo apt-get install feh

echo "*** installation i3 done"

echo "*** installing autojump"
apt-get install autojump

echo "*** installing tree, tdlr and ack"
apt-get install tree
apt-get install ack-grep
sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep
echo '--pager=less -RFX' >> ~/.ackrc
sudo pip install tldr

echo "*** install trash"
easy_install trash-cli
sudo mkdir --parent /.Trash 
sudo chmod a+rw /.Trash 
sudo chmod +t /.Trash


echo "*** french keyboard"
sudo loadkeys fr
sudo setxkbmap fr
#TODO: remplacer le gist par un dossier github
curl https://gist.githubusercontent.com/rachidbch/2f7b5e83cc91f4f0af14/raw/85a8564db38e7042e187f707667cd2f3b304655f/debconf.dat -o /home/vagrant/debconf.dat.tmp
sudo debconf-set-selections /home/vagrant/debconf.dat.tmp
sudo  DEBIAN_FRONTEND=noninteractive apt-get -y install console-data
# only way found so far to permanently have an AZERTY console login !
# BEWARE:  this is a dirty wor around that's too dependant on the exact os or even exact vagrant box used !
sudo cp /usr/share/keymaps/i386/azerty/fr.kmap.gz /etc/console-setup/cached.kmap.gz 
rm /home/vagrant/debconf.dat.tmp

# install help files from mfc gists
echo "*** installing help files"
sudo rm -rf /home/vagrant/.help
sudo -u vagrant -H git clone https://gist.github.com/rachidbch/a42129727c5d13e54e58 /home/vagrant/.help

echo "*** installing dotfiles"
sudo rm -rf /home/vagrant/dotfiles
sudo -u vagrant -H git clone git://github.com/mobilefirstcentury/dotfiles.git /home/vagrant/dotfiles
sudo -u vagrant -H chmod +x /home/vagrant/dotfiles/.i3/conky/conky-i3bar

pushd /home/vagrant/dotfiles
sudo -u vagrant -H chmod +x ./bootstrap.sh
sudo -u vagrant -H ./bootstrap.sh --no-virtualenv --no-ipython --git-name "rachibch" --git-email rachidbch@gmail.com
sudo -u vagrant -H ./bootstrap.sh --delete-backups
popd


echo "*** installing vim plugins"
vim +PluginInstall +qall

echo "*** installing myscripts"
for script_src in /home/vagrant/dotfiles/myscripts/*; do
  cp "$script_src" /usr/local/bin/
  chmod +x  /usr/local/bin/"$script_src"
done


echo "*** installing fonts"
pushd .	
mkdir -p /usr/local/share/fonts/truetype/myfonts		
cp -r /home/vagrant/dotfiles/fonts/. /usr/local/share/fonts/truetype/
chmod 0555  /usr/local/share/fonts
chmod 0555  /usr/local/share/fonts/truetype
chmod 0444  /usr/local/share/fonts/truetype/*
cd /usr/local/share/fonts
fc-cache
popd 

echo "*** configuring ssh-agent for windows"
((windows)) && {
  eval `ssh-agent -s`
  find -L ~/.ssh/ -maxdepth 1  -type f  -not -name '*.pub' -print0 |xargs -0 -r ssh-add
}

hostname mfcdevdraft
usermod -s /usr/bin/zsh vagrant

