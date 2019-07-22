#!/bin/bash
bash docker-bash.sh \
	&& bash k8s-bash.sh \
	&& bash prepare-node.sh \
	&& bash k8s-init-bash.sh  \
	&& bash ingress-deploy.sh  \
	&& bash guestbook-bash.sh \
	&& bash autoscaler
