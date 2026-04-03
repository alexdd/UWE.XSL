<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text.
     Expands languages × output-dirs into a list of paths (lang/subdir) for clean/mkdir. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
  <xsl:param name="output-dirs-uri" as="xs:string" required="yes"/>
  <xsl:variable name="dirs" select="document($output-dirs-uri)/*/dir"/>
  <xsl:template match="/">
    <paths>
      <xsl:for-each select="*/l">
        <xsl:variable name="lang" select="string(@id)"/>
        <xsl:for-each select="$dirs">
          <path lang="{$lang}" subdir="{string(.)}"/>
        </xsl:for-each>
      </xsl:for-each>
    </paths>
  </xsl:template>
</xsl:stylesheet>
