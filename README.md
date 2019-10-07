# Deploy Production Ready Kubernetes Cluster

Inspired by [this blog](https://medium.com/@olegsmetanin/kubernetes-recipe-kubernetes-kubespray-glusterfs-gluster-kubernetes-letsencrypt-kube-lego-595794665459).

## Intro

This tutorial will get you a production ready k8s cluster running on a single server(maybe) contains:

- 3 k8s nodes (2 master + 1 worker)
- an apiserver endpoint in HA mode
- a standalone glusterfs cluster(2 + 2) + heketi api server + glusterfs storageclass
- or nfs server on the host + nfs-client-provisioner + nfs storageclass
- an external LB for bare metal

You may scale the cluster at your needs.

All nodes are virtualized by Vagrant + libvirt.

## Prerequisite

Check your OS doc to install:

- Ansible
- Vagrant
- Libvirt
- Docker & Docker Compose

## K8S Cluster

We use [kubespray](https://github.com/kubernetes-sigs/kubespray) for k8s installation.

- Follow the [official doc](https://github.com/kubernetes-sigs/kubespray/blob/master/docs/vagrant.md) to custimize vagrant config
- Make sure `kubectl_localhost` is set to `False` in Vagrantfile
- Comment `kube_image_repo` and set `gcr_image_repo` to `gcr.azk8s.cn` in `group_vars/k8s-cluster/k8s-cluster.yml` if having trouble with `gcr.io`
- Fire Vagrant up

See [AKS on Azure China Best Practices](https://github.com/Azure/container-service-for-azure-china/tree/master/aks) if you are in China.

## HA Apiserver Endpoint

We use ha-proxy to achieve HA mode. See [HA endpoints for K8s](https://github.com/kubernetes-sigs/kubespray/blob/master/docs/ha-mode.md).

- Set ip of master nodes in haproxy configuration file
- Start `haproxy` in docker compose

## Storage Class

### Glusterfs/Heketi

Since in-cluster glusterfs may fail if you shutdown some gluster node, we choose standalone deployment.

- Config nodes, disks, ip in Vagrantfile; make sure gluster nodes share *the same* private network with k8s nodes
- Set `topology.json` accordingly and load the topology after starting `heketi` in docker compose
- Install `glusterfs-client` to all k8s nodes using galaxy [glusterfs](https://galaxy.ansible.com/geerlingguy/glusterfs)
- Create glusterfs storage class

See `Standalone` in [Heketi Demos](https://github.com/heketi/vagrant-heketi) for further details.

### NFS

For simplicity we can also choose NFS as the storage.

- Config NFS server on the host; make sure all k8s nodes are able to mount nfs
- For security reason, the `nfs.path` should have perm 1777 and belong to `nobody:nogroup`
- Install nfs client to all k8s nodes
- Check [Kubernetes NFS-Client Provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client) to set up

## LoadBalancer for Bare Metal

If services are going to exposed out of the cluster, you may need [MetalLB](https://metallb.universe.tf).

- Install [Helm](https://helm.sh)
- Install [nginx](https://github.com/helm/charts/tree/master/stable/nginx-ingress) and [metalb](https://github.com/helm/charts/tree/master/stable/metallb) using helm
- [Cert-manger](https://docs.cert-manager.io/en/latest/index.html) might be helpful for public services; check out the [officail repo](https://github.com/jetstack/cert-manager/tree/master/deploy)
- Update ingress controller ip in haproxy configuration file to match the external ip, which is given by metalb and using by nginx service, and then restart `haproxy` in docker compose
