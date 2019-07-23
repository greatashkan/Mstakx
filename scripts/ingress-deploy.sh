#!/bin/bash
         mkdir -p $HOME/.kube \
               && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config \
               && sudo chown $(id -u):$(id -g) $HOME/.kube/config \
	       && kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml \
	       && kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/service-nodeport.yaml 
