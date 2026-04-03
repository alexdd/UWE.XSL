#!/bin/bash
# UWE.XSL - DITA Publishing Stylesheets
# Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
# SPDX-License-Identifier: LGPL-3.0-only
# See license.txt for the full license text.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# --- User configuration (no auto-detection/guessing) ---
# Java executable:
# - mac mini (Homebrew): export JAVA_BIN=/opt/homebrew/opt/openjdk/bin/java
# - Docker: keep default JAVA_BIN=java (if image has java in PATH)
JAVA_BIN="${JAVA_BIN:-java}"

# Optional pipeline base URIs (must be valid file: URIs and end with '/')
# Only pass them when explicitly set.
UWE_INPUT_BASE="${UWE_INPUT_BASE:-}"
UWE_OUTPUT_BASE="${UWE_OUTPUT_BASE:-}"
UWE_LOG_BASE="${UWE_LOG_BASE:-}"
UWE_TMP_BASE="${UWE_TMP_BASE:-}"
UWE_VALIDATE_OUTPUT_BASE="${UWE_VALIDATE_OUTPUT_BASE:-}"

validate_base_uri() {
  local name="$1"
  local value="$2"
  case "$value" in
    file://*/) ;;
    *)
      echo "Invalid ${name}: '${value}'. Expected file://.../ (with trailing slash)." >&2
      exit 1
      ;;
  esac
}

[ -n "$UWE_INPUT_BASE" ] && validate_base_uri "UWE_INPUT_BASE" "$UWE_INPUT_BASE"
[ -n "$UWE_OUTPUT_BASE" ] && validate_base_uri "UWE_OUTPUT_BASE" "$UWE_OUTPUT_BASE"
[ -n "$UWE_LOG_BASE" ] && validate_base_uri "UWE_LOG_BASE" "$UWE_LOG_BASE"
[ -n "$UWE_TMP_BASE" ] && validate_base_uri "UWE_TMP_BASE" "$UWE_TMP_BASE"
[ -n "$UWE_VALIDATE_OUTPUT_BASE" ] && validate_base_uri "UWE_VALIDATE_OUTPUT_BASE" "$UWE_VALIDATE_OUTPUT_BASE"

uwe_path_from_output_uri() {
  local u="$1"
  case "$u" in
    file:///*) printf '%s' "${u#file://}" ;;
    file:/*) printf '%s' "${u#file:}" ;;
    *) return 1 ;;
  esac
}

if [[ "$JAVA_BIN" == */* ]]; then
  if [ ! -x "$JAVA_BIN" ]; then
    echo "Java executable not found or not executable: $JAVA_BIN" >&2
    exit 1
  fi
else
  if ! command -v "$JAVA_BIN" >/dev/null 2>&1; then
    echo "Java executable '$JAVA_BIN' not found in PATH." >&2
    exit 1
  fi
  JAVA_BIN="$(command -v "$JAVA_BIN")"
fi
if ! "$JAVA_BIN" -version >/dev/null 2>&1; then
  echo "Java executable failed: $JAVA_BIN" >&2
  exit 1
fi

CALABASH_HOME="$PROJECT_DIR/lib/calabash-dist"
CATALOG="$PROJECT_DIR/src/catalog.xml"

# Calabash 3: use xmlcalabash-app-*.jar
CALABASH_JAR=$(echo "$CALABASH_HOME"/xmlcalabash-app-*.jar 2>/dev/null | head -1)
if [ -z "$CALABASH_JAR" ] || [ ! -f "$CALABASH_JAR" ]; then
  echo "XML Calabash 3 not found. Run: bash scripts/install.sh" >&2
  exit 1
fi

# Optional flag: --no-validate (only meaningful when running main.xpl)
NO_VALIDATE=0
FAIL_ON_VALIDATE=0
FILTERED_ARGS=()
for a in "$@"; do
  if [ "$a" = "--no-validate" ]; then
    NO_VALIDATE=1
  elif [ "$a" = "--fail-on-validate" ]; then
    FAIL_ON_VALIDATE=1
  else
    FILTERED_ARGS+=("$a")
  fi
done
set -- "${FILTERED_ARGS[@]}"

# First argument = pipeline (default: pipeline.xpl). scripts/run.sh [pipeline] [extra args]
PIPELINE_IN="${1:-main.xpl}"
shift 2>/dev/null || true
case "$PIPELINE_IN" in
  /*)  PIPELINE="$PIPELINE_IN" ;;
  */*) PIPELINE="$PROJECT_DIR/$PIPELINE_IN" ;;
  *)   if [ -f "$PROJECT_DIR/src/xpl/$PIPELINE_IN" ]; then
         PIPELINE="$PROJECT_DIR/src/xpl/$PIPELINE_IN"
       else
         PIPELINE="$PROJECT_DIR/src/xpl/pipelines/$PIPELINE_IN"
       fi ;;
esac

# Pipeline uses FOP via p:os-exec (lib/fop required for PDF).
FOP_LIB="$PROJECT_DIR/lib/fop"
[ -d "$FOP_LIB/fop" ] && FOP_LIB="$FOP_LIB/fop"
CP="$CALABASH_JAR"
for j in "$CALABASH_HOME"/lib/*.jar; do [ -f "$j" ] && CP="$CP:$j"; done
for j in "$FOP_LIB"/build/*.jar "$FOP_LIB"/lib/*.jar; do [ -f "$j" ] && CP="$CP:$j"; done 2>/dev/null
if [ -n "$UWE_TMP_BASE" ] && TMP_DIR="$(uwe_path_from_output_uri "$UWE_TMP_BASE")"; then
  TMP_DIR="${TMP_DIR%/}"
else
  TMP_DIR="$PROJECT_DIR/test/tmp"
fi

# Generate FOP config: replace __FONT_DIR__ with absolute path to font directory.
FONT_DIR="$PROJECT_DIR/lib/fonts/noto"
if [ -f "$PROJECT_DIR/conf/fop/fop-template.xconf" ]; then
  "$JAVA_BIN" -cp "$CP" net.sf.saxon.Transform \
    -s:"$PROJECT_DIR/conf/fop/fop-template.xconf" \
    -xsl:"$PROJECT_DIR/src/xpl/tools/fop-config-resolve.xsl" \
    "font-dir=$FONT_DIR" \
    -o:"$PROJECT_DIR/conf/fop/fop-generated.xconf" 2>/dev/null || true
fi

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

# macOS/Unix: run FOP shell script. Windows (Git Bash): Java cannot exec that script — use cmd + fop.bat (see run.bat).
MAIN_OPTS=()
MAIN_PIPELINE=""
FOP_CLI=""
case "$PIPELINE" in
  *main.xpl)
    MAIN_PIPELINE=1
    FOP_SCRIPT="$FOP_LIB/fop"
    [ -f "$FOP_SCRIPT" ] || FOP_SCRIPT="$PROJECT_DIR/lib/fop/fop/fop"
    FOP_BAT="$FOP_LIB/fop.bat"
    [ -f "$FOP_BAT" ] || FOP_BAT="$PROJECT_DIR/lib/fop/fop/fop.bat"
    case "$(uname -s 2>/dev/null)" in
      MINGW*|MSYS*|CYGWIN*)
        MAIN_OPTS=(--step:main --output:result="${TMP_DIR}/pipeline-result.xml" use-cmd-wrapper=true "fop-command=$FOP_BAT")
        FOP_CLI="$FOP_BAT"
        ;;
      *)
        MAIN_OPTS=(--step:main --output:result="${TMP_DIR}/pipeline-result.xml" use-cmd-wrapper=false "fop-command=$FOP_SCRIPT")
        FOP_CLI="$FOP_SCRIPT"
        ;;
    esac
    ;;
esac

pipeline_env_opts_for() {
  local p="$1"
  local -a opts=()
  case "$p" in
    *main.xpl)
      [ -n "${UWE_INPUT_BASE:-}" ] && opts+=("input-base=$UWE_INPUT_BASE")
      [ -n "${UWE_OUTPUT_BASE:-}" ] && opts+=("output-base=$UWE_OUTPUT_BASE")
      [ -n "${UWE_LOG_BASE:-}" ] && opts+=("log-base=$UWE_LOG_BASE")
      [ -n "${UWE_TMP_BASE:-}" ] && opts+=("tmp-base=$UWE_TMP_BASE")
      ;;
    *validate.xpl)
      [ -n "${UWE_INPUT_BASE:-}" ] && opts+=("input-base=$UWE_INPUT_BASE")
      [ -n "${UWE_VALIDATE_OUTPUT_BASE:-}" ] && opts+=("output-base=$UWE_VALIDATE_OUTPUT_BASE")
      ;;
  esac
  # When opts is empty, printf '%s\0' with no args still emits a null record; the read
  # loop then passes "" to Calabash as a second pipeline (XI0204 on Windows/Git Bash).
  [ ${#opts[@]} -eq 0 ] || printf '%s\0' "${opts[@]}"
}

run_calabash() {
  local p="$1"; shift
  local -a env_opts=()
  while IFS= read -r -d '' x; do env_opts+=("$x"); done < <(pipeline_env_opts_for "$p")
  "$JAVA_BIN" -Dxml.catalog.files="$CATALOG" -cp "$CP" com.xmlcalabash.app.Main "$p" "$@" "${env_opts[@]}"
}

# Default behavior: when running the main pipeline, run validate.xpl first (unless --no-validate).
if [ -n "$MAIN_PIPELINE" ] && [ "$NO_VALIDATE" -eq 0 ]; then
  VALIDATE_PIPELINE="$PROJECT_DIR/src/xpl/pipelines/validate.xpl"
  run_calabash "$VALIDATE_PIPELINE"
  VRC=$?
  if [ "$VRC" -ne 0 ]; then
    echo "Validation reported errors (exit $VRC). Continuing with main pipeline." >&2
    if [ "$FAIL_ON_VALIDATE" -eq 1 ]; then
      exit "$VRC"
    fi
  fi
fi

run_calabash "$PIPELINE" "${MAIN_OPTS[@]}" "$@"
RC=$?
if [ -n "$UWE_OUTPUT_BASE" ] && p=$(uwe_path_from_output_uri "$UWE_OUTPUT_BASE"); then
  OUTPUT_FALLBACK="${p%/}"
else
  OUTPUT_FALLBACK="$PROJECT_DIR/test/output/XmlHandsOn"
fi

if [ "$RC" -eq 0 ] && [ -n "$MAIN_PIPELINE" ]; then
  for dir in "$TMP_DIR"/*; do
    [ -d "$dir" ] || continue
    lang="$(basename "$dir")"
    at2="$dir/at2.xml"
    pdf="$OUTPUT_FALLBACK/$lang/pdf/$lang.pdf"
    if [ -f "$at2" ]; then
      mkdir -p "$(dirname "$pdf")"
      [ -f "$pdf" ] && rm -f "$pdf"
      "$FOP_CLI" -c "$PROJECT_DIR/conf/fop/fop-generated.xconf" -atin "$at2" -pdf "$pdf" || RC=$?
    fi
  done
fi
exit "$RC"
