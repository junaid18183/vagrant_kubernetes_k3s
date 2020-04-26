# OpenFaas

Official openfaas [documentation](https://docs.openfaas.com/)

##### Pre-requisite

Make sure you have downloaded the `faas-cli` binary 

The binary should be present in `./bin` folder if you want to operate it from vagrant box. And if you are operating from your host machine it should be in your $PATH.

##### Install

To install the fission run the task `task app:deploy:openfaas`

If you want to operate from your host machine, export the KUBECONFIG variable

```
export KUBECONFIG=kubeconfig.yml
```

If you want to operate from the vagrant box, ssh to it using 

```
vagrant ssh
```

##### Check the status of openfaas deployment

```
[vagrant@tiber docker_images]$ kubectl get pods -n openfaas
NAME                                 READY   STATUS    RESTARTS   AGE
nats-6775fc6c6c-npw66                1/1     Running   0          40s
basic-auth-plugin-5565697c9b-fnzls   1/1     Running   0          40s
queue-worker-767b4c7469-tt9gh        1/1     Running   0          39s
prometheus-7485f5bdd8-p9tkf          1/1     Running   0          39s
alertmanager-78fbdb95bb-t5slc        1/1     Running   0          40s
gateway-58786d8fc8-4h6ll             2/2     Running   0          40s
faas-idler-9d84bf69b-9wf8c           1/1     Running   2          40s
```

##### Get the NodePort 

```
NODEPORT=$(kubectl get svc gateway-external  -n openfaas -o=jsonpath='{..nodePort}')
echo $NODEPORT
```

The UI will be available at [http://172.28.128.4:$NODEPORT/ui/](http://172.28.128.4:31112/ui/)

##### Credentails for the UI or faas-cli will be 

```
USER=$(k get secret basic-auth -o jsonpath='{.data.basic-auth-user}' -n openfaas | base64 --decode)

PASSWD=$(k get secret basic-auth -o jsonpath='{.data.basic-auth-password}' -n openfaas | base64 --decode)

echo "user is $USER and password is $PASSWD for openfaas UI"
```

##### Login to faas-cli

```
faas-cli login --password $PASSWD --gateway 172.28.128.4:$NODEPORT
```



## Sample Demo function

Openfaas just like knative requires your function to be packaged as docker image first. And then using a yaml file containing the docker image from registry you can deploy the function.

I have created a sample docker image and pushed to `junaid18183/openfass-python-demo:latest`

To see the source code of the function check the `demo_functions/openfass_demo` directory.

*You can do these steps either from your host machine or from the vagrant box.* 

*If you are operating from within vagrant box, ssh to vagrant and cd to /vagrant directory.*

```
vagrant ssh
cd /vagrant
```

To create and push the docker image you can use the `faas-cli` as below 

```
cd demo_functions/openfass_demo
faas-cli new --lang python openfass-python-demo
#Change the code in openfass-python-demo/handler.py

faas-cli build -f  ./openfass-python-demo.yml
faas-cli push -f ./openfass-python-demo.yml

```

##### Deploy the function

```
cd demo_functions/openfass_demo/

faas-cli deploy -f ./openfass-python-demo.yml
Deploying: openfass-python-demo.
WARNING! Communication is not secure, please consider using HTTPS. Letsencrypt.org offers free SSL/TLS certificates.

Deployed. 202 Accepted.
URL: http://172.28.128.4:31112/function/openfass-python-demo
```

Check the pods is started in openfaas-fn namespace

```
$ k get pods -n openfaas-fn
NAME                                    READY   STATUS    RESTARTS   AGE
openfass-python-demo-5455c8c54b-28jjn   1/1     Running   0          82s
```

Check the function using `faas-cli`

```
OPENFAAS_URL=http://172.28.128.4:31112 faas-cli list
Function                      	Invocations    	Replicas
openfass-python-demo          	3              	1
```

##### Test the function

```
$ curl http://172.28.128.4:31112/function/openfass-python-demo -d "Hello World"
Hello! You said: Hello World
Hello World
```



Addionaly you can use openfaas UI to deploy the function.



## Cleanup 

```
task app:destroy:openfaas
```



##### References

<https://blog.alexellis.io/first-faas-python-function/>