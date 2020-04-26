# Kubeless

kubeless official [documentation](https://kubeless.io/docs/)

##### Pre-requisite

Make sure you have downloaded the `kubeless` binary 

The binary should be present in `./bin` folder if you want to operate it from vagrant box. And if you are operating from your host machine it should be in your $PATH.



##### Install

To install the fission run the task `task app:deploy:kubeless`

If you want to operate from your host machine, export the KUBECONFIG variable

```
export KUBECONFIG=kubeconfig.yml
```

If you want to operate from the vagrant box, ssh to it using 

```
vagrant ssh
```

##### Check the status of kubeless deployment

```
kubectl get pods -n kubeless
NAME                                           READY   STATUS    RESTARTS   AGE
kubeless-controller-manager-57d495575b-l95sc   3/3     Running   0          4m30s
```



## Sample Demo function

##### Create the function

You can do these steps either from your host machine or from the vagrant box. 

If you are operating from within vagrant box, ssh to vagrant and cd to /vagrant directory.

```
vagrant ssh
cd /vagrant
```



```
$ kubeless function deploy hello --runtime python2.7  --from-file demo_functions/kubeless_demo.py --handler test.hello --image-pull-policy IfNotPresent
```

##### Confirm the function pods are in running state 

```
[vagrant@tiber]$ kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
hello-7ccb949d98-5gx7m   1/1     Running   0          21s
```

##### Check the state of the function, using both kubectl and kubeless cli 

```
[vagrant@tiber]$ kubeless function ls
NAME 	NAMESPACE	HANDLER   	RUNTIME  	DEPENDENCIES	STATUS
hello	default  	test.hello	python2.7	            	1/1 READY

[vagrant@tiber]$ kubectl get function
NAME    AGE
hello   92s
```

##### Test the function 

Using the kubeless cli 

```
kubeless function call hello --data 'Hello world!'
```

##### Add the ingress and check the status 

```
[vagrant@tiber ~]$ kubeless trigger http create kubeless-hello --function-name hello --hostname faas.ijuned.com

[vagrant@tiber ~]$ kubectl get ing
NAME             HOSTS             ADDRESS        PORTS   AGE
kubeless-hello   faas.ijuned.com   172.28.128.4   80      4s
```

Test the function using curl 

```
curl  -H 'Host: faas.ijuned.com' --data 'Hello world!' http://172.28.128.4
```



## Cleanup 

```
task app:destroy:kubeless
```

