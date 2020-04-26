# OpenFaas

##### Install

To install the fission run the task `app:deploy:openfaas`

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

##### Get the NodePort 

```
NODEPORT=$(kubectl get svc gateway-external  -n openfaas -o=jsonpath='{..nodePort}')
```

The UI will be available at `<http://172.28.128.4:$NODEPORT/ui/>`

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

## Cleanup 

```
task app:destroy:openfaas
```

