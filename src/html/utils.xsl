<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dyxml="http://www.docufy.de/ns/dyxml" exclude-result-prefixes="#all" version="3.0">
  <!-- escape strings for JSON -->
  <!-- see: https://xsl-list.mulberrytech.narkive.com/05nJ95cH/json-encoding-strings-in-xslt-2-0 -->
  <xsl:variable name="regexp">\\|\n|\r|\t|"|/</xsl:variable>
  <xsl:variable name="json-escapes">
    <esc j="\\" x="\"/>
    <esc j="\n" x="&#10;"/>
    <esc j="\&quot;" x="&quot;"/>
    <esc j="\t" x="&#9;"/>
    <esc j="\r" x="&#13;"/>
    <esc j="\/" x="/"/>
  </xsl:variable>
  <xsl:key name="json-escapes" match="p" use="@x"/>
  <xsl:template match="text()" mode="json">
    <xsl:analyze-string select="normalize-space(.)" regex="{$regexp}">
      <xsl:matching-substring>
        <xsl:value-of select="key('json-escapes', . ,$json-escapes)/@j"/>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="translate(.,'&#10;',' ')"/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
    <xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template name="make-chapter-fname">
    <xsl:param name="context" select="."/>
    <xsl:variable name="number">
      <xsl:number count="chapter" format="1_1_" level="multiple" from="/"/>
    </xsl:variable>
    <xsl:variable name="title-part" select="normalize-space(string(($context/title, $context/content/title)[1]))"/>
    <xsl:variable name="from-href" select="replace(replace(string($context/@data-src-href), '\\', '/'), '^.*[/]', '')"/>
    <xsl:variable name="stem" select="replace($from-href, '\.dita$', '')"/>
    <xsl:variable name="slug">
      <xsl:choose>
        <xsl:when test="string-length($title-part) &gt; 0">
          <xsl:value-of select="replace($title-part, '[^a-zA-Z0-9]', '_')"/>
        </xsl:when>
        <xsl:when test="string-length($stem) &gt; 0">
          <xsl:value-of select="replace($stem, '[^a-zA-Z0-9]', '_')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>topic</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat($number, $slug)"/>
  </xsl:template>
</xsl:stylesheet>
