dialog --yesno "Right now, this installer will only partition disks for you.\n\nProceed?" 10 50
if [ $? -ne 0 ]; then
  clear
  echo "Aborted by user."
  exit 1
fi

echo "BASH_SOURCE=${BASH_SOURCE%/*}"

source "${BASH_SOURCE%/*}/scriptlets/partitioning/main.sh"

# source ./scriptlets/

# Systemd, openssh, Wayland, QTGreet, Hyprland, PipeWire, Westerm, qpwgraph, nano 

