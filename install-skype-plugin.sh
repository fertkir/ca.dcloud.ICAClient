#!/bin/bash

tempURL=$(wget -O - https://www.citrix.com/downloads/workspace-app/additional-client-software/hdx-realtime-media-engine.html | grep -m 1 -e 'rel="https.*hdx-realtime-media-engine-.*html"' | sed -ne 's/<a .* rel="\(.*\)" id="downloadcomponent.*">/\1/p')
wget -O /tmp/hdx.zip $(wget -O - $tempURL | sed -ne '/HDX.*zip/ s/<a .* rel="\(.*\)" id="downloadcomponent_3">/https:\1/p' | sed -e 's/\r//g')

unzip /tmp/hdx.zip -d /tmp/HDX-RTME
cp -r /tmp/HDX-RTME/HDX*/* /tmp/icaclient
cd /tmp/icaclient/x86_64
ar -x citrix-hdx-realtime-media-engine_*_amd64.deb
tar -xf data.tar.xz

#HDX RTME requires some directories for storing settings, log, and version info. These directories aren't persistant
#so they get recreated everytime the Flatpak is run. I haven't observed any negative effects from settings being wiped every time the app closes.
mkdir -p /var/lib/RTMediaEngineSRV
chmod a+rw -v /var/lib/RTMediaEngineSRV
mkdir -p /var/log/RTMediaEngineSRV
chmod a+rw -v /var/log/RTMediaEngineSRV
mkdir -p /var/lib/Citrix/HDXRMEP
chmod a+rw -v /var/lib/Citrix/HDXRMEP

#Install HDX RTME.
cd /app/ICAClient/linuxx64
mkdir rtme
cp /tmp/icaclient/x86_64/usr/local/bin/HDXRTME.so .
chmod +x HDXRTME.so
cp /tmp/icaclient/x86_64/usr/local/bin/* rtme
MODULE_INI=config/module.iniflatpak
if [ -L "$MODULE_INI" ] ; then
    MODULE_INI=$(readlink -f "$MODULE_INI")
fi
cp $MODULE_INI .
chmod a+rw -v module.ini
rtme/RTMEconfig -install -ignoremm
if [ -s "./new_module.ini" ] ; then
    rm -rf "$MODULE_INI"
    cp ./new_module.ini "$MODULE_INI"
    chmod a+rw -v "$MODULE_INI"
fi
rm -rf ./module.ini
rm -rf ./new_module.ini
