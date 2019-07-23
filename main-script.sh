#!/bin/bash
bash scrips/docker-bash.sh \
	&& bash scrips/k8s-bash.sh \
	&& bash scrips/prepare-node.sh \
	&& bash scrips/k8s-init-bash.sh  \
	&& bash scrips/ingress-deploy.sh  \
	&& bash scrips/guestbook-bash.sh \
	&& bash scrips/autoscaler
