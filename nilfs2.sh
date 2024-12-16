#!/bin/bash
DEVICE="/dev/disk/by-label/idoc" # /dev/mapper/luks-b3f31029-4b02-4b4a-9106-253155f4ac2f
TARGET="$XDG_RUNTIME_DIR/documents"
mkdir -p "$TARGET"

function mount_snapshot() {
    choice=$(lscp --snapshot --reverse "$DEVICE" | tail -n+2|awk '{print $1" \t"$2"\t"$3}' | fzf --bind=q:cancel)
    if [[ ${#choice} -gt 0 ]]; then
        snapshot=$(echo $choice|cut -d' ' -f1)
        echo "mount $snapshot"
        mkdir -p "$TARGET/snapshots/$snapshot"
        nilfs2-mounter mount "$DEVICE" "$TARGET/snapshots/$snapshot" "$snapshot"
    fi
}

function unmount_snapshots() {
    shopt -s extglob
    for i in "$TARGET/snapshots/"*; do
        nilfs2-mounter umount "$i"
        rmdir "$i"
    done
}

case $1 in
    choose-mount-snapshot)
    mount_snapshot
    ;;
    umount-snapshots)
    unmount_snapshots
    ;;
    *)
    echo "erreur"
    ;;
esac