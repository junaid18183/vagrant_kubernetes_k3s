# Offline docker images and binary

<u>This is one time task , not need to be done every time you do `vagrant up</u>`

##### Download the Airgap docker image

For working offline its better to avoid pulling images again and again. 

So download the offline k3s docker images from the [k3s repo](https://github.com/rancher/k3s/releases/download/v1.17.4%2Bk3s1/k3s-airgap-images-amd64.tar) to the `docker_images/k3s-airgap-images-amd64-v1.17.4.tar`



```
wget https://github.com/rancher/k3s/releases/download/v1.17.4%2Bk3s1/k3s-airgap-images-amd64.tar -O docker_images/k3s-airgap-images-amd64-v1.17.4.tar
```

##### Download all of the required docker images for FAAS frameworks.

There is a list of docker images which are required by FAAS frameworks, which we can pre-download and load it in Vagrant box

Image list  - `docker_images/docker_images_list.txt`

To Download those images run the script ***This is one time task. once you have downloaded the images no need to run this script again***

```
bash bin/save_docker_images.sh
```

I find the required docker images for offline using below method.


```
grep -w image ../config/fission-core-1.8.0.yaml | sort | uniq | awk -F ":" '{print $2}' | sed 's| ||g'>  docker_images_list.txt
grep -w image ../config/kubeless-v1.0.6.yaml | sort | uniq | grep -v "," | sed 's| ||g' | grep ^image >> docker_images_list.txt
grep -w image ../config/openfaas-5.4.1-install.yaml | sort | uniq | grep -v "," | sed 's| ||g' | grep ^image >> docker_images_list.txt
```
##### Download the Binary files of the FAAS tools

Just like we download the docker images , we can download the x86 binaries of following tools to the `bin` folder, which gets shared on Vagrant box.
	   

	fission
	helm
	k3s  - https://github.com/rancher/k3s/releases/download/v1.17.4%2Bk3s1/k3s
	kubeless
	faas-cli - wget https://github.com/openfaas/faas-cli/releases/download/0.12.2/faas-cli -O bin/faas-cli

Example 

```
wget https://github.com/rancher/k3s/releases/download/v1.17.4%2Bk3s1/k3s bin/k3s
wget https://github.com/openfaas/faas-cli/releases/download/0.12.2/faas-cli -O bin/faas-cli
```



# Start the Vagrant box

##### Start the Vagrant box and ssh to it

```
vagrant up
vagrant ssh


[vagrant@tiber ~]$ kubectl get nodes
NAME    STATUS   ROLES    AGE   VERSION
tiber   Ready    master   53s   v1.17.4+k3s1

[vagrant@tiber ~]$ kubectl get pods -n kube-system
NAME                                      READY   STATUS      RESTARTS   AGE
metrics-server-6d684c7b5-7xqr8            1/1     Running     0          76s
local-path-provisioner-58fb86bdfd-x4fg9   1/1     Running     0          76s
helm-install-traefik-blfhx                0/1     Completed   0          76s
svclb-traefik-jccfv                       2/2     Running     0          41s
coredns-6c6bb68b64-pmkpb                  1/1     Running     0          76s
traefik-7b8b884c8-lzfx2                   1/1     Running     0          41s
[vagrant@tiber ~]$ docker images
IMAGE                                           TAG                 IMAGE ID            SIZE
docker.io/fission/alpinecurl                    latest              1e52658abdee9       7.53MB
docker.io/fission/fission-bundle                1.8.0               9640fd2dc576e       60.1MB
docker.io/fission/pre-upgrade-checks            1.8.0               98523d3a9f4c7       50.5MB
docker.io/kubeless/cronjob-trigger-controller   v1.0.1              aec1dd30bb573       80.3MB
docker.io/kubeless/function-controller          v1.0.6              4d8c28a732e17       89MB
docker.io/kubeless/http-trigger-controller      v1.0.1              d6f09f3299d90       87.1MB
docker.io/library/nats-streaming                0.11.2              fdbad19bf11e5       12.4MB
docker.io/openfaas/basic-auth-plugin            0.17.0              2d28ce679c626       15.7MB
docker.io/openfaas/faas-idler                   0.2.1               8591a644ec2c8       24.6MB
docker.io/openfaas/faas-netes                   0.9.15              388640a30ffd6       58.3MB
docker.io/openfaas/gateway                      0.18.7              5fd9660e0fd93       29.3MB
docker.io/openfaas/queue-worker                 0.9.0               81f6956ff09b9       8.71MB
docker.io/prom/alertmanager                     v0.18.0             ce3c87f17369e       53.3MB
docker.io/prom/prometheus                       v2.11.0             b97ed892eb236       127MB
docker.io/rancher/coredns-coredns               1.6.3               c4d3d16fe508b       44.4MB
docker.io/rancher/klipper-helm                  v0.2.3              274808e7f6b83       138MB
docker.io/rancher/klipper-lb                    v0.1.2              897ce3c5fc8ff       6.46MB
docker.io/rancher/library-traefik               1.7.19              aa764f7db3051       86.6MB
docker.io/rancher/local-path-provisioner        v0.0.11             9d12f9848b99f       36.5MB
docker.io/rancher/metrics-server                v0.3.6              9dd718864ce61       41.2MB
docker.io/rancher/pause                         3.1                 da86e6ba6ca19       746kB
```



# Fission 

##### Install Fission

```
k apply -f /vagrant/config/fission-core-1.8.0.yaml
```

##### Check the status of fission deployment

```
[vagrant@tiber ~]$ k get pods -n fission
NAME                                       READY   STATUS    RESTARTS   AGE
fission-1-8-0-fission-co-1.8.0-480-d6h7v   0/1     Pending   0          22s
router-dd6bbfdcb-b7ncc                     0/1     Pending   0          21s
storagesvc-7877594985-jgs84                0/1     Pending   0          21s
controller-7c74dd9695-5xnxm                0/1     Pending   0          21s
timer-dfbdc8489-gg2nm                      0/1     Pending   0          21s
executor-6c848fd97b-vb7jj                  0/1     Pending   0          21s
kubewatcher-6b55dfcfff-k8ftr               0/1     Pending   0          21s
buildermgr-77798686b9-6x7mb                0/1     Pending   0          21s
fission-1-8-0-fission-co-1.8.0-182-zn9s4   0/1     Pending   0          21s
```

**Wait till pods are in running status.  Its fine to `storagesvc` pod to be in pending status.**

##### Create  Python  environment

```
/usr/local/bin/fission environment create --name python --image fission/python-env
```

Check the pods in fission_function namespace 

```
[vagrant@tiber ~]$ k get pods -n fission-function
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
k get functions
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

*This curl since its using NodePort service will also work from your laptop.*

##### Clean-up

- Delete the route/trigger 

- Delete the function using fission or kubectl 

- Delete the fission CRD

  ```
  k delete function hello-fission
  k delete -f /vagrant/config/fission-core-1.8.0.yaml
  ```

  

# Kubeless 

##### Install kubeless 

```
/usr/local/bin/kubectl apply -f /vagrant/config/kubeless-v1.0.6.yaml
```

Confirm all pods are running 

```
kubectl get pods -n kubeless
NAME                                           READY   STATUS    RESTARTS   AGE
kubeless-controller-manager-57d495575b-l95sc   3/3     Running   0          4m30s
```



##### Create the first function 

```
kubeless function deploy hello --runtime python2.7  --from-file /vagrant/demo_functions/kubeless_demo.py --handler test.hello --image-pull-policy IfNotPresent
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
k delete function hello
k delete -f /vagrant/config/kubeless-v1.0.6.yaml
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
