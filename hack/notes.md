I found the required docker images for offline using below method
```
grep -w image ../config/fission-core-1.8.0.yaml | sort | uniq | awk -F ":" '{print $2}' | sed 's| ||g'>  docker_images_list.txt
grep -w image ../config/kubeless-v1.0.6.yaml | sort | uniq | grep -v "," | sed 's| ||g' | grep ^image >> docker_images_list.txt
grep -w image ../config/openfaas-5.4.1-install.yaml | sort | uniq | grep -v "," | sed 's| ||g' | grep ^image >> docker_images_list.txt
```
