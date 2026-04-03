<?xml version="1.0"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
  <!-- Replace memo pageViewports with external area trees; renumber with Saxon-HE
         (no saxon:assign — that requires Saxon-PE). Numbering matches the old
         assign sequence: base = count(preceding::pageViewport)+1, first inserted = base+1. -->
  <xsl:template match="pageViewport[descendant::block[contains(@prod-id,'-memo-')]]">
    <xsl:variable name="base" as="xs:integer" select="count(preceding::pageViewport) + 1"/>
    <xsl:variable name="externals" as="element(pageViewport)*">
      <xsl:sequence>
        <xsl:for-each select="descendant::block[contains(@prod-id,'-memo-')]">
          <xsl:variable name="memo-id" select="substring-before(@prod-id,'-memo-')"/>
          <xsl:variable name="href" select="concat('../../client/data/', $memo-id, '/at.xml')"/>
          <xsl:if test="doc-available($href)">
            <xsl:sequence select="doc($href)//pageViewport"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:sequence>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="exists($externals)">
        <xsl:for-each select="$externals">
          <xsl:variable name="nr" as="xs:integer" select="$base + position()"/>
          <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="key" select="concat('P', $nr)"/>
            <xsl:attribute name="nr" select="$nr"/>
            <xsl:attribute name="formatted-nr" select="$nr"/>
            <xsl:apply-templates select="node()"/>
          </xsl:copy>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <!-- No memo AT on disk (e.g. sample build): keep original viewport -->
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
