# Helm charts for anycable

This repo contains a [Helm chart](https://github.com/anycable/anycable-helm/tree/master/anycable-go) to deploy anycable-go websocket server.

## TL;DR

To install anycable-go to your kubernetes cluster simply run:

```shell
helm repo add anycable https://helm.anycable.io/

# With Helm 3
helm upgrade -i anycable-go anycable/anycable-go

# With Helm 2
helm upgrade -i --name anycable-go anycable/anycable-go
```

## Introduction

AnyCable allows you to use any WebSocket server (written in any language) as a replacement for your Ruby server (such as Faye, ActionCable, etc).

AnyCable uses the same protocol as ActionCable, so you can use its JavaScript client without any monkey-patching.

`anycable-go` is an implementations of AnyCable WebSocket server written in Go. This repository allows you to install `anycable-go` into your Kubernetes cluster.

## Prerequisites

* Kubernetes 1.4+ with Beta APIs enabled

## Installing chart

```shell
helm repo add anycable https://helm.anycable.net/

# With Helm 3
helm upgrade -i anycable-go anycable/anycable-go

# With Helm 2
helm upgrade -i --name anycable-go anycable/anycable-go
```

The command deploys anycable-go on the Kubernetes cluster in the default configuration. The [configuration section](#configuration) lists various ways to override default configuration during deployment.

> **Tip:** To list all releases use `helm list`

## Uninstalling the Chart

```shell
helm delete anycable-go
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

Specify each parameter using the `--set key=value[,key=value]` argument to helm install or provide your own file via `-f values.yaml`. For example,

```shell
helm upgrade -i anycable-go \
  --namespace anycable-go \
  --set image.tag=v0.6.4 \
  anycable/anycable-go
```

The above command installs a specified version of anycable.

## Supported Chart values

### anycable-go

These are the values used to configure anycable-go itself:

|Value|Description|Default|
|-----|-----------|-------|
|**image.tag**|version of docker image to use|`v0.6.5`|
|**env.anycableHost**|listen ip address or host|`0.0.0.0`|
|**env.anycablePort**|listen port number|`8080`|
|**env.anycablePath**|WebSocket endpoint path|`/cable`|
|**env.anycableSslCert**|SSL certificate path||
|**env.anycableSslKey**|SSL private key path||
|**env.anycableRedisUrl**|Redis DB url|`redis://localhost:6379/5`|
|**env.anycableRedisChannel**|Redis channel for broadcasts|`__anycable__`|
|**env.anycableRpcHost**|RPC service address|`localhost:50051`|
|**env.anycableHeaders**|List of headers to proxy to RPC|`cookie`|
|**env.anycableDisconnectRate**|Max number of Disconnect calls per second|`100`|

### Monitoring

|Value|Description|Default|
|-----|-----------|-------|
|**env.anycableLogLevel**|Set logging level (debug/info/warn/error/fatal)|`info`|
|**env.anycableLogFormat**|Set logging format (text, json)|`text`|
|**env.anycableDebug**|Enable debug mode (more verbose logging)||
|**env.anycableMetricsLog**|Enable metrics logging (with info level)||
|**env.anycableMetricsLogInterval**|Specify how often flush metrics logs (in seconds)|`15`|
|**env.anycableMetricsLogFormatter**|Specify the path to custom Ruby formatter script (only supported on MacOS and Linux)||
|**env.anycableMetricsHttp**|Enable HTTP metrics endpoint at the specified path|`/metrics`|
|**env.anycableMetricsHost**|Server host for metrics endpoint, default: the same as for main server,||
|**env.anycableMetricsPort**|Server port for metrics endpoint, default: the same as for main server,|`8081`|
|**serviceMonitor.enabled**|Enable creation of `ServiceMonitor` resource for automatic metrics discovery by Prometheus operator|`false`|
|**serviceMonitor.namespace**|Namespace to create ServiceMonitor in (if differs from chart's namespace)|_chart's namespace_|
|**serviceMonitor.interval**|Metrics scrape interval|_Prometheus default_|
|**serviceMonitor.labels**|Labels that should be present in service monitor to be discovered|`{}`|

### Ingress configuration

|Value|Description|Default|
|-----|-----------|-------|
|**ingress.enable**|When true, enables ingress resource for anycable|`false`|
|**ingress.host**|Hostname for the ingress resource to use|`example.com`|
|**ingress.path**|When true, enables ingress resource for anycable|`/cable`|
|**ingress.acme**|Enables the ingress resource annotation which tells cert-manager to issue a Let's Encrypt certificate|`{}`|
|**ingress.nonAcme**|Enables the ingress resource annotation which tells cert-manager to use existing certificate|`{ hosts: [] }`|
|**ingress.annotations**|Additional annotations for the ingress resource||

See `values.yaml` for some more Kubernetes-specific configuration options.

## Development

### Upgrading charts

 1. Clone this repository

 2. Create git worktree for `gh-pages` branch:

    ```sh
    make prepare
    ```

 3. Update your chart, bump version in its `Chart.yaml`

 4. Lint you chart:

    ```sh
    helm lint anycable-go
    ```

 5. Commit and push your changes:

    ```sh
    git commit -m "anycable-go: vX.Y.Z"
    git tag anycable-go-X.Y.Z -s -m "anycable-go chart vX.Y.Z for app version A.B.C"
    git push --follow-tags
    ```

 6. Build and publish charts into repository:

    ```sh
    make release
    ```

 7. Enjoy!
