#!/bin/bash
DEVICE="/dev/disk/by-label/documents"
TARGET="/mnt"

if [[ ! -f "$TARGET/.nilfs" ]] || [[ ! -d "$TARGET/.snapshots" ]]; then
    echo "vide, on monte"
    set -x
    ./nmount mount "$DEVICE" "$TARGET"; set +x
fi

choice=$(lscp --snapshot --reverse "$DEVICE" | tail -n+2|awk '{print $1" \t"$2"\t"$3}' | fzf --bind=q:cancel)
if [[ ${#choice} -gt 0 ]]; then
    snapshot=$(echo $choice|cut -d' ' -f1)
    echo "mount $snapshot"
    mkdir -p "$TARGET/.snapshots/$snapshot"
    ./nmount mount "$DEVICE" "$TARGET/.snapshots/$snapshot" "$snapshot"
fi
