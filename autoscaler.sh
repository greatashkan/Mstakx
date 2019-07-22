#!/bin/bash
              mkdir -p $HOME/.kube \
                && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config \
                && sudo chown $(id -u):$(id -g) $HOME/.kube/config \
		&& kubectl autoscale deployment frontend --cpu-percent=50 --min=3 --max=6 -n staging \
		&& kubectl autoscale deployment frontend --cpu-percent=50 --min=3 --max=6 -n production
