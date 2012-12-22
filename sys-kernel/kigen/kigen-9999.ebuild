# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git-2
inherit eutils

EGIT_REPO_URI="git://github.com/r1k0/kigen.git"
SRC_URI=""

DESCRIPTION="a kernel|initramfs generator for Portage"
HOMEPAGE="http://github.com/r1k0/kigen"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64" # ~ppc ~ppc64"
IUSE="doc module-rebuild" # ibm"

DEPEND=">=dev-lang/python-3 
		sys-apps/coreutils 
		app-arch/cpio 
		dev-libs/openssl
		module-rebuild? ( sys-kernel/module-rebuild )"

src_install() {
	cd ${S} || die "cannot cd ${S}"

	# python modules
	insinto /usr/lib/`eselect python show --python3`/site-packages/kigen  || die "cannot insinto site-package"


	# we chose kigen as the name rep for compatibility with python import kigen.*
	# when the sotfware is installed
	# this way kigen works when installed in site-package/kigen AND when cloned from git
	doins -r modules 			|| die "cannot doins -r modules"

#	if use ibm
#	then
#		cp arch/ppc64/kernel-2.6-pSeries arch/ppc64/kernel-2.6
#	else
#		cp arch/ppc64/kernel-2.6.g5 arch/ppc64/kernel-2.6
#	fi

	# arch and default
	insinto /usr/share/kigen 	|| die "cannot insinto /usr/share/kigen"
	doins -r arch 				|| die "cannot doins -r arch"
	doins -r defaults 			|| die "cannot doins -r defaults"
	doins -r tools 				|| die "cannot doins -r tools"
	doins -r scripts			|| die "cannot doins -r scripts"

	# config file
	insinto /etc 				|| die "cannot insinto /etc"
	doins -r doc/kigen 			|| die "cannot doins -r doc/kigen"

	# if USE doc is enabled
	if use doc
	then
		# man page
		doman doc/man/kigen.8 	|| die "cannot doman doc/man/kigen.8"
		# README file
		dodoc README.rst TODO 	|| die "cannot dodocREADME.rst TODO"
	fi

	# entry point
	dosbin kigen 				|| die "cananot dosbin kigen"
}

#pkg_preinst() {
#	rm ${ROOT}/usr/lib/`eselect python show --python3`/site-packages/kigen/*.py[co] 
#}

pkg_postinst() {
	ewarn
	ewarn "This is still experimental software, be cautious."
	ewarn
	ewarn "Tell me what works and breaks for you by dropping a comment at"
	ewarn "http://github.com/r1k0/kigen"
	ewarn
}
