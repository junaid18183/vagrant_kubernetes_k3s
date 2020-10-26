# -*- mode: ruby -*-
# vi: set ft=ruby :

# This script to install Kubernetes will get executed after we have provisioned the box
$script = <<-SCRIPT
> /vagrant/kubeconfig.yml
cp /vagrant/bin/* /usr/local/bin/

mkdir -p /var/lib/rancher/k3s/agent/images
cp /vagrant/docker_images/*.tar /var/lib/rancher/k3s/agent/images/
cp /vagrant/docker_images/*/*.tar /var/lib/rancher/k3s/agent/images/

INSTALL_K3S_SKIP_DOWNLOAD=true /vagrant/bin/install-k3s.sh server --tls-san tiber --write-kubeconfig-mode=644 --flannel-iface=eth1 --node-ip=172.28.128.4

echo "alias k=/usr/local/bin/kubectl" >> /etc/profile.d/sh.local
echo "alias docker='sudo /usr/local/bin/k3s crictl'" >> /etc/profile.d/sh.local

mkdir -p /home/vagrant/.kube/
mkdir -p /root/.kube/

cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config && chown vagrant:vagrant /home/vagrant/.kube/config
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
cp /etc/rancher/k3s/k3s.yaml /vagrant/kubeconfig.yml

sed -i 's|127.0.0.1|172.28.128.4|g' /vagrant/kubeconfig.yml
sed -i 's|default|k3s-tiber|g' /vagrant/kubeconfig.yml

SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7"
  config.vm.hostname = "tiber"
  config.vm.network "private_network", ip: "172.28.128.4"
  config.vm.provision "shell", inline: $script
  config.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
   end
  config.vm.synced_folder git_dir=ENV['SHARED_CODE'] || ENV['HOME']+"work/git", "/home/vagrant/git"
end
