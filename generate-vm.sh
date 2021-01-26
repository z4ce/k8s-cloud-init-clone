#!/bin/bash
#assumes: govc env set
#kube context set to your workload destination
# user and meta.yaml files generated from some existing VM and templated
# Generate user and meta.yaml files by polling some existing vm
set -xe
export NEWNAME="imgbld-$(date +'%s')"
govc vm.clone -k -on=false -vm "$1" $NEWNAME
export JOINTOKEN="$(kubeadm token create)"
export MAC=$(govc device.info -k -vm $NEWNAME -json ethernet-0 | jq -r .Devices[].MacAddress)
envsubst '${JOINTOKEN}' < user.yaml > /tmp/user.yaml
envsubst '${MAC} ${NEWNAME}' < meta.yaml > /tmp/meta.yaml
govc vm.change -k -vm $NEWNAME  -e guestinfo.metadata="$(cat /tmp/meta.yaml|base64)" -e guestinfo.metadata.encoding="base64" -e guestinfo.userdata="$(cat /tmp/user.yaml|base64)" -e guestinfo.userdata.encoding="base64" -e pciPassthru.use64BitMMIO="true" -e pciPassthru.64bitMMIOSizeGB="128"
govc vm.power -k -on $NEWNAME
