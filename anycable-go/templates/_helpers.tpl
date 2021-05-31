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

{{/*
Template to generate apiVersion for ingress
*/}}
{{- define "apiVersions.ingress" }}
{{- $apiVersion := "" }}
{{- $gitVersion := $.Capabilities.KubeVersion.GitVersion -}}
{{- $apiVersions := $.Capabilities.APIVersions -}}
{{- if and ($apiVersions.Has "networking.k8s.io/v1") (semverCompare ">= 1.19.x" $gitVersion) -}}
{{- print "networking.k8s.io/v1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- end -}}
{{- end }}