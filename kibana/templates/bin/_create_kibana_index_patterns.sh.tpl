#!/bin/bash
{{/*
Copyright 2017 The Openstack-Helm Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/}}
set -ex

{{- range .Values.conf.create_kibana_indexes.indexes }}
curl -K- <<< "--user ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD}" \
  -XPOST "${ELASTICSEARCH_ENDPOINT}/.kibana/index-pattern/{{ . }}-*" -H 'Content-Type: application/json' \
  -d '{"title":"{{ . }}-*","timeFieldName":"@timestamp","notExpandable":true}'
{{- end }}
curl -K- <<< "--user ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD}" \
  -XPOST "${ELASTICSEARCH_ENDPOINT}/.kibana/config/5.6.4" -H 'Content-Type: application/json' \
  -d '{"defaultIndex" : "{{ .Values.conf.create_kibana_indexes.default_index }}-*"}'