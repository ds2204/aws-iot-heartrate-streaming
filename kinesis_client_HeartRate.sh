#!/usr/bin/env bash
set -euo pipefail
# Synthetic demo data. Default is an offline preview; --send explicitly enables AWS writes.
mode="${1:---dry-run}"
count="${COUNT:-10}"
[[ "$count" =~ ^[1-9][0-9]*$ ]] || { echo "COUNT must be a positive integer" >&2; exit 2; }
[[ "$mode" == --dry-run || "$mode" == --send ]] || { echo "Usage: bash kinesis_client_HeartRate.sh [--dry-run|--send]" >&2; exit 2; }
if [[ "$mode" == --send ]]; then
  : "${STREAM_NAME:?Set STREAM_NAME before sending}"
  command -v aws >/dev/null
fi
for ((i=0; i<count; i++)); do
  deviceID=$((RANDOM % 10 + 1))
  heartRate=$((RANDOM % 81 + 60))
  printf '%s,%s\n' "$deviceID" "$heartRate"
  if [[ "$mode" == --send ]]; then
    payload=$(printf '%s,%s\n' "$deviceID" "$heartRate" | base64 | tr -d '\n')
    aws kinesis put-record --stream-name "$STREAM_NAME" --data "$payload" --cli-binary-format base64 --partition-key "$deviceID" --region "${AWS_REGION:-us-east-1}"
    sleep "${INTERVAL_SECONDS:-1}"
  fi
done
