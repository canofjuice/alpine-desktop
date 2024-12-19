#!/bin/sh
LOGDATE=$(date +"%Y-%m-%d-%T")
exec > >(tee output-$LOGDATE.log) 2>&1

trap "clear; echo CANCELLED!; exit" SIGINT
if [ $(id -u) -ne 0 ]
then
	echo "This script is expected to be ran as the root user."
	echo "Please switch to the root user to continue."
	exit
fi

while true; do
	echo "Have you created a regular user? ( Y / N )"
	read yn
	case $yn in
		[Yy]* ) break ;;
		[Nn]* ) echo "A regular user is required to proceed with the script."; echo "You must run "setup-user -a" to create a regular user and proceed with the script."; exit ;;
		* ) echo "Have you created a regular user? ( Y / N )";;
	esac
done

echo "Enter the name of the regular user:"
read NORMALUSER

clear
                          
echo "     ####################    "
echo "    ######################   "
echo "   ########   ###  ########         _    _       _              ____            _    _              "
echo "  #######   #   #    #######       / \  | |_ __ (_)_ __   ___  |  _ \  ___  ___| | _| |_ ___  _ __  "
echo " ######   #####   #    ######     / _ \ | | '_ \| | '_ \ / _ \ | | | |/ _ \/ __| |/ / __/ _ \| '_ \ "
echo "  ###      ######   #    ###     / ___ \| | |_) | | | | |  __/ | |_| |  __/\__ \   <| || (_) | |_) |"
echo "   ########################     /_/   \_\_| .__/|_|_| |_|\___| |____/ \___||___/_|\_\\__\___/| .__/ "
echo "    ######################                |_|                                                |_|    "
echo "     ####################    "
echo ""
echo ""
echo "Welcome to the Alpine Desktop script!"
echo "This script will install and configure a desktop environment for your current Alpine Linux installation."
echo "You will also be asked extra questions about installing extra software and other things."
echo ""
echo ""
echo ""
read -p "Press any key to start the script. Otherwise, strike CTRL + C to cancel the operation."
clear ; echo "Installation in progress! Do not terminate the script while running, otherwise the system might be unstable!" && sleep 3s

if [ ! -f /etc/apk/repositories.bak ]
then
	cp /etc/apk/repositories /etc/apk/repositories.bak
fi
rm /etc/apk/repositories
touch /etc/apk/repositories
setup-apkrepos -fc
apk update
apk upgrade
setup-desktop xfce
setup-devd udev
apk add xf86-input-evdev xf86-input-libinput xf86-input-wacom xf86-input-synaptics xf86-input-vmmouse xf86-input-mtrack xf86-video-nouveau xf86-video-nv xf86-video-vesa xf86-video-ark xf86-video-i740 xf86-video-amdgpu xf86-video-ati xf86-video-intel xf86-video-fbdev xf86-video-vmware xf86-video-qxl
apk add intel-ucode amd-ucode
apk add font-terminus font-inconsolata font-dejavu font-noto font-noto-cjk font-awesome font-noto-extra font-cantarell font-vollkorn font-misc-cyrillic font-mutt-misc font-screen-cyrillic font-winitzki-cyrillic font-cronyx-cyrillic font-noto-thai font-noto-tibetan font-ipa font-sony-misc font-jis-misc font-noto-arabic font-noto-armenian font-noto-cherokee font-noto-devanagari font-noto-ethiopic font-noto-georgian font-noto-hebrew font-noto-lao font-noto-malayalam font-noto-tamil font-noto-thaana
fc-cache -fv
apk add elogind polkit-elogind fuse3 fuse-openrc gvfs udisks2 dbus dbus-x11 pipewire pipewire-pulse wireplumber gst-plugin-pipewire networkmanager networkmanager-wifi wpa_supplicant network-manager-applet bluez blueman ufw 7zip unzip zip xz gzip ntfs-3g dosfstools exfatprogs fuse-exfat gvfs-afp gvfs-mtp gvfs-smb gvfs-afc gvfs-nfs gvfs-archive gvfs-dav gvfs-fuse gvfs-gphoto2 gvfs-avahi gvfs-goa gvfs-cdda
rc-update add elogind default
rc-update add fuse default
rfkill unblock all
modprobe btusb
rc-update add bluetooth default

if [ ! -f /etc/NetworkManager/NetworkManager.conf.bak ]
then
	mv /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf.bak
fi

rm /etc/NetworkManager/NetworkManager.conf
touch /etc/NetworkManager/NetworkManager.conf
echo "[main]" >> /etc/NetworkManager/NetworkManager.conf
echo "dhcp=internal" >> /etc/NetworkManager/NetworkManager.conf
echo "plugins=ifupdown,keyfile" >> /etc/NetworkManager/NetworkManager.conf
echo "" >> /etc/NetworkManager/NetworkManager.conf
echo "[ifupdown]" >> /etc/NetworkManager/NetworkManager.conf
echo "managed=true" >> /etc/NetworkManager/NetworkManager.conf
echo "" >> /etc/NetworkManager/NetworkManager.conf
echo "[device]" >> /etc/NetworkManager/NetworkManager.conf
echo "wifi.scan-rand-mac-address=yes" >> /etc/NetworkManager/NetworkManager.conf
echo "wifi.backend=wpa_supplicant" >> /etc/NetworkManager/NetworkManager.conf
rc-update add networkmanager default
rc-update del networking boot
rc-update del wpa_supplicant boot
rc-update del iwd boot

if [ ! -e /etc/pipewire ]
then
	cp -a /usr/share/pipewire /etc
fi

if [ ! -e /etc/wireplumber ]
then
	cp -a /usr/share/wireplumber /etc
fi

ufw enable
ufw default deny incoming
ufw default allow outgoing
rc-update add ufw default
apk add firefox xdg-user-dirs xdg-desktop-portal-gtk xarchiver galculator mousepad ristretto parole thunar-archive-plugin xfce4-appfinder xfce4-screenshooter xfce4-taskmanager xfce-polkit mugshot pavucontrol xfce4-screensaver xfce4-whiskermenu-plugin xfce4-pulseaudio-plugin xfce4-clipman-plugin xfce4-notifyd mesa mesa-dri-gallium mesa-egl mesa-gbm mesa-gl mesa-glapi mesa-gles mesa-libd3dadapter9 mesa-osmesa mesa-rusticl mesa-va-gallium mesa-vdpau-gallium mesa-vulkan-ati mesa-vulkan-intel mesa-vulkan-layers gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-vaapi gst-libav
echo "XCURSOR_THEME=Adwaita" >> /etc/environment
mkdir /usr/share/icons/default
touch /usr/share/icons/default/index.theme
echo "[Adwaita]" >> /usr/share/icons/default/index.theme
echo "Inherits=Adwaita" >> /usr/share/icons/default/index.theme
apk add apk-gtk3
echo "pkexec apk-gtk update && pkexec apk-gtk upgrade" > /usr/bin/update-system
chmod +x /usr/bin/update-system
cp update-system.desktop /usr/share/applications
cp wallpaper.jpg /usr/share/backgrounds
echo "background=/usr/share/backgrounds/wallpaper.jpg" >> /etc/lightdm/lightdm-gtk-greeter.conf
doas -u $NORMALUSER xdg-user-dirs-update --force
clear
while true; do
	echo "Would you like to apply desktop customizations? This will install a theme, icon set and change the default XFCE panel layout."
	echo "( Y / N )"
	read YN
	case $YN in
		[Yy]* ) apk add adw-gtk3 papirus-icon-theme adwaita-qt adwaita-qt5 adwaita-qt6; echo "QT_STYLE_OVERRIDE=adwaita-dark" >> /etc/environment ; mkdir /home/$NORMALUSER/.config ; cp -r xfce4 /home/$NORMALUSER/.config/ ; chown -Rc $NORMALUSER /home/$NORMALUSER/.config ; chown -Rc $NORMALUSER /home/$NORMALUSER/.config/xfce4 ; mkdir /etc/skel/.config ; cp -r xfce4 /etc/skel/.config; echo "background=/usr/share/backgrounds/wallpaper.jpg" >> /etc/lightdm/lightdm-gtk-greeter.conf; echo "theme-name=adw-gtk3-dark" >> /etc/lightdm/lightdm-gtk-greeter.conf; echo "icon-theme-name=Papirus-Dark" >> /etc/lightdm/lightdm-gtk-greeter.conf; echo "font-name=Cantarell" >> /etc/lightdm/lightdm-gtk-greeter.conf; echo "cursor-theme-name=Adwaita" >> /etc/lightdm/lightdm-gtk-greeter.conf; break ;;
		[Nn]* ) break ;;
		* ) echo "Would you like to apply desktop customizations? This will install a theme, icon set and change the default XFCE panel layout." & echo "( Y / N )";;
	esac
done
clear
while true; do
	echo "Would you like to use Chromium instead of Firefox? ( Y / N )"
	read yn
	case $yn in
		[Yy]* ) apk del firefox ; apk add chromium; break ;;
		[Nn]* ) break ;;
		* ) echo "Would you like to use Chromium instead of Firefox? ( Y / N )";;
	esac
done
clear
while true; do
	echo "Would you like to install the LibreOffice office suite? ( Y / N )"
	read yn
	case $yn in
		[Yy]* ) apk add libreoffice; break ;;
		[Nn]* ) break ;;
		* ) echo "Would you like to install the LibreOffice office suite? ( Y / N )";;
	esac
done
clear
if [[ $yn == n || $yn == N ]]; then
while true; do
	echo "Would you like to install Abiword and Gnumeric instead? ( Y / N )"
	read yn
	case $yn in
		[Yy]* ) apk add libreoffice; break ;;
		[Nn]* ) break ;;
		* ) echo "Would you like to install Abiword and Gnumeric instead? ( Y / N )";;
	esac
done
fi
clear
while true; do
	echo "Would you like to install Evolution? [Email, Calendar, Contacts, Todo, Notes] ( Y / N )"
	read yn
	case $yn in
		[Yy]* ) apk add evolution; break;;
		[Nn]* ) break;;
		* ) echo "Would you like to install Evolution? ( Y / N )";;
	esac
done
clear
while true; do
	echo "Would you like to install GIMP? ( Y / N )"
	read yn
	case $yn in
		[Yy]* ) apk add gimp; break;;
		[Nn]* ) break;;
		* ) echo "Would you like to install GIMP? ( Y / N )";;
	esac
done
clear
while true; do
	echo "Would you like to use VLC instead of Parole for media playback? ( Y / N )"
	read yn
	case $yn in
		[Yy]* ) apk del parole; apk add vlc-qt break;;
		[Nn]* ) break;;
		* ) echo "Would you like to use VLC instead of Parole for media playback? ( Y / N )";;
	esac
done
clear
while true; do
	echo "Would you like to install Flatpak support? ( Y / N )"
	read yn
	case $yn in
		[Yy]* ) apk add flatpak; flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo; doas -u $NORMALUSER xdg-user-dirs-update; break;;
		[Nn]* ) break;;
		* ) echo "Would you like to install Flatpak support? ( Y / N )";;
	esac
done

if [[ $yn == y || $yn == Y ]]; then
while true; do
	echo "Would you like to use GNOME Software for managing Flatpaks? ( Y / N )"
	read yn
	case $yn in
		[Yy]* ) apk add gnome-software gnome-software-plugin-flatpak; rc-update add apk-polkit-server default; break ;;
		[Nn]* ) break ;;
		* ) echo "Would you like to use GNOME Software for managing Flatpaks? ( Y / N )";;
	esac
done
fi
clear
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "INSTALLATION COMPLETE ! ! !"
echo "Please restart the system for changes to take effect."
echo " "
exit
