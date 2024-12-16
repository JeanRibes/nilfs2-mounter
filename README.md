# NILFS non-root snapshot viewer

This suite of tools allows you to list and mount snaphots in a NILFS2 filesystem.

## Setup

run `make all` to build, install (with setuid) the binaries, accompanying script and .desktop shortcuts

## Usage

The shortcuts allow for a easy usage: make a snaphot, select and mount one (requires the `fzf` tool on the PATH), and unmount all snapshots.

```bash
nilfs.sh choose-mount-snapshot # select and mount one with fzf
nilfs.sh umount-snapshots # unmounts all snapshots
```

## Caveats

Currently this setup supports only one NILFS2 device.
The scripts auto-detects-its using mounts, but it can be set with env var `NILFS2_MOUNTER_DEVICE`
