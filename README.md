# k3s_vagrant_faas_demo

## Introduction 

This is a sample vagrant box , which will help you to start the single node kubernetes cluser using [k3s](https://github.com/rancher/k3s)

## Dependancies

##### Vagrant - 

Install vagrant - Refer the official installation [document](https://www.vagrantup.com/docs/installation/).

Vagarnt box - This vagant box is based on `bento/centos-7` so better to download that before hand.

##### Task - 

Install the task. Refer the official installation [document](https://taskfile.dev/#/installation) the installation document.  If you are on Mac its simply running 

```
brew install go-task/tap/go-task
```

##### Verify the task list

```
task: Available tasks for this project:
* build:binary: 		Download the required binaries
* build:download_images: 	Downloads the docker images for offline usage
* infra:deploy: 		Starts the Vagrant box and installs single node k8s
* infra:destroy: 		Destroy the vagrant box.
```

##### Accessing the cluster 

The `infra:deploy` will create a kubeconfig file at ./kubeconfig.yml. 

If you want to access the k8s cluser from your host machine set the KUBECONFIG environment variable.

```
export KUBECONFIG=kubeconfig.yml
```

You can then run the `kubectl` commands from either your host machine or vagrant box. 

To run from the vagrant box, you need to ssh to it using `vagrant ssh`



# Offline Images

##### To speed up the installation and to avoid downloading docker images each time vagrant box starts.

There is optional `build:download_images` task which will download all of the required docker images and saves them as .tar

You can run this **first time** to download the images. 

```
$ task build:download_images
```



## Deploy

To deploy the Vagrant box , run the  command  `infra:deploy` 

```
$ task infra:deploy
```



## Destroy 

To destoy the Vagrant box  , run the  command  `infra:destroy` 

```
$ task infra:destroy
```

# How to use

Start the vagrant box

`vagrant up` or `task infra:deploy`

if you want to access the cluser from your local host machine, You can access by 
```
export KUBECONFIG=kubeconfig.yml
kubectl get nodes
```
Provided you have `kubectl` available on your machine.

If you want to work from within the vagrant box, SSH it 

```
vagrant ssh
```

Once in vagrant box you do not need to download the `docker` and `kubectl` as those are readily avialble for you.