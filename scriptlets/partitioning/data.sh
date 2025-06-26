#!/bin/bash

set -euo pipefail

# Check for dialog
if ! command -v dialog &>/dev/null; then
  echo "Installing 'dialog'..."
  emerge --ask --noreplace dialog || exit 1
fi

# Detect block devices (excluding loopback and optical)
mapfile -t BLOCKS < <(lsblk -dpno NAME,TYPE | grep 'disk' | awk '{print $1}')
if [ ${#BLOCKS[@]} -eq 0 ]; then
  echo "No block devices found!" >&2
  exit 1
fi

# Build dialog options dynamically
DIALOG_OPTS=()
for dev in "${BLOCKS[@]}"; do
  DIALOG_OPTS+=("$dev" "" off)
done

# Use dialog to pick disks
CHOICES=$(dialog --stdout --separate-output \
  --checklist "Select disks to format with Btrfs:" 20 60 10 \
  "${DIALOG_OPTS[@]}")

clear

if [ -z "$CHOICES" ]; then
  echo "No disks selected. Exiting."
  exit 1
fi

echo "You selected the following disks:"
for disk in $CHOICES; do
  echo " - $disk"
done

dialog --yesno "Proceed to wipe and format these disks with Btrfs?\n\n${CHOICES}" 10 50
if [ $? -ne 0 ]; then
  clear
  echo "Aborted by user."
  exit 1
fi

for disk in $CHOICES; do
  echo "Erasing $disk..."
  unmount_and_wipe $disk
done

# Format disks and mount
mkfs.btrfs -f -L GENTOO_DATA $CHOICES
mount ${CHOICES%%$'\n'*} /mnt/gentoo

# Subvolumes
btrfs subvolume create /mnt/gentoo/@root
btrfs subvolume create /mnt/gentoo/@home
btrfs subvolume create /mnt/gentoo/@containers
umount /mnt/gentoo

# Mount with compression
mount -o compress=zstd,subvol=@root ${CHOICES%%$'\n'*} /mnt/gentoo
mkdir -p /mnt/gentoo/home /mnt/gentoo/var/lib/containers
mount -o compress=zstd,subvol=@home ${CHOICES%%$'\n'*} /mnt/gentoo/home
mount -o compress=zstd,subvol=@containers ${CHOICES%%$'\n'*} /mnt/gentoo/var/lib/containers
