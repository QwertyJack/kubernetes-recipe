# -*- mode: ruby -*-
# # vi: set ft=ruby :

$num_instances = 3
$instance_name_prefix = "node"
$vm_gui = false
$vm_memory = 4096
$vm_cpus = 2
$shared_folders = {}
$forwarded_ports = {}
$subnet = "10.0.20"
$os = "ubuntu1804"
$network_plugin = "flannel"
