<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text.
     CALS/HTML table rendering for mode simple (included from main.xsl). -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" exclude-result-prefixes="#all">
  <xsl:variable name="table-border-color" select="'#e2e8f0'"/>
  <xsl:variable name="table-border-width" select="'1px'"/>
  <xsl:variable name="default-cell-padding" select="'6px'"/>
  <xsl:variable name="table-body-bg" select="'#f7fafc'"/>
  <xsl:variable name="table-header-bg" select="'#edf2f7'"/>
  <xsl:variable name="table-body-text" select="'#2d3748'"/>
  <xsl:variable name="table-header-text" select="'#1a202c'"/>
  <xsl:template name="set-table-background-color">
    <xsl:value-of select="$table-body-bg"/>
  </xsl:template>
  <xsl:template name="set-text-color">
    <xsl:value-of select="$table-body-text"/>
  </xsl:template>
  <xsl:template name="draw-border-right">
    <xsl:text>border-right: </xsl:text>
    <xsl:value-of select="$table-border-color"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$table-border-width"/>
    <xsl:text> solid;</xsl:text>
  </xsl:template>
  <xsl:template name="draw-border-bottom">
    <xsl:text>border-bottom: </xsl:text>
    <xsl:value-of select="$table-border-color"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$table-border-width"/>
    <xsl:text> solid;</xsl:text>
  </xsl:template>
  <xsl:template name="draw-border-top">
    <xsl:text>border-top: </xsl:text>
    <xsl:value-of select="$table-border-color"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$table-border-width"/>
    <xsl:text> solid;</xsl:text>
  </xsl:template>
  <xsl:template name="draw-border-left">
    <xsl:text>border-left: </xsl:text>
    <xsl:value-of select="$table-border-color"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$table-border-width"/>
    <xsl:text> solid;</xsl:text>
  </xsl:template>
  <xsl:template name="draw-border">
    <xsl:variable name="tg" select="ancestor::tgroup[1]"/>
    <xsl:variable name="curRow" select=".."/>
    <xsl:variable name="this-entry" select="1 + count(preceding-sibling::entry)"/>
    <xsl:variable name="last-entry" select="count(../entry)"/>
    <xsl:variable name="this-row" select="count($tg//row[. &lt;&lt; $curRow]) + 1"/>
    <xsl:variable name="last-row" select="count($tg//row)"/>
    <xsl:variable name="frame">
      <xsl:choose>
        <xsl:when test="string-length(ancestor::table[1]/@frame) &gt; 0">
          <xsl:value-of select="ancestor::table[1]/@frame"/>
        </xsl:when>
        <xsl:otherwise>all</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="colname" select="@colname"/>
    <xsl:variable name="colsep">
      <xsl:choose>
        <xsl:when test="not(@colsep) and string-length($colname) &gt; 0 and $tg/colspec[@colname = $colname]/@colsep">
          <xsl:value-of select="$tg/colspec[@colname = $colname]/@colsep"/>
        </xsl:when>
        <xsl:when test="ancestor-or-self::*[self::table or self::tgroup or self::entry or self::row]/@colsep">
          <xsl:value-of select="ancestor-or-self::*[self::table or self::tgroup or self::entry or self::row][@colsep][1]/@colsep"/>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="rowsep">
      <xsl:choose>
        <xsl:when test="not(@rowsep) and not(../@rowsep) and string-length($colname) &gt; 0 and $tg/colspec[@colname = $colname]/@rowsep">
          <xsl:value-of select="$tg/colspec[@colname = $colname]/@rowsep"/>
        </xsl:when>
        <xsl:when test="ancestor-or-self::*[self::table or self::tgroup or self::entry or self::row]/@rowsep">
          <xsl:value-of select="ancestor-or-self::*[self::table or self::tgroup or self::entry or self::row][@rowsep][1]/@rowsep"/>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$colsep = '1' or $rowsep = '1' or (not($frame = '') and not($frame = 'none'))">
      <xsl:choose>
        <xsl:when test="not($this-entry = $last-entry)">
          <xsl:if test="$colsep = '1'">
            <xsl:call-template name="draw-border-right"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$frame = 'all' or $frame = 'sides'">
            <xsl:call-template name="draw-border-right"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$this-entry = 1 and ($frame = 'all' or $frame = 'sides')">
        <xsl:call-template name="draw-border-left"/>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="not($this-row = $last-row)">
          <xsl:if test="$rowsep = '1'">
            <xsl:call-template name="draw-border-bottom"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$frame = 'bottom' or $frame = 'topbot' or $frame = 'all'">
            <xsl:call-template name="draw-border-bottom"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$this-row = 1 and ($frame = 'top' or $frame = 'topbot' or $frame = 'all')">
        <xsl:call-template name="draw-border-top"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  <xsl:template match="tgroup" mode="#all">
    <table cellpadding="0" cellspacing="0" class="uwe-cals-table" width="100%" style="border-collapse:collapse;">
      <xsl:apply-templates mode="#current"/>
    </table>
  </xsl:template>
  <xsl:template match="tbody" mode="#all">
    <tbody>
      <xsl:apply-templates mode="#current"/>
    </tbody>
  </xsl:template>
  <xsl:template match="thead" mode="#all">
    <xsl:if test="*[normalize-space(.)]">
      <thead>
        <xsl:apply-templates mode="#current"/>
      </thead>
    </xsl:if>
  </xsl:template>
  <xsl:template match="tfoot" mode="#all">
    <tfoot>
      <xsl:apply-templates mode="#current"/>
    </tfoot>
  </xsl:template>
  <xsl:template match="row" mode="#all">
    <tr>
      <xsl:apply-templates mode="#current"/>
    </tr>
  </xsl:template>
  <xsl:template name="set-entry-align">
    <xsl:if test="ancestor-or-self::*[self::tgroup or self::entry]/@align">
      <xsl:text>text-align:</xsl:text>
      <xsl:value-of select="ancestor-or-self::*[self::tgroup or self::entry][@align][1]/@align"/>
      <xsl:text>;</xsl:text>
    </xsl:if>
  </xsl:template>
  <xsl:template name="get-column-width">
    <xsl:variable name="tg" select="ancestor::tgroup[1]"/>
    <xsl:variable name="cn" select="@colname"/>
    <xsl:choose>
      <xsl:when test="@htmlwidth">
        <xsl:value-of select="@htmlwidth"/>
      </xsl:when>
      <xsl:when test="$cn and $tg/colspec[@colname = $cn]">
        <xsl:variable name="spec" select="$tg/colspec[@colname = $cn][1]"/>
        <xsl:variable name="raw" select="string($spec/@colwidth)"/>
        <xsl:variable name="num" select="number(translate($raw, '*', ''))"/>
        <xsl:variable name="total" select="sum(for $c in $tg/colspec return number(translate(string($c/@colwidth), '*', '')))"/>
        <xsl:choose>
          <xsl:when test="$total gt 0 and not($total != $total) and $num gt 0">
            <xsl:value-of select="concat(string(round(100 * $num div $total)), '%')"/>
          </xsl:when>
          <xsl:when test="string-length($raw) &gt; 0">
            <xsl:value-of select="$raw"/>
          </xsl:when>
          <xsl:otherwise>*</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>*</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="entry" mode="#all">
    <xsl:variable name="cell" select="if (ancestor::thead) then 'th' else 'td'"/>
    <xsl:element name="{$cell}">
      <xsl:call-template name="set-span"/>
      <xsl:attribute name="width">
        <xsl:call-template name="get-column-width"/>
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:call-template name="set-entry-align"/>
        <xsl:call-template name="valign"/>
        <xsl:choose>
          <xsl:when test="ancestor::thead">
            <xsl:text>background:</xsl:text>
            <xsl:value-of select="$table-header-bg"/>
            <xsl:text>;color:</xsl:text>
            <xsl:value-of select="$table-header-text"/>
            <xsl:text>;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>background:</xsl:text>
            <xsl:call-template name="set-table-background-color"/>
            <xsl:text>;color:</xsl:text>
            <xsl:call-template name="set-text-color"/>
            <xsl:text>;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>padding:</xsl:text>
        <xsl:value-of select="$default-cell-padding"/>
        <xsl:text>;</xsl:text>
        <xsl:call-template name="draw-border"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="ancestor::table[@type = 'choicetable'] and count(parent::row/preceding-sibling::row) &gt; 0">
          <xsl:choose>
            <xsl:when test="preceding-sibling::*">
              <span style="font-family:Wingdings;font-size:14pt">¨</span>
            </xsl:when>
            <xsl:otherwise>
              <span style="font-family:Wingdings;font-size:14pt">þ</span>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="#current"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="not(normalize-space(string(.))) and not(*//text()[normalize-space()])">
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  <xsl:template name="valign">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*[self::thead or self::tfoot or self::tbody or self::row or self::entry]/@valign">
        <xsl:variable name="va" select="ancestor-or-self::*[self::thead or self::tfoot or self::tbody or self::row or self::entry][@valign][1]/@valign"/>
        <xsl:choose>
          <xsl:when test="$va = 'top'">vertical-align:top;</xsl:when>
          <xsl:when test="$va = 'middle'">vertical-align:middle;</xsl:when>
          <xsl:when test="$va = 'bottom'">vertical-align:bottom;</xsl:when>
          <xsl:otherwise>vertical-align:top;</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>vertical-align:top;</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="set-span">
    <xsl:variable name="entry.colspan">
      <xsl:choose>
        <xsl:when test="@spanname or @namest">
          <xsl:call-template name="calculate.colspan"/>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="@morerows">
      <xsl:attribute name="rowspan">
        <xsl:value-of select="@morerows + 1"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="number($entry.colspan) &gt; 1">
      <xsl:attribute name="colspan">
        <xsl:value-of select="$entry.colspan"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  <xsl:template name="calculate.colspan">
    <xsl:variable name="spanname" select="@spanname"/>
    <xsl:variable name="spanspec" select="ancestor::tgroup/spanspec[@spanname = $spanname]"/>
    <xsl:variable name="namest">
      <xsl:choose>
        <xsl:when test="@spanname">
          <xsl:value-of select="$spanspec/@namest"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@namest"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="nameend">
      <xsl:choose>
        <xsl:when test="@spanname">
          <xsl:value-of select="$spanspec/@nameend"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@nameend"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="scol">
      <xsl:call-template name="colspec.colnum">
        <xsl:with-param name="colspec" select="ancestor::tgroup/colspec[@colname = $namest][last()]"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="ecol">
      <xsl:call-template name="colspec.colnum">
        <xsl:with-param name="colspec" select="ancestor::tgroup/colspec[@colname = $nameend][last()]"/>
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
        <xsl:value-of select="number($prec.colspec.colnum) + 1"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="colspec" mode="#all"/>
</xsl:stylesheet>
