# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="Tool to identify Web Application Firewalls protecting a website"
HOMEPAGE="https://github.com/EnableSecurity/wafw00f"
SRC_URI="https://github.com/EnableSecurity/wafw00f/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
IUSE="socks5"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="dev-python/requests[socks5?,${PYTHON_USEDEP}]
	>=dev-python/pluginbase-0.3[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"
