# LWB Helm Charts

[Helm](https://helm.sh) repo for different charts related to LWB which can be installed on [Kubernetes](https://kubernetes.io)

### Add Helm repository

To install the repo just run:

```bash
helm repo add nextcloud https://lwb-mbh.github.io/helm/
helm repo update
```

### Helm Charts

* [lwb](https://lwb-mbh.github.io/helm/)

  ```bash
  helm install my-release lwb/application
  ```