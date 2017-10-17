#!/usr/bin/env bash

LXD_CONTAINER=$1

SSH_KEY=.deploy/keys/key_$LXD_CONTAINER


#sudo lxc launch ubuntu:16.04 k8sworker -c security.privileged=true -c security.nesting=true -c linux.kernel_modules=ip_tables,ip6_tables,netlink_diag,nf_nat,overlay -c raw.lxc=lxc.aa_profile=unconfined
#sudo lxc config device add k8sworker mem unix-char path=/dev/mem

mkdir -p .deploy/keys
rm -f $SSH_KEY
ssh-keygen -b 4096 -P "" -f $SSH_KEY
sudo lxc exec $LXD_CONTAINER -- apt update
sudo lxc exec $LXD_CONTAINER -- apt install -y python openssh-server
sudo lxc exec $LXD_CONTAINER -- mkdir -p /root/.ssh
sudo lxc file push $SSH_KEY.pub $LXD_CONTAINER/root/.ssh/authorized_keys
sudo lxc exec $LXD_CONTAINER -- chmod 700 /root/.ssh
sudo lxc exec $LXD_CONTAINER -- chmod 600 /root/.ssh/authorized_keys
sudo lxc exec $LXD_CONTAINER -- chown -R root:root /root/.ssh

sudo lxc profile show mod_br_netfilter
if [ "$?" != "0" ]; then
	sudo lxc profile create mod_br_netfilter
	sudo lxc profile set mod_br_netfilter linux.kernel_modules "bridge, br_netfilter, overlay, nf_nat"
	sudo lxc profile show mod_br_netfilter
fi

sudo lxc profile show mod_br_netfilter | grep $LXD_CONTAINER
if [ "$?" != "0" ]; then
	sudo lxc profile add $LXD_CONTAINER mod_br_netfilter
	sudo lxc restart $LXD_CONTAINER
fi

