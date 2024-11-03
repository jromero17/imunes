#!/bin/sh

. scripts/prepare_vroot_functions.sh

PACKAGES_MINIMAL="$PACKAGES_MINIMAL bind918 bind-tools dnsmasq"
PACKAGES="$PACKAGES_MINIMAL $PACKAGES_COMMON isc-dhcp44-server isc-dhcp44-client isc-dhcp44-relay \
    sylpheed apache24 apr db18 jansson nginx netsurf midori wireshark gnome-themes-extra sakura vte3 \
    fping dsniff gdk-pixbuf2 gsfonts xpdf openvpn easy-rsa net-snmp"
    #php84 php84-mysqli php84-curl 
    #php84-gd php84-intl php84-mbstring php84-xml php84-zip php84-composer php84-extensions php84-zlib"
PACKAGES=`echo $PACKAGES | sed 's/scapy/py311-scapy/'`
PACKAGES=`echo $PACKAGES | sed 's/quagga/quagga/'`

checkArgs $*

# Start installation
mkdir -p $WORKDIR
cd $WORKDIR
echo -n "" > $LOG

if [ $mini -eq 1 ]; then
    PKGS=${PACKAGES_MINIMAL}
else
    PKGS=${PACKAGES}
fi

if [ $offline -eq 0 ]; then
    fetchBaseOnline
fi

prepareUnionfs
populateFs

preparePackagesPkg
chroot $VROOT_MASTER /bin/sh -c 'env ASSUME_ALWAYS_YES=YES pkg bootstrap' >> $LOG 2>&1
checkPkgVersion
installPackagesPkg

if [ $mini -eq 0 ]; then
    log "OUT" "Installing additional tools..."
    sh $IMUNESDIR/scripts/install_usr_tools.sh >> $LOG 2>&1
    log "OUT" "Installing additional tools done."
fi

mkdir $VROOT_MASTER/usr/local/etc/snmp
mkdir $VROOT_MASTER/usr/local/etc/openvpn

configQuagga

configFrr

wiresharkGUIfix

configApache24

cleanUnnecessary

log "OUT" "Installation successfully finished. Check the log for more \
information: $LOG"
