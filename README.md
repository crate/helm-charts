# Crate Helm Charts repository for Kubernetes


This is a community maintained repository containing Helm charts for CrateDB.

## Charts

### CrateDB

| Charts                | Description                                                               |
| ----------------------| ------------------------------------------------------------------------- |
| [crate](charts/crate) | CrateDB. [Artifact Hub](https://artifacthub.io/packages/helm/crate/crate) |

### CrateDB with Crate Operator

Install CrateDB by using the operator.

| Charts                                            | Description                                                    |
| --------------------------------------------------| -------------------------------------------------------------- |
| [crate-operator](charts/crate-operator)           | CrateDB operator.                                              |
| [crate-operator-crds](charts/crate-operator-crds) | CrateDB Custom Resource Definitions (CRDs) for Crate operator. |


## Usage

```
helm repo add crate https://crate.github.io/helm-charts
helm install <chart name>
```

See [Helm docs](https://helm.sh/docs/helm) for further usage.

## Maintainers

Charts sources are in `/charts/<chart>`, their packaged result in `/docs/<chart>`.

To package charts:
```
make package
```

To update helm repository:
```
make repo
```
