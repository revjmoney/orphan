# Running a board over the network (netboot)

A second board does not need its own SD card: it can boot a kernel from its NAND flash and use a Linux PC's
disk as its root filesystem over NFS. That is how the Orphan Radio board runs during development: same Orphan
system as an SD-card board, its own hostname, and the server keeps the files.

**Advanced and not yet scripted for others.** It means writing the board's NAND, and the stock boot loader gives
no way back without a 3.3 V serial cable on J12. Read [flash.md](flash.md) first.

## How it works

1. The stock S9 U-Boot has no saved settings and hard-codes the kernel command line, so the kernel carries its
   own: a Linux 6.18 build (Xilinx tree, Ardzy's S9 config) with `CONFIG_CMDLINE_FORCE` and
   `root=/dev/nfs nfsroot=<server ip>:/srv/s9/rootfs,v3,tcp ip=dhcp rw rootwait panic=10`.
2. That kernel and the device tree replace the stock ones in the NAND's kernel and DTB slots
   (`flash_erase` + `nandwrite -p` from the stock firmware, after a full NAND backup).
3. The server exports `/srv/s9/rootfs` (an Orphan system) read-write to the LAN with `no_root_squash`.
4. In that root: no SD entries in `/etc/fstab`, and systemd-networkd must **not** manage the Ethernet
   (`[Link] Unmanaged=yes`), because the kernel already brought it up and the root filesystem depends on it.
   No SD-card services (activity lights, Ardzy's `ardzy.txt` config, the boot-OK watchdog). Its own SSH host keys
   (`ssh-keygen -A -f <root>`) and an empty `/etc/machine-id`.

## Making a netboot root from an SD-card Orphan

Copy the SD system to the server with `tar --one-file-system` (it stays consistent enough for a copy), add the
netboot kernel's modules to `usr/lib/modules`, then apply step 4.

**Swapping the root under a running board kills it** (its NFS file handles go stale). Reboot the board first,
wait until it stops answering ping, then rename the folders on the server and run `exportfs -ra`.

The server must be on whenever the board starts.

---
[Buy me a coffee](https://buymeacoffee.com/revjmoney) · by [JMSCNC](https://jmscnc.com), makers of RotatoCAM · **[Rev. J. Money - 2026]**
