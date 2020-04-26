#! /bin/bash

for image in $(cat docker_images/docker_images_list.txt ) ; do 
    path=$(echo $image | sed 's|gcr.io/||g')
    path=$(echo $path | sed 's|docker.io/||g')

    path=${path%@*} #Remove the char after @

    path=$(echo $path | sed 's|/|_|g')
    path=$(echo $path | sed 's|:|_|g')

    FILE="docker_images/$path.tar"
    if [ -f "$FILE" ] ; then
        echo "image already saved at $FILE"
    else
        echo "Saving $image at $FILE" 
        docker pull $image     
        if [ $image == "junaid18183/knative-demo-python:latest" ]; then
            docker tag docker.io/junaid18183/knative-demo-python:latest dev.local/junaid18183/knative-demo-python:latest
            docker save dev.local/junaid18183/knative-demo-python:latest > $FILE
        else
            docker save $image > $FILE
        fi
    fi
done