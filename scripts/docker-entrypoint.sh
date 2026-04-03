#!/bin/bash
# UWE.XSL - DITA Publishing Stylesheets
# Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
# SPDX-License-Identifier: LGPL-3.0-only
# See license.txt for the full license text.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_DIR"

# Docker defaults (compose should pass explicit UWE_*_BASE values)
UWE_INPUT_BASE="${UWE_INPUT_BASE:-file:///data/input/}"
UWE_OUTPUT_BASE="${UWE_OUTPUT_BASE:-file:///data/output/}"
UWE_LOG_BASE="${UWE_LOG_BASE:-file:///data/output/.logs/}"
UWE_TMP_BASE="${UWE_TMP_BASE:-file:///tmp/uwe-pipeline/}"
UWE_VALIDATE_OUTPUT_BASE="${UWE_VALIDATE_OUTPUT_BASE:-file:///data/output/validate/}"
export UWE_INPUT_BASE UWE_OUTPUT_BASE UWE_LOG_BASE UWE_TMP_BASE UWE_VALIDATE_OUTPUT_BASE

uri_to_path() {
  local uri="$1"
  case "$uri" in
    file:///*) printf '%s' "${uri#file://}" ;;
    *) echo "Invalid file URI: $uri" >&2; exit 1 ;;
  esac
}

OUTPUT_DIR="$(uri_to_path "$UWE_OUTPUT_BASE")"
LOG_DIR="$(uri_to_path "$UWE_LOG_BASE")"
TMP_DIR="$(uri_to_path "$UWE_TMP_BASE")"
VALIDATE_OUTPUT_DIR="$(uri_to_path "$UWE_VALIDATE_OUTPUT_BASE")"

mkdir -p "${OUTPUT_DIR}" "${LOG_DIR}" "${TMP_DIR}" "${VALIDATE_OUTPUT_DIR}"

exec bash "$SCRIPT_DIR/run.sh" "$@"
