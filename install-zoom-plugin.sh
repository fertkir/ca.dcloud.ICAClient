#!/bin/bash

mkdir -p /tmp/zoomplugin
wget -O /tmp/zoomplugin/zoomplugin.deb https://zoom.us/download/vdi/5.14.0.23370/zoomcitrixplugin-ubuntu_5.14.0.deb

cd /tmp/zoomplugin/
ar -x zoomplugin.deb
tar -xf data.tar.xz
tar -xf control.tar.xz

mkdir -p /app/etc/
mv etc/* /app/etc/

mv opt/Citrix/ICAClient/* /app/ICAClient/linuxx64/

mkdir -p /app/usr/lib/
mv usr/lib/* /app/usr/lib/

mkdir -p /app/usr/share/doc/
mv usr/share/doc/* /app/usr/share/doc/

sed -i 's/CONFIG_LINK_FILE=.*$/CONFIG_LINK_FILE=\/app\/ICAClient\/linuxx64\/config\/module.ini/' postinst
. postinst
