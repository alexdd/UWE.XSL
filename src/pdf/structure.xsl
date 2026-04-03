<?xml version="1.0" encoding="utf-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xe="http://www.xes.future" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
  <!-- ========== Struktur: Meta (Titelseite) ========== -->
  <xsl:template match="meta">
    <fo:page-sequence master-reference="page-sequence">
      <xsl:attribute name="force-page-count">
        <xsl:choose>
          <xsl:when test="$format='book'">end-on-even</xsl:when>
          <xsl:otherwise>auto</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <fo:flow flow-name="xsl-region-body">
        <xsl:call-template name="cover-page"/>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>
  <!-- ========== Structure: Back cover ========== -->
  <xsl:template match="cover-backpage">
    <fo:page-sequence master-reference="multicol-page-sequence-backcover">
      <xsl:attribute name="force-page-count">end-on-even</xsl:attribute>
      <xsl:call-template name="print-header-and-footer-backcover"/>
      <fo:flow flow-name="xsl-region-body">
        <xsl:call-template name="cover-outside-back"/>
        <xsl:choose>
          <xsl:when test="$paper-format='A5'">
            <fo:block font-size="6pt" line-height="120%">
              <xsl:apply-templates select="chapter/*"/>
            </fo:block>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="chapter/*"/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>
  <xsl:template match="cover-backpage/chapter/block-title|cover-backpage/chapter/title|cover-backpage/chapter/column-wide-element">
    <xsl:choose>
      <xsl:when test="$paper-format='A5' and not(self::column-wide-element)"/>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ========== Struktur: Kapitel, Index, Appendix, TOC ========== -->
  <xsl:template match="chapter[not(parent::chapter)] | index | appendix | figure-index | footnote-index" priority="5">
    <xsl:choose>
      <xsl:when test="self::chapter and not(/descendant::toc) and not(preceding-sibling::chapter) and not($format='book')">
        <fo:page-sequence master-reference="page-sequence">
          <xsl:attribute name="force-page-count">auto</xsl:attribute>
          <xsl:call-template name="print-header-and-footer"/>
          <fo:flow flow-name="xsl-region-body">
            <xsl:call-template name="section-content"/>
            <xsl:apply-templates select="following-sibling::*[self::chapter or self::figure-index or self::footnote-index or self::appendix]" mode="not_book"/>
            <fo:block space-before="{$section-between-space}">
              <xsl:apply-templates select="//meta/cover-text"/>
            </fo:block>
          </fo:flow>
        </fo:page-sequence>
      </xsl:when>
      <xsl:when test="(self::chapter or self::figure-index or self::footnote-index) and not($format='book')"/>
      <xsl:otherwise>
        <fo:page-sequence>
          <xsl:attribute name="force-page-count">
            <xsl:choose>
              <xsl:when test="self::appendix and /*//cover-backpage">end-on-odd</xsl:when>
              <xsl:when test="self::appendix and not(/*//cover-backpage)">auto</xsl:when>
              <xsl:when test="self::index and not(/descendant::appendix) and /*//cover-backpage">end-on-odd</xsl:when>
              <xsl:when test="self::footnote-index and not(/descendant::index) and not(/descendant::appendix) and /*//cover-backpage">end-on-odd</xsl:when>
              <xsl:when test="self::figure-index and not(/descendant::footnote-index) and not(/descendant::index) and not(/descendant::appendix) and /*//cover-backpage">end-on-odd</xsl:when>
              <xsl:when test="self::chapter and following-sibling::*[1][self::cover-backpage]">end-on-odd</xsl:when>
              <xsl:when test="parent::cover-backpage">end-on-even</xsl:when>
              <xsl:when test="self::chapter and not($chapter-on-right-page='yes')">auto</xsl:when>
              <xsl:otherwise>end-on-even</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="master-reference">
            <xsl:choose>
              <xsl:when test="self::index">twocol-page-sequence</xsl:when>
              <xsl:otherwise>page-sequence</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:call-template name="print-header-and-footer"/>
          <fo:flow flow-name="xsl-region-body">
            <xsl:call-template name="section-content"/>
          </fo:flow>
        </fo:page-sequence>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="chapter|figure-index|footnote-index|appendix" mode="not_book">
    <xsl:call-template name="section-content"/>
  </xsl:template>
  <xsl:template match="chapter[parent::chapter]" priority="5">
    <xsl:call-template name="section-content"/>
  </xsl:template>
  <xsl:template match="title" mode="running">
    <fo:basic-link internal-destination="{generate-id()}">
      <fo:inline font-style="italic" border-bottom="1pt #999 solid">
        <xsl:apply-templates/>
      </fo:inline>
    </fo:basic-link>
  </xsl:template>
  <xsl:template match="toc">
    <fo:page-sequence master-reference="page-sequence">
      <xsl:if test="$chapter-on-right-page='yes'">
        <xsl:attribute name="force-page-count">end-on-even</xsl:attribute>
      </xsl:if>
      <xsl:call-template name="print-header-and-footer"/>
      <fo:flow flow-name="xsl-region-body">
        <fo:block id="toc">
          <xsl:call-template name="toc-title-styles"/>
          <xsl:if test="$layout='columns'">
            <xsl:attribute name="span">all</xsl:attribute>
          </xsl:if>
          <xsl:call-template name="section-title">
            <xsl:with-param name="section-level">1</xsl:with-param>
            <xsl:with-param name="type">not-numbered</xsl:with-param>
          </xsl:call-template>
        </fo:block>
        <xsl:for-each select="$section-list">
          <xsl:call-template name="print-toc-entries"/>
        </xsl:for-each>
        <xsl:if test="not($format='book')">
          <xsl:if test="$layout='columns'">
            <fo:block span="all" margin-top="{$section-between-space}" keep-with-previous.within-page="always"/>
          </xsl:if>
          <xsl:apply-templates select="following-sibling::*[self::chapter or self::figure-index or self::appendix or self::footnote-index]" mode="not_book"/>
          <fo:block space-before="{$section-between-space}">
            <xsl:apply-templates select="//meta/cover-text"/>
          </fo:block>
        </xsl:if>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>
  <!-- ========== Struktur: Lesezeichen (PDF-Bookmarks) ========== -->
  <xsl:template match="toc" mode="bookmarks">
    <fo:bookmark internal-destination="toc">
      <fo:bookmark-title>
        <xsl:call-template name="boilerplate-lookup">
          <xsl:with-param name="key">B_TOC</xsl:with-param>
        </xsl:call-template>
      </fo:bookmark-title>
    </fo:bookmark>
  </xsl:template>
  <xsl:template match="figure-index" mode="bookmarks">
    <fo:bookmark internal-destination="figure-index">
      <fo:bookmark-title>
        <xsl:call-template name="boilerplate-lookup">
          <xsl:with-param name="key">B_FIGURE_INDEX</xsl:with-param>
        </xsl:call-template>
      </fo:bookmark-title>
    </fo:bookmark>
  </xsl:template>
  <xsl:template match="appendix" mode="bookmarks">
    <fo:bookmark internal-destination="appendix">
      <fo:bookmark-title>
        <xsl:call-template name="boilerplate-lookup">
          <xsl:with-param name="key">B_APPENDIX</xsl:with-param>
        </xsl:call-template>
      </fo:bookmark-title>
    </fo:bookmark>
  </xsl:template>
  <xsl:template match="footnote-index" mode="bookmarks">
    <fo:bookmark internal-destination="footnote-index">
      <fo:bookmark-title>
        <xsl:call-template name="boilerplate-lookup">
          <xsl:with-param name="key">B_FOOTNOTE_INDEX</xsl:with-param>
        </xsl:call-template>
      </fo:bookmark-title>
    </fo:bookmark>
  </xsl:template>
  <xsl:template match="index" mode="bookmarks">
    <fo:bookmark internal-destination="index">
      <fo:bookmark-title>
        <xsl:call-template name="boilerplate-lookup">
          <xsl:with-param name="key">B_INDEX</xsl:with-param>
        </xsl:call-template>
      </fo:bookmark-title>
    </fo:bookmark>
  </xsl:template>
  <xsl:template match="chapter" mode="bookmarks">
    <xsl:variable name="is-glossary-chapter" as="xs:boolean">
      <xsl:call-template name="chapter-is-glossary"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$is-glossary-chapter">
        <fo:bookmark internal-destination="glossary">
          <fo:bookmark-title>
            <xsl:call-template name="boilerplate-lookup">
              <xsl:with-param name="key">B_GLOSSARY</xsl:with-param>
            </xsl:call-template>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:when>
      <xsl:otherwise>
        <fo:bookmark internal-destination="{generate-id()}">
          <xsl:variable name="section-level">
            <xsl:call-template name="get-section-level"/>
          </xsl:variable>
          <xsl:variable name="title">
            <xsl:call-template name="section-title">
              <xsl:with-param name="section-level" select="$section-level"/>
              <xsl:with-param name="is-bookmark" select="'true'"/>
            </xsl:call-template>
          </xsl:variable>
          <fo:bookmark-title>
            <xsl:value-of select="normalize-space($title)"/>
          </fo:bookmark-title>
          <xsl:apply-templates select="chapter" mode="bookmarks"/>
        </fo:bookmark>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
