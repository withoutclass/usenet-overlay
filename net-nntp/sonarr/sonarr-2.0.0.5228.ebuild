# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user systemd

SRC_URI="http://download.sonarr.tv/v2/master/mono/NzbDrone.master.${PV}.mono.tar.gz"

DESCRIPTION="Sonarr is a Smart PVR for newsgroup and bittorrent users."
HOMEPAGE="http://www.sonarr.tv"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	>=dev-lang/mono-4.4.1.0
	media-video/mediainfo
	dev-db/sqlite"

S=${WORKDIR}/${PN}
MY_PN=NzbDrone
${MY_PN} ${PN}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/sonarr ${PN}
}

src_install() {
	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	keepdir /var/lib/${PN}
	fowners -R ${PN}:${PN} /var/lib/${PN}

	insinto /etc/${PN}
	insopts -m0660 -o ${PN} -g ${PN}

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}


	insinto "/usr/share/"
	doins -r "${S}"

	systemd_dounit "${FILESDIR}/sonarr.service"
	systemd_newunit "${FILESDIR}/sonarr.service" "${PN}@.service"
}
