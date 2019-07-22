# Install K8S baremetal

## Docker installation

First you need to install Docker.
Update the OS

```bash
sudo apt-get update:
```
Install packages to allow apt to use a repository over HTTPS:
```
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
```
Add Dockers official GPG key:
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
Add the repository:
```
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```
Update the apt package index with the latest repo:
```
apt-get update
```
Install the latest version of Docker CE and containerd, or go to the next step to install a specific version:
```
apt-get install docker-ce docker-ce-cli containerd.io

```

Enable Docker and do some configs for 
```
systemctl enable docker
systemctl start docker
```
Test it is working:
```
sudo docker run hello-world
```

#Kubernetes components install:

Add the repo of K8S:
```
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

```
Update the OS.

Install the main components and enable kubelet:
```
apt-get install -y kubelet kubeadm kubectl
systemctl enable kubelet
```
Add the components to hold state in order to not automatic updating of them:
```
apt-mark hold kubelet kubeadm kubectl
```

Do the following config to use Kubernetes properly:
```
sysctl net.bridge.bridge-nf-call-iptables=1
swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
Systemctl disable firewalld
Systemctl stop firewalld
```
## Initialize the Kubernetes cluster with the default Flannel:
```
kubeadm init --pod-network-cidr=10.244.0.0/16
```
Copy the join command at the end of the init process for join of other nodes to the master:
```
kubeadm join 172.16.161.180:6443 --token 10wx8b.lpsjg6ngpml9jqrt 
--discovery-token-ca-cert-hash sha256:
eae821ae6a70f1620a9e7fca9fdce6c49ff6da1af76f1d616e73f90eb06e2d1e
```

If you want to use access the cluster withe the root user use the following:
```
export KUBECONFIG=/etc/kubernetes/admin.conf
```
To use the kubernetes with other users that root do the following:
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
## Join the other nodes to the master:
Install Docker and Kubernetes on this node. And paste the join command 


Now the state of the nodes is "not ready". You have to apply CNI configurations to k8s:
```
kubectl apply f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml
```
now the cluster is ready and the node is joined.

Check that the nodes are up and running:
```
kubectl get nodes
```

## Starting the tests
### Install Ingress controller:
Apply the ingress yaml file. download it or apply it directly. First create the deployment:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
```
Now create the Nodeport of nginx ingress:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/service-nodeport.yaml
```

### Start the guestbook

You can follow the guide from the below link:
https://kubernetes.io/docs/tutorials/stateless-application/guestbook/

Create namespaces before starting the deployments:
```
kubectl create namespace staging

kubectl create namespace production
```

### Create the Redis Master Deployment in both namespaces:
```
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml -n staging

kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml -n staging
```
Run the following command to view the logs from the Redis Master Pod:

```
kubectl logs -f POD-NAME
```

### Creating the Redis Master Service
```
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml -n staging

kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml -n production
```
Check if teh services are running:
```
kubectl get service -n staging
```
### Create the Redis Slave Deplyoment
```
https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/guestbook/redis-slave-deployment.yaml

kubectl apply f redis-slave-deployment.yaml n staging 

kubectl apply -f redis-slave-deployment.yaml -n production
```
And deploy the Slave Services:
```
kubectl apply -f redis-slave-service.yaml -n staging

kubectl apply -f redis-slave-service.yaml -n production

```

### Create the Frontend Deployment
```
wget  https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/guestbook/frontend-deployment.yaml

kubectl  apply -f frontend-deployment.yaml -n staging

kubectl  apply -f frontend-deployment.yaml -n production
```

### Create ingress:
Write the ingress yaml file and apply it:
```
kubectl apply -f frontend-ingress-staging.yaml -n staging

kubectl apply -f frontend-ingress-staging.yaml -n production
```
Check if the ingress is working:
```
curl -H "Host: production-guestbook.mstakx.io" 172.16.161.180:Nginx Port

curl -H "Host: production-guestbook.mstakx.io" 172.16.161.180:Nginx Port
```

### Auto scale the pods:
Run the autoscale against the deployments of Frontend. This is going to autoscale the pods according to the cpu usage:
```
kubectl autoscale deployment frontend --cpu-percent=50 --min=3 --max=6 -n staging

kubectl autoscale deployment frontend --cpu-percent=50 --min=3 --max=6 -n production
```
see if the Autoscaler is running:
```
kubectl get hpa -n staging   
```

### Script for the Pods autoscale change:
```
#!/bin/bash
export KUBECONFIG=/etc/kubernetes/admin.conf
watch -d -n1 'kubectl describe hpa -n staging | grep "Name:" -A 1 && kubectl describe hpa -n staging | grep "Min replicas:" -A 2'
```





