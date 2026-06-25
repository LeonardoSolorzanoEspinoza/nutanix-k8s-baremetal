resource "nutanix_virtual_machine" "k8s_node" {
  count = 4
 
  # Index 0 becomes 'controlplane'.
  # Subsequent indexes become node01, node02, node03.
  name = count.index == 0 ? "controlplane" : format("node%02d", count.index)
 
  cluster_uuid    = var.cluster_uuid
  num_sockets     = 2
 
  # Index 0 (controlplane) gets 8GB (8192 MiB), Workers get 4GB (4096 MiB)
  memory_size_mib = count.index == 0 ? 8192 : 4096
 
  nic_list {
    subnet_uuid = var.subnet_uuid
  }
 
  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = var.image_uuid
    }
    
    disk_size_mib = 61440

    device_properties {
      disk_address = {
        device_index = 0
        adapter_type = "SCSI"
      }
      device_type = "DISK"
    }
  }
 
  # ==========================================
  # CLOUD-INIT GUEST CUSTOMIZATION
  # ==========================================
  guest_customization_cloud_init_user_data = base64encode(<<-EOF
    #cloud-config
    users:
      - name: ubuntu
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
          - ${var.ssh_public_key}
    
    bootcmd:
      - echo "Cloud-init started successfully" > /var/log/cloud-init-custom.log
  EOF
  )
}
