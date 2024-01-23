{{/*
Expand the name of the chart.
*/}}
{{- define "faikChallenge.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "faikChallenge.fullname" -}}
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
{{- define "faikChallenge.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "faikChallenge.labels" -}}
helm.sh/chart: {{ include "faikChallenge.chart" . }}
{{ include "faikChallenge.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
General Selector labels
*/}}
{{- define "faikChallenge.selectorLabels" -}}
app.kubernetes.io/name: {{ include "faikChallenge.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Producer Selector labels
*/}}
{{- define "faikChallenge.producerSelectorLabels" -}}
release: producer
{{- end }}
{{/*
Producer Selector labels
*/}}
{{- define "faikChallenge.consumerSelectorLabels" -}}
release: consumer
{{- end }}
{{/*
producer App Name
*/}}
{{- define "faikChallenge.producerAppName"  -}}
{{- printf "%s-%s"  .Release.Name  "producer" }}
{{- end }}
{{/*
consumer App Name
*/}}
{{- define "faikChallenge.consumerAppName" -}}
{{- printf "%s-%s" ( .Release.Name ) ("consumer") }}
{{- end }}