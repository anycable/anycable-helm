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
helm repo add anycable https://helm.anycable.io/

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
  --set image.tag=1.0.1 \
  anycable/anycable-go
```

The above command installs a specified version of anycable.

## Supported Chart values

### anycable-go

These are the values used to configure anycable-go itself:

|Value|Description|Default|
|-----|-----------|-------|
|**image.repository**|Choose between `anycable/anycable-go` and `ghcr.io/anycable/anycable-go-pro`|`anycable/anycable-go`|
|**image.tag**|Version of docker image to use|`1.0.2`|
|**image.pullSecrets.enabled**|Enable creating secret for pulling image from AnyCable Pro private registry|`false`|
|**image.pullSecrets.registry**|URL of a private registry you want to authorize to|`ghcr.io`|
|**image.pullSecrets.username**|Github username|``|
|**image.pullSecrets.password**|Github token|``|
|**env.anycableHost**|Listen ip address or host|`0.0.0.0`|
|**env.anycablePort**|Listen port number|`8080`|
|**env.anycablePath**|WebSocket endpoint path|`/cable`|
|**env.anycableRedisUrl**|Redis DB url|`redis://localhost:6379/5`|
|**env.anycableRedisKeepaliveInterval**|Interval to periodically ping Redis to make sure it's alive||
|**env.anycableRedisChannel**|Redis channel for broadcasts|`__anycable__`|
|**env.anycableRedisSentinels**|Comma separated list of sentinel hosts, format: `:password@host:port,…`||
|**env.anycableRedisSentinelDiscoveryInterval**|Interval to rediscover sentinels in seconds|`30`|
|**env.anycableRpcHost**|RPC service address|`localhost:50051`|
|**env.anycableHeaders**|List of headers to proxy to RPC|`cookie`|
|**env.anycableDisconnectRate**|Max number of Disconnect calls per second|`100`|
|**env.anycableMaxMessageSize**|Maximum size of a message in bytes|`` (uses anycable-go default: 65536)|

### Kubernetes

|Value|Description|Default|
|-----|-----------|-------|
|**annotations**|User-specified Pod annotations|`{}`|
|**service.annotations**|User-specified Service annotations|`{}`|
|**serviceAccountName**|User-specified ServiceAccount for Pod identity||

### Monitoring

|Value|Description|Default|
|-----|-----------|-------|
|**env.anycableLogLevel**|Set logging level (debug/info/warn/error/fatal)|`info`|
|**env.anycableLogFormat**|Set logging format (text, json)|`text`|
|**env.anycableDebug**|Enable debug mode (more verbose logging)||
|**env.anycableHealthPath**|HTTP health endpoint path|`/health`|
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

### SSL/TLS configuration

Only in case if you can't terminate SSL at Ingress controller or need encryption inside your cluster.

|Value|Description|Default|
|-----|-----------|-------|
|**tls.secretName**|Specify name of TLS secret to use. Existing secret will be used if you don't provide certificate and key||
|**tls.crt**|Specify full certificate chain in PEM format to be written in new TLS secret||
|**tls.key**|Specify private key in PEM format to be written in new TLS secret||

See `values.yaml` for some more Kubernetes-specific configuration options.

### Custom ENV values

When a new version of anycable become available, the chart can be not updated yet. In this case you would need to add new environment variables to the application.
These variables can be added to the **env.custom** section of values. Under the hood, custom env variables are passed to the container through the secret.

```yaml
# ...
env:
  # ...
  custom:
    NEW_FEATURE: foobar
```

## Configuration examples

#### Encrypting communication between ingress-nginx and anycable-go using private CA

 0. Obtain certificate/key pair for anycable-go and CA root certificate for ingress-nginx from your CA.

    For testing purposes you can generate your own CA with following commands:

    ```sh
    # Generate one-time private CA
    openssl req -x509 -sha256 -newkey rsa:4096 -keyout ca.key -out ca.crt -days 356 -nodes -subj '/CN=Fake CA'
    # Issue certificate for anycable-go using it
    openssl req -new -newkey rsa:4096 -keyout server.key -out server.csr -nodes -subj '/CN=anycable-go'
    openssl x509 -req -sha256 -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt
    ```

    See https://github.com/kubernetes/ingress-nginx/issues/4503#issuecomment-536835782 for details.

 1. Place private CA root certificate into separate secret containing _only_ `ca.crt` key:

    ```sh
    kubectl create secret generic ca-private --from-file=ca.crt=ca.crt
    ```

    See https://github.com/kubernetes/ingress-nginx/issues/4688 for details

    Place certificate/key pair for anycable-go into separate TLS secret

    ```sh
    kubectl create secret tls anycable-go-tls-private --from-file=tls.crt=server.crt --from-file=tls.key=server.key
    ```

 2. Reference secret with CA root certificate in the `nginx.ingress.kubernetes.io/proxy-ssl-secret` annotation (with namespace)

 3. Specify `HTTPS` as upstream protocol in `nginx.ingress.kubernetes.io/backend-protocol` annotation.

 4. Specify anycable-go certificate's `CN` (or one of `AltSubjectNames`) in [`proxy_ssl_name`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_name) directive in configuration snippet. Nginx sends the content of `$proxy_host` variable by default and in nginx-ingress always sends `upstream_balancer` as hostname in SNI extension and we need override it.

 5. Enable upstream SSL verification by setting `nginx.ingress.kubernetes.io/proxy-ssl-verify` annotation to `'on'`

Complete example:

```yaml
# values.yaml
fullNameOverride: anycable-go
ingress:
  enable: true
  path: /cable
  acme:
    hosts:
      - example.com
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: HTTPS
    nginx.ingress.kubernetes.io/configuration-snippet: |
      proxy_ssl_name anycable-go;
    nginx.ingress.kubernetes.io/proxy-ssl-secret: default/ca-private
    nginx.ingress.kubernetes.io/proxy-ssl-verify: 'on'
tls:
  secretName: anycable-go-tls
```

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
