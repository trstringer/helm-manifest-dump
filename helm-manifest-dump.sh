#!/bin/bash

NAMESPACE="$1"
RELEASE="$2"
TMP_DIR=$(mktemp -d)

if [[ -z "$NAMESPACE" || -z "$RELEASE" ]]; then
    echo "Missing parameters"
    echo "./helm-manifest-dump.sh <namespace> <release>"
    exit 1
fi

for REVISION in $(helm history -n "$NAMESPACE" "$RELEASE" | tail -n +2 | awk '{print $1}'); do
    helm get manifest -n "$NAMESPACE" --revision "$REVISION" "$RELEASE" > "$TMP_DIR/${RELEASE}_${REVISION}"
done

echo "Manifests located in '$TMP_DIR'"
