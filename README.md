# Cloud init clone 
These scripts let you take a cloud builder image and instantiate it and join it to an existing CAPV managed kubernetes cluster. You might find this useful if you want a VM outside of cluster api management to attach specialty hardware.
#Prereqs
1. kubeadm, kubectl, govc, jq installed and in your $PATH
2. kubectl targeting your desired destination cluster

# Using
1. Set your GOVC environment variables like
```
    export GOVC_USERNAME='administrator@vsphere.local'
    export GOVC_PASSWORD='password'
    export GOVC_URL="https://vcenter"
    export GOVC_DATASTORE="nfs"
```

2. Identify your target node. Pick a node that you want to clone, generally you'll want one of the worker nodes.
```
kubectl get nodes
```

3. Get your templates
```
./get-templates.sh <node-name>
```
You should find user.yaml and meta.yaml in your working directory. If you want manually modify the cloud init data, you can edit these files.

4. Generate VM
`<image>` should be the path to your image builder template. For example `imagebuilder/ubuntu-2004-kube-v1.19.6`
Also note that if you want set any vmx settings, you can add them to options to the vm.change command in this script.
```
./generate-vm.sh imagebuilder/ubuntu-2004-kube-v1.19.6
```

5. Verify node is joined

```
kubectl get nodes 
```

6. Now that you have an unmanaged node joined to your cluster and you can power it off and add any devices or make any changes you deem necessary outside of cluster api management. 
