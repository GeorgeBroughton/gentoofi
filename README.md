# gentoofi
An opinionated install script for my favourite way to set-up Gentoo Linux

The design philosophy behind this is:
 - Containerize every piece of user-installed software on the system, so that uninstallation doesn't leave behind undesirable files.
 - Keep it as modular as possible (hence containers)
 - 

Core components:
 - Limine
   - because it has btrfs snapshot support
 - Systemd
   - Sorry systemd haters. I do like openRC but only for super slim builds. PR this and add support for it if you want though.
 - NetworkManager
 - QTGreet
 - Hyprland
 - Pipewire
 - Wezterm
 - Podman
 - QEMU/KVM

Terminal Software:
 - lazyjournal
 - htop
 - glances
 - tmux

*More to be added here...*

Software:
 - qJournalctl
 - podman desktop
 - qpwgraph (pipewire frontend)

*More to be added here...*

It will:
 - [ ] Create a `btrfs` pool for your data disks (you can select more than one disk to create a pool)
 - [ ] Creates btrfs subvolumes for `/`, `/home`, `/var/lib/containers` and `/var/lib/libvirt`
 - [ ] Make a bcache for the data disks. (you can select more than one disk to create an MDRAID 0 cache, optionally write-thru or write-back)
 - [ ] Configures the system to load everything in the `/` subvolume directly into tmpfs (RAM basically), and snapshot changes to it on disk every shutdown.
    - Similar to alpine linux, only it's an automatic procedure. The number of snapshots maintained and when they take place will eventually be configurable.

*More to be added here...*

# This remains in development. Star it. Fork it. PR it. Come back later if you seriously want to use it.

For those who want to try anyway, you can run this in the live CD:

```sh
git clone https://github.com/GeorgeBroughton/gentoofi.git && cd ./gentoofi && chmod -Rv +x ./ && sudo ./gentoofi.sh
```
