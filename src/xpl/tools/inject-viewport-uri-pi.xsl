<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text.
     Input: <uwe-viewport-inject viewport-uri="…"><map>…</map></uwe-viewport-inject>
     Output: document with <?uwe-viewport-params uri=…?> then the map (for map2uwe.xsl). -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output method="xml" encoding="utf-8" indent="no"/>
  <xsl:template match="uwe-viewport-inject">
    <xsl:processing-instruction name="uwe-viewport-params">
      <xsl:text>uri=</xsl:text>
      <xsl:value-of select="string(@viewport-uri)"/>
    </xsl:processing-instruction>
    <xsl:copy-of select="map"/>
  </xsl:template>
</xsl:stylesheet>
