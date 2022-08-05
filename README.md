# helm-charts

This is a community maintained repository containing a Helm chart for CrateDB
for [Artifact Hub](https://artifacthub.io/packages/helm/crate/crate).

Chart sources are in `/src/<chart>`, their packaged result in `/docs/<chart>`.


## Usage

```
helm repo add crate https://crate.github.io/helm-charts
helm install <chart name>
```

See [Helm docs](https://helm.sh/docs/helm) for further usage.

## Maintainers

To package charts:
```
make package
```

To update helm repository:
```
make repo
```
