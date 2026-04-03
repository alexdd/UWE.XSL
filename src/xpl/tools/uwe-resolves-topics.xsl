<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" version="2.0">
  <xsl:param name="map-href" required="yes"/>
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:variable name="map" select="doc($map-href)"/>
  <!-- All topicrefs with @href in document order (depth-first) -->
  <xsl:variable name="topicrefs" select="$map//*[local-name() = 'topicref'][@href]"/>
  <xsl:variable name="chapters" select="//chapter"/>
  <xsl:variable name="map-count" select="count($topicrefs)"/>
  <xsl:variable name="uwe-count" select="count($chapters)"/>
  <xsl:template match="/">
    <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <svrl:active-pattern document="{$map-href}"/>
      <!-- 1) Topic count: every map topicref must have a chapter in UWE (skip if map could not be loaded, e.g. doc() from pipeline context) -->
      <xsl:if test="$map-count != $uwe-count and $map-count gt 0">
        <svrl:successful-report test="count(//chapter) = count($map//*[local-name()='topicref'][@href])" role="error">
          <svrl:text>Topic count mismatch: map has <xsl:value-of select="$map-count"/> topicref(s), UWE has <xsl:value-of select="$uwe-count"/> chapter(s). Every topic from the map must be resolved in the UWE output.</svrl:text>
        </svrl:successful-report>
      </xsl:if>
      <!-- 2) Title consistency: for each position, map navtitle (if present) vs UWE chapter title.
           Normalize map title by stripping trailing " (imported)" so typical DITA map navtitles match. -->
      <xsl:for-each select="$chapters">
        <xsl:variable name="pos" select="position()"/>
        <xsl:variable name="ref" select="$topicrefs[$pos]"/>
        <xsl:variable name="uwe-title" select="normalize-space(string(content/title))"/>
        <xsl:variable name="map-title-raw" select="normalize-space(string($ref/@navtitle))"/>
        <xsl:variable name="map-title" select="replace($map-title-raw, '\s*\(imported\)\s*$', '')"/>
        <xsl:if test="string($ref/@navtitle) != '' and $map-title != $uwe-title">
          <svrl:successful-report test="false()" role="warning">
            <svrl:text>Title mismatch at position <xsl:value-of select="$pos"/>: map navtitle="<xsl:value-of select="$map-title-raw"/>", UWE chapter title="<xsl:value-of select="$uwe-title"/>".</svrl:text>
          </svrl:successful-report>
        </xsl:if>
      </xsl:for-each>
    </svrl:schematron-output>
  </xsl:template>
</xsl:stylesheet>
