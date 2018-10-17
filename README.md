# ocp-shellinabox
shellinabox containers for OpenShift/OKD/CDK/Minishift - in various flavors

## Features
* The GOOD: `ocp-siab` has `ansible, vim, nano, git, screen, tmux, bash-completion, oc client` installed
* Users only need a browser to access basic tools (`ZERO LOCAL MACHINE INSTALL`!)
* Has syntax highlighting installed for `nano` and `vim`
* Easy to access.  Default user creds are `developer/developer`
* The `developer` password can be reset by using a secret
* Runs on the OpenShift cluster (consolidation of resource usage)
* You can run an instance in one more project namespaces, and `ZERO LOCAL MACHINE INSTALL`
* The BAD: It has to run with an SCC to start shellinbox as `root`
* The GOOD: It immediately drops down to `nobody:nobody`
* It randomizes `root` password on every startup

## Building
```
# Define a new BuildConfig
oc new-build --strategy=docker --name=siab ocp-siab/
# Define new Service and DeploymentConfig
oc new-app --image-stream=siab --name=siab
# Create a ServiceAccount to let our container startup as a privileged pod
oc create serviceaccount siabroot
# Give the ServiceAccount the permission start as a privileged pod in the <siab-project>
oc adm policy add-scc-to-user anyuid system:serviceaccount:<siab-project>:siabroot
# Apply the ServiceAccount to the DeploymentConfig
oc patch dc/siab --patch '{"spec":{"template":{"spec":{"serviceAccountName": "siabroot"}}}}'
# Expose our shellinabox container
oc expose svc/siab
# Rebuild the pod which will also cause a redeployment
oc start-build siab --from-dir=ocp-siab/
```

## Usage
* Visit the exposed route

## References
