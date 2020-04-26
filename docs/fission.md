# Fission

fission official [documentaion](https://docs.fission.io/docs/) 

##### Pre-requisite

Make sure you have downloaded the `fission` binary 

The binary should be present in `./bin` folder if you want to operate it from vagrant box. And if you are operating from your host machine it should be in your $PATH.



##### Install

To install the fission run the task `task app:deploy:fission`

If you want to operate from your host machine, export the KUBECONFIG variable

```
export KUBECONFIG=kubeconfig.yml
```

If you want to operate from the vagrant box, ssh to it using 

```
vagrant ssh
```

##### Check the status of fission deployment

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

## Sample Demo function

You can do these steps either from your host machine or from the vagrant box. 

If you are operating from within vagrant box, ssh to vagrant and cd to /vagrant directory.

```
vagrant ssh
cd /vagrant
```

##### Create  Python  environment

```
fission environment create --name python --image fission/python-env
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
fission function create --name hello-fission --env python --code demo_functions/fission_demo.py
```

Check kubernetes function resource

```
kubectl get functions
```

Check the same using fission cli

```
fission function list
NAME          UID                                  ENV    EXECUTORTYPE MINSCALE MAXSCALE MINCPU MAXCPU MINMEMORY MAXMEMORY TARGETCPU
hello-fission ca04a908-d34d-4334-bfba-52ff71baad26 python poolmgr      0        0        0      0      0         0         0
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
echo $NODEPORT
curl 172.28.128.4:$NODEPORT/fission_demo
```

*This curl  will also work from your laptop , since we are using NodePort service*

## Clean-up

To destroy the fission, run the task `app:destroy:fission`

```
task app:destroy:fission
```