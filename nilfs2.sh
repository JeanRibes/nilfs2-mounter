#!/bin/bash
if [[ -z $NILFS2_MOUNTER_DEVICE ]]; then
	echo "choosing device"
	NILFS2_MOUNTER_DEVICE=$(cat /etc/mtab|grep nilfs2|head -n1|cut -d' ' -f1)
else
	echo "device already set"
fi
TARGET="$XDG_RUNTIME_DIR/nilfs2-mounter"
mkdir -p "$TARGET"

function mount_snapshot() {
    choice=$(lscp --snapshot --reverse "$NILFS2_MOUNTER_DEVICE" | tail -n+2|awk '{print $1" \t"$2"\t"$3}' | fzf --bind=q:cancel)
    if [[ ${#choice} -gt 0 ]]; then
        snapshot=$(echo $choice|cut -d' ' -f1)
        echo "mount $snapshot"
        mkdir -p "$TARGET/snapshots/$snapshot"
        nilfs2-mounter mount "$NILFS2_MOUNTER_DEVICE" "$TARGET/snapshots/$snapshot" "$snapshot"
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
    echo "Usage: $0 <choose-mount-snapshot|umount-snapshots>"
		exit 2
    ;;
esac
