{{/* vim: set filetype=mustache: */}}

{{/* Template to overload .Values with .Values.global.anycableGo */}}
{{- define "anycableGo.values" -}}
{{- unset (deepCopy $.Values) "global" | merge (($.Values.global | default dict).anycableGo | default dict) | toYaml }}
{{- end -}}

{{/* Template to expand the name of the chart */}}
{{- define "anycableGo.name" -}}
{{- $values := include "anycableGo.values" . | fromYaml -}}
{{- default $.Chart.Name $values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Template to generate full name of the chart */}}
{{- define "anycableGo.fullname" -}}
{{- $values := include "anycableGo.values" . | fromYaml -}}
{{- default (printf "%s-anycable-go" $.Release.Name) $values.fullNameOverride | trunc 63 -}}
{{- end -}}

{{/* Template to generate common labels */}}
{{- define "anycableGo.labels" -}}
app: {{ template "anycableGo.name" . }}
chart: "{{ $.Chart.Name }}-{{ $.Chart.Version | replace "+" "_" }}"
component: anycable-go
heritage: {{ $.Release.Service | quote }}
release: {{ $.Release.Name | quote }}
{{- end -}}

{{/* Template to generate secrets for a private Docker repository for K8s to use */}}
{{- define "anycableGo.imagePullSecrets" }}
{{- $values := include "anycableGo.values" . | fromYaml -}}
{{- with $values.image.pullSecrets -}}
{{- if .enabled }}
{{- $username := required "image.pullSecrets.username" .username -}}
{{- $registry := required "image.pullSecrets.registry" .registry -}}
{{- $password := required "image.pullSecrets.password" .password -}}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" $registry (printf "%s:%s" $username $password | b64enc) | b64enc }}
{{- end }}
{{- end -}}
{{- end -}}
