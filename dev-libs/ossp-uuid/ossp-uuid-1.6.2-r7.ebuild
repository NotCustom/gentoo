# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="uuid-${PV}"

GENTOO_DEPEND_ON_PERL="no"

inherit perl-module

DESCRIPTION="An ISO-C:1999 API with CLI for generating DCE, ISO/IEC and RFC compliant UUID"
HOMEPAGE="http://www.ossp.org/pkg/lib/uuid/"
SRC_URI="ftp://ftp.ossp.org/pkg/lib/uuid/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="+cxx perl static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	perl? (
		dev-lang/perl
		test? ( virtual/perl-Test-Simple )
	)"
RDEPEND="perl? ( dev-lang/perl:= )"
BDEPEND="perl? ( dev-lang/perl )"

PATCHES=(
	"${FILESDIR}/${P}-gentoo-r1.patch"
	"${FILESDIR}/${P}-gentoo-perl.patch"
	"${FILESDIR}/${P}-hwaddr.patch"
	"${FILESDIR}/${P}-manfix.patch"
	"${FILESDIR}/${P}-uuid-preserve-m-option-status-in-v-option-handling.patch"
	"${FILESDIR}/${P}-fix-whatis-entries.patch"
	"${FILESDIR}/${P}-fix-data-uuid-from-string.patch"
)

src_configure() {
	# Notes:
	# * collides with e2fstools libs and includes if not moved around
	# * pgsql-bindings need PostgreSQL-sources and are included since PostgreSQL 8.3
	econf \
		--includedir="${EPREFIX}"/usr/include/ossp \
		--with-dce \
		--without-pgsql \
		--without-perl \
		--without-php \
		$(use_with cxx) \
		$(use_enable static-libs static)
}

src_compile() {
	default

	if use perl; then
		cd perl || die
		# configure needs the ossp-uuid.la generated by `make` in $S
		perl-module_src_configure
		perl-module_src_compile
	fi
}

src_test() {
	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${S}/.libs" # required for the perl-bindings to load the (correct) library
	default

	use perl && emake -C perl test
}

src_install() {
	default
	dodoc BINDINGS HISTORY OVERVIEW PORTING SEEALSO USERS

	if use perl ; then
		cd perl || die
		perl-module_src_install
	fi

	find "${ED}" -name '*.la' -delete || die

	mv "${ED}"/usr/$(get_libdir)/pkgconfig/{,ossp-}uuid.pc || die
	mv "${ED}"/usr/share/man/man3/uuid.3{,ossp} || die
	if use cxx; then
		mv "${ED}"/usr/share/man/man3/uuid++.3{,ossp} || die
	fi
}
