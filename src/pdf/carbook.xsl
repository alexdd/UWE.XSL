<?xml version="1.0"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xe="http://www.xes.future" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
  <xsl:import href="uwe.xsl"/>
  <xsl:template name="get-page-width">
    <xsl:text>210</xsl:text>
  </xsl:template>
  <xsl:template name="get-page-height">
    <xsl:text>148</xsl:text>
  </xsl:template>
  <xsl:template name="get-outer-margin">
    <xsl:text>10</xsl:text>
  </xsl:template>
  <xsl:template name="get-inner-margin">
    <xsl:text>15</xsl:text>
  </xsl:template>
  <xsl:template name="get-top-margin">
    <xsl:text>22</xsl:text>
  </xsl:template>
  <xsl:template name="get-bottom-margin">
    <xsl:text>15</xsl:text>
  </xsl:template>
  <xsl:template name="column-count">
    <xsl:text>2</xsl:text>
  </xsl:template>
  <xsl:template name="column-gap">
    <xsl:text>5mm</xsl:text>
  </xsl:template>
  <xsl:template name="set-chapter-right-page">
    <xsl:value-of select="true()"/>
  </xsl:template>
  <xsl:template name="verbatim-styles">
    <xsl:attribute name="font-family">Courier New, monospace</xsl:attribute>
    <xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="line-height">110%</xsl:attribute>
    <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
    <xsl:attribute name="white-space">pre</xsl:attribute>
    <xsl:attribute name="white-space-collapse">false</xsl:attribute>
    <xsl:attribute name="margin-top">0pt</xsl:attribute>
    <xsl:attribute name="margin-bottom">0pt</xsl:attribute>
    <xsl:attribute name="padding">4pt</xsl:attribute>
  </xsl:template>
  <xsl:template name="header-odd-first-line-styles">
    <xsl:attribute name="margin-left" select="concat($inner-margin,$unit)"/>
    <xsl:attribute name="margin-right" select="concat($outer-margin,$unit)"/>
    <xsl:attribute name="height">8mm</xsl:attribute>
    <xsl:attribute name="margin-top">20mm</xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
    <xsl:attribute name="space-after">2mm</xsl:attribute>
  </xsl:template>
  <xsl:template name="header-even-first-line-styles">
    <xsl:attribute name="margin-left" select="concat($outer-margin,$unit)"/>
    <xsl:attribute name="margin-right" select="concat($inner-margin,$unit)"/>
    <xsl:attribute name="height">8mm</xsl:attribute>
    <xsl:attribute name="margin-top">20mm</xsl:attribute>
    <xsl:attribute name="padding-left">2mm</xsl:attribute>
    <xsl:attribute name="padding-right">2mm</xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="space-after">2mm</xsl:attribute>
  </xsl:template>
  <xsl:template name="header-1-odd">
    <xsl:variable name="section-title">
      <xsl:call-template name="get-section-title"/>
    </xsl:variable>
    <xsl:variable name="section-number">
      <xsl:call-template name="get-section-number"/>
    </xsl:variable>
    <fo:table>
      <xsl:attribute name="margin-top">5mm</xsl:attribute>
      <xsl:attribute name="margin-left">15mm</xsl:attribute>
      <xsl:attribute name="color">black</xsl:attribute>
      <fo:table-body>
        <fo:table-row>
          <xsl:attribute name="border-bottom">3pt #00579E solid</xsl:attribute>
          <fo:table-cell font-size="13pt" start-indent="0mm" font-weight="bold">
            <xsl:attribute name="display-align">after</xsl:attribute>
            <xsl:attribute name="padding-bottom">2mm</xsl:attribute>
            <xsl:attribute name="text-align">left</xsl:attribute>
            <xsl:attribute name="width">85mm</xsl:attribute>
            <xsl:attribute name="height">10mm</xsl:attribute>
            <xsl:attribute name="font-size">13pt</xsl:attribute>
            <xsl:attribute name="color">#00579E</xsl:attribute>
            <fo:block>
              <xsl:apply-templates select="/document/title"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell font-size="13pt" start-indent="0mm" font-weight="bold">
            <xsl:attribute name="display-align">after</xsl:attribute>
            <xsl:attribute name="padding-bottom">2mm</xsl:attribute>
            <xsl:attribute name="text-align">right</xsl:attribute>
            <xsl:attribute name="width">100mm</xsl:attribute>
            <xsl:attribute name="height">10mm</xsl:attribute>
            <xsl:attribute name="font-size">13pt</xsl:attribute>
            <xsl:attribute name="font-family">Noto Sans Italic</xsl:attribute>
            <fo:block>
              <xsl:apply-templates select="/document/meta/main-title"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>
  <xsl:template name="header-1-even">
    <xsl:variable name="section-title">
      <xsl:call-template name="get-section-title"/>
    </xsl:variable>
    <xsl:variable name="section-number">
      <xsl:call-template name="get-section-number"/>
    </xsl:variable>
    <fo:table>
      <xsl:attribute name="margin-top">5mm</xsl:attribute>
      <xsl:attribute name="margin-left">10mm</xsl:attribute>
      <xsl:attribute name="color">black</xsl:attribute>
      <fo:table-body>
        <fo:table-row>
          <xsl:attribute name="border-bottom">3pt #00579E solid</xsl:attribute>
          <fo:table-cell text-align="right" font-weight="bold">
            <xsl:attribute name="display-align">after</xsl:attribute>
            <xsl:attribute name="padding-bottom">2mm</xsl:attribute>
            <xsl:attribute name="text-align">left</xsl:attribute>
            <xsl:attribute name="width">100mm</xsl:attribute>
            <xsl:attribute name="font-family">Noto Sans Italic</xsl:attribute>
            <xsl:attribute name="height">10mm</xsl:attribute>
            <xsl:attribute name="font-size">13pt</xsl:attribute>
            <xsl:attribute name="start-indent">0mm</xsl:attribute>
            <fo:block>
              <xsl:apply-templates select="/document/meta/main-title"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell font-size="13pt" start-indent="0mm" font-weight="bold">
            <xsl:attribute name="display-align">after</xsl:attribute>
            <xsl:attribute name="padding-bottom">2mm</xsl:attribute>
            <xsl:attribute name="text-align">right</xsl:attribute>
            <xsl:attribute name="width">85mm</xsl:attribute>
            <xsl:attribute name="height">10mm</xsl:attribute>
            <xsl:attribute name="font-size">13pt</xsl:attribute>
            <xsl:attribute name="color">#00579E</xsl:attribute>
            <fo:block>
              <xsl:apply-templates select="/document/title"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>
  <xsl:template name="cover-title-position">
    <xsl:attribute name="position">fixed</xsl:attribute>
    <xsl:attribute name="top">70mm</xsl:attribute>
    <xsl:attribute name="right">15mm</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:template>
  <xsl:template name="cover-outside-logo-position">
    <xsl:attribute name="position">fixed</xsl:attribute>
    <xsl:attribute name="bottom">15mm</xsl:attribute>
    <xsl:attribute name="right">15mm</xsl:attribute>
    <xsl:attribute name="display-align">after</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:template>
  <xsl:template name="cover-inside-logo-position">
    <xsl:attribute name="position">fixed</xsl:attribute>
    <xsl:attribute name="bottom">15mm</xsl:attribute>
    <xsl:attribute name="right">15mm</xsl:attribute>
    <xsl:attribute name="display-align">after</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:template>
  <xsl:template name="keep-rules-list-item1">
    <xsl:attribute name="keep-together.within-page">15</xsl:attribute>
  </xsl:template>
  <xsl:attribute-set name="symbol">
    <xsl:attribute name="max-height">11pt</xsl:attribute>
    <xsl:attribute name="baseline-shift">10pt</xsl:attribute>
    <xsl:attribute name="src" select="if ($docker='no') then @src else concat('/teditor/',@src)"/>
  </xsl:attribute-set>
  <xsl:template name="extended-block-title-styles">
    <xsl:if test="following-sibling::*[1][self::column-wide-element[count(child::*)=1 and p]]">
      <xsl:attribute name="break-before">column</xsl:attribute>
    </xsl:if>
  </xsl:template>
  <xsl:attribute-set name="figure.img.block">
    <xsl:attribute name="start-indent">
      <xsl:choose>
        <xsl:when test="ancestor::result">10mm</xsl:when>
        <xsl:when test="count(ancestor::*[self::li or self::step])&gt;1">12mm</xsl:when>
        <xsl:when test="ancestor::*[self::li or self::step]">6mm</xsl:when>
        <xsl:otherwise>0mm</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="space-after">6pt</xsl:attribute>
    <xsl:attribute name="padding">2pt</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">
      <xsl:choose>
        <xsl:when test="../@pdfwidth='margin' and $paper-format='A5'">always</xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="text-align">
      <xsl:choose>
        <xsl:when test="../@pdfwidth='margin' and not($layout='rtf') and $paper-format='A4' and not($layout='columns')">right</xsl:when>
        <xsl:when test="ancestor::ul or ancestor::procedure">left</xsl:when>
        <xsl:otherwise>center</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="background-color">
      <xsl:choose>
        <xsl:when test="ancestor::result">none</xsl:when>
        <xsl:when test="count(ancestor::*[self::li or self::step])&gt;1">none</xsl:when>
        <xsl:when test="ancestor::*[self::li or self::step]">none</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$option_color2"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:template name="cover-back-logo-styles">
    <xsl:attribute name="position">fixed</xsl:attribute>
    <xsl:attribute name="top">40mm</xsl:attribute>
    <xsl:attribute name="right">25mm</xsl:attribute>
    <xsl:attribute name="display-align">after</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:template>
  <xsl:template name="extra-backcover-image">
    <fo:block>
      <fo:external-graphic>
        <xsl:if test="$look-and-feel='fashion'">
          <xsl:attribute name="border">
            <xsl:text>1pt </xsl:text>
            <xsl:value-of select="$option_color3"/>
            <xsl:text> solid</xsl:text>
          </xsl:attribute>
        </xsl:if>
        <xsl:attribute name="content-width">40mm</xsl:attribute>
        <xsl:attribute name="src" select="if ($docker='no') then xe:resolve-local-src(//cover-image) else concat('/teditor/',//cover-image)"/>
      </fo:external-graphic>
    </fo:block>
  </xsl:template>
  <xsl:template name="copyright-backcover">
    <xsl:attribute name="top">130mm</xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <fo:block>
      <xsl:value-of select="$option_copyright"/>
    </fo:block>
  </xsl:template>
  <xsl:template name="section-styles">
    <xsl:param name="section-level"/>
    <xsl:attribute name="id" select="generate-id()"/>
    <xsl:if test="self::glossary">
      <xsl:attribute name="margin-left" select="concat($margin-width,'mm')"/>
    </xsl:if>
    <xsl:if test="ancestor::supplemental-directives">
      <xsl:attribute name="space-before" select="$supplemental-directives-space-before"/>
    </xsl:if>
    <xsl:if test="@hyphenation='yes'">
      <xsl:attribute name="hyphenate">true</xsl:attribute>
    </xsl:if>
    <xsl:if test="@chapterpage='yes'">
      <xsl:attribute name="break-before">page</xsl:attribute>
    </xsl:if>
    <xsl:attribute name="space-before.conditionality">discard</xsl:attribute>
    <xsl:attribute name="space-after.conditionality">discard</xsl:attribute>
    <xsl:attribute name="space-before">0mm</xsl:attribute>
  </xsl:template>
  <xsl:template match="chapter-subtitle">
    <fo:block>
      <xsl:call-template name="block-styles"/>
      <xsl:attribute name="font-weight">bold</xsl:attribute>
      <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
      <xsl:attribute name="start-indent">0</xsl:attribute>
      <xsl:attribute name="font-family">Noto Sans Bold</xsl:attribute>
      <xsl:attribute name="color">#00579E</xsl:attribute>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:attribute-set name="nb">
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="background-color">#f3f3f3</xsl:attribute>
    <xsl:attribute name="font-family">Noto Sans Bold</xsl:attribute>
    <xsl:attribute name="color">#00579E</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>
  <xsl:template name="render-footer-page-number">
    <fo:inline-container background-color="#00579E" padding="0" margin="0" start-indent="0" color="white" font-weight="bold" width="10mm" height="5mm" text-align="center">
      <fo:block margin-top="1mm">
        <fo:page-number/>
      </fo:block>
    </fo:inline-container>
  </xsl:template>
  <xsl:template name="get-cover-bar-color">#00579E</xsl:template>
</xsl:stylesheet>
