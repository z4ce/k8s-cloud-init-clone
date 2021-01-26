#!/bin/bash
govc vm.info -e -json -k $1 | jq '.VirtualMachines[0].Config.ExtraConfig[] | select (.Key == "guestinfo.metadata") | .Value' -r | base64 -d > meta.yaml
govc vm.info -e -json -k $1 | jq '.VirtualMachines[0].Config.ExtraConfig[] | select (.Key == "guestinfo.userdata") | .Value' -r | base64 -d > user.yaml

# this could be better, but didn't want to depend on yq.. so it is what it is
perl -p -i -e 's/^          token:.*$/          token: \$JOINTOKEN/g' user.yaml
perl -p -i -e 's/^instance-id:.*$/instance-id: "\${NEWNAME}"/g' meta.yaml
perl -p -i -e 's/^local-hostname:.*$/local-hostname: "\${NEWNAME}"/g' meta.yaml
perl -p -i -e 's/^        macaddress:.*$/        macaddress: "\${MAC}"/g' meta.yaml

