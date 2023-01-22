#!/usr/bin/env bash

if [ $USER != "root" ]; then
    echo "This script must be run using sudo"
    exit -1
fi

export BASE_USER=pi
set -e

git clone --depth 1 --branch v1.2.4 https://github.com/Rat-OS/RatOS.git

set -ea
source ./RatOS/src/config
set +a

echo "Installing common.sh"
wget -q --show-progress -O /common.sh \
https://raw.githubusercontent.com/guysoft/CustomPiOS/71787f060221069848abfcbb307f616680f7dbb1/src/common.sh

sed -i 's|from=$1|from=$1; from="${from:1}"|' /common.sh
sed -i 's|python-dev python-matplotlib|python-dev|' ./RatOS/src/modules/klipper/config
sed -i 's|libusb-1.0|libusb-1.0-0|' ./RatOS/src/modules/klipper/config
sed -i 's|sed -i|#sed -i|' ./RatOS/src/modules/is_req_preinstall/start_chroot_script
sed -i 's|sudo cp "./scripts/klipper-mcu-start.sh" /etc/init.d/klipper_mcu|sudo cp "./scripts/klipper-mcu.service" /etc/systemd/system/|' \
./RatOS/src/modules/rpi_mcu/start_chroot_script
sed -i 's|sudo update-rc.d klipper_mcu defaults|sudo systemctl enable klipper-mcu.service|' \
./RatOS/src/modules/rpi_mcu/start_chroot_script

PKGS=(klipper node is_req_preinstall moonraker mainsail klipperscreen ratos rpi_mcu)

for PKG in ${PKGS[@]}; do
    echo "Installing package: $PKG"
    cp /common.sh ./RatOS/src/modules/${PKG}
    chmod 755 ./RatOS/src/modules/${PKG}/common.sh ./RatOS/src/modules/${PKG}/start_chroot_script
    pushd ./RatOS/src/modules/${PKG}
    if [ -f config ]; then
        set -a
        source config
        set +a
    fi
    ./start_chroot_script
    popd
done

echo "*** All Done - Rebooting ***"
systemctl reboot -i
