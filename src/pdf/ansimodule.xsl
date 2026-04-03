<?xml version="1.0"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xe="http://www.xes.future" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
  <xsl:variable name="langg" select="substring-before(//meta/language,'-')"/>
  <xsl:variable name="varr" select="substring-after(//meta/language,'-')"/>
  <xsl:template name="render-ansi-hints">
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="self::danger">
          <xsl:call-template name="boilerplate-lookup">
            <xsl:with-param name="key">B_DANGER</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="self::warning">
          <xsl:call-template name="boilerplate-lookup">
            <xsl:with-param name="key">B_WARNING</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="self::caution">
          <xsl:call-template name="boilerplate-lookup">
            <xsl:with-param name="key">B_CAUTION</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="self::notice">
          <xsl:call-template name="boilerplate-lookup">
            <xsl:with-param name="key">B_NOTICE</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="self::note"/>
      </xsl:choose>
    </xsl:variable>
    <fo:block-container>
      <xsl:call-template name="hint"/>
      <xsl:choose>
        <xsl:when test="not(self::note)">
          <fo:block xsl:use-attribute-sets="ansi-hint-styles">
            <xsl:call-template name="render-ansi-hints-signal-panel">
              <xsl:with-param name="title" select="$title"/>
            </xsl:call-template>
            <fo:block xsl:use-attribute-sets="ansi-hint-body-styles">
              <xsl:apply-templates select="cause"/>
              <xsl:call-template name="hint-body"/>
            </fo:block>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:table table-layout="fixed" width="100%">
            <fo:table-body>
              <fo:table-row>
                <fo:table-cell xsl:use-attribute-sets="hint-cell-1">
                  <fo:block>
                    <fo:external-graphic src="{xe:resolve-local-src(doc($pdf-config)//ansi-note-image)}" width="13mm" content-height="scale-to-fit"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell xsl:use-attribute-sets="hint-cell-2">
                  <fo:block xsl:use-attribute-sets="hint-title">
                    <xsl:value-of select="$title"/>
                  </fo:block>
                  <xsl:apply-templates select="cause"/>
                  <xsl:call-template name="hint-body"/>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-body>
          </fo:table>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block-container>
  </xsl:template>
  <xsl:template name="render-ansi-hints-signal-panel">
    <xsl:param name="filename"/>
    <xsl:param name="title"/>
    <fo:block-container xsl:use-attribute-sets="ansi-hint-panel-styles">
      <fo:block>
        <xsl:if test="not(self::note or self::notice)">
          <fo:inline xsl:use-attribute-sets="ansi-hint-signalgfx-styles">
            <fo:external-graphic src="{if (self::danger) then xe:resolve-local-src(doc($pdf-config)//ansi-white-image) else xe:resolve-local-src(doc($pdf-config)//ansi-black-image)}" content-width="4mm"/>
          </fo:inline>
        </xsl:if>
        <fo:inline xsl:use-attribute-sets="ansi-hint-signalword-styles">
          <xsl:value-of select="translate($title,'!','')"/>
        </fo:inline>
      </fo:block>
    </fo:block-container>
    <fo:block-container xsl:use-attribute-sets="ansi-hint-panel-border-bottom-styles">
      <fo:block/>
    </fo:block-container>
  </xsl:template>
  <xsl:template name="hint">
    <xsl:attribute name="space-after">
      <xsl:value-of select="$hint-space-after"/>
    </xsl:attribute>
    <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
    <xsl:attribute name="font-style">
      <xsl:choose>
        <xsl:when test="name() = 'note'">italic</xsl:when>
        <xsl:otherwise>normal</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:if test="self::note">
      <xsl:attribute name="background-color">
        <xsl:choose>
          <xsl:when test="name() = 'note' or name() = 'notice'">
            <xsl:value-of select="$color-black-10"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$color-black-15"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  <xsl:attribute-set name="hint-title">
    <xsl:attribute name="space-after">
      <xsl:value-of select="$hint-title-space-after"/>
    </xsl:attribute>
    <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
    <xsl:attribute name="font-style">
      <xsl:choose>
        <xsl:when test="name() = 'note'">italic</xsl:when>
        <xsl:otherwise>normal</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="font-weight">
      <xsl:choose>
        <xsl:when test="name() = 'note'">normal</xsl:when>
        <xsl:otherwise>bold</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="line-height">inherit</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="hint-cell-1">
    <xsl:attribute name="padding">2mm</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="width">16mm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="hint-cell-2">
    <xsl:attribute name="padding">2mm</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="ansi-hint-styles">
    <xsl:attribute name="border-bottom-width">2pt</xsl:attribute>
    <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
    <xsl:attribute name="border-bottom-color">
      <xsl:choose>
        <xsl:when test="self::danger">#E20025</xsl:when>
        <xsl:when test="self::warning">#F29200</xsl:when>
        <xsl:when test="self::caution">#FFDF00</xsl:when>
        <xsl:otherwise>#006BAB</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="ansi-hint-panel-styles">
    <xsl:attribute name="width">
      <xsl:choose>
        <xsl:when test="concat($langg,'_',$varr) = ('uk_UA','sk_SK','nl_NL','fr_FR','el_GR','bg_BG','sv_SE','ru_RU','pl_PL','az_AZ','it_IT')">58mm</xsl:when>
        <xsl:otherwise>40mm</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="height">
      <xsl:choose>
        <xsl:when test="self::notice">5mm</xsl:when>
        <xsl:otherwise>6mm</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="background-color">
      <xsl:choose>
        <xsl:when test="self::danger">#E20025</xsl:when>
        <xsl:when test="self::warning">#F29200</xsl:when>
        <xsl:when test="self::caution">#FFDF00</xsl:when>
        <xsl:otherwise>#006BAB</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="display-align">center</xsl:attribute>
    <xsl:attribute name="padding-top">
      <xsl:choose>
        <xsl:when test="self::notice">1.5mm</xsl:when>
        <xsl:otherwise>1mm</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="ansi-hint-signalgfx-styles">
    <xsl:attribute name="content-width">4mm</xsl:attribute>
    <xsl:attribute name="baseline-shift">-1pt</xsl:attribute>
    <xsl:attribute name="padding-right">2mm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="ansi-hint-signalword-styles">
    <xsl:attribute name="color">
      <xsl:choose>
        <xsl:when test="self::danger or self::notice">#FFFFFF</xsl:when>
        <xsl:otherwise>#000000</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="font-style">
      <xsl:choose>
        <xsl:when test="self::notice">italic</xsl:when>
        <xsl:otherwise>normal</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="font-weight">
      <xsl:choose>
        <xsl:when test="self::note">normal</xsl:when>
        <xsl:otherwise>bold</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="ansi-hint-body-styles">
    <xsl:attribute name="margin-left">1mm</xsl:attribute>
    <xsl:attribute name="margin-right">1mm</xsl:attribute>
    <xsl:attribute name="margin-bottom">2mm</xsl:attribute>
    <xsl:attribute name="margin-top">2mm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="ansi-hint-panel-border-bottom-styles">
    <xsl:attribute name="border-bottom-width">2pt</xsl:attribute>
    <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
    <xsl:attribute name="border-bottom-color">
      <xsl:choose>
        <xsl:when test="self::danger">#E20025</xsl:when>
        <xsl:when test="self::warning">#F29200</xsl:when>
        <xsl:when test="self::caution">#FFDF00</xsl:when>
        <xsl:otherwise>#006BAB</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="width">100%</xsl:attribute>
  </xsl:attribute-set>
</xsl:stylesheet>
