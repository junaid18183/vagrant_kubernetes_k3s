# Knative

knative official [documenation](https://knative.dev/docs/)

##### Install

To install the fission run the task `task app:deploy:knative`

If you want to operate from your host machine, export the KUBECONFIG variable

```
export KUBECONFIG=kubeconfig.yml
```

If you want to operate from the vagrant box, ssh to it using 

```
vagrant ssh
```

##### Check the status of knative deployment

```
[vagrant@tiber]$ kubectl get pods -n knative-serving
NAME                          READY   STATUS    RESTARTS   AGE
webhook-6cf777df8c-26lpk      1/1     Running   0          29s
controller-68ffd44c88-mbnlk   1/1     Running   0          29s
autoscaler-687f68c656-2qflb   1/1     Running   0          29s
activator-66f9c58f8f-8n2pt    1/1     Running   0          29s

[vagrant@tiber knative]$ kubectl get pods -n kourier-system
NAME                                      READY   STATUS         RESTARTS   AGE
3scale-kourier-control-794b8b9b4f-z8sjt   1/1     Running        0          32s
3scale-kourier-gateway-567b5b495d-d5hxd   0/1     Running        0          34s
```

## Sample Demo function

For knative functions you need to package your application as a docker image and push it to dockcer registry.  

I have pushed the sample demo function image to `junaid18183/knative-demo-python:latest`

For code of that sample function see the files at `demo_functions/knative_demo/` 

Using those files you have to build and push  the docker image to dockcer registry . 

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

Additionaly I have added the `imagePullPolicy: IfnotPresent` in the service.yaml file to avoid downloading at run time.

##### Deploy the function

After the build has completed and the container is pushed to docker hub, you can deploy the app into your cluster. Ensure that the container image value in service.yaml matches the container you built in the previous step. Apply the configuration using kubectl

```
kubectl apply -f demo_functions/knative_demo/app/service.yaml
```

**Check the ksvc** 

```
[vagrant@tiber ~]$ kubectl get ksvc
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



## Cleanup 

```
task app:destroy:knative
```