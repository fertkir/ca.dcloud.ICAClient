# ca.dcloud.ICAClient
Build and install the Citrix Workspace app + HDX RealTime Media Engine Skype as a Flatpak application

#Disclaimer
This project and myself are not affiliated with Citrix. This project does not contain or distribute any Citrix software. When the flatpak is built, it iniates downloads from Citrix's site packages that they have made freely available.

#Requirements
flatpak, flatpak-builder, elfutils, pulseaudio
You should be able to install all of these through your distro's package manager.

#Instructions
Clone/download this repo. Citrix seems to generate a unique download URL everytime you try to download the Workspace and HDX pacakges, so you'll have to go to the site and get you own unique URL.
https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html
Under Tarball packages, click on Download File button for x86_64. When your browser prompts you to download, click cancel (if it's set to automatically download you can just delete/cancel the download in progress), you have to do this to make the actual download link available. Now right-click on the Download File button and copy the link. You'll have to past the link into ca.dcloud.ICAClient.yml file that you downloaded as part of this repo. Open that file with a text editor and file the code block that starts with "name: icaclient", several lines down you'll see "url:", paste the link you copied there. Right beneath that is "sha256:". On the Citrix page, right under the Download File button is Checksums, copy the checksum starting after "SHA-256-" and paste it into the .yml file after "sha256:".

Repeat the same process for the HDX RTME, in the .yml file it is the code block that starts with "name: HDXEngine".
https://www.citrix.com/downloads/workspace-app/additional-client-software/hdx-realtime-media-engine-29400.html

Open a terminal in the folder where you downloaded this repo, and run the following:
flatpak-builder --user --install --force-clean icaclient ca.dcloud.ICAClient.yml

It will take some time to download and build. Once it is finished, launch the application by running^1:
flatpak run ca.dcloud.ICAClient && flatpak kill ca.dcloud.ICAClient
The first time you start the flatpak it will run some install scripts before launching Workspace.



1 The reasong for the "flatpak kill" part is that launching Workspace starts a few background processes, which aren't stoppted simply by closing the Workspace app/exiting the flatpak. If you don't kill the flatpak (thereby killing those processes), if you try to launch it again Workspace will hang while loading. If you do get into a situation where it hangs, you can solve this be deleting ~/.var/app/ca.dcloud.ICAClient/.ICAClient. I hope to fix this and make things a little more elegant in the future.
