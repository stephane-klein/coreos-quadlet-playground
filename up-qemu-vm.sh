#!/usr/bin/env bash

cd "$(dirname "$0")"

cat << 'EOF'
If you want to reinstall the VM, you must delete `./disks/coreos-disk.qcow2` with:

$ rm ./disks/coreos-disk.qcow2

EOF

mkdir -p disks/

if [ ! -f "./disks/coreos-disk.qcow2" ]; then
    qemu-img create \
        -f qcow2 \
        ./disks/coreos-disk.qcow2 \
        10G
fi

systemctl --user stop coreos-1 >/dev/null 2>&1 || true
systemctl --user reset-failed coreos-1 >/dev/null 2>&1 || true
systemctl --user kill coreos-1 >/dev/null 2>&1 || true

systemd-run --user --unit=coreos-1 \
    qemu-system-x86_64 \
        -name coreos-custom-iso-1 \
        -machine type=q35,accel=kvm \
        -cpu host \
        -smp 2 \
        -m 4048 \
        -display none \
        -drive file=$(pwd)/disks/coreos-disk.qcow2,id=hd0,if=none,format=qcow2 \
        -device virtio-blk-pci,drive=hd0,bootindex=0 \
        -drive if=none,id=cd0,media=cdrom,file=$(pwd)/images/fedora-coreos-custom-for-qemu.iso \
        -device ide-cd,drive=cd0,bootindex=1 \
        -netdev user,id=net0,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:8080 \
        -device virtio-net-pci,netdev=net0 \
        -monitor unix:/tmp/coreos-1-monitor.sock,server,nowait \
        -serial unix:/tmp/coreos-1-console.sock,server,nowait \
        -virtfs local,path=$(pwd)/shared,mount_tag=shared,security_model=passthrough,id=shared0


source ./_utils.sh

wait_for_ssh_availability "127.0.0.1" 2222 "stephane"
echo 

cat << EOF
To enter in coreos-1 VM, execute:

$ ./ssh-enter-vm.sh

Stop VM:

$ ./down-qemu-vm.sh

Teardown:

$ ./teardown.sh

EOF
