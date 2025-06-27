#!/bin/bash

unmount_and_wipe() {
  local dev=$1
  local mountpoints < <(mount | grep "$dev" | awk '{print $3}')

  echo "Unmounting any mounted partitions on $dev..."
  for mountpoint in "${mountpoints[@]}"; do
    umount -Rv $mountpoint
  done

  echo "Disabling swap on $dev if active..."
  swapoff "$dev"* 2>/dev/null || true

  echo "Wiping filesystem signatures..."
  wipefs -a "$dev"
}

source "${BASH_SOURCE%/*}/data.sh"
source "${BASH_SOURCE%/*}/cache.sh"