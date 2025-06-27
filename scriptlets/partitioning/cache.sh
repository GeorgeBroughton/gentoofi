#!/bin/bash

# Detect fast disks (e.g. NVMe)
mapfile -t FAST_DISKS < <(lsblk -dpno NAME,TYPE | grep 'disk' | grep -E 'nvme|ssd' | awk '{print $1}')

if [ ${#FAST_DISKS[@]} -gt 0 ]; then

  # Build dialog options
  CACHE_OPTS=()
  for dev in "${FAST_DISKS[@]}"; do
    CACHE_OPTS+=("$dev" "" off)
  done

  # Dialog selection
  CACHE_SELECTION=$(dialog --stdout --separate-output \
    --checklist "Select cache disk(s) (NVMe/SSD):" 20 60 10 \
    "${CACHE_OPTS[@]}")

  clear

  # Count selected
  CACHE_COUNT=$(echo "$CACHE_SELECTION" | wc -l)

  if [ "$CACHE_COUNT" -eq 0 ]; then
    echo "No cache device selected. Skipping bcache setup."
    exit 0
  elif [ "$CACHE_COUNT" -eq 1 ]; then
    CACHE_DEV="$CACHE_SELECTION"
  else
    echo "Creating MDRAID0 array for cache..."
    mdadm --create --verbose /dev/mdcache --level=0 --raid-devices=$CACHE_COUNT $CACHE_SELECTION
    CACHE_DEV="/dev/mdcache"
  fi

  # Create bcache
  make-bcache -B /dev/btrfs_backing_device -C "$CACHE_DEV"

else

  dialog --yesno "No fast storage was found.\n\nContinue?" 10 50
  if [ $? -ne 0 ]; then
    clear
    echo "Aborted by user."
    exit 1
  fi
  
fi