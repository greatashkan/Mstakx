#!/bin/bash
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
	&& cat deb https://apt.kubernetes.io/ kubernetes-xenial main >> /etc/apt/sources.list.d/kubernetes.list \
	&& apt-get update \ 
	&& apt-get install -y kubelet kubeadm kubectl \ 
	&& systemctl enable kubelet \
	&& apt-mark hold kubelet kubeadm kubectl \ 
	&& sysctl net.bridge.bridge-nf-call-iptables=1 \
        && swapoff -a \
        && sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
        && Systemctl disable firewalld \
        && Systemctl stop firewalld \
	&& mkdir -p $HOME/.kube \
	&& sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config \
	&& sudo chown $(id -u):$(id -g) $HOME/.kube/config \
	&& kubectl apply f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml
	
               

