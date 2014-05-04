#!/bin/sh
# A script to install Prezto for all users using zsh on a Gentoo environment
# (but should work on other GNU/Linux systems)
#
# TODO:
# Convert this script to a shorter working .ebuild
# 
# Prerequisites:
# * /etc/zsh/{zlogin|zlogout|zpreztorc|zshenv|zshrc} musn’t exist
# * Root
#
# Original arch package: https://aur.archlinux.org/packages/pr/prezto-git/PKGBUILD
#
# Git repository : https://github.com/sorin-ionescu/prezto.git
#
# Depends on :
# * zsh>=4.3.10
# * git
# * coreutils
# * sed

srcdir='/var/tmp/portage/app-shells/prezto'
_gitname='git'
mkdir -p $srcdir/$_gitname

# Clean up environment first
rm -rf /var/tmp/portage/app-shells/prezto/* # rm -rf $srcdir/* should work too

# Fetch from Git into source dir
git clone --recursive 'https://github.com/sorin-ionescu/prezto.git' $srcdir/$_gitname

# Create /etc/zsh in src dir
mkdir -p $srcdir/etc/zsh

# Change ~/.zprezto/ link to use /usr/lib/prezto/ instead
sed -i 's#\${ZDOTDIR:-\$HOME}/\.zprezto/#/usr/lib/prezto/#g' $srcdir/$_gitname/init.zsh

# List of files we will add, no zprofile as it is provided by app-shells/zsh already
backup=('etc/zsh/zlogin' 'etc/zsh/zlogout' 'etc/zsh/zpreztorc' 'etc/zsh/zshenv' 'etc/zsh/zshrc')

# Add sources
echo "source /etc/zsh/zpreztorc" > "$srcdir/etc/zsh/zshrc"
echo "source /usr/lib/prezto/init.zsh" >> "$srcdir/etc/zsh/zshrc"

for entry in ${backup[@]}; do
  rcfile=$(basename $entry)
  if [ -f $srcdir/$_gitname/runcoms/$rcfile ]; then
    echo $rcfile
    echo "source /usr/lib/prezto/runcoms/$rcfile" >> "$srcdir/etc/zsh/$rcfile"
  fi
done

### INSTALL ###
# Prezto core
mkdir -p /usr/lib/prezto
cp -r $srcdir/$_gitname/* /usr/lib/prezto

# Move documentation to /usr/share/doc/
mkdir -p /usr/share/doc/prezto
mv /usr/lib/prezto/*.md /usr/share/doc/prezto

# Etc files
mkdir -p /etc
cp -r $srcdir/etc/zsh /etc

# Clean up again
rm -rf /var/tmp/portage/app-shells/prezto/* # rm -rf $srcdir/* should work too