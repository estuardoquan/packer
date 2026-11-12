#!/bin/sh
# usage: lvm-disk.sh <scsi-key> <vg> <lv>=<size> [<lv>=<size> ...]
#
#   lvm-disk.sh scsi0 vg0 lv_root=100%
#   lvm-disk.sh scsi1 vg1 lv_data=50% lv_home=100%
#
# size: "100%" = all free space in the VG; "N%" = N percent of the VG.

k=$1
vg=$2
shift 2

disk=$(readlink -f "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-$k")
if [ ! -b "$disk" ]; then
    echo "lvm-disk: $k: no such disk" >&2
    exit 0
fi
name=${disk##*/}

# --- PV -------------------------------------------------------------------

# PV on this disk: the disk itself, or one of its partitions
pv=
for p in $(pvs --noheadings -o pv_name); do
    p=$(readlink -f "$p")
    n=${p##*/}
    if [ "$n" = "$name" ]; then
        pv=$p
    elif [ -e "/sys/class/block/$name/$n/partition" ]; then
        pv=$p
    fi
done

if [ -z "$pv" ]; then
    # new disk: whole-disk PV, unless the disk already has partitions
    if ls "/sys/class/block/$name/"*/partition >/dev/null 2>&1; then
        echo "lvm-disk: $k: partitioned disk without a PV, skipped" >&2
        exit 0
    fi
    if ! pvcreate "$disk"; then
        exit 0
    fi
    pv=$disk
else
    # existing PV: grow the partition if there is one, then the PV
    n=${pv##*/}
    if [ -e "/sys/class/block/$n/partition" ]; then
        growpart "$disk" "$(cat "/sys/class/block/$n/partition")"
    fi
    pvresize "$pv"
fi

# --- VG -------------------------------------------------------------------

cur=$(pvs --noheadings -o vg_name "$pv" | tr -d ' ')
if [ -z "$cur" ]; then
    if vgs "$vg" >/dev/null 2>&1; then
        # VG exists on another disk: add this one to it
        vgextend "$vg" "$pv"
    else
        vgcreate "$vg" "$pv"
    fi
elif [ "$cur" != "$vg" ]; then
    echo "lvm-disk: $k: PV is in $cur, not $vg, skipped" >&2
    exit 0
fi

# --- LVs ------------------------------------------------------------------

# pass 1: LVs sized N% of the VG
for arg in "$@"; do
    lv=${arg%%=*}
    size=${arg#*=}
    if [ "$size" = "100%" ]; then
        continue
    fi
    if lvs "$vg/$lv" >/dev/null 2>&1; then
        pct=${size%\%}
        vg_bytes=$(vgs --noheadings --units b --nosuffix -o vg_size "$vg" | tr -d ' ')
        lv_bytes=$(lvs --noheadings --units b --nosuffix -o lv_size "$vg/$lv" | tr -d ' ')
        ext_bytes=$(vgs --noheadings --units b --nosuffix -o vg_extent_size "$vg" | tr -d ' ')
        want=$((vg_bytes / 100 * pct))
        # grow only when the LV is short by more than one extent
        if [ $((want - lv_bytes)) -gt "$ext_bytes" ]; then
            lvextend -r -l "${size}VG" "$vg/$lv"
        fi
    else
        lvcreate -y -n "$lv" -l "${size}VG" "$vg"
        mkfs.ext4 -q "/dev/$vg/$lv"
    fi
done

# pass 2: LVs sized 100% take whatever is left
for arg in "$@"; do
    lv=${arg%%=*}
    size=${arg#*=}
    if [ "$size" != "100%" ]; then
        continue
    fi
    free=$(vgs --noheadings -o vg_free_count "$vg" | tr -d ' ')
    if [ "$free" -gt 0 ]; then
        if lvs "$vg/$lv" >/dev/null 2>&1; then
            lvextend -r -l +100%FREE "$vg/$lv"
        else
            lvcreate -y -n "$lv" -l 100%FREE "$vg"
            mkfs.ext4 -q "/dev/$vg/$lv"
        fi
    fi
done

exit 0
