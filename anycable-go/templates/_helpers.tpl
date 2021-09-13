{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "anycableGo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "anycableGo.fullname" -}}
{{- default (printf "%s-anycable-go" .Release.Name) .Values.fullNameOverride | trunc 63 -}}
{{- end -}}

{{/* Template to generate apiVersion for ingress */}}
{{- define "anycableGo.apiVersions.ingress" }}
    {{- $kubeVersion := $.Capabilities.KubeVersion.Version }}
    {{- $apiVersions := $.Capabilities.APIVersions }}

    {{- if ($kubeVersion | semverCompare ">=1.22.0-0") -}}
        {{- if $apiVersions.Has "networking.k8s.io/v1" -}}
            {{- "networking.k8s.io/v1" -}}
        {{- end -}}
    {{- else if ($kubeVersion | semverCompare ">=1.19.0-0" | and ($apiVersions.Has "networking.k8s.io/v1")) -}}
        {{- "networking.k8s.io/v1" -}}
    {{- else if ($kubeVersion | semverCompare ">=1.14.0-0" | and ($apiVersions.Has "networking.k8s.io/v1beta1")) -}}
        {{- "networking.k8s.io/v1beta1" -}}
    {{- else if $apiVersions.Has "extensions/v1beta1" -}}
        {{- "extensions/v1beta1" -}}
    {{- end -}}
{{- end }}

{{/*
Template to generate secrets for a private Docker repository for K8s to use
*/}}
{{- define "anycableGo.imagePullSecrets" }}
{{- with .Values.image.pullSecrets -}}
{{- if .enabled }}
{{- $username := required "image.pullSecrets.username" .username -}}
{{- $registry := required "image.pullSecrets.registry" .registry -}}
{{- $password := required "image.pullSecrets.password" .password -}}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" $registry (printf "%s:%s" $username $password | b64enc) | b64enc }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Template to
*/}}
{{- define "anycableGo.envFrom" -}}
- secretRef:
    name: {{ template "anycableGo.fullname" . }}-secrets
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_HOST
*/}}
{{- define "anycableGo.anycableHost" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableHost) -}}
    {{ .Values.global.anycableGo.env.anycableHost | quote }}
{{- else if not (empty .Values.env.anycableHost) -}}
    {{ .Values.env.anycableHost | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_PORT
*/}}
{{- define "anycableGo.anycablePort" -}}
{{- if not (empty .Values.global.anycableGo.env.anycablePort) -}}
    {{ .Values.global.anycableGo.env.anycablePort | quote }}
{{- else if not (empty .Values.env.anycablePort) -}}
    {{ .Values.env.anycablePort | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_PATH
*/}}
{{- define "anycableGo.anycablePath" -}}
{{- if not (empty .Values.global.anycableGo.env.anycablePath) -}}
    {{ .Values.global.anycableGo.env.anycablePath | quote }}
{{- else if not (empty .Values.env.anycablePath) -}}
    {{ .Values.env.anycablePath | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_REDIS_CHANNEL
*/}}
{{- define "anycableGo.anycableRedisChannel" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableRedisChannel) -}}
    {{ .Values.global.anycableGo.env.anycableRedisChannel | quote }}
{{- else if not (empty .Values.env.anycableRedisChannel) -}}
    {{ .Values.env.anycableRedisChannel | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_REDIS_SENTINEL_DISCOVERY_INTERVAL
*/}}
{{- define "anycableGo.anycableRedisSentinelDiscoveryInterval" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableRedisSentinelDiscoveryInterval) -}}
    {{ .Values.global.anycableGo.env.anycableRedisSentinelDiscoveryInterval | quote }}
{{- else if not (empty .Values.env.anycableRedisSentinelDiscoveryInterval) -}}
    {{ .Values.env.anycableRedisSentinelDiscoveryInterval | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_REDIS_KEEPALIVE_INTERVAL
*/}}
{{- define "anycableGo.anycableRedisKeepaliveInterval" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableRedisKeepaliveInterval) -}}
    {{ .Values.global.anycableGo.env.anycableRedisKeepaliveInterval | quote }}
{{- else if not (empty .Values.env.anycableRedisKeepaliveInterval) -}}
    {{ .Values.env.anycableRedisKeepaliveInterval | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_RPC_HOST
*/}}
{{- define "anycableGo.anycableRpcHost" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableRpcHost) -}}
    {{ .Values.global.anycableGo.env.anycableRpcHost | quote }}
{{- else if not (empty .Values.env.anycableRpcHost) -}}
    {{ .Values.env.anycableRpcHost | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_HEADERS
*/}}
{{- define "anycableGo.anycableHeaders" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableHeaders) -}}
    {{ .Values.global.anycableGo.env.anycableHeaders | quote }}
{{- else if not (empty .Values.env.anycableHeaders) -}}
    {{ .Values.env.anycableHeaders | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_DISCONNECT_RATE
*/}}
{{- define "anycableGo.anycableDisconnectRate" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableDisconnectRate) -}}
    {{ .Values.global.anycableGo.env.anycableDisconnectRate | quote }}
{{- else if not (empty .Values.env.anycableDisconnectRate) -}}
    {{ .Values.env.anycableDisconnectRate | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_LOG_LEVEL
*/}}
{{- define "anycableGo.anycableLogLevel" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableLogLevel) -}}
    {{ .Values.global.anycableGo.env.anycableLogLevel | quote }}
{{- else if not (empty .Values.env.anycableLogLevel) -}}
    {{ .Values.env.anycableLogLevel | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_LOG_FORMAT
*/}}
{{- define "anycableGo.anycableLogFormat" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableLogFormat) -}}
    {{ .Values.global.anycableGo.env.anycableLogFormat | quote }}
{{- else if not (empty .Values.env.anycableLogFormat) -}}
    {{ .Values.env.anycableLogFormat | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_DEBUG
*/}}
{{- define "anycableGo.anycableDebug" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableDebug) -}}
    {{ .Values.global.anycableGo.env.anycableDebug | quote }}
{{- else if not (empty .Values.env.anycableDebug) -}}
    {{ .Values.env.anycableDebug | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_METRICS_LOG
*/}}
{{- define "anycableGo.anycableMetricsLog" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableMetricsLog) -}}
    {{ .Values.global.anycableGo.env.anycableMetricsLog | quote }}
{{- else if not (empty .Values.env.anycableMetricsLog) -}}
    {{ .Values.env.anycableMetricsLog | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_METRICS_LOG_INTERVAL
*/}}
{{- define "anycableGo.anycableMetricsLogInterval" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableMetricsLogInterval) -}}
    {{ .Values.global.anycableGo.env.anycableMetricsLogInterval | quote }}
{{- else if not (empty .Values.env.anycableMetricsLogInterval) -}}
    {{ .Values.env.anycableMetricsLogInterval | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_METRICS_LOG_FORMATTER
*/}}
{{- define "anycableGo.anycableMetricsLogFormatter" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableMetricsLogFormatter) -}}
    {{ .Values.global.anycableGo.env.anycableMetricsLogFormatter | quote }}
{{- else if not (empty .Values.env.anycableMetricsLogFormatter) -}}
    {{ .Values.env.anycableMetricsLogFormatter | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_METRICS_HTTP
*/}}
{{- define "anycableGo.anycableMetricsHttp" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableMetricsHttp) -}}
    {{ .Values.global.anycableGo.env.anycableMetricsHttp | quote }}
{{- else if not (empty .Values.env.anycableMetricsHttp) -}}
    {{ .Values.env.anycableMetricsHttp | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_METRICS_HOST
*/}}
{{- define "anycableGo.anycableMetricsHost" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableMetricsHost) -}}
    {{ .Values.global.anycableGo.env.anycableMetricsHost | quote }}
{{- else if not (empty .Values.env.anycableMetricsHost) -}}
    {{ .Values.env.anycableMetricsHost | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_METRICS_PORT
*/}}
{{- define "anycableGo.anycableMetricsPort" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableMetricsPort) -}}
    {{ .Values.global.anycableGo.env.anycableMetricsPort | quote }}
{{- else if not (empty .Values.env.anycableMetricsPort) -}}
    {{ .Values.env.anycableMetricsPort | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_HEALTH_PATH
*/}}
{{- define "anycableGo.anycableHealthPath" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableHealthPath) -}}
    {{ .Values.global.anycableGo.env.anycableHealthPath | quote }}
{{- else if not (empty .Values.env.anycableHealthPath) -}}
    {{ .Values.env.anycableHealthPath | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_MAX_MESSAGE_SIZE
*/}}
{{- define "anycableGo.anycableMaxMessageSize" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableMaxMessageSize) -}}
    {{ .Values.global.anycableGo.env.anycableMaxMessageSize | quote }}
{{- else if not (empty .Values.env.anycableMaxMessageSize) -}}
    {{ .Values.env.anycableMaxMessageSize | quote }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_REDIS_URL
*/}}
{{- define "anycableGo.anycableRedisUrl" -}}
{{- if not (empty .Values.global.anycableGo.redisUrlSecret) -}}
secretKeyRef:
    name: {{ .Values.global.anycableGo.redisUrlSecret.name }}
    key: {{ .Values.global.anycableGo.redisUrlSecret.key }}
{{- else if not (empty .Values.redisUrlSecret) -}}
secretKeyRef:
    name: {{ .Values.redisUrlSecret.name }}
    key: {{ .Values.redisUrlSecret.key }}
{{- else -}}
secretKeyRef:
    name: {{ template "anycableGo.fullname" . }}-secrets
    key: ANYCABLE_REDIS_URL
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_REDIS_SENTINELS
*/}}
{{- define "anycableGo.anycableRedisSentinels" -}}
{{- if not (empty .Values.global.anycableGo.redisSentinelsSecret) -}}
secretKeyRef:
    name: {{ .Values.global.anycableGo.redisSentinelsSecret.name }}
    key: {{ .Values.global.anycableGo.redisSentinelsSecret.key }}
{{- else if not (empty .Values.redisSentinelsSecret) -}}
secretKeyRef:
    name: {{ .Values.redisSentinelsSecret.name }}
    key: {{ .Values.redisSentinelsSecret.key }}
{{- else -}}
secretKeyRef:
    name: {{ template "anycableGo.fullname" . }}-secrets
    key: ANYCABLE_REDIS_SENTINELS
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for the Redis URL
*/}}
{{- define "anycableGo.redisUrl" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableRedisUrl) -}}
    {{ .Values.global.anycableGo.env.anycableRedisUrl }}
{{- else if not (empty .Values.env.anycableRedisUrl) -}}
    {{ .Values.env.anycableRedisUrl }}
{{- end -}}
{{- end -}}

{{/*
Template to provide a value for ANYCABLE_MAX_MESSAGE_SIZE
*/}}
{{- define "anycableGo.redisSentinels" -}}
{{- if not (empty .Values.global.anycableGo.env.anycableRedisSentinels) -}}
    {{ .Values.global.anycableGo.env.anycableRedisSentinels }}
{{- else if not (empty .Values.env.anycableRedisSentinels) -}}
    {{ .Values.env.anycableRedisSentinels }}
{{- end -}}
{{- end -}}
