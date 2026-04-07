# 1. Kill and remove broken FAZ
sudo virsh destroy FortiAnalyzer
sudo virsh undefine FortiAnalyzer

# 2. Delete old data disk and create fresh one
sudo rm /var/lib/libvirt/images/faz-data.qcow2
sudo qemu-img create -f qcow2 /var/lib/libvirt/images/faz-data.qcow2 100G
sudo chown libvirt-qemu:kvm /var/lib/libvirt/images/faz-data.qcow2
sudo chmod 660 /var/lib/libvirt/images/faz-data.qcow2

# 3. Redeploy with 8GB RAM
sudo virt-install \
  --name FortiAnalyzer \
  --ram 8192 --vcpus 2 \
  --cpu host-model --os-variant generic \
  --import \
  --disk path=/var/lib/libvirt/images/fortianalyzer.qcow2,format=qcow2,bus=virtio \
  --disk path=/var/lib/libvirt/images/faz-data.qcow2,format=qcow2,bus=virtio \
  --network network=default,model=virtio \
  --graphics none --noautoconsole

# 4. Watch it boot — should say "Formatting log disk..."
sudo virsh console FortiAnalyzer
