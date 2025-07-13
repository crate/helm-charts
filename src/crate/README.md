# CrateDB Helm Chart

This Helm chart deploys [CrateDB](https://crate.io/) on r, with optional monitoring via Prometheus and Grafana.

## Features

- **CrateDB Database**: Distributed SQL database for machine data
- **Monitoring**: Optional Prometheus stack for metrics collection
- **Dashboards**: Optional Grafana for visualization with pre-built CrateDB dashboards
- **Scalable**: Configurable number of nodes
- **Persistent Storage**: Configurable persistent volumes

## Quick Start

### Basic Installation

```bash
helm install my-crate ./crate
```

### Installation with Monitoring

```bash
helm install my-crate ./crate \
  --set monitoring.enabled=true \
  --set prometheus.enabled=true \
  --set grafana.enabled=true
```

## Configuration

### CrateDB Configuration

| Parameter             | Description                 | Default |
| --------------------- | --------------------------- | ------- |
| `crate.clusterName`   | Name of the CrateDB cluster | `crate` |
| `crate.heapSize`      | JVM heap size in GiB        | `1.0`   |
| `crate.numberOfNodes` | Number of CrateDB nodes     | `1`     |
| `image.tag`           | CrateDB image tag           | `6.0.0` |

### Monitoring Configuration

| Parameter                           | Description                                   | Default    |
| ----------------------------------- | --------------------------------------------- | ---------- |
| `monitoring.enabled`                | Enable monitoring features                    | `true`     |
| `monitoring.annotations.enabled`    | Use Prometheus annotations for discovery      | `true`     |
| `monitoring.annotations.interval`   | Scrape interval                               | `30s`      |
| `monitoring.annotations.path`       | Metrics endpoint path                         | `/metrics` |
| `monitoring.annotations.port`       | Metrics port                                  | `7071`     |
| `monitoring.serviceMonitor.enabled` | Create ServiceMonitor for Prometheus Operator | `false`    |

### Prometheus Configuration

| Parameter                                                                                              | Description                        | Default         |
| ------------------------------------------------------------------------------------------------------ | ---------------------------------- | --------------- |
| `prometheus.enabled`                                                                                   | Deploy Prometheus stack            | `true`          |
| `prometheus.prometheus.prometheusSpec.retention`                                                       | Data retention period              | `7d`           |
| `prometheus.prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage` | Storage size                       | `5Gi`          |
| `prometheus.kube-state-metrics.enabled`                                                                | Enable Kubernetes state metrics    | `true`          |
| `prometheus.node-exporter.enabled`                                                                     | Enable node exporter               | `true`          |
| `prometheus.alertmanager.enabled`                                                                      | Enable alert manager               | `false`         |
| `prometheus.prometheus.prometheusSpec.additionalScrapeConfigs`                                         | Annotation-based service discovery | See values.yaml |

### Grafana Configuration

| Parameter                             | Description                                | Default         |
| ------------------------------------- | ------------------------------------------ | --------------- |
| `grafana.enabled`                     | Deploy Grafana                             | `true`          |
| `grafana.adminPassword`               | Grafana admin password                     | `admin`         |
| `grafana.persistence.enabled`         | Enable persistent storage                  | `true`          |
| `grafana.persistence.size`            | Storage size                               | `10Gi`          |
| `grafana.initChownData.enabled`       | Enable init container for permissions      | `false`         |
| `grafana.datasources`                 | Configure CrateDB as a Postgres datasource | See values.yaml |
| `grafana.dashboards.default.crate-db` | Pre-configured CrateDB dashboard           | `gnetId: 15983` |

### JMX and Monitoring Configuration

| Parameter                        | Description                                | Default    |
| -------------------------------- | ------------------------------------------ | ---------- |
| `crate.jmx.enabled`              | Enable JMX remote access                   | `true`     |
| `crate.jmx.port`                 | JMX port                                   | `6666`     |
| `crate.jmx.exporter.enabled`     | Enable JMX exporter for Prometheus metrics | `true`     |
| `crate.jmx.exporter.version`     | JMX exporter version                       | `1.2.0`    |
| `crate.jmx.exporter.port`        | JMX exporter port                          | `7071`     |
| `crate.stats.enabled`            | Enable CrateDB stats collection            | `true`     |
| `monitoring.enabled`             | Enable monitoring features                 | `true`     |
| `monitoring.annotations.enabled` | Enable Prometheus pod annotations          | `true`     |
| `monitoring.annotations.port`    | Port for Prometheus scraping               | `7071`     |
| `monitoring.annotations.path`    | Path for Prometheus metrics                | `/metrics` |

## Examples

### Scaling CrateDB

```bash
helm upgrade my-crate ./crate \
  --set crate.numberOfNodes=3 \
  --set crate.heapSize=2.0
```

### Enable JMX monitoring with Prometheus annotations

```bash
helm install my-crate ./crate \
  --set monitoring.enabled=true \
  --set crate.jmx.exporter.enabled=true \
  --set prometheus.enabled=true \
  --set grafana.enabled=true
```

### Enable annotation-based monitoring only (no Prometheus stack)

```bash
helm install my-crate ./crate \
  --set monitoring.enabled=true \
  --set monitoring.annotations.enabled=true \
  --set prometheus.enabled=false \
  --set grafana.enabled=false
```

### Custom Storage

```bash
helm install my-crate ./crate \
  --set persistentVolume.size=100Gi \
  --set persistentVolume.storageClass=fast-ssd
```

## Accessing Services

### CrateDB Admin UI

```bash
kubectl port-forward svc/crate 4200:4200
```

Then access http://localhost:4200

### Grafana Dashboard

```bash
kubectl port-forward svc/my-crate-grafana 3000:80
```

Then access http://localhost:3000 (admin/admin)

### Prometheus UI

```bash
kubectl port-forward svc/my-crate-prometheus 9090:9090
```

Then access http://localhost:9090

## Monitoring

When monitoring is enabled, the chart provides:

1. **Annotation-based Discovery**: Prometheus automatically discovers CrateDB metrics using pod/service annotations
2. **Grafana Dashboard**: Pre-configured dashboard showing CrateDB CPU, memory, and database metrics
3. **Standard Prometheus**: Uses community-maintained prometheus-stack and grafana charts

### Monitoring Configuration

The chart uses annotation-based service discovery by default:

- Adds `prometheus.io/scrape`, `prometheus.io/port`, and `prometheus.io/path` annotations to CrateDB pods and services
- Works with any Prometheus installation that supports annotation-based discovery
- No dependency on Prometheus Operator or custom resources

## Dependencies

This chart can optionally include:

- [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [Grafana](https://github.com/grafana/helm-charts/tree/main/charts/grafana)

## Upgrading

```bash
helm dependency update ./crate
helm upgrade my-crate ./crate
```

## Configuration

The following table lists the configurable parameters of the CrateDB chart and their default values.

| Parameter                     | Description                                                                                                                                     | Default                          |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| app                           | Name used in resource metadata.                                                                                                                 | crate                            |
| crate.clusterName             | Name of CrateDB cluster - [docs](https://cratedb.com/docs/guide/admin/clustering/multi-node-setup.html#multi-node-setup.)                       | crate                            |
| crate.heapSize                | Crate's heap size (in GiB) - [docs](https://crate.io/docs/crate/reference/en/latest/config/environment.html)                                    | 1                                |
| crate.numberOfNodes           | Number of pods (Crate nodes)                                                                                                                    | 1                                |
| crate.recoverAfterNodes       | See [docs](https://crate.io/docs/crate/guide/en/latest/scaling/multi-node-setup.html#gateway-configuration)                                     | floor(crate.numberOfNodes/2) + 1 |
| http.cors.enabled             | Whether CORS is enabled - [docs](https://crate.io/docs/crate/reference/en/latest/config/node.html#cross-origin-resource-sharing-cors)           | False                            |
| http.cors.allowOrigin         | CORS origin to allow (if enabled) - [docs](https://crate.io/docs/crate/reference/en/latest/config/node.html#cross-origin-resource-sharing-cors) | \*                               |
| image.tag                     | Crate image tag (version)                                                                                                                       | 6.0.0                            |
| persistentVolume.enabled      | Whether to use a persistent volume (vs. memory)                                                                                                 | true                             |
| persistentVolume.storageClass | Storage class of the PV (if enabled)                                                                                                            | retain                           |
| persistentVolume.accessModes  | Access modes of the PV (if enabled)                                                                                                             | [ReadWriteOnce]                  |
| persistentVolume.size         | Size of the PV (if enabled)                                                                                                                     | 10Gi                             |
| persistentVolume.annotations  | Annotations of the PV (if enabled)                                                                                                              | {}                               |
| resources.limits.cpu          | Maximum CPU per pod                                                                                                                             | 1                                |
| resources.limits.memory       | Maximum memory per pod                                                                                                                          | crate.heapSize \* 3              |
| resources.requests.cpu        | Amount of CPU requested per pod                                                                                                                 | 500m                             |
| service.name                  | Name of K8s service created for CrateDB                                                                                                         | crate                            |
| service.ports.ui              | Port to use for admin UI                                                                                                                        | 4200                             |
| service.ports.psql            | Port to use for psql connections                                                                                                                | 5432                             |
| service.ports.transport       | Port to use for node-to-node communication                                                                                                      | 4300                             |
| service.ports.jmx             | Port to use for JMX remote connections                                                                                                          | 6666                             |
| service.ports.prometheus      | Port to use for Prometheus metrics (JMX exporter)                                                                                               | 7071                             |

NB: `resources.requests.memory` is not configurable: the minimum of `crate.heapSize * 2` is inferred.

## Production Features

This Helm chart includes production-ready features based on CrateDB Cloud (crate-operator) configurations:

- **JMX Exporter**: Automatically downloads and configures the CrateDB JMX exporter for comprehensive metrics
- **Health Checks**: Configurable readiness probes with sensible defaults
- **Production Java Options**:
  - JMX remote access configuration (`javaOpts.jmx`)
  - JMX exporter configuration (`javaOpts.jmxExporter`)
  - Heap dump on OutOfMemoryError with configurable path (`javaOpts.heapDump`)
  - Security hardening (`javaOpts.security`: `-Dlog4j2.formatMsgNoLookups=true`)
- **System Optimization**: Init container configures kernel parameters (`vm.max_map_count`, TCP keepalive settings)
- **Stats Collection**: Enables CrateDB's built-in statistics collection for monitoring
- **Annotation-based Discovery**: Uses Kubernetes pod annotations for Prometheus scraping (ServiceMonitor-free)

## More info

You can read more about CrateDB in:

- [Official Documentation](https://crate.io/docs/)
- [Docker Hub](https://hub.docker.com/_/crate/)
