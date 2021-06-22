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

{{/*
Template to generate secrets for a private Docker repository for K8s to use
*/}}
{{- define "anycableGo.imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.imageCredentials.registry (printf "%s:%s" .Values.imageCredentials.username .Values.imageCredentials.password | b64enc) | b64enc }}
{{- end }}

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
