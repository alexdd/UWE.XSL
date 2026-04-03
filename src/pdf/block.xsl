<?xml version="1.0" encoding="utf-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xe="http://www.xes.future" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
  <!-- ========== Block: Grundcontainer ========== -->
  <xsl:template match="block">
    <fo:block>
      <xsl:call-template name="block-styles"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="block/title">
    <fo:block>
      <xsl:call-template name="block-title-styles"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="column-wide-element">
    <xsl:choose>
      <xsl:when test="$layout='columns' or $layout='rtf' or $paper-format='A5'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <fo:table>
          <xsl:call-template name="block-styles"/>
          <xsl:if test="descendant::subtitle and not(descendant::figure)">
            <xsl:attribute name="keep-with-previous.within-page">always</xsl:attribute>
          </xsl:if>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell vertical-align="top">
                <xsl:call-template name="margin-styles"/>
                <fo:block>
                  <xsl:if test="$position-of-block-title='margin'">
                    <xsl:apply-templates select="preceding-sibling::*[1][self::block-title]" mode="has-content"/>
                  </xsl:if>
                  <xsl:apply-templates select="preceding-sibling::*[1][child::figure[@pdfwidth='margin']]">
                    <xsl:with-param name="position">margin</xsl:with-param>
                    <xsl:with-param name="print-block-title">
                      <xsl:choose>
                        <xsl:when test="not(preceding-sibling::*[2][self::block-title])">yes</xsl:when>
                        <xsl:otherwise>no</xsl:otherwise>
                      </xsl:choose>
                    </xsl:with-param>
                  </xsl:apply-templates>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell width="{concat($column-width,$unit)}">
                <fo:block>
                  <xsl:call-template name="block-styles"/>
                  <xsl:if test="$position-of-block-title='column'">
                    <xsl:apply-templates select="preceding-sibling::*[1][self::block-title]" mode="has-content"/>
                  </xsl:if>
                  <xsl:call-template name="make-extended-block-styles"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="block-title" mode="has-content">
    <fo:block>
      <xsl:call-template name="block-title-styles"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="block-title">
    <xsl:choose>
      <xsl:when test="$layout='columns' or $paper-format='A5' or $layout='rtf'">
        <fo:block>
          <xsl:call-template name="block-title-styles"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$position-of-block-title!='main'">
            <fo:table keep-with-next.within-page="always">
              <xsl:call-template name="block-styles"/>
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell>
                    <xsl:call-template name="margin-styles"/>
                    <fo:block>
                      <xsl:call-template name="block-title-styles"/>
                      <xsl:if test="$position-of-block-title='margin'">
                        <xsl:apply-templates/>
                      </xsl:if>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block>
                      <xsl:call-template name="block-title-styles"/>
                      <xsl:if test="$position-of-block-title='column'">
                        <xsl:apply-templates/>
                      </xsl:if>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </xsl:when>
          <xsl:otherwise>
            <fo:block>
              <xsl:call-template name="block-title-styles"/>
              <xsl:apply-templates/>
            </fo:block>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="page-wide-element">
    <xsl:param name="position">page</xsl:param>
    <xsl:param name="print-block-title">yes</xsl:param>
    <xsl:choose>
      <xsl:when test="$layout='columns'  or $layout='rtf' or $paper-format='A5'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$print-block-title='yes'">
          <xsl:apply-templates select="preceding-sibling::*[1][self::block-title]"/>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$position='page'">
            <xsl:apply-templates select="*[not(self::figure[@pdfwidth='margin'])]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ========== Block: Paragraphs and text blocks ========== -->
  <xsl:template match="p">
    <fo:block>
      <xsl:call-template name="p"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="verbatim">
    <fo:block>
      <xsl:call-template name="verbatim-styles"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="node()[1][self::text()][ancestor::verbatim]">
    <xsl:value-of select="replace(.,'^\s+','')"/>
  </xsl:template>
  <xsl:template match="abstract">
    <fo:block>
      <xsl:call-template name="abstract-styles"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="info">
    <fo:block>
      <xsl:attribute name="background-color">
        <xsl:choose>
          <xsl:when test="@type='substeps'">
            <xsl:value-of select="$color-black-05"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$color-black-10"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="start-indent">
        <xsl:choose>
          <xsl:when test="@type='substeps'">17mm</xsl:when>
          <xsl:otherwise>7mm</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="padding">1mm</xsl:attribute>
      <xsl:attribute name="font-style">italic</xsl:attribute>
      <xsl:attribute name="margin-bottom">0px</xsl:attribute>
      <xsl:attribute name="padding-bottom">0px</xsl:attribute>
      <xsl:attribute name="space-after">0px</xsl:attribute>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="result">
    <fo:block>
      <xsl:attribute name="color">#999999</xsl:attribute>
      <xsl:attribute name="start-indent">
        <xsl:choose>
          <xsl:when test="@type='substeps'">17mm</xsl:when>
          <xsl:otherwise>7mm</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="padding">2mm</xsl:attribute>
      <xsl:attribute name="font-weight">bold</xsl:attribute>
      <xsl:attribute name="margin-top">
        <xsl:choose>
          <xsl:when test="@type='substeps'">4pt</xsl:when>
          <xsl:otherwise>8pt</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="margin-bottom">
        <xsl:choose>
          <xsl:when test="@type='substeps'">4pt</xsl:when>
          <xsl:otherwise>8pt</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="not($layout='rtf')">
          <fo:list-block>
            <fo:list-item>
              <xsl:call-template name="keep-rules-list-item1"/>
              <fo:list-item-label>
                <fo:block color="{$color-black-50}">
                  <xsl:call-template name="ul-label-1"/>
                </fo:block>
              </fo:list-item-label>
              <fo:list-item-body>
                <xsl:attribute name="start-indent">
                  <xsl:choose>
                    <xsl:when test="@type='substeps'">21mm</xsl:when>
                    <xsl:otherwise>12mm</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <fo:block>
                  <xsl:apply-templates/>
                </fo:block>
              </fo:list-item-body>
            </fo:list-item>
          </fo:list-block>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>
  <xsl:template match="subtitle">
    <fo:block>
      <xsl:call-template name="block-styles"/>
      <xsl:attribute name="font-weight">bold</xsl:attribute>
      <xsl:attribute name="start-indent">0</xsl:attribute>
      <xsl:choose>
        <xsl:when test="ancestor::meta or ancestor::figure">
          <fo:inline wrap-option="no-wrap">
            <xsl:call-template name="boilerplate-lookup">
              <xsl:with-param name="key">B_FIG</xsl:with-param>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:number count="subtitle[not(ancestor::meta) and not(parent::figure[@pdfwidth='margin'])]" format="1" level="any"/>
            <xsl:if test="string(.)">
              <xsl:text>: </xsl:text>
            </xsl:if>
          </fo:inline>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="chapter-subtitle">
    <fo:block>
      <xsl:call-template name="block-styles"/>
      <xsl:attribute name="font-weight">bold</xsl:attribute>
      <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
      <xsl:attribute name="start-indent">0</xsl:attribute>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <!-- ========== Block: Figures and images ========== -->
  <xsl:template match="figure">
    <xsl:apply-templates select="desc"/>
    <xsl:call-template name="figure"/>
    <xsl:if test="not(@pdfwidth='margin')">
      <xsl:apply-templates select="*[not(self::img) and not(self::desc)]"/>
    </xsl:if>
  </xsl:template>
  <xsl:template name="figure">
    <fo:block xsl:use-attribute-sets="figure">
      <xsl:attribute name="id" select="subtitle/@id"/>
      <xsl:apply-templates select="img"/>
    </fo:block>
  </xsl:template>
  <xsl:template match="img">
    <fo:block xsl:use-attribute-sets="figure.img.block">
      <fo:external-graphic xsl:use-attribute-sets="figure.img">
            </fo:external-graphic>
    </fo:block>
  </xsl:template>
  <xsl:template match="subtitle[ancestor::figure]">
    <fo:block id="{generate-id()}">
      <xsl:call-template name="subtitle-styles"/>
      <fo:inline wrap-option="no-wrap">
        <xsl:call-template name="boilerplate-lookup">
          <xsl:with-param name="key">B_FIG</xsl:with-param>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:number count="subtitle[not(ancestor::meta) and not(parent::figure[@pdfwidth='margin'])]" format="1" level="any"/>
        <xsl:if test="string(.)">
          <xsl:text>:</xsl:text>
        </xsl:if>
      </fo:inline>
      <xsl:if test="string(.)">
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
      </xsl:if>
    </fo:block>
  </xsl:template>
  <!-- ========== Block: Hinweise (Cause/Consequence/Danger/Warning/...) ========== -->
  <xsl:template match="cause">
    <fo:block>
      <xsl:call-template name="ul-title"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="consequence">
    <fo:list-item>
      <xsl:call-template name="ul-list-item"/>
      <xsl:call-template name="keep-rules-list-item1"/>
      <fo:list-item-label start-indent="2mm">
        <fo:block color="{$color-black-50}">
          <xsl:call-template name="ul-label-1"/>
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body>
        <xsl:call-template name="ul-list-item-body"/>
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>
  <xsl:template match="danger | warning | caution | notice | note">
    <xsl:choose>
      <xsl:when test="not($ansi) and not(self::note) and $paper-format='A4'">
        <fo:block>
          <xsl:attribute name="padding">0mm</xsl:attribute>
          <xsl:attribute name="background-color" select="$color-black-05"/>
          <xsl:attribute name="keep-together.within-page">10</xsl:attribute>
          <xsl:attribute name="space-after" select="$hint-space-after"/>
          <fo:external-graphic>
            <xsl:attribute name="src">
              <xsl:choose>
                <xsl:when test="name()='notice'">
                  <xsl:value-of select="xe:resolve-local-src(doc($pdf-config)//notice-image)"/>
                </xsl:when>
                <xsl:when test="name()='warning'">
                  <xsl:value-of select="xe:resolve-local-src(doc($pdf-config)//warning-image)"/>
                </xsl:when>
                <xsl:when test="name()='danger'">
                  <xsl:value-of select="xe:resolve-local-src(doc($pdf-config)//danger-image)"/>
                </xsl:when>
                <xsl:when test="name()='caution'">
                  <xsl:value-of select="xe:resolve-local-src(doc($pdf-config)//caution-image)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="xe:resolve-local-src(doc($pdf-config)//hint-end-image)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </fo:external-graphic>
          <fo:block-container margin-left="{concat($margin-width,'mm')}" margin-right="15mm">
            <fo:block start-indent="0">
              <xsl:apply-templates select="cause"/>
            </fo:block>
            <xsl:call-template name="hint-body"/>
          </fo:block-container>
          <fo:external-graphic>
            <xsl:attribute name="src" select="xe:resolve-local-src(doc($pdf-config)//hint-end-image)"/>
          </fo:external-graphic>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="render-ansi-hints"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="hint-body">
    <xsl:if test="consequence[string-length(.)&gt;0]">
      <fo:list-block start-indent="0mm">
        <xsl:call-template name="ul-styles"/>
        <xsl:apply-templates select="*[not(self::cause)]"/>
      </fo:list-block>
      <fo:block keep-with-previous.within-page="always">
        <xsl:attribute name="margin-bottom">
          <xsl:value-of select="$ul-space-after"/>
        </xsl:attribute>
      </fo:block>
    </xsl:if>
  </xsl:template>
  <!-- ========== Block: Lists (ul, li, procedure, step, action) ========== -->
  <xsl:template match="ul">
    <xsl:if test="title">
      <fo:block>
        <xsl:call-template name="ul-title"/>
        <xsl:apply-templates select="title"/>
      </fo:block>
    </xsl:if>
    <xsl:if test="li[string-length(.)&gt;0]">
      <xsl:call-template name="ul-body"/>
      <fo:block keep-with-previous.within-page="always">
        <xsl:attribute name="margin-bottom">
          <xsl:value-of select="$ul-space-after"/>
        </xsl:attribute>
      </fo:block>
    </xsl:if>
    <xsl:if test="$layout='rtf'">
      <fo:block color="white">.</fo:block>
    </xsl:if>
  </xsl:template>
  <xsl:template name="ul-body">
    <fo:list-block>
      <xsl:call-template name="ul-styles"/>
      <xsl:apply-templates select="*[not(self::title)]"/>
    </fo:list-block>
  </xsl:template>
  <xsl:template match="li">
    <fo:list-item>
      <xsl:call-template name="ul-list-item"/>
      <xsl:call-template name="keep-rules-list-item1"/>
      <xsl:if test="@type='choice'">
        <xsl:attribute name="border-top">#808080 1px solid</xsl:attribute>
        <xsl:attribute name="padding-top">4pt</xsl:attribute>
      </xsl:if>
      <xsl:if test="@type='choice' and not(following-sibling::*)">
        <xsl:attribute name="border-bottom">#808080 1px solid</xsl:attribute>
        <xsl:attribute name="padding-bottom">4pt</xsl:attribute>
      </xsl:if>
      <fo:list-item-label>
        <xsl:choose>
          <xsl:when test="ancestor::result and position() = 1">
            <fo:block/>
          </xsl:when>
          <xsl:when test="ancestor::result and position() &gt; 1">
            <xsl:attribute name="start-indent">17mm</xsl:attribute>
            <fo:block>
              <xsl:call-template name="ul-label-1"/>
            </fo:block>
          </xsl:when>
          <xsl:when test="@type='choice'">
            <xsl:attribute name="start-indent">7mm</xsl:attribute>
            <fo:block>
              <xsl:call-template name="ul-label-1"/>
            </fo:block>
          </xsl:when>
          <xsl:otherwise>
            <fo:block color="{$color-black-50}">
              <xsl:choose>
                <xsl:when test="not($layout='rtf')">
                  <xsl:call-template name="ul-label-2"/>
                </xsl:when>
                <xsl:otherwise> </xsl:otherwise>
              </xsl:choose>
            </fo:block>
          </xsl:otherwise>
        </xsl:choose>
      </fo:list-item-label>
      <fo:list-item-body>
        <xsl:call-template name="ul-list-item-body"/>
        <xsl:if test="ancestor::result">
          <xsl:attribute name="start-indent">23mm</xsl:attribute>
        </xsl:if>
        <xsl:if test="@type='choice'">
          <xsl:attribute name="start-indent">14mm</xsl:attribute>
        </xsl:if>
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>
  <xsl:template match="procedure">
    <xsl:if test="title">
      <fo:block>
        <xsl:call-template name="ul-title"/>
        <xsl:apply-templates select="title"/>
      </fo:block>
    </xsl:if>
    <xsl:if test="step[string-length(.)&gt;0]">
      <xsl:call-template name="procedure-body"/>
    </xsl:if>
    <xsl:if test="$layout='rtf'">
      <fo:block color="white">.</fo:block>
    </xsl:if>
  </xsl:template>
  <xsl:template name="procedure-body">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="step">
    <xsl:if test="ancestor::procedure[not(@type=('ol','ul'))]">
      <xsl:apply-templates select="action/*[not(self::p)]"/>
    </xsl:if>
    <fo:list-block>
      <xsl:call-template name="ul-styles"/>
      <xsl:apply-templates select="action"/>
    </fo:list-block>
  </xsl:template>
  <xsl:template match="action">
    <fo:list-item>
      <xsl:call-template name="ul-list-item"/>
      <xsl:call-template name="keep-rules-list-item1"/>
      <fo:list-item-label>
        <fo:block>
          <fo:inline>
            <xsl:call-template name="step-number-format"/>
            <xsl:call-template name="step-number"/>
          </fo:inline>
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body>
        <xsl:call-template name="ol-list-item-body"/>
        <xsl:apply-templates/>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>
  <xsl:template name="step-number">
    <xsl:choose>
      <xsl:when test="not($layout='rtf')">
        <xsl:if test="ancestor::procedure[@type='substeps']">
          <xsl:value-of select="count(../../preceding-sibling::step)"/>
          <xsl:text>.</xsl:text>
        </xsl:if>
        <xsl:value-of select="count(../preceding-sibling::step)+1"/>
        <xsl:text>. </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="ul-label-1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="step-number-format">
    <xsl:attribute name="background-color">
      <xsl:choose>
        <xsl:when test="ancestor::procedure[@type='substeps']">
          <xsl:value-of select="$color-black-10"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$color-black-75"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="color">
      <xsl:choose>
        <xsl:when test="ancestor::procedure[@type='substeps']">black</xsl:when>
        <xsl:otherwise>white</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="padding-top">2px</xsl:attribute>
    <xsl:attribute name="padding-left">2px</xsl:attribute>
    <xsl:attribute name="padding-right">2px</xsl:attribute>
  </xsl:template>
  <!-- ========== Block: Zeilenumbruch, Tabellen-Beschriftung, Beschreibung ========== -->
  <xsl:template match="br">
    <fo:block/>
  </xsl:template>
  <xsl:template match="colbr">
    <fo:block break-after="column"/>
  </xsl:template>
  <xsl:template match="caption">
    <fo:block font-weight="bold" keep-with-next="always">
      <xsl:attribute name="space-after" select="$table-title-space-after"/>
      <xsl:attribute name="id" select="generate-id()"/>
      <xsl:if test="string(.)">
        <xsl:apply-templates/>
      </xsl:if>
    </fo:block>
  </xsl:template>
  <xsl:template match="desc[following-sibling::*[1][self::tgroup]] | figure/desc">
    <fo:block font-style="italic" keep-with-next="always" keep-together.within-page="always">
      <xsl:attribute name="space-after" select="$table-title-space-after"/>
      <xsl:attribute name="border">#e3e3e3 2pt solid</xsl:attribute>
      <xsl:attribute name="padding">5pt</xsl:attribute>
      <xsl:attribute name="margin">0mm</xsl:attribute>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
</xsl:stylesheet>
