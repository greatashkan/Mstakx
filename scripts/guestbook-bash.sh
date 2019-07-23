#!/bion/bash
	 mkdir -p $HOME/.kube \
	       && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config \
	       && sudo chown $(id -u):$(id -g) $HOME/.kube/config \
               && kubectl create namespace staging && kubectl create namespace production \
	       && kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml -n staging \
               && kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml -n production \
	       && kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml -n staging \
               && kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml -n production \
	       && kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/guestbook/redis-slave-deployment.yaml -n staging \
               && kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/guestbook/redis-slave-deployment.yaml -n production \
	       && kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/guestbook/redis-slave-deployment.yaml -n staging \
	       && kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/guestbook/redis-slave-deployment.yaml -n production \
	       && kubectl  apply -f https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/guestbook/frontend-deployment.yaml -n staging \
	       && kubectl  apply -f https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/guestbook/frontend-deployment.yaml -n production \
	       && kubectl apply -f frontend-ingress-staging.yaml -n staging \
	       && kubectl apply -f frontend-ingress-staging.yaml -n production
