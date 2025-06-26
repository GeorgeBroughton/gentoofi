#!/bin/bash

unmount_and_wipe() {
  local dev=$1

  echo "Unmounting any mounted partitions on $dev..."
  lsblk -n -o MOUNTPOINT "$dev" | grep -q '/' && umount -R "$dev"* || true

  echo "Disabling swap on $dev if active..."
  swapoff "$dev"* 2>/dev/null || true

  echo "Wiping filesystem signatures..."
  wipefs -a "$dev"
}

echo "BASH_SOURCE=${BASH_SOURCE%/*}"

source "${BASH_SOURCE%/*}/data.sh"
source "${BASH_SOURCE%/*}/cache.sh"