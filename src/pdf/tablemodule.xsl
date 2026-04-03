<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">
  <xsl:template name="table">
    <root>
      <eh-table type="{@type}" special="{@special}">
        <xsl:attribute name="layoutset">
          <xsl:choose>
            <xsl:when test="@type='dl'">table_evaluation</xsl:when>
            <xsl:otherwise>table_default</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:if test="@id">
          <xsl:attribute name="id" select="@id"/>
        </xsl:if>
        <xsl:copy-of select="./*"/>
      </eh-table>
    </root>
  </xsl:template>
  <xsl:template match="table">
    <xsl:param name="type">none</xsl:param>
    <xsl:variable name="eh-table">
      <xsl:call-template name="table"/>
    </xsl:variable>
    <fo:block>
      <xsl:if test="@id">
        <xsl:attribute name="id" select="@id"/>
      </xsl:if>
      <xsl:apply-templates select="$eh-table/*">
        <xsl:with-param name="type" select="$type"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:template>
  <xsl:template name="set-cellpadding">
    <xsl:variable name="padding" select="if (@padding) then @padding else $table-padding"/>
    <xsl:choose>
      <xsl:when test="ancestor::eh-table/@layoutset='table_evaluation'">
        <xsl:attribute name="padding-top" select="$padding"/>
        <xsl:attribute name="padding-bottom" select="$padding"/>
        <xsl:attribute name="padding-left" select="$padding"/>
        <xsl:attribute name="padding-right" select="$padding"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="padding" select="$padding"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="draw-border-right">
    <xsl:attribute name="border-right-style">
      <xsl:call-template name="table-frame-border-style"/>
    </xsl:attribute>
    <xsl:attribute name="border-right-width">
      <xsl:call-template name="table-frame-border-thickness"/>
    </xsl:attribute>
    <xsl:attribute name="border-right-color">
      <xsl:call-template name="table-frame-border-color"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="draw-border-bottom">
    <xsl:attribute name="border-bottom-style">
      <xsl:call-template name="table-frame-border-style"/>
    </xsl:attribute>
    <xsl:attribute name="border-bottom-width">
      <xsl:call-template name="table-frame-border-thickness"/>
    </xsl:attribute>
    <xsl:attribute name="border-bottom-color">
      <xsl:call-template name="table-frame-border-color"/>
    </xsl:attribute>
    <xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>
  </xsl:template>
  <xsl:template name="draw-border-top">
    <xsl:if test="@vertical!='yes'">
      <xsl:attribute name="border-top-style">
        <xsl:call-template name="table-frame-border-style"/>
      </xsl:attribute>
      <xsl:attribute name="border-top-width">
        <xsl:call-template name="table-frame-border-thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-top-color">
        <xsl:call-template name="table-frame-border-color"/>
      </xsl:attribute>
      <xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>
    </xsl:if>
  </xsl:template>
  <xsl:template name="draw-border-left">
    <xsl:attribute name="border-left-style">
      <xsl:call-template name="table-frame-border-style"/>
    </xsl:attribute>
    <xsl:attribute name="border-left-width">
      <xsl:call-template name="table-frame-border-thickness"/>
    </xsl:attribute>
    <xsl:attribute name="border-left-color">
      <xsl:call-template name="table-frame-border-color"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="draw-border">
    <xsl:variable name="this-entry">
      <xsl:number count="entry" from="row"/>
    </xsl:variable>
    <xsl:variable name="this-row">
      <xsl:number count="row" from="tgroup" level="any"/>
    </xsl:variable>
    <xsl:variable name="last-entry" select="count(../entry)"/>
    <xsl:variable name="last-row" select="count(ancestor::tgroup/*/row)"/>
    <xsl:variable name="tabstyle">
      <xsl:choose>
        <xsl:when test="string-length(ancestor-or-self::*/@tabstyle) &gt; 0">
          <xsl:value-of select="ancestor-or-self::*/@tabstyle"/>
        </xsl:when>
        <xsl:otherwise>h1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="frame">
      <xsl:choose>
        <xsl:when test="string-length(ancestor-or-self::*/@frame) &gt; 0">
          <xsl:value-of select="ancestor-or-self::*/@frame"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="ancestor-or-self::*/@tabstyle='prod-str-1'">sides</xsl:when>
            <xsl:when test="ancestor-or-self::*/@tabstyle='h0-no-lines'">none</xsl:when>
            <xsl:otherwise>all</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="colsep">
      <xsl:choose>
        <xsl:when test="not(@colsep) and ancestor::*[self::tgroup or self::thead or self::tbody]/colspec[position()=$this-entry]/@colsep">
          <xsl:value-of select="ancestor::*[self::tgroup or self::thead or self::tbody]/colspec[position()=$this-entry]/@colsep"/>
        </xsl:when>
        <xsl:when test="ancestor-or-self::*[self::eh-table or self::tgroup or self::entry or self::row]/@colsep">
          <xsl:value-of select="ancestor-or-self::*[self::eh-table or self::tgroup or self::entry or self::row][@colsep][1]/@colsep"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="ancestor-or-self::*/@tabstyle='h0-no-lines'">0</xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="rowsep">
      <xsl:choose>
        <xsl:when test="not(@rowsep) and not(../@rowsep) and ancestor::*[self::tgroup or self::thead or self::tbody]/colspec[position()=$this-entry]/@rowsep">
          <xsl:value-of select="ancestor::*[self::tgroup or self::thead or self::tbody]/colspec[position()=$this-entry]/@rowsep"/>
        </xsl:when>
        <xsl:when test="ancestor-or-self::*[self::eh-table or self::tgroup or self::entry or self::row]/@rowsep">
          <xsl:value-of select="ancestor-or-self::*[self::eh-table or self::tgroup or self::entry or self::row][@rowsep][1]/@rowsep"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="ancestor-or-self::*/@tabstyle='h0-no-lines'">0</xsl:when>
            <xsl:when test="ancestor-or-self::*/@tabstyle='prod-str-1'">0</xsl:when>
            <xsl:when test="ancestor-or-self::*/@tabstyle='prod-str-2'">0</xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- draws a border around a table cell -->
    <xsl:if test="$colsep='1' or $rowsep='1' or (not($frame='') and not($frame='none'))">
      <!-- if we have @colsep, @rowsep or @frame set to a value which allows for drawing a border... -->
      <xsl:choose>
        <!-- draw right border on cell -->
        <xsl:when test="not($this-entry = $last-entry)  and not(ancestor::eh-table[@layoutset='table_evaluation'])">
          <!-- ...check if not last column... -->
          <xsl:if test="$colsep='1'">
            <xsl:call-template name="draw-border-right"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <!-- ...otherwise if last column then draw frame... -->
          <xsl:if test="($frame='all' or $frame='sides')  and not(ancestor::eh-table[@layoutset='table_evaluation'])">
            <xsl:call-template name="draw-border-right"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <!-- draw left border on cell if first cell  -->
      <xsl:if test="$this-entry=1 and ($frame='all' or $frame='sides') and not(ancestor::eh-table[@layoutset='table_evaluation'])">
        <xsl:call-template name="draw-border-left"/>
      </xsl:if>
      <!-- draw border top and border bottom -->
      <xsl:choose>
        <xsl:when test="not($this-row = $last-row)">
          <!-- check if not last row -->
          <xsl:if test="$rowsep='1'">
            <xsl:call-template name="draw-border-bottom"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <!-- otherwise handle last row -->
          <xsl:if test="$frame='bottom' or $frame='topbot' or $frame='all'">
            <xsl:call-template name="draw-border-bottom"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <!-- handle first row -->
      <xsl:if test="$this-row = 1 and ($frame='top' or $frame='topbot' or $frame='all')">
        <xsl:call-template name="draw-border-top"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  <xsl:template match="eh-table">
    <xsl:param name="type"/>
    <fo:block xsl:use-attribute-sets="table">
      <xsl:apply-templates select="*[not(self::indexterm)]">
        <xsl:with-param name="type" select="$type"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:template>
  <xsl:template match="eh-table/title">
    <fo:block xsl:use-attribute-sets="table.title">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template name="get-special-table-styles">
    <xsl:param name="type"/>
    <!-- override me -->
  </xsl:template>
  <xsl:template match="tgroup">
    <xsl:param name="type"/>
    <xsl:if test="tbody">
      <fo:table xsl:use-attribute-sets="tgroup1" table-layout="fixed">
        <xsl:call-template name="get-special-table-styles">
          <xsl:with-param name="type" select="$type"/>
        </xsl:call-template>
        <xsl:if test="@align">
          <xsl:attribute name="text-align">
            <xsl:value-of select="if (string-length(@align) &gt; 0) then @align else 'inherit'"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:call-template name="Render-TB"/>
        <xsl:variable name="frame">
          <xsl:call-template name="determine-frame"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="not(thead) and ($frame='top' or $frame='topbot' or $frame='all')">
            <xsl:apply-templates select="*[not(self::tfoot)]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:table>
    </xsl:if>
  </xsl:template>
  <xsl:template name="determine-frame">
    <xsl:choose>
      <xsl:when test="string-length(ancestor-or-self::*/@frame) &gt; 0">
        <xsl:value-of select="ancestor-or-self::*/@frame"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="ancestor-or-self::*/@tabstyle='prod-str-1'">sides</xsl:when>
          <xsl:when test="ancestor-or-self::*/@tabstyle='h0-no-lines'">none</xsl:when>
          <xsl:otherwise>all</xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tbody">
    <xsl:variable name="frame">
      <xsl:call-template name="determine-frame"/>
    </xsl:variable>
    <xsl:if test="not(../thead) and ($frame='top' or $frame='topbot' or $frame='all')">
      <fo:table-header height="4px">
        <xsl:if test="not(ancestor::*[@special='tui'])">
          <xsl:call-template name="draw-border-bottom"/>
        </xsl:if>
        <fo:table-row>
          <fo:table-cell>
            <fo:block/>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-header>
      <xsl:apply-templates select="../tfoot"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="*">
        <fo:table-body>
          <xsl:call-template name="Render-TB"/>
          <xsl:for-each select="row">
            <xsl:call-template name="row"/>
          </xsl:for-each>
        </fo:table-body>
      </xsl:when>
      <xsl:otherwise>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="thead">
    <xsl:if test="*[normalize-space(.)]">
      <fo:table-header xsl:use-attribute-sets="thead">
        <xsl:call-template name="Render-TB"/>
        <xsl:apply-templates select="colspec"/>
        <xsl:for-each select="row">
          <xsl:call-template name="row"/>
        </xsl:for-each>
      </fo:table-header>
    </xsl:if>
  </xsl:template>
  <xsl:template match="tfoot">
    <xsl:if test="*">
      <fo:table-footer>
        <xsl:call-template name="Render-TB"/>
        <xsl:apply-templates select="colspec"/>
        <xsl:for-each select="row">
          <xsl:call-template name="row"/>
        </xsl:for-each>
      </fo:table-footer>
    </xsl:if>
  </xsl:template>
  <xsl:template match="colspec">
    <xsl:variable name="column-width">
      <xsl:choose>
        <xsl:when test="contains(@colwidth,'*')">
          <xsl:choose>
            <xsl:when test="string-length(@colwidth)=1">remove</xsl:when>
            <xsl:otherwise>
              <xsl:variable name="value" select="translate(@colwidth,'*','')"/>
              <xsl:value-of select="concat('proportional-column-width(',$value,')')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="not(contains(@colwidth,'pt')) and not(contains(@colwidth,'px')) and not(contains(@colwidth,'cm')) and not(contains(@colwidth,'mm')) and not(contains(@colwidth,'pi')) and not(contains(@colwidth,'in')) and string-length(@colwidth) &gt; 0">
          <xsl:value-of select="@colwidth"/>
          <xsl:text>mm</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="contains(@colwidth,'pi')">
              <xsl:variable name="num" select="substring-before(@colwidth,'p')"/>
              <xsl:variable name="pica" select="if (string($num) != '') then number($num)*0.166 else 0"/>
              <xsl:value-of select="$pica"/>
              <xsl:text>in</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@colwidth"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="count(ancestor::tgroup//*[@namest])=0">
      <fo:table-column>
        <xsl:attribute name="column-number">
          <xsl:value-of select="@colnum"/>
        </xsl:attribute>
        <xsl:if test="string-length($column-width) &gt; 0">
          <xsl:attribute name="column-width">
            <xsl:choose>
              <xsl:when test="$column-width='remove'">
                <xsl:text>proportional-column-width(1)</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$column-width"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:if>
      </fo:table-column>
    </xsl:if>
  </xsl:template>
  <xsl:template name="get-keep-rules-table-row">
    <xsl:variable name="this-row">
      <xsl:number count="row" from="tbody"/>
    </xsl:variable>
    <xsl:variable name="last-row" select="count(../row)"/>
    <xsl:attribute name="keep-together.within-page">200</xsl:attribute>
    <xsl:if test="@rowkeep = 'previous'">
      <xsl:attribute name="keep-with-previous.within-page">100</xsl:attribute>
    </xsl:if>
    <xsl:if test="@rowkeep = 'next'">
      <xsl:attribute name="keep-with-next.within-page">100</xsl:attribute>
    </xsl:if>
    <xsl:if test="number($this-row) = 1">
      <xsl:attribute name="keep-with-next.within-page">50</xsl:attribute>
    </xsl:if>
    <xsl:if test="number($this-row) = number($last-row)">
      <xsl:attribute name="keep-with-previous.within-page">40</xsl:attribute>
    </xsl:if>
  </xsl:template>
  <xsl:template name="row">
    <xsl:variable name="tmp">
      <xsl:value-of select="child::entry[not(@contains_boilerplate='yes')]"/>
    </xsl:variable>
    <xsl:variable name="has-content">
      <xsl:choose>
        <xsl:when test="preceding-sibling::row[position()=1]/descendant::entry[@morerows='1']">yes</xsl:when>
        <xsl:when test="string-length(normalize-space($tmp))=0 and string-length(descendant::figure[1]/img/@y.filename)=0">no</xsl:when>
        <xsl:otherwise>yes</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="preceding-row-content">
      <xsl:value-of select="preceding-sibling::row[1]"/>
    </xsl:variable>
    <xsl:variable name="this-row-content">
      <xsl:value-of select="."/>
    </xsl:variable>
    <xsl:variable name="content-same-as-preceding">
      <xsl:choose>
        <xsl:when test="preceding-sibling::row/descendant::figure">no</xsl:when>
        <xsl:when test="row/descendant::figure">no</xsl:when>
        <xsl:when test="normalize-space($this-row-content) != normalize-space($preceding-row-content)">no</xsl:when>
        <xsl:otherwise>yes</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="($has-content='yes' and $content-same-as-preceding='no') or position() = 1">
      <fo:table-row>
        <xsl:if test="string-length(normalize-space(@height)) &gt; 0">
          <xsl:attribute name="height" select="@height"/>
        </xsl:if>
        <xsl:if test="string-length(normalize-space(@keepwithnext)) &gt; 0">
          <xsl:attribute name="keep-with-next">
            <xsl:value-of select="@keepwithnext"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:call-template name="get-keep-rules-table-row"/>
        <xsl:call-template name="Render-TB"/>
        <xsl:apply-templates/>
      </fo:table-row>
    </xsl:if>
  </xsl:template>
  <xsl:template name="set-colspec-align">
    <xsl:variable name="colname" select="@colname"/>
    <xsl:attribute name="text-align">
      <xsl:variable name="align" select="ancestor::tgroup/colspec[@colname = $colname]/@align"/>
      <xsl:value-of select="if (string-length($align) &gt; 0) then $align else 'inherit'"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="set-entry-align">
    <xsl:if test="ancestor-or-self::*[self::tgroup or self::entry]/@align">
      <xsl:attribute name="text-align">
        <xsl:variable name="align" select="ancestor-or-self::*[self::tgroup or self::entry][@align][1]/@align"/>
        <xsl:value-of select="if (string-length($align) &gt; 0) then $align else 'inherit'"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  <xsl:template name="get-keep-rules-table-cell">
    <xsl:attribute name="keep-together.within-page">15</xsl:attribute>
  </xsl:template>
  <xsl:template match="entry">
    <fo:table-cell>
      <xsl:attribute name="font-size" select="if (@font-size) then @font-size else 'inherit'"/>
      <xsl:attribute name="line-height" select="if (@line-height) then @line-height else 'inherit'"/>
      <xsl:attribute name="font-weight" select="if (@font-height) then @font-height else 'inherit'"/>
      <xsl:call-template name="set-table-background-color"/>
      <xsl:call-template name="set-text-color"/>
      <xsl:call-template name="set-colspec-align"/>
      <xsl:call-template name="set-entry-align"/>
      <xsl:call-template name="draw-border"/>
      <xsl:call-template name="set-cellpadding"/>
      <xsl:call-template name="valign"/>
      <xsl:variable name="entry.colspan">
        <xsl:choose>
          <xsl:when test="@spanname or @namest">
            <xsl:call-template name="calculate.colspan"/>
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="string-length(@bgcolor) &gt; 0 or string-length(../@bgcolor) &gt; 0">
        <xsl:attribute name="background-color" select="if (@bgcolor) then @bgcolor else ../@bgcolor"/>
      </xsl:if>
      <xsl:if test="@morerows">
        <xsl:attribute name="number-rows-spanned">
          <xsl:value-of select="@morerows+1"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="Render-TB"/>
      <xsl:if test="$entry.colspan &gt; 1">
        <xsl:attribute name="number-columns-spanned">
          <xsl:value-of select="$entry.colspan"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="../../../../@pgwide='yes'">
        <xsl:attribute name="start-indent">0mm</xsl:attribute>
      </xsl:if>
      <xsl:if test="descendant::figure">
        <xsl:attribute name="padding">2mm 2mm 2mm 2mm</xsl:attribute>
      </xsl:if>
      <xsl:variable name="colnum" select="count(preceding-sibling::entry)+1"/>
      <xsl:variable name="preceding-content">
        <xsl:value-of select="../preceding-sibling::row[1]/entry[$colnum]"/>
      </xsl:variable>
      <xsl:variable name="preceding-cell-content">
        <xsl:value-of select="preceding-sibling::entry[1]"/>
      </xsl:variable>
      <xsl:variable name="this-content">
        <xsl:value-of select="."/>
      </xsl:variable>
      <xsl:if test="(normalize-space($preceding-content) = normalize-space($this-content)      and string-length(normalize-space($preceding-cell-content)) = 0       and @merge='yes' and not(ancestor::thead)) or @border-top='none'">
        <xsl:attribute name="border-top-style">
          <xsl:call-template name="table-frame-border-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-top-width">2pt</xsl:attribute>
        <xsl:attribute name="border-top-color">
          <xsl:value-of select="$color-black-10"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="string-length(normalize-space($this-content)) != 0       and not(normalize-space($preceding-content) = normalize-space($this-content))     and @merge='yes' and not(ancestor::thead)">
        <xsl:attribute name="border-top-style">
          <xsl:call-template name="table-frame-border-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-top-width">2pt</xsl:attribute>
        <xsl:attribute name="border-top-color">
          <xsl:value-of select="$color-white"/>
        </xsl:attribute>
      </xsl:if>
      <fo:block-container start-indent="0mm">
        <xsl:if test="@vertical='yes'">
          <xsl:attribute name="height" select="parent::row/@height"/>
          <xsl:attribute name="reference-orientation">90</xsl:attribute>
          <xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
          <xsl:attribute name="margin-top" select="parent::row/@height"/>
        </xsl:if>
        <fo:block>
          <xsl:call-template name="get-keep-rules-table-cell"/>
          <xsl:choose>
            <xsl:when test="string-length(string(.))=0 and string-length(descendant::img[position()=1]/@y.filename)=0 and not(@autotext='no')">
              <xsl:value-of select="$empty-placeholder-string"/>
            </xsl:when>
            <xsl:when test="normalize-space($preceding-content) = normalize-space($this-content) and @merge='yes'         and string-length($preceding-cell-content)=0"/>
            <xsl:when test="string-length(normalize-space($this-content))=0        and string-length(normalize-space($preceding-cell-content))&gt;0 and @merge='yes'">
              <xsl:value-of select="$empty-placeholder-string"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="ancestor::eh-table[@type='choicetable'] and count(parent::row/preceding-sibling::row)&gt;0">
                  <fo:list-block>
                    <fo:list-item>
                      <fo:list-item-label>
                        <fo:block color="{$color-black-50}">
                          <xsl:choose>
                            <xsl:when test="preceding-sibling::*">
                              <fo:inline font-family="Wingdings" font-size="120%">¨</fo:inline>
                            </xsl:when>
                            <xsl:otherwise>
                              <fo:inline font-family="Wingdings" font-size="120%">þ</fo:inline>
                            </xsl:otherwise>
                          </xsl:choose>
                        </fo:block>
                      </fo:list-item-label>
                      <fo:list-item-body start-indent="6mm">
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
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:block-container>
    </fo:table-cell>
  </xsl:template>
  <xsl:template name="calculate.colspan">
    <xsl:param name="entry" select="."/>
    <xsl:variable name="spanname" select="$entry/@spanname"/>
    <xsl:variable name="spanspec" select="($entry/ancestor::tgroup/spanspec[@spanname=$spanname]                          |$entry/ancestor::entrytbl/spanspec[@spanname=$spanname])[last()]"/>
    <xsl:variable name="namest">
      <xsl:choose>
        <xsl:when test="@spanname">
          <xsl:value-of select="$spanspec/@namest"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$entry/@namest"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="nameend">
      <xsl:choose>
        <xsl:when test="@spanname">
          <xsl:value-of select="$spanspec/@nameend"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$entry/@nameend"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="scol">
      <xsl:call-template name="colspec.colnum">
        <xsl:with-param name="colspec" select="($entry/ancestor::tgroup/colspec[@colname=$namest]                                |$entry/ancestor::entrytbl/colspec[@colname=$namest])[last()]"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="ecol">
      <xsl:call-template name="colspec.colnum">
        <xsl:with-param name="colspec" select="($entry/ancestor::tgroup/colspec[@colname=$nameend]                                |$entry/ancestor::entrytbl/colspec[@colname=$nameend])[last()]"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$namest != '' and $nameend != ''">
        <xsl:choose>
          <xsl:when test="number($ecol) &gt;= number($scol)">
            <xsl:value-of select="number($ecol) - number($scol) + 1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="number($scol) - number($ecol) + 1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="colspec.colnum">
    <xsl:param name="colspec" select="."/>
    <xsl:choose>
      <xsl:when test="$colspec/@colnum">
        <xsl:value-of select="$colspec/@colnum"/>
      </xsl:when>
      <xsl:when test="$colspec/preceding-sibling::colspec">
        <xsl:variable name="prec.colspec.colnum">
          <xsl:call-template name="colspec.colnum">
            <xsl:with-param name="colspec" select="$colspec/preceding-sibling::colspec[1]"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$prec.colspec.colnum + 1"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="Render-TB">
    <xsl:if test="@render-tbl='regular'">
      <xsl:attribute name="font-family">Arial</xsl:attribute>
    </xsl:if>
    <xsl:if test="@render-tbl='italic'">
      <xsl:attribute name="font-family">Arial</xsl:attribute>
    </xsl:if>
  </xsl:template>
  <xsl:template name="valign">
    <xsl:if test="ancestor-or-self::*[self::thead or self::tfoot or self::tbody or self::row or self::entry]/@valign">
      <xsl:variable name="valign">
        <xsl:value-of select="ancestor-or-self::*[self::thead or self::tfoot or self::tbody or self::row or self::entry][@valign][1]/@valign"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$valign='top'">
          <xsl:attribute name="display-align">before</xsl:attribute>
        </xsl:when>
        <xsl:when test="$valign='middle'">
          <xsl:attribute name="display-align">center</xsl:attribute>
        </xsl:when>
        <xsl:when test="$valign='bottom'">
          <xsl:attribute name="display-align">after</xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:template match="spanspec"/>
</xsl:stylesheet>
