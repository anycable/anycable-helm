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

{{/* Template to generate apiVersion for HPA */}}
{{- define "anycableGo.apiVersions.hpa" }}
    {{- $kubeVersion := $.Capabilities.KubeVersion.Version }}
    {{- $apiVersions := $.Capabilities.APIVersions }}

    {{- if $kubeVersion | semverCompare ">=1.26.0-0" -}}
        {{- "autoscaling/v2" -}}
    {{- else if $kubeVersion | semverCompare ">=1.23.0-0" | and ($apiVersions.Has "autoscaling/v2") -}}
        {{- "autoscaling/v2" -}}
    {{- else if $kubeVersion | semverCompare ">=1.12.0-0" | and ($apiVersions.Has "autoscaling/v2beta2") -}}
        {{- "autoscaling/v2beta2" -}}
    {{- else if $apiVersions.Has "autoscaling/v2beta1" }}
        {{- "autoscaling/v2beta1" -}}
    {{- else }}
        {{- "autoscaling/v1" -}}
    {{- end -}}
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
