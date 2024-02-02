### Private Test Connectivity

1. Save the jump host public IP address

    ```bash
   JUMP_IP=$(az vm list-ip-addresses -g $AZR_RESOURCE_GROUP -n $AZR_CLUSTER-jumphost -o tsv \
   --query '[].virtualMachine.network.publicIpAddresses[0].ipAddress')
   echo $JUMP_IP
   ```

1. update /etc/hosts to point the openshift domains to localhost. Use the DNS of your openshift cluster as described in the previous step in place of $YOUR_OPENSHIFT_DNS below

   ```bash
   127.0.0.1 api.$YOUR_OPENSHIFT_DNS
   127.0.0.1 console-openshift-console.apps.$YOUR_OPENSHIFT_DNS
   127.0.0.1 oauth-openshift.apps.$YOUR_OPENSHIFT_DNS
   ```

1. SSH to that instance, tunneling traffic for the appropriate hostnames. Be sure to use your new/existing private key, the OpenShift DNS for $YOUR_OPENSHIFT_DNS and your Jumphost IP

   ```bash
   sudo ssh -L 6443:api.$YOUR_OPENSHIFT_DNS:6443 \
   -L 443:console-openshift-console.apps.$YOUR_OPENSHIFT_DNS:443 \
   -L 80:console-openshift-console.apps.$YOUR_OPENSHIFT_DNS:80 \
   aro@$JUMP_IP
   ```

1. Log in using oc login

   ```bash
   oc login $ARO_URL -u $ARO_USERNAME -p $ARO_PASSWORD
   ```

NOTE: Another option to connect to a Private ARO cluster jumphost is the usage of [sshuttle](https://sshuttle.readthedocs.io/en/stable/index.html). If we suppose that we deployed ARO vnet with the `10.0.0.0/20` CIDR we can connect to the cluster using (both API and Console):

```bash
sshuttle --dns -NHr aro@$JUMP_IP 10.0.0.0/20 --daemon
```

and opening a browser the `api.$YOUR_OPENSHIFT_DNS` and `console-openshift-console.apps.$YOUR_OPENSHIFT_DNS` will be reachable.