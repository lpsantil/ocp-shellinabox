# ocp-shellinabox
shellinabox containers for OpenShift/OKD/CDK/Minishift - in various flavors

## Features
* The GOOD: `ocp-siab` has `vim, nano, git, screen, tmux, bash-completion, oc client` installed
* Users only need a browser to access basic tools (`ZERO LOCAL MACHINE INSTALL`!)
* Has syntax highlighting installed for `nano` and `vim`
* Default user is completely unprivileged
* Easy to access.  Default user creds are `developer/developer`.
* Runs on the OpenShift cluster (consolidation of resource usage)
* You can run an instance in one more project namespaces, and `ZERO LOCAL MACHINE INSTALL`
* The GOOD: It runs with an SCC to start shellinbox as unprivleged user `developer`
* The GOOD: Changing `developer`'s password is as simple as creating and injecting a secret as an environment var `SIABPWD`

## Building and deploying
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

## Usage
* Visit the exposed route
* In CDK/Minishift, the route would be something like http://siab-myproject.192.168.99.100.nip.io

## References
* [openshiftcli-inabox][0]
* [docker-shellinabox][1]
* [ssh-git-docker][2]

[0]: https://github.com/VeerMuchandi/openshiftcli-inabox
[1]: https://github.com/andrefernandes/docker-shellinabox
[2]: https://github.com/openshift-qe/ssh-git-docker
