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
* The GOOD: It runs with an SCC to start shellinbox as unprivliged user `developer`
* The GOOD: Changing `developer`'s password is as simple as creating and injecting a secret as an environment var `SIABPWD`

## Building
```
# Define a new BuildConfig
oc new-build --strategy=docker --name=siab ocp-siab/
# Create a ServiceAccount to let our container startup as a privileged pod
oc create serviceaccount siabuser
# Give the ServiceAccount the permission start as a privileged pod in the <siab-project>
oc adm policy add-scc-to-user anyuid system:serviceaccount:<siab-project>:siabuser
# Define new Service and DeploymentConfig
oc new-app --image-stream=siab --name=siab
# Apply the ServiceAccount to the DeploymentConfig
oc patch dc/siab --patch '{"spec":{"template":{"spec":{"serviceAccountName": "siabuser"}}}}'
# Expose our shellinabox container
oc expose svc/siab
# Rebuild the pod from the local source dir
oc start-build siab --from-dir=ocp-siab/
```

## Usage
* Visit the exposed route

## References
* [openshiftcli-inabox][0]
* [docker-shellinabox][1]
* [ssh-git-docker][2]

[0]: https://github.com/VeerMuchandi/openshiftcli-inabox
[1]: https://github.com/andrefernandes/docker-shellinabox
[2]: https://github.com/openshift-qe/ssh-git-docker
