{{- define "libchart.pv-secrets-store-csi-pv.tpl" -}}
apiVersion: v1
kind: PersistentVolume
metadata:
  name: {{ .Values.csi.name }}
  labels:
    {{- include "libchart.labels" . | nindent 4 }}
spec:
  capacity:
    storage: {{ .Values.csi.storage | default "10Mi" | quote }}
  accessModes:
    - ReadOnlyMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: {{ .Values.csi.storageClassName | quote}}
  csi:
    driver: secrets-store.csi.k8s.com
    readOnly: true
    volumeHandle: kv
    volumeAttributes:
      providerName:  {{ .Values.csi.providerName | quote}}
      usePodIdentity: {{ .Values.csi.usePodIdentity | default "false" | quote }}
      keyvaultName: {{ .Values.csi.keyvaultName | quote}}
      objects:  |
        array:
{{ toYaml .Values.csi.array | indent 8 }}
      resourceGroup: {{ .Values.csi.resourceGroup | quote}}
      subscriptionId: {{ .Values.csi.subscriptionId | quote}}
      tenantId: {{ .Values.csi.tenantId | quote}}
    nodePublishSecretRef:
      name: secrets-store-creds
{{- end -}}
