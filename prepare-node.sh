#!/bin/sh
sudo apt-get update \ 
	&& sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common \ 
	&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \ 
	&& sudo add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	      $(lsb_release -cs) \
	         stable" \
	&& apt-get update \ 
	&& apt-get install docker-ce docker-ce-cli containerd.io \
	&& systemctl start docker \ 
	&& sleep 3 \
	&& systemctl enable docker \
        && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
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
	
               

