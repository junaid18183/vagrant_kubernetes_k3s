# k3s_vagrant_faas_demo

## Introduction 

This is a sample vagrant box , which will help you to start the single node kubernetes cluser using [k3s](https://github.com/rancher/k3s)

It also have configuration to install and configure the  FAAS frameworks with very simple `task` command.

- kubeless

- fission

- openfass

- knative

with their sample hello-world example. 

It  will help you to quick-start working on serverless functions on any of these framewroks in no time. 

Ideal for local development. 

Bonus, it also supports complete offline operation by downloading all required docker images. So that you not waste time to download them every time.

I am using this to evalute those four serverless framework, and come up with [comparision](./docs/comparision-faas.md)

The kubernetes installation is also accessible from your host machine. You just needs to export the `KUBECONFIG=kubeconfig.yml` environment variable. 

This gives a complete experience of working with remote cluster.

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
$ task -l
task: Available tasks for this project:
* app:deploy:all: 		    Deploy all of the faas frameworks
* app:deploy:fission: 		Deploy the kubeless on this vagrant box
* app:deploy:knative: 		Deploy the knative on this vagrant box
* app:deploy:kubeless: 		Deploy the kubeless on this vagrant box
* app:deploy:openfaas: 		Deploy the openfaas on this vagrant box
* app:destroy:all: 		    Destroy all of the faas frameworks
* app:destroy:fission: 		Destory the kubeless on this vagrant box
* app:destroy:knative: 		Destory the knative on this vagrant box
* app:destroy:kubeless: 	Destory the kubeless on this vagrant box
* app:destroy:openfaas: 	Destory the openfaas on this vagrant box
* build:binary: 		      Download the required binaries
* build:download_images: 	Downloads the docker images for offline usage
* infra:deploy: 		      Starts the Vagrant box and installs single node k8s
* infra:destroy: 		      Destroy the vagrant box.
```

Download the following binaries at the  in `bin/` directory.  So that you can use then within vagrant box. Or you can install them on your host machine as well.

**fission** -  Official install [document](https://docs.fission.io/docs/installation/#install-fission-cli) 

**kubeless** -  Official release [page](https://github.com/kubeless/kubeless/releases) 

**fass-cli** - Official release [page](https://github.com/openfaas/faas-cli/releases)



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
image already saved at docker_images/fission_alpinecurl_latest.tar
image already saved at docker_images/fission_fission-bundle_1.8.0.tar
image already saved at docker_images/fission_pre-upgrade-checks_1.8.0.tar
image already saved at docker_images/fission_python-env_latest.tar
image already saved at docker_images/fission_fetcher_1.8.0.tar
image already saved at docker_images/kubeless_cronjob-trigger-controller_v1.0.1.tar
image already saved at docker_images/kubeless_function-controller_v1.0.6.tar
image already saved at docker_images/kubeless_http-trigger-controller_v1.0.1.tar
image already saved at docker_images/openfaas_faas-idler_0.2.1.tar
image already saved at docker_images/nats-streaming_0.11.2.tar
image already saved at docker_images/openfaas_basic-auth-plugin_0.17.0.tar
image already saved at docker_images/openfaas_faas-netes_0.9.15.tar
image already saved at docker_images/openfaas_gateway_0.18.7.tar
image already saved at docker_images/openfaas_queue-worker_0.9.0.tar
image already saved at docker_images/prom_alertmanager_v0.18.0.tar
image already saved at docker_images/prom_prometheus_v2.11.0.tar
image already saved at docker_images/kubeless_unzip_latest.tar
image already saved at docker_images/kubeless_python_2.7.tar
image already saved at docker_images/knative-releases_knative.dev_eventing_cmd_controller_v0.14.0.tar
image already saved at docker_images/knative-releases_knative.dev_eventing_cmd_webhook_v0.14.0.tar
image already saved at docker_images/knative-releases_knative.dev_serving_cmd_activator_v0.14.0.tar
image already saved at docker_images/knative-releases_knative.dev_serving_cmd_autoscaler_v0.14.0.tar
image already saved at docker_images/knative-releases_knative.dev_serving_cmd_controller_v0.14.0.tar
image already saved at docker_images/knative-releases_knative.dev_serving_cmd_webhook_v0.14.0.tar
image already saved at docker_images/knative-releases_knative.dev_net-kourier_cmd_kourier_v0.14.0.tar
image already saved at docker_images/knative-releases_knative.dev_serving_cmd_queue_v0.14.0.tar
image already saved at docker_images/maistra_proxyv2-ubi8_1.0.8.tar
image already saved at docker_images/junaid18183_knative-demo-python_latest.tar
image already saved at docker_images/junaid18183_openfass-python-demo_latest.tar
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


## FAAS framework deployment

The project provides a simple `app:deploy:all` task to deploy all four serverless faas framework. 

but installing all four of them would be resource intensive, beside some the functionality will collide with each other e.g. fission and kubeless both have crd object with name `function` which might not work with one of them if all are deployed. 

So for optimal performance install any one of them at a time , and procees to deploy their specific hello-world function.

The installation and removal of any of those serverless faas framework is as simple as running any of the following `task` commands 

```
* app:deploy:fission: 		Deploy the kubeless on this vagrant box
* app:deploy:knative: 		Deploy the knative on this vagrant box
* app:deploy:kubeless: 		Deploy the kubeless on this vagrant box
* app:deploy:openfaas: 		Deploy the openfaas on this vagrant box

* app:destroy:fission: 		Destory the kubeless on this vagrant box
* app:destroy:knative: 		Destory the knative on this vagrant box
* app:destroy:kubeless: 	Destory the kubeless on this vagrant box
* app:destroy:openfaas: 	Destory the openfaas on this vagrant box
```

For details on each framework on installation and running first function refer - 

- [kubeless](./docs/kubeless.md) 
- [fission](./docs/fission.md)
- [openfaas](./docs/openfaas.md)
- [knative](./docs/knativd.md)

Finally find the [comparision-faas.md](./docs/comparision-faas.md) to understand the differences pros and cons of each of the above serverless faas frameworks.
