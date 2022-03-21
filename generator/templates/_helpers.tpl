{{- define "generator.jobs" -}}
jobs:
{{- range .Values.http }}
  - type: http
    args:
      request:
        method: GET
        path: {{ quote . }}
{{- end }}
{{- range .Values.tcp }}
{{- $ip := .ip}}
{{- range .ports }}
  - type: tcp
    args:
      address: {{ printf "%s:%v" $ip . }}
      body: "{{ "{{" }} random_payload 10 {{ "}}" }}"
      interval_ms: 100
{{- end }}
{{- end }}
{{- range .Values.udp }}
{{- $ip := .ip}}
{{- range .ports }}
  - type: udp
    args:
      address: {{ printf "%s:%v" $ip . }}
      filter: "{{ "{{" }} (.Value (ctx_key \"global\")).EnablePrimitiveJobs {{ "}}" }}"
      body: "{{ "{{" }} random_payload 10 {{ "}}" }}"
      interval_ms: 1
{{- end }}
{{- end }}
{{- with .Values.other }}
{{ . | toYaml | nindent 2 }}
{{- end }}
{{- end }}
