# Helm charts for anycable

This repo contains a [Helm chart](https://github.com/anycable/anycable-helm/tree/master/anycable-go) to deploy anycable-go websocket server.

## TL;DR

To install anycable-go to your kubernetes cluster simply run:

```shell
helm repo add anycable https://helm.anycable.io/

# With Helm 3
helm upgrade -i anycable-go anycable/anycable-go
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
|**image.tag**|Version of docker image to use|`1.4.7`|
|**image.pullSecrets.enabled**|Enable creating secret for pulling image from AnyCable Pro private registry|`false`|
|**image.pullSecrets.registry**|URL of a private registry you want to authorize to|`ghcr.io`|
|**image.pullSecrets.username**|Github username|``|
|**image.pullSecrets.password**|Github token|``|
|**env.anycableHost**|Listen IP address or host|`0.0.0.0`|
|**env.anycablePort**|Listen port number|`8080`|
|**env.anycablePath**|WebSocket endpoint path (you can specify multiple paths using a comma as separator)|`/cable`|
|**env.anycableSecret**|The application secret used to secure AnyCable features: signed streams, JWT authentication, etc.|``|
|**env.anycableStreamsSecret**|A dedicated secret key used to sign streams. If none specified, the application secret is used.|``|
|**env.anycableJwtSecret**|The secret key used to sign JWT tokens. Optional (the application secret is used if no JWT secret specified)|``|
|**env.anycableJwtTtl**|The time-to-live (TTL) for tokens in seconds.|`3600`|
|**env.anycableBroadcastAdapter**|Broadcasting adapter to use: redis, http, redisx or nats (multiple are allowed via a comma-separated list)|`redis`|
|**env.anycableBroadcastKey**|A secret key used to authorize broadcast requests. Currently, only used by the HTTP adapter. If not set, the value is inferred from the application secret.|``|
|**env.anycableHttpBroadcastPath**|HTTP pub/sub endpoint path|`/_broadcast`|
|**env.anycableHttpBroadcastPort**|Port to receive broadcasting requests|`8090`|
|**env.anycableHttpBroadcastSecret**|Authorization secret to protect the broadcasting endpoint||
|**env.anycableRedisUrl**|Redis DB url|`redis://localhost:6379/5`|
|**env.anycableRedisChannel**|Redis channel for broadcasts|`__anycable__`|
|**env.anycableRedisSentinels**|Comma-separated list of sentinel hosts, format: `:password@hostname:port,..`||
|**env.anycableRedisSentinelDiscoveryInterval**|Interval to rediscover sentinels in seconds|`30`|
|**env.anycableRedisKeepaliveInterval**|Interval to periodically ping Redis to make sure it's alive|`30`|
|**env.anycableRedisTlsVerify**|Whether to validate Redis server TLS certificate if rediss:// protocol is used|`false`|
|**env.anycableRedisTlsClientCertPath**|Path to file with client TLS certificate in PEM format if Redis server requires client authentication||
|**env.anycableRedisTlsClientKeyPath**|Path to file with private key for client TLS certificate if Redis server requires client authentication||
|**env.anycableRedisDisableCache**|Some managed Redis (e.g., Google Cloud) providers block many Redis commands, including client-side server tracking, which is enabled in AnyCable by default. See [here for more details](https://docs.anycable.io/troubleshooting?id=failed-to-connect-to-redis-unknown-command-39client39-with-args-beginning-with-39tracking39)|`false`|
|**env.anycableRpcConcurrency**|Max number of concurrent RPC request; should be slightly less than the RPC server concurrency|`28`|
|**env.anycableRpcHost**|RPC service address|`localhost:50051`|
|**env.anycableRpcEnableTls**|Enable client-side TLS with the RPC server|`false`|
|**env.anycableRpcTlsVerify**|Whether to verify the RPC server certificate|`true`|
|**env.anycableRpcTlsRootCa**|CA root certificate file path or contents in PEM format|If not set, system CAs will be used|
|**env.anycableRpcMaxCallRecvSize**|Override default MaxCallRecvMsgSize for RPC client (bytes)||
|**env.anycableRpcMaxCallSendSize**|Override default MaxCallSendMsgSize for RPC client (bytes)||
|**env.anycableRpcImpl**|RPC implementation (grpc, http)||If not set, infer RPC implementation from RPC host
|**env.anycableHttpRpcSecret**|Authentication secret for RPC over HTTP||
|**env.anycableHttpRpcTimeout**|HTTP RPC timeout (in ms)|`3000`|
|**env.anycableHeaders**|List of headers to proxy to RPC|`cookie`|
|**env.anycableProxyCookies**|Cookie keys to send to RPC, default is all||
|**env.anycablePresets**|Configuration presets, comma-separated (none, fly, heroku, broker)|Inferred automatically if possible|
|**env.anycableBroker**|Broker engine to use (none, memory, nats, redis)|``|
|**env.anycableHistoryLimit**|Max number of messages to keep in the stream's history|`100`|
|**env.anycableHistoryTtl**|TTL for messages in stream's history (seconds)|`300`|
|**env.anycableSessionsTtl**|TTL for expired/disconnected sessions (seconds)|`300`|
|**env.anycablePubsub**|Pub/Sub adapter to use (none, redis, nats)|``|
|**env.anycableNatsServers**|Comma-separated list of NATS cluster servers|`nats://localhost:4222`|
|**env.anycableNatsChannel**|NATS channel for broadcasts|`__anycable__`|
|**env.anycableNatsDontRandomizeServers**|Disable NATS servers randomization during (re-)connect|`false`|
|**env.anycableEmbedNats**|Enable embedded NATS server and use it for pub/sub||
|**env.anycableEnatsAddr**|NATS server bind address|`nats://localhost:4222`|
|**env.anycableEnatsCluster**|NATS cluster service bind address||
|**env.anycableEnatsClusterName**|NATS cluster name|`anycable-cluster`|
|**env.anycableEnatsClusterRoutes**|Comma-separated list of known cluster addresses||
|**env.anycableEnatsGateway**|NATS gateway bind address||
|**env.anycableEnatsGateways**|Semicolon-separated list of known gateway configurations||
|**env.anycableEnatsGatewayAdvertise**|NATS gateway advertise address||
|**env.anycableEnatsStoreDir**|Embedded NATS store directory for JetStream|If not set, auto-generated in the temp dir|
|**env.anycableEnatsServerName**|Embedded NATS unique server name|If not set, auto-generated|
|**env.anycableEnatsDebug**|Enable NATS server logs||
|**env.anycableEnatsTrace**|Enable NATS server protocol trace logs||
|**env.anycableMaxMessageSize**|Maximum size of a message in bytes|`65536`|
|**env.anycableMaxConn**|Limit simultaneous server connections|`0` (no limit)|
|**env.anycableShutdownTimeout**|Graceful shutdown timeout (in seconds)|`30`|
|**env.anycableDisconnectTimeout**|[DEPRECATED] Graceful shutdown timeout (in seconds). Use `env.anycableShutdownTimeout` instead|`5`|
|**env.anycableDisconnectRate**|Max number of Disconnect calls per second|`100`|
|**env.anycableShutdownPoolSize**|Number of goroutines to use for disconnect calls on shutdown|`16`|
|**env.anycableDisconnectBacklogSize**|Size of the channel's buffer for disconnect requests|`4096`|
|**env.anycableDisconnectMode**|Define when to call Disconnect callback: auto, always, never|`auto`|
|**env.anycableDisableDisconnect**|[DEPRECATED] Disable calling Disconnect callback. Use `env.anycableDisconnectMode=never` instead|`false`|
|**env.anycableReadBufferSize**|WebSocket connection read buffer size|`1024`|
|**env.anycableWriteBufferSize**|WebSocket connection write buffer size|`1024`|
|**env.anycableEnableWsCompression**|Enable WebSocket per message compression|`false`|
|**env.anycableHubGopoolSize**|Size of the goroutines pool to broadcast messages|`16`|
|**env.anycableAllowedOrigins**|Accept requests only from specified origins. No check is performed if empty||
|**env.anycablePingInterval**|Action Cable ping interval (in seconds)|`3`|
|**env.anycablePingTimestampPrecision**|Precision for timestamps in ping messages (s, ms, ns)|`s`|
|**env.anycablePongTimeout**|How long to wait for a pong response before disconnecting the client (in seconds). Zero means no pongs required|`0`|
|**env.anycableJwtIdKey**|Encryption key used to verify JWT tokens||
|**env.anycableJwtIdParam**|Name of a query string param or an HTTP header carrying a token|`jid`|
|**env.anycableJwtIdEnforce**|Whether to enforce token presence for all connections|`false`|
|**env.anycableTurboStreams**|Enable Turbo Streams|`false`|
|**env.anycableTurboRailsKey**|Enable Turbo Streams fastlane with the specified signing key||
|**env.anycableTurboRailsCleartext**|Enable Turbo Streams fastlane without stream names signing|`false`|
|**env.anycableCableReadyKey**|Enable CableReady fastlane with the specified signing key||
|**env.anycableCableReadyCleartext**|Enable Cable Ready fastlane without stream names signing|`false`|
|**env.anycableSse**|Enable SSE endpoint|`false`|
|**env.anycableSsePath**|SSE endpoint path|`/events`|
|**command**|Override entrypoint for Alpine images|`/usr/local/bin/anycable-go`
|**args**|Customize ARGV (in addition to `env` settings above)|`[]`|

### Kubernetes

|Value|Description|Default|
|-----|-----------|-------|
|**replicas**|Number of replicas for `anycable-go` deployment (ignored when HPA is enabled)|`1`|
|**hpa.enabled**|Enable HorizontalPodAutoscaler|`false`|
|**hpa.minReplicas**|Minimum replicas for HPA|`1`|
|**hpa.maxReplicas**|Maximum replicas for HPA|`3`|
|**hpa.targetCPUUtilizationPercentage**|Target CPU utilization for HPA|`50`|
|**pod.annotations**|User-specified Pod annotations|`{}`|
|**pod.extraLabels**|User-specified Pod Labels|`{}`|
|**pod.tolerations**|User-specified Pod tolerations|`[]`|
|**pod.serviceAccountName**|User-specified ServiceAccount for Pod identity||
|**service.annotations**|User-specified Service annotations|`{}`|

### Monitoring

|Value|Description|Default|
|-----|-----------|-------|
|**env.anycableLogLevel**|Set logging level (debug/info/warn/error/fatal)|`info`|
|**env.anycableLogFormat**|Set logging format (text, json)|`text`|
|**env.anycableDebug**|Enable debug mode (more verbose logging)||
|**env.anycableHealthPath**|HTTP health endpoint path|`/health`|
|**env.anycableMetricsLog**|Enable metrics logging (with info level)||
|**env.anycableMetricsRotateInterval**|Specify how often to flush metrics to writers (logs, statsd) (in seconds)|`15`|
|**env.anycableMetricsLogInterval**|[DEPRECATED] Specify how often flush metrics logs. Use `env.anycableMetricsRotateInterval` instead|`15`|
|**env.anycableMetricsLogFormatter**|Specify the path to custom Ruby formatter script (only supported on MacOS and Linux)||
|**env.anycableMetricsHttp**|Enable HTTP metrics endpoint at the specified path|`/metrics`|
|**env.anycableMetricsHost**|Server host for metrics endpoint, default: the same as for main server||
|**env.anycableMetricsPort**|Server port for metrics endpoint, default: the same as for main server|`8081`|
|**env.anycableMetricsTags**|Comma-separated list of default (global) tags to add to every metric||
|**env.anycableMetricsLogFilter**|Specify list of metrics to print to log||
|**env.anycableStatsRefreshInterval**|How often to refresh the server stats (in seconds)|`5`|
|**env.anycableStatsdHost**|Server host for metrics sent to statsd server||
|**env.anycableStatsdPrefix**|Statsd metrics prefix|`anycable_go.`|
|**env.anycableStatsdMaxPacketSize**|Statsd client maximum UDP packet size|`1400`|
|**env.anycableStatsdTagsFormat**|One of "datadog", "influxdb", or "graphite"|`datadog`|
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

 2. Update your chart, bump version in its `Chart.yaml`

 3. Lint you chart:

    ```sh
    helm lint anycable-go
    ```

 4. Commit and push your changes:

    ```sh
    git commit -m "anycable-go: vX.Y.Z"
    git tag anycable-go-X.Y.Z -s -m "anycable-go chart vX.Y.Z for app version A.B.C"
    git push --follow-tags
    ```

 5. Enjoy!
