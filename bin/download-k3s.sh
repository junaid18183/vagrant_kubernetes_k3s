#! /bin/bash

K3S_VERSION="v1.18.10+k3s1"

AIRGAP_K3_IMAGES_SOURCE=https://github.com/rancher/k3s/releases/download/$K3S_VERSION/k3s-airgap-images-amd64.tar
AIRGAP_K3_IMAGES="docker_images/k3s-airgap-images-amd64-$K3S_VERSION.tar"

if [ -f "$AIRGAP_K3_IMAGES" ] ; then
        echo "Airgap k3s docker images already present at $AIRGAP_K3_IMAGES"
    else
        echo "Saving Airgap k3s docker images at  $AIRGAP_K3_IMAGES"
        wget $AIRGAP_K3_IMAGES_SOURCE -O $AIRGAP_K3_IMAGES
fi


K3S_SOURCE=https://github.com/rancher/k3s/releases/download/$K3S_VERSION/k3s
K3S_BINARY="bin/k3s"

if [ -f "$K3S_BINARY" ] ; then
        echo "k3s binary already present at $K3S_BINARY"
    else
        echo "Saving k3s binary at  $K3S_BINARY"
        wget $K3S_SOURCE -O $K3S_BINARY
        chmod 755 $K3S_BINARY
fi