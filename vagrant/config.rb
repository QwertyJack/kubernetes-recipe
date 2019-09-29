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
# Setting multi_networking to true will install Multus: https://github.com/intel/multus-cni
$multi_networking = false
# The first three nodes are etcd servers
$etcd_instances = 3
# The first two nodes are kube masters
$kube_master_instances = 2
# All nodes are kube nodes
$kube_node_instances = $num_instances

$inventory = "inventory/mycluster"
