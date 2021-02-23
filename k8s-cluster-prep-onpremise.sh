## K8S CLUSTER SETUP ON-PREMISE
## SOURCES: 
## https://medium.com/@fromprasath/setup-kubernetes-cluster-using-kubeadm-in-vsphere-virtual-machines-985372ee5b97
## https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
## https://rudimartinsen.com/2020/08/08/setting-up-a-kubernetes-cluster-vms/
##

# Enable ssh on the machines
sudo apt-get install openssh-server -y

# Disable swap on the virtual machines
sudo swapoff -a

# Install necessary Packages
sudo apt-get update && sudo apt-get install -y apt-transport-https curl gnupg vim htop

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# kubeadm, kubectl and kubelet installation
sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl

# After installing the above packages, let us hold them
sudo apt-mark hold kubelet kubeadm kubectl

# Install Container Runtime
sudo apt-get install docker.io -y

# Enable docker on startup
sudo systemctl enable docker.service

##
## MASTER CONFIG
##

# Setup hostname(Optional)
sudo hostnamectl set-hostname k8s-master

#Setup control-plane hostname
sudo vi /etc/hosts

# Install Control plane
kubeadm init  --control-plane-endpoint k8s-master:6443 --pod-network-cidr=192.168.2.0/16

# SOURCE: https://kubernetes.io/docs/setup/production-environment/container-runtimes/#cgroup-drivers
# Change the Docker cgroup driver

# Accessing the cluster
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Set up shell completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
source <(kubectl completion bash)

# Install Pod network add-on
curl https://docs.projectcalico.org/manifests/calico.yaml -O

# Find the CALICO_IPV4POOL_CIDR variable in the yaml file and replace the value with the same subnet you used in the kubeadm init command
vi calico.yaml

<<EOF
- name: CALICO_IPV4POOL_CIDR
  value: "192.168.2.0/16"
EOF

# Now let's install Calico in our cluster
kubectl apply -f calico.yaml

# Verify current state
kubectl get nodes

##
## NODES CONFIG
##

#Setup control-plane hostname
sudo vi /etc/hosts

## SOURCES: 
## https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#join-nodes
## https://rudimartinsen.com/2020/08/08/setting-up-a-kubernetes-cluster-vms/#update-2020-12-30---print-join-command
## Generate token and print join command
sudo kubeadm token generate
sudo kubeadm token create <TOKEN-FROM-GENERATE-STEP> --ttl 1h --print-join-command
# This will output the full kubeadm join command for a worker node

# Run kubeadm join
sudo kubeadm join --token <token> <control-plane-host>:<control-plane-port> --discovery-token-ca-cert-hash sha256:<hash>

# Verify
kubectl get nodes