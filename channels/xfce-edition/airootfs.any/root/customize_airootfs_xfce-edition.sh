#!/usr/bin/env bash
#
# Yamada Hayao
# Twitter: @Hayao0819
# Email  : hayao@fascode.net
#
# (c) 2019-2020 Fascode Network.
#

set -e -u


# Default value
# All values can be changed by arguments.
password=arch
boot_splash=false
kernel='zen'
theme_name=alter-logo
rebuild=false
japanese=false
username='arch'
os_name="Swilner Linux"
install_dir="arch"
usershell="/bin/bash"
debug=true


# Parse arguments
while getopts 'p:bt:k:rxju:o:i:s:da:' arg; do
    case "${arg}" in
        p) password="${OPTARG}" ;;
        b) boot_splash=true ;;
        t) theme_name="${OPTARG}" ;;
        k) kernel="${OPTARG}" ;;
        r) rebuild=true ;;
        j) japanese=true;;
        u) username="${OPTARG}" ;;
        o) os_name="${OPTARG}" ;;
        i) install_dir="${OPTARG}" ;;
        s) usershell="${OPTARG}" ;;
        d) debug=true ;;
        x) debug=true; set -xv ;;
        a) arch="${OPTARG}"
    esac
done


# Delete file only if file exists
# remove <file1> <file2> ...
function remove () {
    local _list
    local _file
    _list=($(echo "$@"))
    for _file in "${_list[@]}"; do
        if [[ -f ${_file} ]]; then
            rm -f "${_file}"
        elif [[ -d ${_file} ]]; then
            rm -rf "${_file}"
        fi
        echo "${_file} was deleted."
    done
}


# Replace wallpaper.
if [[ -f /usr/share/backgrounds/xfce/xfce-stripes.png ]]; then
    remove /usr/share/backgrounds/xfce/xfce-stripes.png
    ln -s /usr/share/backgrounds/wallpaper.png /usr/share/backgrounds/xfce/xfce-stripes.png
fi
[[ -f /usr/share/backgrounds/wallpaper.png ]] && chmod 644 /usr/share/backgrounds/wallpaper.png


# Bluetooth
rfkill unblock all
systemctl enable bluetooth

# Snap
if [[ "${arch}" = "x86_64" ]]; then
    systemctl enable snapd.apparmor.service
    systemctl enable apparmor.service
    systemctl enable snapd.socket
    systemctl enable snapd.service
fi


# Update system datebase
dconf update


# firewalld
systemctl enable firewalld.service


# Replace link
#if [[ "${japanese}" = true ]]; then
    #remove "/etc/skel/Desktop/welcome-to-alter.desktop"
   # remove "/home/${username}/Desktop/welcome-to-alter.desktop"

  #  mv "/etc/skel/Desktop/welcome-to-alter-jp.desktop" "/etc/skel/Desktop/welcome-to-alter.desktop"
 #   mv "/home/${username}/Desktop/welcome-to-alter-jp.desktop" "/home/${username}/Desktop/welcome-to-alter.desktop"
#else
 #   remove "/etc/skel/Desktop/welcome-to-alter-jp.desktop"
 #   remove "/home/${username}/Desktop/welcome-to-alter-jp.desktop"
#fi


# Replace right menu
if [[ "${japanese}" = true ]]; then
    remove "/etc/skel/.config/Thunar/uca.xml"
    remove "/home/${username}/.config/Thunar/uca.xml"

    mv "/etc/skel/.config/Thunar/uca.xml.jp" "/etc/skel/.config/Thunar/uca.xml"
    mv "/home/${username}/.config/Thunar/uca.xml.jp" "/home/${username}/.config/Thunar/uca.xml"
else
    remove "/etc/skel/.config/Thunar/uca.xml.jp"
    remove "/home/${username}/.config/Thunar/uca.xml.jp"
fi

# Added autologin group to auto login
groupadd autologin
usermod -aG autologin ${username}


# Enable LightDM to auto login
if [[ "${boot_splash}" =  true ]]; then
    systemctl enable lightdm-plymouth.service
else
    systemctl enable lightdm.service
fi


# Set script permission
chmod 755 /usr/local/bin/alterlinux-sidebar

# Replace auto login user
sed -i s/%USERNAME%/${username}/g /etc/lightdm/lightdm.conf

chsh -s /bin/zsh
rm -f -r /usr/share/lightdm-webkit/themes/alter/images/4-3.png
rm -f -r /usr/share/lightdm-webkit/themes/alter/images/5-4.png
rm -f -r /usr/share/lightdm-webkit/themes/alter/images/16-10.png
rm -f -r /usr/share/lightdm-webkit/themes/alter/images/Aqua_logo.png
rm -f -r /usr/share/lightdm-webkit/themes/alter/images/index.html
cp -f /usr/share/backgrounds/4-3.png /usr/share/lightdm-webkit/themes/alter/images/4-3.png
cp -f /usr/share/backgrounds/5-4.png /usr/share/lightdm-webkit/themes/alter/images/5-4.png
# cp -f /usr/share/backgrounds/16-10.jpg /usr/share/lightdm-webkit/themes/alter/images/16-10.png
cp -f /usr/share/backgrounds/4-3.png /usr/share/lightdm-webkit/themes/alter/images/Aqua_logo.png
cp -f /usr/share/backgrounds/index.html /usr/share/lightdm-webkit/themes/alter/index.html
# pacman -U /home/yytu/aqualinux/channels/aqua.add/packages.x86_64/pinta-git-r1821.faf54854-1-x86_64.pkg.tar.xz
# ln '/home/yytu/aqualinux/work/x86_64/airootfs/home/aqua/Desktop/calamares.desktop' '/home/yytu/aqualinux/work/x86_64/airootfs/home/aqua/デスクトップ'