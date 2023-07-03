#!/bin/bash

wget -O /tmp/linuxx64.tar.gz $(wget -O - https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html | sed -ne '/linuxx64.*tar.gz/ s/<a .* rel="\(.*\)" id="downloadcomponent">/https:\1/p' | sed -e 's/\r//g')
mkdir -p /tmp/icaclient
tar -zxf /tmp/linuxx64.tar.gz --directory=/tmp/icaclient
mkdir -p /app/share/icons/hicolor/64x64/apps
cp /tmp/icaclient/linuxx64/linuxx64.cor/icons/000_Receiver_64.png /app/share/icons/hicolor/64x64/apps/ca.dcloud.ICAClient.png
mkdir -p /app/share/icons/hicolor/256x256/apps
cp /tmp/icaclient/linuxx64/linuxx64.cor/icons/receiver.png /app/share/icons/hicolor/256x256/apps/ca.dcloud.ICAClient.png

#Set the default install directory in the Workspace install script
sed -ie 's/DefaultInstallDir=.*$/DefaultInstallDir=\/app\/ICAClient\/linuxx64/' /tmp/icaclient/linuxx64/hinst
#The installation options selected below answer yes to using the gstreamer pluging from ICAClient. The "app protection component" and USB support
#require the installer to be run as root, so they cannot be installed in this case.
echo -e "1\n\ny\ny\n3\n" | /tmp/icaclient/setupwfc

ln -s /etc/ssl/certs/*.pem /app/ICAClient/linuxx64/keystore/cacerts/
/app/ICAClient/linuxx64/util/ctx_rehash /app/ICAClient/linuxx64/keystore/cacerts/
