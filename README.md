# k3s_vagrant_faas_demo

## Dependancies

##### Vagrant - 

Install vagrant

Vagarnt box - This vagant box is based on `bento/centos-7` so better to download that before hand.

##### Task - 

Download the task. [Refer](https://taskfile.dev/#/installation) the installation document.  If you are on Mac its simply running 

```
brew install go-task/tap/go-task
```

##### Verify the task list

```
$ task -l
task: Available tasks for this project:
* app:deploy:kubeless: 		Deploy the kubeless on this vagrant box
* app:destroy:kubeless: 	Destory the kubeless on this vagrant box
* build:download_images: 	Downloads the docker images for offline usage
* infra:deploy: 		Starts the Vagrant box and installs single node k8s
* infra:destroy: 		Destroy the vagrant box.
```

Download the following binaries at the  in `bin/` directory.  

**fission** 

**kubeless**

**fass-cli**



Accessing the cluster 

The `infra:deploy` will create a kubeconfig file at ./kubeconfig.yml. 

If you want to access the k8s cluser from your host machine set the KUBECONFIG environment variable.

```
export KUBECONFIG=kubeconfig.yml
```

You can then run the `kubectl` commands from either your host machine or vagrant box. To run from the vagrant box, you need to ssh to it using `vagrant ssh`



# Offline Images

##### To speed up the installation and to avoid downloading docker images each time vagrant box starts.

There is optional `build:download_images` task which will download all of the required docker images and saves them as .tar

You can run this **first time** to download the images. 

```
[k3s_vagrant_faas_demo]$ task build:download_images
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

To deploy the Vagrant box , run the  command  `task infra:deploy` 

```
$ task infra:deploy

Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'bento/centos-7'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'bento/centos-7' is up to date...
==> default: A newer version of the box 'bento/centos-7' for provider 'virtualbox' is
==> default: available! You currently have version '201812.27.0'. The latest is version
==> default: '202004.15.0'. Run `vagrant box update` to update.
==> default: Setting the name of the VM: k3s_vagrant_faas_demo_default_1587819244181_26592
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
    default: Adapter 2: hostonly
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
==> default: Setting hostname...
==> default: Configuring and enabling network interfaces...
==> default: Mounting shared folders...
    default: /vagrant => /Users/jmemon/work/git/vagrant_boxes/k3s_vagrant_faas_demo
    default: /home/vagrant/git => /Users/jmemon/work/git
==> default: Running provisioner: shell...
    default: Running: inline script
    default: [INFO]  Skipping k3s download and verify
    default: [INFO]  Creating /usr/local/bin/kubectl symlink to k3s
    default: [INFO]  Creating /usr/local/bin/crictl symlink to k3s
    default: [INFO]  Creating uninstall script /usr/local/bin/k3s-uninstall.sh
    default: [INFO]  systemd: Creating environment file /etc/systemd/system/k3s.service.env
    default: [INFO]  systemd: Creating service file /etc/systemd/system/k3s.service
    default: [INFO]  systemd: Enabling k3s unit
    default: Created symlink from /etc/systemd/system/multi-user.target.wants/k3s.service to /etc/systemd/system/k3s.service.
    default: [INFO]  systemd: Starting k3s
    default: namespace/kubeless created
    default: namespace/fission created
    default: namespace/openfaas created
    default: namespace/openfaas-fn created
NAME                           STATUS   ROLES    AGE   VERSION
ip-10-64-12-208.ec2.internal   Ready    master   23h   v1.15.3
```



## Destroy 

To destoy the Vagrant box  , run the  command  `task infra:destroy` 

```
$ task infra:destroy
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
```



------

# FAAS Frameworks

# Fission 

##### Install Fission

To install the fission run the rake task `task app:deploy:fission`

##### Check the status of fission deployment

Login to vagrant box. `vagrant ssh`

```
[vagrant@tiber ~]$ kubectl get pods -n fission

```

```
task app:deploy:fission
namespace/fission-function unchanged
namespace/fission-builder unchanged
clusterrole.rbac.authorization.k8s.io/secret-configmap-getter unchanged
clusterrole.rbac.authorization.k8s.io/package-getter unchanged
serviceaccount/fission-svc unchanged
rolebinding.rbac.authorization.k8s.io/fission-admin unchanged
clusterrolebinding.rbac.authorization.k8s.io/fission-crd unchanged
serviceaccount/fission-fetcher unchanged
serviceaccount/fission-builder unchanged
configmap/feature-config unchanged
deployment.apps/controller configured
deployment.apps/executor configured
deployment.apps/buildermgr configured
deployment.apps/kubewatcher configured
deployment.apps/timer configured
deployment.apps/storagesvc configured
persistentvolumeclaim/fission-storage-pvc unchanged
service/router unchanged
service/controller unchanged
service/storagesvc unchanged
service/executor unchanged
deployment.apps/router configured
job.batch/fission-1-8-0-fission-co-1.8.0-182 configured
job.batch/fission-1-8-0-fission-co-1.8.0-480 unchanged

```

##### Check the status of fission deployment

Login to vagrant box. `vagrant ssh`

```
[vagrant@tiber ~]$ kubectl get pods -n fission
NAME                                       READY   STATUS      RESTARTS   AGE
fission-1-8-0-fission-co-1.8.0-480-8qnht   0/1     Completed   0          77s
buildermgr-77798686b9-wnmmz                1/1     Running     0          78s
executor-6c848fd97b-xt2fm                  1/1     Running     0          78s
router-dd6bbfdcb-2jsqj                     1/1     Running     0          77s
controller-7c74dd9695-l9v52                1/1     Running     0          78s
kubewatcher-6b55dfcfff-xb6x5               1/1     Running     1          78s
timer-dfbdc8489-rlxch                      1/1     Running     1          78s
fission-1-8-0-fission-co-1.8.0-182-nn48l   0/1     Completed   0          77s
storagesvc-7877594985-qb4kn                1/1     Running     0          78s
```

**Wait till pods are in running status.  Its fine to `storagesvc` pod to be in pending status.**

##### Create  Python  environment

```
/usr/local/bin/fission environment create --name python --image fission/python-env
```

Check the pods in fission_function namespace 

```
[vagrant@tiber ~]$ kubectl get pods -n fission-function
NAME                                         READY   STATUS    RESTARTS   AGE
poolmgr-python-default-903-fd7c84b7b-7592x   2/2     Running   0          44s
poolmgr-python-default-903-fd7c84b7b-cj8dl   2/2     Running   0          44s
poolmgr-python-default-903-fd7c84b7b-jrlqd   2/2     Running   0          44s
```

##### Create the first function

```
fission function create --name hello-fission --env python --code /vagrant/demo_functions/fission_demo.py
```

Check k8s function resource

```
kubectl get functions
```

##### Test the sample function

Test using fission CLI

```
fission function test --name hello-fission
```

Add a route to expose the function 

```
fission route create --method GET --url /fission_demo --function hello-fission
```

Test the function using exposed route/Ingress 

```
NODEPORT=$(kubectl --namespace fission get svc router -o=jsonpath='{..nodePort}')
curl 172.28.128.4:$NODEPORT/fission_demo
```

*This curl  will also work from your laptop , since we are using NodePort service*

##### Clean-up

To destroy the fission, run the task `app:destroy:fission`

```
task app:destroy:fission
```



# Kubeless 

##### Install kubeless 

Run the `task app:deploy:kubeles` task

**Confirm all pods are running** 

Login to vagrant box. `vagrant ssh`

```
kubectl get pods -n kubeless
NAME                                           READY   STATUS    RESTARTS   AGE
kubeless-controller-manager-57d495575b-l95sc   3/3     Running   0          4m30s
```



##### Create the first function 

```
/usr/local/bin/kubeless function deploy hello --runtime python2.7  --from-file /vagrant/demo_functions/kubeless_demo.py --handler test.hello --image-pull-policy IfNotPresent
```

Confirm the function pods are in running state 

```
[vagrant@tiber knative]$ k get pods
NAME                     READY   STATUS    RESTARTS   AGE
hello-7ccb949d98-5gx7m   1/1     Running   0          21s
```

Check the state of the function, using both kubectl and kubeless cli 

```
[vagrant@tiber kubeless_faas_install]$ kubeless function ls
NAME 	NAMESPACE	HANDLER   	RUNTIME  	DEPENDENCIES	STATUS
hello	default  	test.hello	python2.7	            	1/1 READY
[vagrant@tiber kubeless_faas_install]$ kubectl get function
NAME    AGE
hello   92s
```

##### Test the function 

Using the kubeless cli 

```
kubeless function call hello --data 'Hello world!'
```

Add the ingress and check the status 

```
[vagrant@tiber ~]$ kubeless trigger http create kubeless-hello --function-name hello --hostname faas.ijuned.com

[vagrant@tiber ~]$ k get ing
NAME             HOSTS             ADDRESS        PORTS   AGE
kubeless-hello   faas.ijuned.com   172.28.128.4   80      4s
```

Test the function using curl 

```
curl  -H 'Host: faas.ijuned.com' --data 'Hello world!' http://172.28.128.4
```



##### Cleanup 

```
task app:destroy:kubeless
```



# OpenFaas

##### Install OpenFaas

```
/usr/local/bin/kubectl apply -f /vagrant/config/openfaas-5.4.1-install.yaml
```

Confirm all pods running 

```
[vagrant@tiber docker_images]$ k get pods -n openfaas
NAME                                 READY   STATUS    RESTARTS   AGE
nats-6775fc6c6c-npw66                1/1     Running   0          40s
basic-auth-plugin-5565697c9b-fnzls   1/1     Running   0          40s
queue-worker-767b4c7469-tt9gh        1/1     Running   0          39s
prometheus-7485f5bdd8-p9tkf          1/1     Running   0          39s
alertmanager-78fbdb95bb-t5slc        1/1     Running   0          40s
gateway-58786d8fc8-4h6ll             2/2     Running   0          40s
faas-idler-9d84bf69b-9wf8c           1/1     Running   2          40s
```

Get the NodePort 

```
NODEPORT=$(kubectl get svc gateway-external  -n openfaas -o=jsonpath='{..nodePort}')
```

The UI will be available at `<http://172.28.128.4:$NODEPORT/ui/>`



Credentails for the UI or faas-cli will be 

```
USER=$(k get secret basic-auth -o jsonpath='{.data.basic-auth-user}' -n openfaas | base64 --decode)

PASSWD=$(k get secret basic-auth -o jsonpath='{.data.basic-auth-password}' -n openfaas | base64 --decode)

echo "user is $USER and password is $PASSWD for openfaas UI"
```



Login to faas-cli

```
faas-cli login --password $PASSWD --gateway 172.28.128.4:$NODEPORT
```



##### Cleanup 

```
/usr/local/bin/kubectl delete -f /vagrant/config/openfaas-5.4.1-install.yaml
```



# KNative

```
k apply -f /vagrant/config/knative/serving-crds.yaml -f /vagrant/config/knative/serving-core.yaml -f /vagrant/config/knative/kourier.yaml
```

Kourier only exposes ingresses that have the “kourier” ingress class. By default Knative annotates all the ingresses for Istio but you can change that by patching the “config-network” configmap as follows:

```
kubectl patch configmap/config-network \
  -n knative-serving \
  --type merge \
  -p '{"data":{"ingress.class":"kourier.ingress.networking.knative.dev"}}'
```

Confirm the pods are in running status 

```
[vagrant@tiber knative]$ k get pods -n knative-serving
NAME                          READY   STATUS    RESTARTS   AGE
webhook-6cf777df8c-26lpk      1/1     Running   0          29s
controller-68ffd44c88-mbnlk   1/1     Running   0          29s
autoscaler-687f68c656-2qflb   1/1     Running   0          29s
activator-66f9c58f8f-8n2pt    1/1     Running   0          29s

[vagrant@tiber knative]$ k get pods -n kourier-system
NAME                                      READY   STATUS         RESTARTS   AGE
3scale-kourier-control-794b8b9b4f-z8sjt   1/1     Running        0          32s
3scale-kourier-gateway-567b5b495d-d5hxd   0/1     Running        0          34s
```

##### Create the first function

For knative functions you need to package your application as a docker image and push it to dockcer registry.  For sample code see the files at `demo_functions/knative_demo/` 

Using those files you have to build and push  the docker image to dockcer registry . 



##### Build the push the docker image

*just change the `service.yaml` with your docker-hub username.* 

```
cd demo_functions/knative_demo/
docker build -t docker.io/junaid18183/knative-demo-python .
docker push junaid18183/knative-demo-python:latest
```

##### For the offline running

knative contoller by default resolve image tags to sha-digests in order to better guarantee immutability of Revisions. This step can be skipped for images prefixed with `dev.local` or `ko.local`  as explained [here](https://github.com/knative/serving/issues/6101). 

So you can re-tag the image as dev.local 

```
docker tag docker.io/junaid18183/knative-demo-python:latest dev.local/junaid18183/knative-demo-python:latest

docker save dev.local/junaid18183/knative-demo-python:latest > docker_images/junaid18183_knative-demo-python_latest.tar
```

and include the `dev.local/junaid18183/knative-demo-python:latest` in the `docker_images/docker_images_list.txt` file. So that the vagrant box will have that image post start up.

Additionaly I have added the `imagePullPolicy: Never` in the service.yaml file to avoid downloading at run time.

##### Deploy the function

After the build has completed and the container is pushed to docker hub, you can deploy the app into your cluster. Ensure that the container image value in service.yaml matches the container you built in the previous step. Apply the configuration using kubectl

```
k apply -f /vagrant/demo_functions/knative_demo/app/service.yaml
```

**Check the ksvc** 

```
[vagrant@tiber ~]$ k get ksvc
NAME                  URL                                              LATESTCREATED               LATESTREADY                 READY   REASON
knative-demo-python   http://knative-demo-python.default.example.com   knative-demo-python-bw9cw   knative-demo-python-bw9cw   True
```

Get the NodePort 

```
NODEPORT=$(kubectl get svc kourier -n kourier-system -o=jsonpath='{.spec.ports[0].nodePort}')
```


Test the Function

```
curl -k -H 'Host: knative-demo-python.default.example.com' http://172.28.128.4:$NODEPORT
```



##### Clean-up

```
k delete -f /vagrant/demo_functions/knative_demo/app/service.yaml

k delete -f /vagrant/config/knative/serving-crds.yaml -f /vagrant/config/knative/serving-core.yaml -f /vagrant/config/knative/kourier.yaml
```
