#!/bin/bash
        kubeadm init --pod-network-cidr=10.244.0.0/16 \
        && sudo kubeadm token create --print-join-command > joincommand \ 
	&& ssh infra@172.16.161.181 -pGJH^*&234@ $joincommand
