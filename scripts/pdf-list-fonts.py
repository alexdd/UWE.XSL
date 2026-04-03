#!/usr/bin/env python3
# UWE.XSL - DITA Publishing Stylesheets
# Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
# SPDX-License-Identifier: LGPL-3.0-only
# See license.txt for the full license text.
"""
List fonts embedded/used in a PDF.
Usage: python pdf-list-fonts.py <file.pdf>
Requires: pip install pymupdf
"""
import sys
try:
    import fitz  # PyMuPDF
except ImportError:
    sys.stderr.write("Install with: pip install pymupdf\n")
    sys.exit(1)

def main():
    if len(sys.argv) < 2:
        sys.stderr.write("Usage: python pdf-list-fonts.py <file.pdf>\n")
        sys.exit(1)
    path = sys.argv[1]
    doc = fitz.open(path)
    seen = set()
    for p in range(len(doc)):
        for f in doc.get_page_fonts(p):
            # PyMuPDF: (xref, name, type, basefont, ...); index 3 = basefont
            name = (f[3] if isinstance(f, (list, tuple)) and len(f) > 3 else "") or ""
            if name and name not in seen:
                seen.add(name)
                print(name)
    doc.close()
    if not seen:
        sys.stderr.write("(no fonts reported)\n")

if __name__ == "__main__":
    main()
