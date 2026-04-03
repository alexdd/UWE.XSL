#!/bin/bash
# UWE.XSL - DITA Publishing Stylesheets
# Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
# SPDX-License-Identifier: LGPL-3.0-only
# See license.txt for the full license text.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LIB_DIR="$PROJECT_DIR/lib"

CALABASH_VERSION="3.0.41"
FOP_VERSION="2.11"
SCHXSLT_TAG="v1.10"

CASH_VERSION="8.1.5"
LUNR_VERSION="v2.3.9"
LUNR_LANG_VERSION="1.14.0"
MARKJS_VERSION="8.11.1"

RESLIB_DIR="$PROJECT_DIR/src/html/res/lib"

mkdir -p "$LIB_DIR"
mkdir -p "$RESLIB_DIR"

# ── XML Calabash 3 (XProc 3.0) ──────────────────────────────
if [ -f "$LIB_DIR/calabash-dist/xmlcalabash-app-${CALABASH_VERSION}.jar" ]; then
  echo "[ok] XML Calabash ${CALABASH_VERSION} already installed."
else
  echo "[..] Downloading XML Calabash ${CALABASH_VERSION}..."
  curl -L -o "$LIB_DIR/_calabash.zip" \
    "https://codeberg.org/xmlcalabash/xmlcalabash3/releases/download/${CALABASH_VERSION}/xmlcalabash-${CALABASH_VERSION}.zip"
  unzip -q "$LIB_DIR/_calabash.zip" -d "$LIB_DIR"
  rm -rf "$LIB_DIR/calabash-dist"
  mv "$LIB_DIR/xmlcalabash-${CALABASH_VERSION}" "$LIB_DIR/calabash-dist"
  rm "$LIB_DIR/_calabash.zip"
  echo "[ok] XML Calabash ${CALABASH_VERSION} installed."
fi

# ── Apache FOP ────────────────────────────────────────────────
if [ -d "$LIB_DIR/fop" ]; then
  echo "[ok] Apache FOP ${FOP_VERSION} already installed."
else
  echo "[..] Downloading Apache FOP ${FOP_VERSION}..."
  curl -L -o "$LIB_DIR/_fop.zip" \
    "https://downloads.apache.org/xmlgraphics/fop/binaries/fop-${FOP_VERSION}-bin.zip"
  unzip -q "$LIB_DIR/_fop.zip" -d "$LIB_DIR"
  mv "$LIB_DIR/fop-${FOP_VERSION}" "$LIB_DIR/fop"
  rm "$LIB_DIR/_fop.zip"
  echo "[ok] Apache FOP ${FOP_VERSION} installed."
fi

# ── SchXSLT ───────────────────────────────────────────────────
if [ -d "$LIB_DIR/schxslt" ]; then
  echo "[ok] SchXSLT ${SCHXSLT_TAG} already installed."
else
  echo "[..] Downloading SchXSLT ${SCHXSLT_TAG}..."
  curl -L -o "$LIB_DIR/_schxslt.zip" \
    "https://codeberg.org/schxslt/schxslt/archive/${SCHXSLT_TAG}.zip"
  unzip -q "$LIB_DIR/_schxslt.zip" -d "$LIB_DIR"
  rm "$LIB_DIR/_schxslt.zip"
  echo "[ok] SchXSLT ${SCHXSLT_TAG} installed."
fi

# ── Noto fonts (for FOP PDF output) ────────────────────────────
NOTO_FONTS_DIR="$LIB_DIR/fonts/noto"
NOTO_BASE="https://raw.githubusercontent.com/googlefonts/noto-fonts/main/hinted/ttf"
mkdir -p "$NOTO_FONTS_DIR"
if [ -f "$NOTO_FONTS_DIR/NotoSans-Regular.ttf" ]; then
  echo "[ok] Noto fonts already installed."
else
  echo "[..] Downloading Noto fonts..."
  for f in NotoSans/NotoSans-Regular.ttf NotoSans/NotoSans-Bold.ttf NotoSans/NotoSans-Italic.ttf NotoSans/NotoSans-BoldItalic.ttf NotoSansSymbols/NotoSansSymbols-Regular.ttf; do
    outname=$(basename "$f")
    curl -L -o "$NOTO_FONTS_DIR/$outname" "$NOTO_BASE/$f" || true
  done
  echo "[ok] Noto fonts installed to lib/fonts/noto/."
fi

# ── Cash (jQuery-compatible DOM library) ─────────────────────
if [ -d "$RESLIB_DIR/cash" ]; then
  echo "[ok] Cash ${CASH_VERSION} already installed."
else
  echo "[..] Downloading Cash ${CASH_VERSION}..."
  curl -L -o "$RESLIB_DIR/_cash.zip" \
    "https://github.com/fabiospampinato/cash/archive/refs/tags/${CASH_VERSION}.zip"
  unzip -q "$RESLIB_DIR/_cash.zip" -d "$RESLIB_DIR"
  mv "$RESLIB_DIR/cash-${CASH_VERSION}" "$RESLIB_DIR/cash"
  rm "$RESLIB_DIR/_cash.zip"
  echo "[ok] Cash ${CASH_VERSION} installed."
fi

# ── lunr.js (client-side search) ─────────────────────────────
if [ -d "$RESLIB_DIR/lunr" ]; then
  echo "[ok] lunr.js ${LUNR_VERSION} already installed."
else
  echo "[..] Downloading lunr.js ${LUNR_VERSION}..."
  curl -L -o "$RESLIB_DIR/_lunr.zip" \
    "https://github.com/olivernn/lunr.js/archive/refs/tags/${LUNR_VERSION}.zip"
  unzip -q "$RESLIB_DIR/_lunr.zip" -d "$RESLIB_DIR"
  mv "$RESLIB_DIR/lunr.js-${LUNR_VERSION#v}" "$RESLIB_DIR/lunr"
  rm "$RESLIB_DIR/_lunr.zip"
  echo "[ok] lunr.js ${LUNR_VERSION} installed."
fi

# ── lunr-languages (language stemmers for lunr.js) ───────────
if [ -d "$RESLIB_DIR/lunr-languages" ]; then
  echo "[ok] lunr-languages ${LUNR_LANG_VERSION} already installed."
else
  echo "[..] Downloading lunr-languages ${LUNR_LANG_VERSION}..."
  curl -L -o "$RESLIB_DIR/_lunr-lang.zip" \
    "https://github.com/MihaiValentin/lunr-languages/archive/refs/tags/${LUNR_LANG_VERSION}.zip"
  unzip -q "$RESLIB_DIR/_lunr-lang.zip" -d "$RESLIB_DIR"
  mv "$RESLIB_DIR/lunr-languages-${LUNR_LANG_VERSION}" "$RESLIB_DIR/lunr-languages"
  rm "$RESLIB_DIR/_lunr-lang.zip"
  echo "[ok] lunr-languages ${LUNR_LANG_VERSION} installed."
fi

# ── mark.js (keyword highlighting) ───────────────────────────
if [ -d "$RESLIB_DIR/markjs" ]; then
  echo "[ok] mark.js ${MARKJS_VERSION} already installed."
else
  echo "[..] Downloading mark.js ${MARKJS_VERSION}..."
  curl -L -o "$RESLIB_DIR/_markjs.zip" \
    "https://github.com/julkue/mark.js/archive/refs/tags/${MARKJS_VERSION}.zip"
  unzip -q "$RESLIB_DIR/_markjs.zip" -d "$RESLIB_DIR"
  mv "$RESLIB_DIR/mark.js-${MARKJS_VERSION}" "$RESLIB_DIR/markjs"
  rm "$RESLIB_DIR/_markjs.zip"
  echo "[ok] mark.js ${MARKJS_VERSION} installed."
fi

echo ""
echo "All dependencies installed."
echo ""
echo "  Runtime (lib/):"
echo "    calabash-dist/  XML Calabash ${CALABASH_VERSION} (XProc 3.0)"
echo "    fop/            Apache FOP ${FOP_VERSION}"
echo "    fonts/noto/     Noto fonts (Sans, Symbols) for PDF"
echo "    schxslt/        SchXSLT ${SCHXSLT_TAG}"
echo ""
echo "  Front-end (src/html/res/lib/):"
echo "    cash/            Cash ${CASH_VERSION}"
echo "    lunr/            lunr.js ${LUNR_VERSION}"
echo "    lunr-languages/  lunr-languages ${LUNR_LANG_VERSION}"
echo "    markjs/          mark.js ${MARKJS_VERSION}"
