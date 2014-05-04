prezto-install
==============

A script to install Prezto for all users using zsh on a Gentoo environment (but should work on other GNU/Linux systems).

Original arch package: https://aur.archlinux.org/packages/pr/prezto-git/PKGBUILD

Prerequisites
-------------

* Root
* /etc/zsh/{zlogin,zlogout,zpreztorc,zshenv,zshrc} musn’t exist
* Dependencies:
    * zsh>=4.3.10
    * git
    * coreutils
    * sed

Future
------

Make an ebuild from this script.