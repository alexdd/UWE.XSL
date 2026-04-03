<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tektur="http://www.stylesheet-entwicklung.de" version="2.0" exclude-result-prefixes="#all">
  <xsl:param name="mapid" select="'map'"/>
  <xsl:function name="tektur:escape-for-regex" as="xs:string">
    <xsl:param name="arg" as="xs:string?"/>
    <xsl:sequence select="replace($arg, '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))', '\\$1')"/>
  </xsl:function>
  <xsl:function name="tektur:substring-after-last" as="xs:string">
    <xsl:param name="arg" as="xs:string?"/>
    <xsl:param name="delim" as="xs:string"/>
    <xsl:sequence select="replace($arg, concat('^.*', tektur:escape-for-regex($delim)), '')"/>
  </xsl:function>
  <xsl:function name="tektur:get-image-filename">
    <xsl:param name="src-attribute"/>
    <xsl:variable name="original" select="tektur:substring-after-last($src-attribute,'/')"/>
    <xsl:value-of select="$original"/>
  </xsl:function>
  <xsl:template match="img" mode="simple">
    <img src="{concat('images/',tektur:get-image-filename(@src))}" class="img">
      <xsl:if test="parent::figure/@pdfwidth='margin'">
        <xsl:attribute name="style">max-width:150px</xsl:attribute>
      </xsl:if>
      <xsl:if test="parent::figure/@pdfwidth='column'">
        <xsl:attribute name="style">max-width:250px</xsl:attribute>
      </xsl:if>
    </img>
  </xsl:template>
  <xsl:template match="symbol" mode="simple">
    <img src="{concat('images/',tektur:get-image-filename(@src))}">
        </img>
  </xsl:template>
</xsl:stylesheet>
