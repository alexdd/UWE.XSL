<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:template match="/">
    <xsl:variable name="error-reports" select="//*[local-name() = 'successful-report'][@role = 'error']"/>
    <xsl:if test="exists($error-reports)">
      <xsl:message terminate="yes">
        <xsl:text>RESOLVE-FAIL: not all map topics resolved in UWE. </xsl:text>
        <xsl:value-of select="string($error-reports[1])"/>
      </xsl:message>
    </xsl:if>
    <ok/>
  </xsl:template>
</xsl:stylesheet>
