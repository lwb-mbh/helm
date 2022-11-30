{{/*
Expand the name of the chart.
*/}}
{{- define "deploy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "deploy.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "deploy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "deploy.labels" -}}
helm.sh/chart: {{ include "deploy.chart" . }}
{{ include "tomcat.deploy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tomcat.deploy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "deploy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: tomcat
tier: frontend
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "deploy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "deploy.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "gitlabPullSecret" }}
{{- with .Values.global.imageCredentials }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

{{- define "helpers.list-tomcat-env-variables"}}
{{- range .Values.env.plain }}
- name: {{ .name }}
  value: {{ .value | quote }}
{{- end }}
{{- end }}

{{/*
Name of secrets
*/}}
{{- define "deploy.secrets" -}}
{{- printf "%s-%s" .Chart.Name "secrets" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Name of secrets
*/}}
{{- define "deploy.externalsecrets" -}}
{{- printf "%s_%s" .Chart.Name "secrets" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create name of secretstore.
*/}}
{{- define "deploy.secretstore" -}}
{{- printf "%s" .Release.Name | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
