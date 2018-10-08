# ocp-shellinabox
shellinabox containers for OpenShift/OKD/CDK/Minishift - in various flavors

## Features

## Building
```
# Define a new BuildConfig
oc new-build --strategy=docker --name=siab src/
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
oc start-build siab --from-dir=src/
```

## Usage
* Visit the exposed route

## References
