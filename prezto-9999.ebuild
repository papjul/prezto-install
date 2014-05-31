# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shell/prezto/prezto-9999.ebuild,v 1.1 2014/05/31 18:04:11 eva Exp $

EAPI="5"

inherit git-2

DESCRIPTION="Configuration framework for zsh; enriches the command line interface environment with sane defaults, aliases, functions, auto completion, and prompt themes"
HOMEPAGE="https://github.com/sorin-ionescu/prezto"

EGIT_REPO_URI="https://github.com/sorin-ionescu/prezto.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-shells/zsh"

src_prepare() {
	# Change ~/.zprezto/ link to use /usr/lib/prezto/ instead
	sed -i 's#\${ZDOTDIR:-\$HOME}/\.zprezto/#/usr/lib/prezto/#g' init.zsh || die

	# Create /etc/zsh in src dir
	mkdir -p etc/zsh || die

	# Change ~/.zprezto/ link to use /usr/lib/prezto/ instead
	sed -i 's#\${ZDOTDIR:-\$HOME}/\.zprezto/#/usr/lib/prezto/#g' init.zsh || die

	# List of files we will add, no zprofile as it is provided by app-shells/zsh already
	backup=('etc/zsh/zlogin' 'etc/zsh/zlogout' 'etc/zsh/zpreztorc' 'etc/zsh/zshenv' 'etc/zsh/zshrc')

	# Add sources
	echo "source /etc/zsh/zpreztorc" > "etc/zsh/zshrc"
	echo "source /usr/lib/prezto/init.zsh" >> "etc/zsh/zshrc"

	for entry in ${backup[@]}; do
		rcfile=$(basename $entry)
		if [ -f runcoms/$rcfile ]; then
			echo "source /usr/lib/prezto/runcoms/$rcfile" >> "$entry"
		fi
	done
}

src_install() {
	# Move documentation to /usr/share/doc/
	dodoc "${WORKDIR}/${PN}-${PV}/*.md"

	# Etc files
	insinto /etc/zsh
	doins "${WORKDIR}/${PN}-${PV}/etc/zsh"

	# Prezto core (in /usr/lib/prezto)
	dolib "${WORKDIR}/${PN}-${PV}/*"
}
