# ocp-shellinabox
shellinabox container for OpenShift/OKD/CDK/Minishift
 
## Features
* Provides a basic, lightweight container to administer OpenShift-based clusters
* The GOOD: `ocp-siab` has `vim, nano, git, screen, tmux, bash-completion, oc client` installed
* Users only need a browser to access basic tools (`ZERO LOCAL MACHINE INSTALL`!)
* Has syntax highlighting installed for `nano` and `vim`
* Default user is completely unprivileged
* Easy to access.  Default user creds are `developer/developer`.
* Runs on the OpenShift cluster (consolidation of resource usage)
* You can run an instance in one or more project namespaces, and `ZERO LOCAL MACHINE INSTALL`
* The GOOD: It runs with an SCC to start shellinbox as unprivleged user `developer`
* The GOOD: Changing `developer`'s password is as simple as creating a secret and injecting as an environment var `SIABPWD`

## Building and deploying
Automated Steps
```
# Execute the YAML template
oc apply -f siab.template.yaml
# Wait for about 5 minutes for the container to build and deploy
```

Manual steps
```
# Define a new BuildConfig
oc new-build --strategy=docker --name=siab .
# Rebuild the pod from the local source dir
oc start-build siab --from-dir=. -w
# Create a ServiceAccount to let our container startup as a privileged pod
oc create serviceaccount siab
# As `cluster-admin`, give the ServiceAccount the permission start as an anyuid pod (in our case, `UID 1001` or `developer:developer`)
oc adm policy add-scc-to-user anyuid -z siab
# Define new Service and DeploymentConfig
oc new-app --image-stream=siab --name=siab
# Apply the ServiceAccount to the DeploymentConfig
oc patch dc/siab --patch '{"spec":{"template":{"spec":{"serviceAccountName": "siab"}}}}'
# Expose our shellinabox container
oc expose svc/siab
# Extend the session idle timeout to 10 minutes
oc annotate route siab --overwrite haproxy.router.openshift.io/timeout=600s
```

If you're building in CDK or build does not include the `oc` binary in your resulting container, you'll need to re-register the VM, and enable the OpenShift Container Platform repo
```
# Login to your running CDK/minishift VM
minishift ssh
# Elevate your privileges to root
sudo su -
# Temporarily unregister the VM
subscription-manager unregister
# Re-register the VM
subscription-manager register
# Find the Pool ID associated with OpenShift Container Platform
subscription-manager list --available | less
# Attach the Pool ID
subscription-manager attach --pool=<POOLID>
# Enable the OpenShift Container Platform repo
subscription-manager repos --enable=rhel-7-server-ose-3.11-rpms
# Exit out of root
exit
```


## Usage
* Visit the exposed route
* In CDK/Minishift, the route would be something like http://siab-myproject.192.168.99.100.nip.io
* To avoid closing your browser tab while using `nano`, `^W` (`Where Is` function) has been remapped to `^F`

## References
* [openshiftcli-inabox][0]
* [docker-shellinabox][1]
* [ssh-git-docker][2]

[0]: https://github.com/VeerMuchandi/openshiftcli-inabox
[1]: https://github.com/andrefernandes/docker-shellinabox
[2]: https://github.com/openshift-qe/ssh-git-docker

