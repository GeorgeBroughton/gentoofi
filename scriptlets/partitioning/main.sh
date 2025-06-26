unmount_and_wipe() {
  local dev=$1

  echo "Unmounting any mounted partitions on $dev..."
  lsblk -n -o MOUNTPOINT "$dev" | grep -q '/' && umount -R "$dev"* || true

  echo "Disabling swap on $dev if active..."
  swapoff "$dev"* 2>/dev/null || true

  echo "Wiping filesystem signatures..."
  wipefs -a "$dev"
}

source "${BASH_SOURCE%/*}/partitioning-data.sh"
source "${BASH_SOURCE%/*}/partitioning-cache.sh"