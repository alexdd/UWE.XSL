<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text.
     Replaces __FONT_DIR__ in conf/fop/fop-template.xconf with the absolute font directory.
     Accepts font-dir as OS path; converts to file URI for embed-url (FOP requires URI).
     <directory> gets the raw OS path (FOP resolves it as filesystem path). -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:param name="font-dir" select="''"/>
  <xsl:output method="xml" indent="yes"/>
  <xsl:variable name="dir" select="translate(normalize-space($font-dir), '\', '/')"/>
  <!-- Build file URI: /Users/x -> file:///Users/x, C:/x -> file:///C:/x -->
  <xsl:variable name="dir-uri" select="     if (matches($dir, '^[A-Za-z]:')) then concat('file:///', $dir)     else if (starts-with($dir, '/')) then concat('file://', $dir)     else $dir"/>
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- <directory> needs OS path, not file URI -->
  <xsl:template match="directory/text()[contains(., '__FONT_DIR__')]">
    <xsl:value-of select="replace(., '__FONT_DIR__', $dir)"/>
  </xsl:template>
  <!-- Other text nodes: file URI -->
  <xsl:template match="text()[contains(., '__FONT_DIR__')][not(parent::directory)]">
    <xsl:value-of select="replace(., '__FONT_DIR__', $dir-uri)"/>
  </xsl:template>
  <!-- Attributes (embed-url etc.): file URI -->
  <xsl:template match="@*[contains(., '__FONT_DIR__')]">
    <xsl:attribute name="{name()}" select="replace(., '__FONT_DIR__', $dir-uri)"/>
  </xsl:template>
</xsl:stylesheet>
