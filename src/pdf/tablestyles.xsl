<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:variable name="empty-placeholder-string"/>
  <xsl:attribute-set name="table">
    <xsl:attribute name="id">
      <xsl:value-of select="generate-id()"/>
    </xsl:attribute>
    <xsl:attribute name="space-after">
      <xsl:value-of select="$table-space-after"/>
    </xsl:attribute>
    <xsl:attribute name="space-before">
      <xsl:value-of select="$table-space-after"/>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="thead">
    <xsl:attribute name="background-color">
      <xsl:choose>
        <xsl:when test="$look-and-feel='fashion'">
          <xsl:value-of select="$color-black-20"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$color-white"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="tgroup1">
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="width">100%</xsl:attribute>
  </xsl:attribute-set>
  <xsl:template name="set-text-color">
    <xsl:if test="not(ancestor::thead)">
      <xsl:attribute name="color">
        <xsl:choose>
          <xsl:when test="descendant::txtcol">
            <xsl:value-of select="descendant::txtcol[1]/@color"/>
          </xsl:when>
          <xsl:otherwise>black</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  <xsl:template name="set-table-background-color">
    <xsl:if test="not(ancestor::thead)">
      <xsl:variable name="colnum" select="count(preceding-sibling::entry)"/>
      <xsl:attribute name="background-color">
        <xsl:choose>
          <xsl:when test="descendant::cellcol">
            <xsl:value-of select="descendant::cellcol[1]/@color"/>
          </xsl:when>
          <xsl:when test="parent::row/entry/descendant::rowcol">
            <xsl:value-of select="parent::row/entry[descendant::rowcol][position()=1]/descendant::rowcol/@color"/>
          </xsl:when>
          <xsl:when test="ancestor::tgroup/descendant::entry[count(preceding-sibling::entry)=$colnum]/descendant::colcol">
            <xsl:value-of select="ancestor::tgroup/descendant::entry[count(preceding-sibling::entry)=$colnum and descendant::colcol][position()=1]/descendant::colcol/@color"/>
          </xsl:when>
          <xsl:when test="ancestor::eh-table/@layoutset='table_evaluation'">
            <xsl:value-of select="$color-black-05"/>
          </xsl:when>
          <xsl:when test="$look-and-feel='fashion'">
            <xsl:value-of select="$color-black-10"/>
          </xsl:when>
          <xsl:otherwise>white</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  <xsl:attribute-set name="table.title">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="margin-bottom">
      <xsl:value-of select="$table-title-space-after"/>
    </xsl:attribute>
    <xsl:attribute name="keep-with-next">always</xsl:attribute>
  </xsl:attribute-set>
  <xsl:variable name="default.table.frame">all</xsl:variable>
  <xsl:template name="table-frame-border-style">solid</xsl:template>
  <xsl:template name="table-frame-border-thickness">
    <xsl:choose>
      <xsl:when test="$look-and-feel='fashion'">2pt</xsl:when>
      <xsl:otherwise>1pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="table-frame-border-color">
    <xsl:choose>
      <xsl:when test="ancestor::eh-table/@layoutset='table_default'">
        <xsl:value-of select="$color-white"/>
      </xsl:when>
      <xsl:when test="ancestor::eh-table/@layoutset='table_evaluation'">
        <xsl:value-of select="$color-white"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$color-white"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:variable name="default.table.width"/>
</xsl:stylesheet>
