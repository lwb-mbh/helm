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
{{ include "mariadb.deploy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mariadb.deploy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "deploy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
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

{{- define "helpers.list-mariadb-env-variables"}}
- name: TZ
  value: "Europe/Berlin"
- name: MYSQL_USER
  value: {{ .Values.global.plain.dbUser | quote }}
- name: MYSQL_DATABASE
  value: {{ .Values.global.plain.dbDatabase | quote }}
{{- end }}

{{- define "helpers.list-backup-env-variables"}}
- name: DB_USERNAME
  value: {{ .Values.global.plain.dbUser | quote }}
- name: DB_HOST
  value: {{ (include "deploy.mariadb.host" .) | quote }}
- name: DB_PORT
  value: {{ .Values.global.plain.dbPort | quote }}
- name: LOG_USERNAME
  value: {{ .Values.global.plain.dbLogUser | quote }}
- name: LOG_HOST
  value: {{ .Values.global.plain.dbLogHost | quote }}
{{- end }}

{{/*
Name of backup
*/}}
{{- define "deploy.backup.name" -}}
{{- printf "%s-%s" (include "deploy.fullname" .) "backup" | trunc 63 }}
{{- end }}

{{/*
Backup path name
*/}}
{{- define "deploy.backup.subPath" -}}
{{- printf "%s/%s/%s" .Chart.Name ( default "stage" .Values.global.plain.environment ) .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Name of backup env secrets
*/}}
{{- define "deploy.backup.env.secrets" -}}
{{- printf "%s-%s-%s-%s" (include "deploy.fullname" .) "backup" "env" "secrets" | trunc 63 }}
{{- end }}

{{/*
host of mariadb
*/}}
{{- define "deploy.mariadb.host"}}
{{- if .Values.global.plain.dbExternal }}
{{- .Values.global.plain.dbIP }}
{{- else }}
{{- (include "deploy.fullname" .) }}
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