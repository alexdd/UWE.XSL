<?xml version="1.0" encoding="utf-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
					Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
					SPDX-License-Identifier: LGPL-3.0-only
					See license.txt for the full license text. -->
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xe="http://www.xes.future" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
  <xsl:include href="tablestyles.xsl"/>
  <xsl:include href="tablemodule.xsl"/>
  <xsl:include href="legend.xsl"/>
  <xsl:include href="ansimodule.xsl"/>
  <xsl:include href="appendixmodule.xsl"/>
  <xsl:param name="docker">no</xsl:param>
  <xsl:param name="pdf_config_uri" select="''"/>
  <xsl:variable name="pdf-config" select="if (string($pdf_config_uri) != '') then $pdf_config_uri else (if ($docker='no') then 'pdf_config.xml' else 'pdf_config_docker.xml')"/>
  <xsl:variable name="ctm" select="doc($pdf-config)//custom = 'true'"/>
  <xsl:variable name="ansi" select="/document/meta/safety-messages = 'ansi'"/>
  <xsl:variable name="custom" select="if (not($ansi)) then $ctm else false()"/>
  <xsl:param name="localize_file">localize.xml</xsl:param>
  <xsl:param name="option_color1">#E2E0E0</xsl:param>
  <xsl:param name="option_color2">#EFEDED</xsl:param>
  <xsl:param name="option_color3">#747575</xsl:param>
  <xsl:param name="option_color4">#7F7F7F</xsl:param>
  <xsl:variable name="option_copyright" select="doc($pdf-config)//copyright-url"/>
  <xsl:param name="version">1234</xsl:param>
  <xsl:param name="imagedir">../../test/boilerplate</xsl:param>
  <xsl:param name="option_outer_margin_A4_leftgap">15</xsl:param>
  <xsl:param name="option_outer_margin_A5_leftgap">10</xsl:param>
  <xsl:param name="option_outer_margin_A4_A5">20</xsl:param>
  <xsl:param name="option_inner_margin_A4_leftgap">25</xsl:param>
  <xsl:param name="option_inner_margin_A5_leftgap">20</xsl:param>
  <xsl:param name="option_inner_outer_margin_A4_A5">20</xsl:param>
  <xsl:param name="option_top_margin_A4">40</xsl:param>
  <xsl:param name="option_top_margin_A5">35</xsl:param>
  <xsl:param name="option_bottom_margin_A4">20</xsl:param>
  <xsl:param name="option_bottom_margin_A5">20</xsl:param>
  <xsl:param name="option_bg_block_top">yes</xsl:param>
  <xsl:param name="option_bg_block_center">yes</xsl:param>
  <xsl:param name="option_default_font_size_A4">10</xsl:param>
  <xsl:param name="option_headline_font_sizes_A4">16,14,13,11,11</xsl:param>
  <xsl:param name="option_default_font_size_A5">9</xsl:param>
  <xsl:param name="option_headline_font_sizes_A5">12,11,10,9,9</xsl:param>
  <xsl:param name="option_margin_width_A4">30</xsl:param>
  <xsl:param name="option_default_font_family">Noto Sans Regular, Noto Sans Symbols, DejaVu Sans</xsl:param>
  <xsl:param name="print_format">no</xsl:param>
  <xsl:param name="print_layout">no</xsl:param>
  <xsl:param name="print_paper_format">no</xsl:param>
  <xsl:param name="print_page_margin">no</xsl:param>
  <!-- Mode: leftgap | leftright … (from params layout/print_page_margins). Used when print_page_margin != 'no'. -->
  <xsl:param name="print_page_margins">leftgap</xsl:param>
  <xsl:param name="print_spaces">no</xsl:param>
  <xsl:param name="print_header">no</xsl:param>
  <xsl:param name="print_footer">no</xsl:param>
  <xsl:param name="print_look_and_feel">no</xsl:param>
  <xsl:param name="print_table_layout">no</xsl:param>
  <xsl:param name="print_chapter_on_right_page">no</xsl:param>
  <xsl:param name="theme">custom</xsl:param>
  <xsl:function name="xe:resolve-local-src">
    <xsl:param name="src"/>
    <xsl:variable name="value" select="normalize-space(string($src))"/>
    <xsl:choose>
      <xsl:when test="$value = ''">
        <xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="matches($value, '^(file:|https?:|/|[A-Za-z]:[/\\])')">
        <xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="starts-with($value, './transformation/uwe/images/')">
        <xsl:value-of select="resolve-uri(replace($value, '^\./transformation/uwe/images/', '../../test/boilerplate/'), $pdf-config)"/>
      </xsl:when>
      <xsl:when test="starts-with($value, '../') or starts-with($value, './')">
        <xsl:value-of select="resolve-uri($value, $pdf-config)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <xsl:variable name="logo_small_odd" select="xe:resolve-local-src(doc($pdf-config)//logo-small-odd)"/>
  <xsl:variable name="logo_small_even" select="xe:resolve-local-src(doc($pdf-config)//logo-small-even)"/>
  <xsl:variable name="logo_small_odd_top" select="doc($pdf-config)//logo-small-odd-top"/>
  <xsl:variable name="logo_small_even_top" select="doc($pdf-config)//logo-small-even-top"/>
  <xsl:variable name="hfsa4" select="tokenize(translate($option_headline_font_sizes_A4,' ',''),',')"/>
  <xsl:variable name="headline_font_size_A4_level_1" select="$hfsa4[1]"/>
  <xsl:variable name="headline_font_size_A4_level_2" select="$hfsa4[2]"/>
  <xsl:variable name="headline_font_size_A4_level_3" select="$hfsa4[3]"/>
  <xsl:variable name="headline_font_size_A4_level_4" select="$hfsa4[4]"/>
  <xsl:variable name="headline_font_size_A4_level_5" select="$hfsa4[5]"/>
  <xsl:variable name="hfsa5" select="tokenize(translate($option_headline_font_sizes_A5,' ',''),',')"/>
  <xsl:variable name="headline_font_size_A5_level_1" select="$hfsa5[1]"/>
  <xsl:variable name="headline_font_size_A5_level_2" select="$hfsa5[2]"/>
  <xsl:variable name="headline_font_size_A5_level_3" select="$hfsa5[3]"/>
  <xsl:variable name="headline_font_size_A5_level_4" select="$hfsa5[4]"/>
  <xsl:variable name="headline_font_size_A5_level_5" select="$hfsa5[5]"/>
  <xsl:variable name="A0-WIDTH">841</xsl:variable>
  <xsl:variable name="A0-HEIGHT">1189</xsl:variable>
  <xsl:variable name="A1-WIDTH">594</xsl:variable>
  <xsl:variable name="A1-HEIGHT">841</xsl:variable>
  <xsl:variable name="A2-WIDTH">420</xsl:variable>
  <xsl:variable name="A2-HEIGHT">594</xsl:variable>
  <xsl:variable name="A3-WIDTH">294</xsl:variable>
  <xsl:variable name="A3-HEIGHT">420</xsl:variable>
  <xsl:variable name="A4-WIDTH">210</xsl:variable>
  <xsl:variable name="A4-HEIGHT">297</xsl:variable>
  <xsl:variable name="A5-WIDTH">148</xsl:variable>
  <xsl:variable name="A5-HEIGHT">210</xsl:variable>
  <xsl:variable name="A6-WIDTH">105</xsl:variable>
  <xsl:variable name="A6-HEIGHT">148</xsl:variable>
  <xsl:variable name="A7-WIDTH">74</xsl:variable>
  <xsl:variable name="A7-HEIGHT">105</xsl:variable>
  <xsl:variable name="A8-WIDTH">52</xsl:variable>
  <xsl:variable name="A8-HEIGHT">74</xsl:variable>
  <xsl:variable name="US-Letter-WIDTH">215.9</xsl:variable>
  <xsl:variable name="US-Letter-HEIGHT">279.4</xsl:variable>
  <xsl:variable name="color-white">#fff</xsl:variable>
  <xsl:variable name="color-black">#000</xsl:variable>
  <xsl:variable name="color-black-05">#F6F6F6</xsl:variable>
  <xsl:variable name="color-black-10">#e6e6e6</xsl:variable>
  <xsl:variable name="color-black-15">#D9D9D9</xsl:variable>
  <xsl:variable name="color-black-20">#CCCCCC</xsl:variable>
  <xsl:variable name="color-black-25">#BFBFBF</xsl:variable>
  <xsl:variable name="color-black-35">#A6A6A6</xsl:variable>
  <xsl:variable name="color-black-50">#808080</xsl:variable>
  <xsl:variable name="color-black-75">#404040</xsl:variable>
  <xsl:variable name="color-risk-low">#00FF00</xsl:variable>
  <xsl:variable name="color-risk-high">#FFFF00</xsl:variable>
  <xsl:variable name="color-risk-medium">#00FFFF</xsl:variable>
  <xsl:variable name="color-risk-very-high">#FF0000</xsl:variable>
  <xsl:variable name="owner" select="//meta/owner"/>
  <xsl:variable name="date-of-last-change" select="//meta/date-of-last-change"/>
  <xsl:variable name="status" select="//meta/status"/>
  <xsl:variable name="rooty" select="/"/>
  <xsl:variable name="format">
    <xsl:choose>
      <xsl:when test="$print_format='no'">
        <xsl:value-of select="//meta/structure/format"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$print_format"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="layout">
    <xsl:choose>
      <xsl:when test="$print_layout='no'">
        <xsl:value-of select="//meta/design/layout"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$print_layout"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="paper-format">
    <xsl:choose>
      <xsl:when test="$print_paper_format='no'">
        <xsl:value-of select="//meta/design/paper-format"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$print_paper_format"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="page-margin">
    <xsl:choose>
      <xsl:when test="$print_page_margin='no'">
        <xsl:value-of select="//meta/design/page-margin"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$print_page_margins"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="spaces">
    <xsl:choose>
      <xsl:when test="$print_spaces='no'">
        <xsl:value-of select="//meta/design/spaces"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$print_spaces"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="header">
    <xsl:choose>
      <xsl:when test="$print_header='no'">
        <xsl:value-of select="//meta/design/header"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$print_header"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="footer">
    <xsl:choose>
      <xsl:when test="$print_footer='no'">
        <xsl:value-of select="//meta/design/footer"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$print_footer"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="look-and-feel">
    <xsl:choose>
      <xsl:when test="$print_look_and_feel='no'">
        <xsl:value-of select="//meta/design/look-and-feel"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$print_look_and_feel"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="table-layout">
    <xsl:choose>
      <xsl:when test="$print_table_layout='no'">
        <xsl:value-of select="//meta/design/table-layout"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$print_table_layout"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:template name="set-chapter-right-page">
    <xsl:choose>
      <xsl:when test="$print_chapter_on_right_page='no'">
        <xsl:value-of select="if(//meta/structure/chapter-on-right-page) then true() else false()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$print_chapter_on_right_page"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:variable name="chapter-on-right-page">
    <xsl:call-template name="set-chapter-right-page"/>
  </xsl:variable>
  <xsl:variable name="page-height">
    <xsl:call-template name="get-page-height"/>
  </xsl:variable>
  <xsl:variable name="page-width">
    <xsl:call-template name="get-page-width"/>
  </xsl:variable>
  <xsl:variable name="inner-margin">
    <xsl:call-template name="get-inner-margin"/>
  </xsl:variable>
  <xsl:variable name="outer-margin">
    <xsl:call-template name="get-outer-margin"/>
  </xsl:variable>
  <xsl:variable name="top-margin">
    <xsl:call-template name="get-top-margin"/>
  </xsl:variable>
  <xsl:variable name="bottom-margin">
    <xsl:call-template name="get-bottom-margin"/>
  </xsl:variable>
  <xsl:variable name="margin-width">
    <xsl:call-template name="get-margin-width"/>
  </xsl:variable>
  <xsl:variable name="column-width">
    <xsl:call-template name="get-column-width"/>
  </xsl:variable>
  <xsl:variable name="position-of-block-title">
    <xsl:call-template name="get-position-of-block-title"/>
  </xsl:variable>
  <xsl:variable name="position-of-chapter-title">
    <xsl:call-template name="get-position-of-chapter-title"/>
  </xsl:variable>
  <xsl:variable name="default-font-family">
    <xsl:call-template name="get-default-font-family"/>
  </xsl:variable>
  <xsl:variable name="default-font-size">
    <xsl:call-template name="get-default-font-size"/>
  </xsl:variable>
  <xsl:variable name="default-line-height">
    <xsl:call-template name="get-default-line-height"/>
  </xsl:variable>
  <xsl:variable name="block-space-after">
    <xsl:call-template name="get-block-space-after"/>
  </xsl:variable>
  <xsl:variable name="p-space-after">
    <xsl:call-template name="get-p-space-after"/>
  </xsl:variable>
  <xsl:variable name="subtitle-space-after">
    <xsl:call-template name="get-subtitle-space-after"/>
  </xsl:variable>
  <xsl:variable name="ul-space-after">
    <xsl:call-template name="get-ul-space-after"/>
  </xsl:variable>
  <xsl:variable name="ul-space-before">
    <xsl:call-template name="get-ul-space-before"/>
  </xsl:variable>
  <xsl:variable name="ul-title-space-after">
    <xsl:call-template name="get-ul-title-space-after"/>
  </xsl:variable>
  <xsl:variable name="ul-listitem-space-after">
    <xsl:call-template name="get-ul-listitem-space-after"/>
  </xsl:variable>
  <xsl:variable name="img-space-after">
    <xsl:call-template name="get-img-space-after"/>
  </xsl:variable>
  <xsl:variable name="hint-space-after">
    <xsl:call-template name="get-hint-space-after"/>
  </xsl:variable>
  <xsl:variable name="hint-title-space-after">
    <xsl:call-template name="get-hint-title-space-after"/>
  </xsl:variable>
  <xsl:variable name="table-padding">
    <xsl:call-template name="get-table-padding"/>
  </xsl:variable>
  <xsl:variable name="table-space-after">
    <xsl:call-template name="get-table-space-after"/>
  </xsl:variable>
  <xsl:variable name="table-title-space-after">
    <xsl:call-template name="get-table-title-space-after"/>
  </xsl:variable>
  <xsl:variable name="table-default-border-thickness">
    <xsl:call-template name="get-table-default-border-thickness"/>
  </xsl:variable>
  <xsl:variable name="table-evaluation-border-thickness">
    <xsl:call-template name="get-table-evaluation-border-thickness"/>
  </xsl:variable>
  <xsl:variable name="table-cell-background-optional">
    <xsl:call-template name="get-table-cell-background-optional"/>
  </xsl:variable>
  <xsl:variable name="table-cell-background-optional-2">
    <xsl:call-template name="get-table-cell-background-optional-2"/>
  </xsl:variable>
  <xsl:variable name="table-cell-background-optional-3">
    <xsl:call-template name="get-table-cell-background-optional-3"/>
  </xsl:variable>
  <xsl:variable name="section-between-space">
    <xsl:call-template name="get-section-between-space"/>
  </xsl:variable>
  <xsl:variable name="module-between-space">
    <xsl:call-template name="get-module-between-space"/>
  </xsl:variable>
  <xsl:variable name="supplemental-directives-space-before">
    <xsl:call-template name="get-supplemental-directives-space-before"/>
  </xsl:variable>
  <xsl:variable name="section-title-level1-font-size">
    <xsl:call-template name="get-section-title-level1-font-size"/>
  </xsl:variable>
  <xsl:variable name="section-title-level2-font-size">
    <xsl:call-template name="get-section-title-level2-font-size"/>
  </xsl:variable>
  <xsl:variable name="section-title-level3-font-size">
    <xsl:call-template name="get-section-title-level3-font-size"/>
  </xsl:variable>
  <xsl:variable name="section-title-level4-font-size">
    <xsl:call-template name="get-section-title-level4-font-size"/>
  </xsl:variable>
  <xsl:variable name="section-title-level5-font-size">
    <xsl:call-template name="get-section-title-level5-font-size"/>
  </xsl:variable>
  <xsl:variable name="section-title-level6-font-size">
    <xsl:call-template name="get-section-title-level6-font-size"/>
  </xsl:variable>
  <xsl:variable name="toc-start-indent">
    <xsl:call-template name="get-toc-start-indent"/>
  </xsl:variable>
  <xsl:variable name="toc-text-level1-start-indent">
    <xsl:call-template name="get-toc-text-level1-start-indent"/>
  </xsl:variable>
  <xsl:variable name="toc-text-level2-start-indent">
    <xsl:call-template name="get-toc-text-level2-start-indent"/>
  </xsl:variable>
  <xsl:variable name="toc-text-level3-start-indent">
    <xsl:call-template name="get-toc-text-level3-start-indent"/>
  </xsl:variable>
  <xsl:variable name="toc-text-level4-start-indent">
    <xsl:call-template name="get-toc-text-level4-start-indent"/>
  </xsl:variable>
  <xsl:variable name="outer-margin-backcover">
    <xsl:call-template name="get-outer-margin-backcover"/>
  </xsl:variable>
  <xsl:variable name="inner-margin-backcover">
    <xsl:call-template name="get-inner-margin-backcover"/>
  </xsl:variable>
  <xsl:variable name="top-margin-backcover">
    <xsl:call-template name="get-top-margin-backcover"/>
  </xsl:variable>
  <xsl:variable name="bottom-margin-backcover">
    <xsl:call-template name="get-bottom-margin-backcover"/>
  </xsl:variable>
  <xsl:variable name="backcover-column-count">
    <xsl:call-template name="get-backcover-column-count"/>
  </xsl:variable>
  <xsl:variable name="backcover-column-gap">
    <xsl:call-template name="get-backcover-column-gap"/>
  </xsl:variable>
  <xsl:variable name="fig-space-after">
    <xsl:call-template name="get-fig-space-after"/>
  </xsl:variable>
  <xsl:variable name="fig-space-before">
    <xsl:call-template name="get-fig-space-before"/>
  </xsl:variable>
  <xsl:variable name="subtitle-font-weight">
    <xsl:call-template name="get-subtitle-font-weight"/>
  </xsl:variable>
  <xsl:variable name="unit">mm</xsl:variable>
  <xsl:variable name="margins-changed">
    <xsl:choose>
      <xsl:when test="number($option_outer_margin_A4_leftgap)!=15 and $paper-format='A5'">yes</xsl:when>
      <xsl:when test="number($option_outer_margin_A5_leftgap)!=10 and $paper-format='A5'">yes</xsl:when>
      <xsl:when test="number($option_outer_margin_A4_A5)!=20 and $paper-format='A5'">yes</xsl:when>
      <xsl:when test="number($option_inner_margin_A4_leftgap)!=25 and $paper-format='A5'">yes</xsl:when>
      <xsl:when test="number($option_inner_margin_A5_leftgap)!=20 and $paper-format='A5'">yes</xsl:when>
      <xsl:when test="number($option_inner_outer_margin_A4_A5)!=20 and $paper-format='A5'">yes</xsl:when>
      <xsl:when test="number($option_top_margin_A4)!=45 and $paper-format='A5'">yes</xsl:when>
      <xsl:when test="number($option_top_margin_A5)!=35 and $paper-format='A5'">yes</xsl:when>
      <xsl:when test="number($option_bottom_margin_A4)!=30 and $paper-format='A5'">yes</xsl:when>
      <xsl:when test="number($option_bottom_margin_A5)!=20 and $paper-format='A5'">yes</xsl:when>
      <xsl:otherwise>no</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:template name="region-body-odd-page-styles">
    <xsl:attribute name="margin-left">
      <xsl:value-of select="concat($inner-margin,'mm')"/>
    </xsl:attribute>
    <xsl:attribute name="margin-right">
      <xsl:value-of select="concat($outer-margin,'mm')"/>
    </xsl:attribute>
    <xsl:attribute name="margin-top">
      <xsl:value-of select="concat($top-margin,'mm')"/>
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">
      <xsl:value-of select="concat($bottom-margin,'mm')"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="region-body-even-page-styles">
    <xsl:attribute name="margin-left">
      <xsl:value-of select="concat($outer-margin,'mm')"/>
    </xsl:attribute>
    <xsl:attribute name="margin-right">
      <xsl:value-of select="concat($inner-margin,'mm')"/>
    </xsl:attribute>
    <xsl:attribute name="margin-top">
      <xsl:value-of select="concat($top-margin,'mm')"/>
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">
      <xsl:value-of select="concat($bottom-margin,'mm')"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="region-after-even-page-styles">
    <xsl:attribute name="extent">
      <xsl:choose>
        <xsl:when test="$paper-format='A4'">8mm</xsl:when>
        <xsl:otherwise>15mm</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="region-after-odd-page-styles">
    <xsl:attribute name="extent">
      <xsl:choose>
        <xsl:when test="$paper-format='A4'">8mm</xsl:when>
        <xsl:otherwise>15mm</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="region-body-twocol-odd-page-styles">
    <xsl:attribute name="margin-left">
      <xsl:value-of select="concat($outer-margin,'mm')"/>
    </xsl:attribute>
    <xsl:attribute name="margin-right">
      <xsl:value-of select="concat($inner-margin,'mm')"/>
    </xsl:attribute>
    <xsl:attribute name="margin-top">
      <xsl:value-of select="concat($top-margin,'mm')"/>
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">
      <xsl:value-of select="concat($bottom-margin,'mm')"/>
    </xsl:attribute>
    <xsl:attribute name="column-count">2</xsl:attribute>
  </xsl:template>
  <xsl:template name="region-body-twocol-even-page-styles">
    <xsl:attribute name="margin-left">
      <xsl:value-of select="concat($inner-margin,'mm')"/>
    </xsl:attribute>
    <xsl:attribute name="margin-right">
      <xsl:value-of select="concat($outer-margin,'mm')"/>
    </xsl:attribute>
    <xsl:attribute name="margin-top">
      <xsl:value-of select="concat($top-margin,'mm')"/>
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">
      <xsl:value-of select="concat($bottom-margin,'mm')"/>
    </xsl:attribute>
    <xsl:attribute name="column-count">2</xsl:attribute>
  </xsl:template>
  <xsl:template name="margin-styles">
    <xsl:attribute name="width">
      <xsl:value-of select="concat($margin-width,$unit)"/>
    </xsl:attribute>
    <xsl:attribute name="vertical-align">top</xsl:attribute>
    <xsl:attribute name="padding-right">
      <xsl:call-template name="get-margin-right-padding"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="block-title-styles">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="line-height">130%</xsl:attribute>
    <xsl:attribute name="text-align">
      <xsl:choose>
        <xsl:when test="$paper-format='A4' and not($layout='columns') and $option_margin_width_A4='30'">center</xsl:when>
        <xsl:when test="$paper-format='A4' and not($layout='columns')">left</xsl:when>
        <xsl:otherwise>left</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:if test="$layout='columns'">
      <xsl:attribute name="background-color" select="$option_color2"/>
    </xsl:if>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">40</xsl:attribute>
    <xsl:attribute name="space-after">6pt</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:call-template name="get-block-title-font-size"/>
    </xsl:attribute>
    <xsl:if test="$look-and-feel='fashion'">
      <xsl:attribute name="color" select="$option_color3"/>
    </xsl:if>
    <xsl:if test="@style='larger'">
      <xsl:attribute name="font-size">16pt</xsl:attribute>
      <xsl:attribute name="border-top">white 5pt solid</xsl:attribute>
      <xsl:attribute name="color">#999</xsl:attribute>
      <xsl:attribute name="text-align">right</xsl:attribute>
    </xsl:if>
    <xsl:call-template name="extended-block-title-styles"/>
  </xsl:template>
  <xsl:template name="extended-block-title-styles"/>
  <xsl:template name="block-styles">
    <xsl:attribute name="space-after">
      <xsl:value-of select="$block-space-after"/>
    </xsl:attribute>
    <xsl:if test="$layout='rtf'">
      <xsl:attribute name="margin-left">1mm</xsl:attribute>
    </xsl:if>
  </xsl:template>
  <xsl:template name="make-extended-block-styles">
    <xsl:apply-templates select="*[not(self::title)]"/>
  </xsl:template>
  <xsl:template name="verbatim-styles">
    <xsl:attribute name="font-family">Courier New, monospace</xsl:attribute>
    <xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="line-height">110%</xsl:attribute>
    <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
    <xsl:attribute name="white-space">pre</xsl:attribute>
    <xsl:attribute name="white-space-collapse">false</xsl:attribute>
    <xsl:choose>
      <xsl:when test="ancestor::entry">
        <xsl:attribute name="margin-top">0pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0pt</xsl:attribute>
        <xsl:attribute name="padding">4pt</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="margin-top">10pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">10pt</xsl:attribute>
        <xsl:attribute name="padding">10pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">5pt</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="not(ancestor::abstract) and not(ancestor::entry) and not(ancestor::result)">
      <xsl:attribute name="border">#e3e3e3 2pt solid</xsl:attribute>
    </xsl:if>
  </xsl:template>
  <xsl:template name="abstract-styles">
    <xsl:param name="type">abstract</xsl:param>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="margin-top">10pt</xsl:attribute>
    <xsl:if test="type='abstract'">
      <xsl:attribute name="margin-bottom">10pt</xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@type='abstract'">
        <xsl:attribute name="border-left"><xsl:value-of select="$option_color2"/> 10pt solid</xsl:attribute>
      </xsl:when>
      <xsl:when test="@type='stepsection'">
        <xsl:attribute name="border"><xsl:value-of select="$option_color2"/> 2pt solid</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
        <xsl:attribute name="padding">2pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">6pt</xsl:attribute>
      </xsl:when>
      <xsl:when test="@type='prereq'">
        <xsl:attribute name="background-color">
          <xsl:value-of select="$option_color1"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
      </xsl:when>
      <xsl:when test="@type='context'">
        <xsl:attribute name="background-color">
          <xsl:value-of select="$option_color2"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@type='postreq'">
        <xsl:attribute name="background-color">
          <xsl:value-of select="$option_color1"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="font-style">italic</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:attribute name="padding-left">10pt</xsl:attribute>
    <xsl:attribute name="padding-right">10pt</xsl:attribute>
    <xsl:attribute name="padding-top">4pt</xsl:attribute>
    <xsl:attribute name="padding-bottom">4pt</xsl:attribute>
  </xsl:template>
  <xsl:template name="subtitle-styles">
    <xsl:attribute name="font-weight" select="$subtitle-font-weight"/>
    <xsl:attribute name="margin-bottom" select="$subtitle-space-after"/>
    <xsl:attribute name="keep-with-previous.within-page">always</xsl:attribute>
  </xsl:template>
  <xsl:template name="ul-styles">
    <xsl:attribute name="space-after">
      <xsl:value-of select="$ul-space-after"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="table-styles">
    <xsl:attribute name="id">
      <xsl:value-of select="generate-id()"/>
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">
      <xsl:value-of select="$table-space-after"/>
    </xsl:attribute>
    <xsl:attribute name="margin-top">
      <xsl:value-of select="$table-space-after"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="default-page-styles">
    <xsl:attribute name="font-family">
      <xsl:value-of select="$default-font-family"/>
    </xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$default-font-size"/>
    </xsl:attribute>
    <xsl:attribute name="line-height">
      <xsl:value-of select="$default-line-height"/>
    </xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="hyphenate">
      <xsl:choose>
        <xsl:when test="$layout='columns'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="hyphenation-push-character-count">3</xsl:attribute>
    <xsl:attribute name="hyphenation-remain-character-count">3</xsl:attribute>
    <xsl:variable name="language" select="substring-before((//meta/language,/*[1]/@language)[1],'-')"/>
    <xsl:attribute name="language">
      <xsl:value-of select="$language"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="link-styles">
    <xsl:attribute name="font-style">italic</xsl:attribute>
  </xsl:template>
  <xsl:template name="url-styles">
    <xsl:attribute name="keep-together.within-line">6</xsl:attribute>
    <xsl:attribute name="color">blue</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
  </xsl:template>
  <xsl:template name="logo-img-styles">
    <xsl:attribute name="position">fixed</xsl:attribute>
    <xsl:attribute name="top">210mm</xsl:attribute>
    <xsl:attribute name="left">40mm</xsl:attribute>
  </xsl:template>
  <xsl:template name="odd-page-styles">
    <xsl:attribute name="page-width" select="concat($page-width,$unit)"/>
    <xsl:attribute name="page-height" select="concat($page-height,$unit)"/>
  </xsl:template>
  <xsl:template name="even-page-styles">
    <xsl:attribute name="page-width" select="concat($page-width,$unit)"/>
    <xsl:attribute name="page-height" select="concat($page-height,$unit)"/>
  </xsl:template>
  <xsl:template name="region-before-even-page-styles">
    <xsl:attribute name="extent" select="concat($top-margin,$unit)"/>
  </xsl:template>
  <xsl:template name="region-before-odd-page-styles">
    <xsl:attribute name="extent" select="concat($top-margin,$unit)"/>
  </xsl:template>
  <xsl:template name="header-odd-first-line-styles">
    <xsl:attribute name="margin-left" select="concat($inner-margin,$unit)"/>
    <xsl:attribute name="margin-right" select="concat($outer-margin,$unit)"/>
    <xsl:attribute name="height">8mm</xsl:attribute>
    <xsl:attribute name="margin-top">
      <xsl:choose>
        <xsl:when test="$paper-format='A4'">16mm</xsl:when>
        <xsl:otherwise>10mm</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
    <xsl:attribute name="space-after">2mm</xsl:attribute>
    <xsl:if test="$look-and-feel='fashion'">
      <xsl:attribute name="color" select="$option_color3"/>
    </xsl:if>
  </xsl:template>
  <xsl:template name="header-odd-second-line-styles">
    <xsl:attribute name="background-color">
      <xsl:choose>
        <xsl:when test="$look-and-feel='fashion'">
          <xsl:value-of select="$option_color1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$color-black-10"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="padding-left">2mm</xsl:attribute>
    <xsl:attribute name="padding-right">2mm</xsl:attribute>
    <xsl:attribute name="height">8mm</xsl:attribute>
    <xsl:attribute name="padding-top">1mm</xsl:attribute>
    <xsl:attribute name="margin-left" select="concat($inner-margin,$unit)"/>
    <xsl:attribute name="margin-right" select="concat($outer-margin,$unit)"/>
    <xsl:attribute name="font-size">13pt</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:template>
  <xsl:template name="header-even-first-line-styles">
    <xsl:attribute name="margin-left" select="concat($outer-margin,$unit)"/>
    <xsl:attribute name="margin-right" select="concat($inner-margin,$unit)"/>
    <xsl:attribute name="height">8mm</xsl:attribute>
    <xsl:attribute name="margin-top">
      <xsl:choose>
        <xsl:when test="$paper-format='A4'">16mm</xsl:when>
        <xsl:otherwise>10mm</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="padding-left">2mm</xsl:attribute>
    <xsl:attribute name="padding-right">2mm</xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="space-after">2mm</xsl:attribute>
    <xsl:if test="$look-and-feel='fashion'">
      <xsl:attribute name="color" select="$option_color3"/>
    </xsl:if>
  </xsl:template>
  <xsl:template name="header-even-second-line-styles">
    <xsl:attribute name="background-color">
      <xsl:choose>
        <xsl:when test="$look-and-feel='fashion'">
          <xsl:value-of select="$option_color1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$color-black-10"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="padding-left">2mm</xsl:attribute>
    <xsl:attribute name="padding-right">2mm</xsl:attribute>
    <xsl:attribute name="height">8mm</xsl:attribute>
    <xsl:attribute name="padding-top">1mm</xsl:attribute>
    <xsl:attribute name="margin-left" select="concat($outer-margin,$unit)"/>
    <xsl:attribute name="margin-right" select="concat($inner-margin,$unit)"/>
    <xsl:attribute name="font-size">13pt</xsl:attribute>
  </xsl:template>
  <xsl:template name="footer-odd-styles">
    <xsl:attribute name="text-align">right</xsl:attribute>
    <xsl:attribute name="margin-left" select="concat($inner-margin,$unit)"/>
    <xsl:attribute name="margin-right" select="concat($outer-margin,$unit)"/>
    <xsl:attribute name="margin-bottom">
      <xsl:choose>
        <xsl:when test="$paper-format='A4'">
          <xsl:value-of select="concat($option_bottom_margin_A4,'mm')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($option_bottom_margin_A5,'mm')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="footer-even-styles">
    <xsl:attribute name="margin-left" select="concat($outer-margin,$unit)"/>
    <xsl:attribute name="margin-right" select="concat($inner-margin,$unit)"/>
    <xsl:attribute name="margin-bottom">
      <xsl:choose>
        <xsl:when test="$paper-format='A4'">
          <xsl:value-of select="concat($option_bottom_margin_A4,'mm')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($option_bottom_margin_A5,'mm')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="blank-page-content-styles">
    <xsl:attribute name="width">150mm</xsl:attribute>
    <xsl:attribute name="left" select="concat(($page-width div 2)-75,$unit)"/>
    <xsl:attribute name="position">fixed</xsl:attribute>
    <xsl:attribute name="top" select="concat(($page-height div 2)-10,$unit)"/>
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="font-size">16pt</xsl:attribute>
    <xsl:attribute name="line-height">110%</xsl:attribute>
  </xsl:template>
  <xsl:template name="region-body-multicol-backcover-odd-page-styles">
    <xsl:attribute name="margin-left" select="concat($inner-margin-backcover,$unit)"/>
    <xsl:attribute name="margin-right" select="concat($outer-margin-backcover,$unit)"/>
    <xsl:attribute name="margin-top" select="concat($top-margin-backcover,$unit)"/>
    <xsl:attribute name="margin-bottom" select="concat($bottom-margin-backcover,$unit)"/>
    <xsl:attribute name="column-count" select="$backcover-column-count"/>
    <xsl:attribute name="column-gap" select="$backcover-column-gap"/>
  </xsl:template>
  <xsl:template name="region-body-multicol-backcover-even-page-styles">
    <xsl:attribute name="margin-left" select="concat($outer-margin-backcover,$unit)"/>
    <xsl:attribute name="margin-right" select="concat($inner-margin-backcover,$unit)"/>
    <xsl:attribute name="margin-top" select="concat($top-margin-backcover,$unit)"/>
    <xsl:attribute name="margin-bottom" select="concat($bottom-margin-backcover,$unit)"/>
    <xsl:attribute name="column-count" select="$backcover-column-count"/>
    <xsl:attribute name="column-gap" select="$backcover-column-gap"/>
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
    <xsl:if test="preceding-sibling::*[not(self::title)]">
      <xsl:attribute name="space-before">
        <xsl:choose>
          <xsl:when test="@ismodule='yes'">
            <xsl:value-of select="$module-between-space"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$look-and-feel='fashion' and $format='book' and not(ancestor::chapter)">0pt</xsl:when>
              <xsl:when test="$look-and-feel='fashion' and $format='book' and ancestor::chapter">8pt</xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$section-between-space"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  <xsl:template name="additional-section-title-styles"/>
  <xsl:template name="section-title-styles">
    <xsl:param name="section-level"/>
    <xsl:attribute name="keep-with-next">always</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:choose>
        <xsl:when test="$section-level=1">
          <xsl:value-of select="$section-title-level1-font-size"/>
        </xsl:when>
        <xsl:when test="$section-level=2">
          <xsl:value-of select="$section-title-level2-font-size"/>
        </xsl:when>
        <xsl:when test="$section-level=3">
          <xsl:value-of select="$section-title-level3-font-size"/>
        </xsl:when>
        <xsl:when test="$section-level=4">
          <xsl:value-of select="$section-title-level4-font-size"/>
        </xsl:when>
        <xsl:when test="$section-level=5">
          <xsl:value-of select="$section-title-level5-font-size"/>
        </xsl:when>
        <xsl:when test="$section-level=6">
          <xsl:value-of select="$section-title-level6-font-size"/>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>
    <xsl:if test="$section-level!=6">
      <xsl:attribute name="provisional-distance-between-starts">
        <xsl:choose>
          <xsl:when test="$section-level=1">
            <xsl:call-template name="get-section-title-level1-text-indent"/>
          </xsl:when>
          <xsl:when test="$section-level=2">
            <xsl:call-template name="get-section-title-level2-text-indent"/>
          </xsl:when>
          <xsl:when test="$section-level=3">
            <xsl:call-template name="get-section-title-level3-text-indent"/>
          </xsl:when>
          <xsl:when test="$section-level=4">
            <xsl:call-template name="get-section-title-level4-text-indent"/>
          </xsl:when>
          <xsl:when test="$section-level=5">
            <xsl:call-template name="get-section-title-level5-text-indent"/>
          </xsl:when>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
    <xsl:attribute name="space-after">
      <xsl:choose>
        <xsl:when test="$section-level=1 and not($format='book')">
          <xsl:value-of select="$section-between-space"/>
        </xsl:when>
        <xsl:when test="$section-level=1">
          <xsl:call-template name="get-section-title-level1-space-after"/>
        </xsl:when>
        <xsl:when test="$section-level=2">
          <xsl:call-template name="get-section-title-level2-space-after"/>
        </xsl:when>
        <xsl:when test="$section-level=3">
          <xsl:call-template name="get-section-title-level3-space-after"/>
        </xsl:when>
        <xsl:when test="$section-level=4">
          <xsl:call-template name="get-section-title-level4-space-after"/>
        </xsl:when>
        <xsl:when test="$section-level=5">
          <xsl:call-template name="get-section-title-level5-space-after"/>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:if test="$look-and-feel='fashion'">
      <xsl:attribute name="color" select="$option_color4"/>
    </xsl:if>
    <xsl:if test="$position-of-chapter-title='column' and not(self::appendix or self::index or self::toc)">
      <xsl:attribute name="start-indent" select="concat($margin-width, $unit)"/>
    </xsl:if>
    <xsl:attribute name="line-height">140%</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:if test="self::appendix">
      <xsl:variable name="top-offset" select="($page-height - $top-margin - $bottom-margin) div 2 - 10"/>
      <xsl:variable name="left-offset" select="($page-width - $inner-margin - $outer-margin) div 2 - 30"/>
      <xsl:attribute name="margin-top" select="concat($top-offset,'mm')"/>
      <xsl:attribute name="margin-left" select="concat($left-offset,'mm')"/>
      <xsl:attribute name="font-size">36pt</xsl:attribute>
    </xsl:if>
    <xsl:call-template name="additional-section-title-styles"/>
  </xsl:template>
  <xsl:template name="toc-styles">
    <xsl:param name="chapter-toc">no</xsl:param>
    <xsl:variable name="section-level">
      <xsl:call-template name="get-section-level"/>
    </xsl:variable>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$default-font-size"/>
    </xsl:attribute>
    <xsl:attribute name="line-height">120%</xsl:attribute>
    <xsl:attribute name="font-weight">
      <xsl:choose>
        <xsl:when test="$section-level=1">bold</xsl:when>
        <xsl:otherwise>normal</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:if test="not($chapter-toc='yes')">
      <xsl:attribute name="start-indent">0mm</xsl:attribute>
      <xsl:attribute name="last-line-end-indent">-10mm</xsl:attribute>
      <xsl:attribute name="end-indent">10mm</xsl:attribute>
      <xsl:attribute name="text-align-last">justify</xsl:attribute>
      <xsl:attribute name="hyphenate">false</xsl:attribute>
    </xsl:if>
    <xsl:if test="$chapter-toc='yes' and $section-level=4">
      <xsl:attribute name="color" select="$option_color3"/>
    </xsl:if>
    <xsl:variable name="preceding-sibling-section-level">
      <xsl:call-template name="get-section-level"/>
    </xsl:variable>
    <xsl:if test="$preceding-sibling-section-level = 1 and $section-level = 2">
      <xsl:attribute name="keep-with-previous">always</xsl:attribute>
    </xsl:if>
    <xsl:if test="$preceding-sibling-section-level = 2 and $section-level = 3">
      <xsl:attribute name="keep-with-previous">always</xsl:attribute>
    </xsl:if>
    <xsl:if test="position()=last()">
      <xsl:attribute name="keep-with-previous">always</xsl:attribute>
    </xsl:if>
    <xsl:if test="position()=last()-1">
      <xsl:attribute name="keep-with-previous">always</xsl:attribute>
    </xsl:if>
    <xsl:attribute name="space-before">
      <xsl:choose>
        <xsl:when test="$section-level &gt; 1">
          <xsl:call-template name="get-toc-entry-space-level-2"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="get-toc-entry-space-level-1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="toc-leader-styles">
    <xsl:attribute name="leader-pattern">dots</xsl:attribute>
    <xsl:attribute name="leader-pattern-width">2mm</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="leader-length.optimum">0pt</xsl:attribute>
    <xsl:attribute name="keep-with-previous">always</xsl:attribute>
    <xsl:attribute name="keep-with-next">always</xsl:attribute>
    <xsl:attribute name="padding-left">2mm</xsl:attribute>
    <xsl:attribute name="padding-right">2mm</xsl:attribute>
  </xsl:template>
  <xsl:template name="toc-page-number-styles">
    <xsl:attribute name="keep-with-previous">always</xsl:attribute>
    <xsl:attribute name="ref-id" select="generate-id()"/>
  </xsl:template>
  <xsl:template name="toc-title-styles">
    <xsl:attribute name="space-after">10mm</xsl:attribute>
  </xsl:template>
  <xsl:template name="odd-header-logo-styles">
    <xsl:attribute name="position">fixed</xsl:attribute>
    <xsl:attribute name="top" select="$logo_small_odd_top"/>
    <xsl:attribute name="left">
      <xsl:value-of select="concat($outer-margin + 12, 'mm')"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="even-header-logo-styles">
    <xsl:attribute name="position">fixed</xsl:attribute>
    <xsl:attribute name="top" select="$logo_small_even_top"/>
    <xsl:attribute name="right">
      <xsl:value-of select="concat($inner-margin + 2,'mm')"/>
    </xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:template>
  <xsl:template name="group-label-styles">
    <xsl:attribute name="font-family">inherit</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:choose>
        <xsl:when test="$paper-format='A5'">9pt</xsl:when>
        <xsl:otherwise>13pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="line-height">110%</xsl:attribute>
    <xsl:attribute name="space-before">
      <xsl:choose>
        <xsl:when test="$paper-format='A5'">8pt</xsl:when>
        <xsl:otherwise>10pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="keep-with-next">always</xsl:attribute>
    <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
    <xsl:attribute name="space-after">
      <xsl:choose>
        <xsl:when test="$paper-format='A5'">3pt</xsl:when>
        <xsl:otherwise>6pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="first-styles">
    <xsl:attribute name="font-family">inherit</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:choose>
        <xsl:when test="$paper-format='A5'">8pt</xsl:when>
        <xsl:otherwise>11pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="line-height">110%</xsl:attribute>
    <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
    <xsl:attribute name="end-indent">6mm</xsl:attribute>
    <xsl:attribute name="last-line-end-indent">-6mm</xsl:attribute>
    <xsl:attribute name="space-after">4pt</xsl:attribute>
  </xsl:template>
  <xsl:template name="second-styles">
    <xsl:attribute name="font-family">inherit</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="text-align-last">justify</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:choose>
        <xsl:when test="$paper-format='A5'">8pt</xsl:when>
        <xsl:otherwise>11pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="line-height">110%</xsl:attribute>
    <xsl:attribute name="margin-left">5mm</xsl:attribute>
    <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
    <xsl:attribute name="end-indent">6mm</xsl:attribute>
    <xsl:attribute name="last-line-end-indent">-6mm</xsl:attribute>
    <xsl:attribute name="space-after">4pt</xsl:attribute>
  </xsl:template>
  <xsl:template name="index-content-styles"/>
  <xsl:template name="leader-styles">
    <xsl:attribute name="leader-pattern">dots</xsl:attribute>
    <xsl:attribute name="leader-length.maximum">100%</xsl:attribute>
    <xsl:attribute name="leader-length.optimum">0.5mm</xsl:attribute>
    <xsl:attribute name="leader-pattern-width">2mm</xsl:attribute>
    <xsl:attribute name="font-style">normal</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="padding-left">1mm</xsl:attribute>
    <xsl:attribute name="padding-right">1mm</xsl:attribute>
  </xsl:template>
  <xsl:template name="set-toc-entry-number-indent">
    <xsl:param name="chapter-toc">no</xsl:param>
    <xsl:variable name="section-level">
      <xsl:call-template name="get-section-level"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$chapter-toc='yes'">
        <xsl:attribute name="start-indent">
          <xsl:choose>
            <xsl:when test="$section-level=1">0mm</xsl:when>
            <xsl:when test="$section-level=2">0mm</xsl:when>
            <xsl:when test="$section-level=3">8mm</xsl:when>
            <xsl:when test="$section-level=4">8mm</xsl:when>
            <xsl:when test="$section-level=5">8mm</xsl:when>
            <xsl:when test="$section-level=5">8mm</xsl:when>
            <xsl:otherwise>0mm</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="start-indent">
          <xsl:choose>
            <xsl:when test="$section-level=1">0mm</xsl:when>
            <xsl:when test="$section-level=2">5mm</xsl:when>
            <xsl:when test="$section-level=3">13mm</xsl:when>
            <xsl:when test="$section-level=4">13mm</xsl:when>
            <xsl:when test="$section-level=5">13mm</xsl:when>
            <xsl:when test="$section-level=6">13mm</xsl:when>
            <xsl:otherwise>0mm</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="set-toc-entry-text-indent">
    <xsl:param name="chapter-toc">no</xsl:param>
    <xsl:variable name="section-level">
      <xsl:call-template name="get-section-level"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$chapter-toc='yes'">
        <xsl:attribute name="start-indent">
          <xsl:choose>
            <xsl:when test="not($format='book') and $section-level=1">0mm</xsl:when>
            <xsl:when test="not($format='book') and $section-level&gt;1">5mm</xsl:when>
            <xsl:when test="$section-level=1">0mm</xsl:when>
            <xsl:when test="$section-level=2">8mm</xsl:when>
            <xsl:when test="$section-level=3">19mm</xsl:when>
            <xsl:when test="$section-level=4">19mm</xsl:when>
            <xsl:when test="$section-level=5">19mm</xsl:when>
            <xsl:when test="$section-level=6">19mm</xsl:when>
            <xsl:otherwise>21mm</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="start-indent">
          <xsl:choose>
            <xsl:when test="not($format='book') and $section-level=1">0mm</xsl:when>
            <xsl:when test="not($format='book') and $section-level&gt;1">5mm</xsl:when>
            <xsl:when test="$section-level=1">5mm</xsl:when>
            <xsl:when test="$section-level=2">13mm</xsl:when>
            <xsl:when test="$section-level=3">24mm</xsl:when>
            <xsl:when test="$section-level=4">27mm</xsl:when>
            <xsl:when test="$section-level=5">27mm</xsl:when>
            <xsl:when test="$section-level=6">27mm</xsl:when>
            <xsl:otherwise>21mm</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-toc-entry-space-level-1">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">4pt</xsl:when>
      <xsl:when test="$spaces='small'">8pt</xsl:when>
      <xsl:otherwise>8pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-toc-entry-space-level-2">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">2pt</xsl:when>
      <xsl:when test="$spaces='small'">4pt</xsl:when>
      <xsl:otherwise>4pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-between-space">
    <xsl:choose>
      <xsl:when test="$layout='rtf'">8pt</xsl:when>
      <xsl:when test="$layout='columns' and $paper-format='A5'">24pt</xsl:when>
      <xsl:when test="$spaces='small'">18pt</xsl:when>
      <xsl:otherwise>28pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-module-between-space">
    <xsl:choose>
      <xsl:when test="$layout='rtf'">6pt</xsl:when>
      <xsl:when test="$layout='columns' and $paper-format='A5'">8pt</xsl:when>
      <xsl:when test="$spaces='small'">9pt</xsl:when>
      <xsl:otherwise>12pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title-level1-font-size">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">
        <xsl:value-of select="concat($headline_font_size_A5_level_1,'pt')"/>
      </xsl:when>
      <xsl:when test="$spaces='small'">
        <xsl:value-of select="concat(string(number($headline_font_size_A4_level_1) - 1),'pt')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($headline_font_size_A4_level_1,'pt')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title-level2-font-size">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">
        <xsl:value-of select="concat($headline_font_size_A5_level_2,'pt')"/>
      </xsl:when>
      <xsl:when test="$spaces='small'">
        <xsl:value-of select="concat(string(number($headline_font_size_A4_level_2) - 1),'pt')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($headline_font_size_A4_level_2,'pt')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title-level3-font-size">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">
        <xsl:value-of select="concat($headline_font_size_A5_level_3,'pt')"/>
      </xsl:when>
      <xsl:when test="$spaces='small'">
        <xsl:value-of select="concat(string(number($headline_font_size_A4_level_3) - 1),'pt')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($headline_font_size_A4_level_3,'pt')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title-level4-font-size">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">
        <xsl:value-of select="concat($headline_font_size_A5_level_4,'pt')"/>
      </xsl:when>
      <xsl:when test="$spaces='small'">
        <xsl:value-of select="concat(string(number($headline_font_size_A4_level_4) - 1),'pt')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($headline_font_size_A4_level_4,'pt')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title-level5-font-size">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">
        <xsl:value-of select="concat($headline_font_size_A5_level_5,'pt')"/>
      </xsl:when>
      <xsl:when test="$spaces='small'">
        <xsl:value-of select="concat(string(number($headline_font_size_A4_level_5) - 1),'pt')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($headline_font_size_A4_level_5,'pt')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title-level6-font-size">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">9pt</xsl:when>
      <xsl:when test="$spaces='small'">10pt</xsl:when>
      <xsl:otherwise>11pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title-level5-text-indent">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">12mm</xsl:when>
      <xsl:when test="$spaces='small'">14mm</xsl:when>
      <xsl:otherwise>18mm</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title-level4-text-indent">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">10mm</xsl:when>
      <xsl:when test="$spaces='small'">15mm</xsl:when>
      <xsl:otherwise>15mm</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title-level3-text-indent">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">10mm</xsl:when>
      <xsl:when test="$spaces='small'">15mm</xsl:when>
      <xsl:otherwise>15mm</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title-level2-text-indent">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">8mm</xsl:when>
      <xsl:when test="$spaces='small'">9mm</xsl:when>
      <xsl:otherwise>10mm</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title-level1-text-indent">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">9mm</xsl:when>
      <xsl:when test="$spaces='small'">10mm</xsl:when>
      <xsl:otherwise>12mm</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title-level5-space-after">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">9pt</xsl:when>
      <xsl:when test="$spaces='small'">10pt</xsl:when>
      <xsl:otherwise>18pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title-level4-space-after">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">9pt</xsl:when>
      <xsl:when test="$spaces='small'">10pt</xsl:when>
      <xsl:otherwise>18pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title-level3-space-after">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">9pt</xsl:when>
      <xsl:when test="$spaces='small'">10pt</xsl:when>
      <xsl:otherwise>18pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title-level2-space-after">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">9pt</xsl:when>
      <xsl:when test="$spaces='small'">10pt</xsl:when>
      <xsl:otherwise>18pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title-level1-space-after">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">24pt</xsl:when>
      <xsl:when test="$spaces='small'">28pt</xsl:when>
      <xsl:otherwise>32pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-outer-margin-backcover">18</xsl:template>
  <xsl:template name="get-inner-margin-backcover">18</xsl:template>
  <xsl:template name="get-top-margin-backcover">
    <xsl:choose>
      <xsl:when test="$paper-format='A5'">75</xsl:when>
      <xsl:otherwise>107</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-bottom-margin-backcover">
    <xsl:choose>
      <xsl:when test="$paper-format='A5'">75</xsl:when>
      <xsl:otherwise>107</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-backcover-column-count">3</xsl:template>
  <xsl:template name="get-backcover-column-gap">2.5mm</xsl:template>
  <xsl:template name="get-supplemental-directives-space-before">
    <xsl:choose>
      <xsl:when test="$paper-format='A5'">0pt</xsl:when>
      <xsl:otherwise>275pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-fig-space-after">
    <xsl:choose>
      <xsl:when test="$spaces='small'">4pt</xsl:when>
      <xsl:otherwise>6pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-fig-space-before">
    <xsl:choose>
      <xsl:when test="$spaces='small'">8pt</xsl:when>
      <xsl:otherwise>12pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-subtitle-space-after">
    <xsl:choose>
      <xsl:when test="$spaces='small'">8pt</xsl:when>
      <xsl:otherwise>12pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-default-font-size">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">8pt</xsl:when>
      <xsl:when test="$spaces='small'">9pt</xsl:when>
      <xsl:otherwise>10pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-default-line-height">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">120%</xsl:when>
      <xsl:when test="$spaces='small'">130%</xsl:when>
      <xsl:otherwise>140%</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-ul-space-after">
    <xsl:choose>
      <xsl:when test="$spaces='small'">4pt</xsl:when>
      <xsl:otherwise>6pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-ul-space-before">
    <xsl:choose>
      <xsl:when test="$spaces='small'">8pt</xsl:when>
      <xsl:otherwise>12pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-table-space-after">
    <xsl:choose>
      <xsl:when test="$spaces='small'">8pt</xsl:when>
      <xsl:otherwise>12pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-table-title-space-after">
    <xsl:choose>
      <xsl:when test="$spaces='small'">4pt</xsl:when>
      <xsl:otherwise>6pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-block-title-font-size">
    <xsl:choose>
      <xsl:when test="$layout='columns' and $paper-format='A5'">9pt</xsl:when>
      <xsl:otherwise>11pt</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-supplemental-directives-space-before-A4-twocol">140mm</xsl:template>
  <xsl:template name="get-page-width">
    <xsl:choose>
      <xsl:when test="$paper-format='A4'">
        <xsl:value-of select="$A4-WIDTH"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$A5-WIDTH"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-page-height">
    <xsl:choose>
      <xsl:when test="$paper-format='A4'">
        <xsl:value-of select="$A4-HEIGHT"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$A5-HEIGHT"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-position-of-block-title">
    <xsl:choose>
      <xsl:when test="$layout='rtf'">column</xsl:when>
      <xsl:when test="$layout='columns' or $paper-format='A5'">main</xsl:when>
      <xsl:when test="$paper-format='A4'">margin</xsl:when>
      <xsl:otherwise>column</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-position-of-chapter-title">
    <xsl:choose>
      <xsl:when test="$layout='rtf'">main</xsl:when>
      <xsl:when test="$paper-format='A4' and $layout='columns'">main</xsl:when>
      <xsl:when test="$paper-format='A4'">main</xsl:when>
      <xsl:otherwise>column</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-margin-right-padding">
    <xsl:choose>
      <xsl:when test="$layout='rtf'">0mm</xsl:when>
      <xsl:when test="$paper-format='A4' and not($layout='columns')">10mm</xsl:when>
      <xsl:otherwise>2mm</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-inner-margin">
    <xsl:choose>
      <xsl:when test="//meta/design/page-margin='leftgap'">
        <xsl:choose>
          <xsl:when test="$paper-format='A4'">
            <xsl:value-of select="$option_inner_margin_A4_leftgap"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$option_inner_margin_A5_leftgap"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$option_inner_outer_margin_A4_A5"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-outer-margin">
    <xsl:choose>
      <xsl:when test="//meta/design/page-margin='leftgap'">
        <xsl:choose>
          <xsl:when test="$paper-format='A4'">
            <xsl:value-of select="$option_outer_margin_A4_leftgap"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$option_outer_margin_A5_leftgap"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$option_inner_outer_margin_A4_A5"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-margin-width">
    <xsl:choose>
      <xsl:when test="$layout='rtf'">0</xsl:when>
      <xsl:when test="$paper-format='A4'">
        <xsl:value-of select="$option_margin_width_A4"/>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-top-margin">
    <xsl:choose>
      <xsl:when test="$layout='rtf'">20</xsl:when>
      <xsl:when test="$paper-format='A4'">
        <xsl:value-of select="$option_top_margin_A4"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$option_top_margin_A5"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-bottom-margin">
    <xsl:choose>
      <xsl:when test="$layout='rtf'">20</xsl:when>
      <xsl:when test="$paper-format='A4'">
        <xsl:value-of select="$option_bottom_margin_A4"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$option_bottom_margin_A5"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-column-width">
    <xsl:variable name="pw">
      <xsl:call-template name="get-page-width"/>
    </xsl:variable>
    <xsl:variable name="im">
      <xsl:call-template name="get-inner-margin"/>
    </xsl:variable>
    <xsl:variable name="om">
      <xsl:call-template name="get-outer-margin"/>
    </xsl:variable>
    <xsl:variable name="mw">
      <xsl:call-template name="get-margin-width"/>
    </xsl:variable>
    <xsl:value-of select="number($pw) - (number($im) + number($om) + number($mw))"/>
  </xsl:template>
  <xsl:template name="get-default-font-family">
    <xsl:value-of select="if (normalize-space($option_default_font_family) != '') then $option_default_font_family else 'Noto Sans Regular, Noto Sans Symbols, DejaVu Sans'"/>
  </xsl:template>
  <xsl:template name="get-block-space-after">6pt</xsl:template>
  <xsl:template name="get-p-space-after">6pt</xsl:template>
  <xsl:template name="get-ul-title-space-after">12pt</xsl:template>
  <xsl:template name="get-ul-listitem-space-after">4pt</xsl:template>
  <xsl:template name="get-img-space-after">6pt</xsl:template>
  <xsl:template name="get-hint-space-after">6pt</xsl:template>
  <xsl:template name="get-hint-title-space-after">6pt</xsl:template>
  <xsl:template name="get-table-layout-set">
    <xsl:attribute name="layoutset">table_evaluation</xsl:attribute>
  </xsl:template>
  <xsl:template name="get-table-padding">2mm</xsl:template>
  <xsl:template name="get-table-default-border-thickness">2.25pt</xsl:template>
  <xsl:template name="get-table-evaluation-border-thickness">1pt</xsl:template>
  <xsl:template name="get-table-cell-background-optional">#fff</xsl:template>
  <xsl:template name="get-table-cell-background-optional-2">
    <xsl:value-of select="$color-black-10"/>
  </xsl:template>
  <xsl:template name="get-table-cell-background-optional-3">
    <xsl:value-of select="$color-black-10"/>
  </xsl:template>
  <xsl:template name="get-toc-start-indent">7.5mm</xsl:template>
  <xsl:template name="get-toc-text-level1-start-indent">7.5mm</xsl:template>
  <xsl:template name="get-toc-text-level2-start-indent">14.5mm</xsl:template>
  <xsl:template name="get-toc-text-level3-start-indent">17.5mm</xsl:template>
  <xsl:template name="get-toc-text-level4-start-indent">20mm</xsl:template>
  <xsl:template name="keep-rules-list-item1">
    <xsl:variable name="this-li">
      <xsl:number count="li" from="ul"/>
    </xsl:variable>
    <xsl:variable name="last-li" select="count(../li)"/>
    <xsl:choose>
      <!-- xsl:when test="number($this-li) = $last-li and preceding-sibling::li">
                <xsl:attribute name="keep-with-previous.within-page">15</xsl:attribute>
            </xsl:when-->
      <xsl:when test="number($this-li) = 1 and following-sibling::li">
        <!-- >xsl:attribute name="keep-with-next.within-page">15</xsl:attribute-->
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-subtitle-font-weight">bold</xsl:template>
  <xsl:template name="header-1-odd">
    <xsl:variable name="section-title">
      <xsl:call-template name="get-section-title"/>
    </xsl:variable>
    <xsl:variable name="section-number">
      <xsl:call-template name="get-section-number"/>
    </xsl:variable>
    <xsl:variable name="is-glossary-chapter" as="xs:boolean">
      <xsl:call-template name="chapter-is-glossary"/>
    </xsl:variable>
    <fo:table>
      <xsl:attribute name="margin-top">
        <xsl:choose>
          <xsl:when test="$paper-format='A4'">
            <xsl:value-of select="concat((number($option_top_margin_A4) - 30),'mm')"/>
          </xsl:when>
          <xsl:when test="$paper-format='A5'">
            <xsl:value-of select="concat((number($option_top_margin_A5) - 20),'mm')"/>
          </xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="margin-left">
        <xsl:choose>
          <xsl:when test="$page-margin='leftgap' and $paper-format='A4'">
            <xsl:value-of select="concat($option_inner_margin_A4_leftgap,'mm')"/>
          </xsl:when>
          <xsl:when test="$page-margin='leftgap' and $paper-format='A5'">
            <xsl:value-of select="concat($option_inner_margin_A5_leftgap,'mm')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($option_inner_outer_margin_A4_A5,'mm')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="not($look-and-feel='fashion')">
        <xsl:attribute name="color">black</xsl:attribute>
      </xsl:if>
      <fo:table-body>
        <fo:table-row>
          <xsl:if test="not($look-and-feel='fashion')">
            <xsl:attribute name="border-bottom">1pt black solid</xsl:attribute>
          </xsl:if>
          <fo:table-cell text-align="right" font-weight="bold">
            <xsl:if test="not($format='book') and not($look-and-feel='fashion')">
              <xsl:attribute name="display-align">after</xsl:attribute>
              <xsl:attribute name="padding-bottom">2mm</xsl:attribute>
            </xsl:if>
            <xsl:if test="not($look-and-feel='fashion') and $header='shortheader'">
              <xsl:attribute name="text-align">left</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="width">
              <xsl:choose>
                <xsl:when test="$format='book'">
                  <xsl:choose>
                    <xsl:when test="$paper-format='A5' and $page-margin='leftgap'">96mm</xsl:when>
                    <xsl:when test="$paper-format='A5'">86mm</xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="concat((210 - number($option_margin_width_A4) - number($option_outer_margin_A4_leftgap) - number($option_inner_margin_A4_leftgap)),'mm')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="$paper-format='A5' and $page-margin='leftgap'">121mm</xsl:when>
                    <xsl:when test="$paper-format='A5'">107mm</xsl:when>
                    <xsl:otherwise>160mm</xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="height">10mm</xsl:attribute>
            <xsl:attribute name="font-size">
              <xsl:choose>
                <xsl:when test="$paper-format='A5'">11pt</xsl:when>
                <xsl:otherwise>13pt</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:if test="$look-and-feel='fashion'">
              <xsl:attribute name="color" select="$option_color3"/>
              <xsl:attribute name="background-color" select="$option_color2"/>
              <xsl:attribute name="display-align">center</xsl:attribute>
              <xsl:attribute name="padding-right">6.5mm</xsl:attribute>
              <xsl:attribute name="height">
                <xsl:choose>
                  <xsl:when test="$paper-format='A5'">10mm</xsl:when>
                  <xsl:otherwise>16mm</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="start-indent">0mm</xsl:attribute>
            <fo:block>
              <xsl:if test="not($look-and-feel='fashion') and $format='book'">
                <xsl:attribute name="padding-bottom">3px</xsl:attribute>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="$format='book'">
                  <xsl:call-template name="get-section-title"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="/document/title"/>
                </xsl:otherwise>
              </xsl:choose>
            </fo:block>
          </fo:table-cell>
          <xsl:if test="$look-and-feel='fashion' and $format='book'">
            <fo:table-cell background-color="white" width="3mm">
              <fo:block/>
            </fo:table-cell>
          </xsl:if>
          <xsl:if test="$format='book'">
            <fo:table-cell text-align="right" font-weight="bold">
              <xsl:attribute name="width">
                <xsl:choose>
                  <xsl:when test="$paper-format='A5' and not($look-and-feel='fashion')">22mm</xsl:when>
                  <xsl:when test="$paper-format='A5'">18mm</xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat((number($option_margin_width_A4) - 3),'mm')"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:if test="$look-and-feel='fashion'">
                <xsl:attribute name="color">
                  <xsl:value-of select="$option_color3"/>
                </xsl:attribute>
                <xsl:attribute name="background-color" select="$option_color1"/>
                <xsl:attribute name="display-align">center</xsl:attribute>
                <xsl:attribute name="text-align">center</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="font-size">
                <xsl:choose>
                  <xsl:when test="$paper-format='A5'">18pt</xsl:when>
                  <xsl:otherwise>26pt</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <fo:block start-indent="0" padding-top="2mm">
                <xsl:choose>
                  <xsl:when test="self::toc">Toc</xsl:when>
                  <xsl:when test="self::index">Idx</xsl:when>
                  <xsl:when test="self::appendix">Apx</xsl:when>
                  <xsl:when test="self::figure-index">Fig</xsl:when>
                  <xsl:when test="self::footnote-index">Lit</xsl:when>
                  <xsl:when test="$is-glossary-chapter">Glo</xsl:when>
                  <xsl:when test="string-length($section-number)=0">
                    <xsl:value-of select="substring($section-title,1,1)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$section-number"/>
                  </xsl:otherwise>
                </xsl:choose>
              </fo:block>
            </fo:table-cell>
          </xsl:if>
        </fo:table-row>
        <xsl:if test="$look-and-feel='fashion' and $format='book' and self::chapter">
          <fo:table-row>
            <fo:table-cell text-align="left" number-columns-spanned="3">
              <fo:block margin-top="2mm" start-indent="0" color="#999">
                <xsl:call-template name="running-header"/>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:if>
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
    <xsl:variable name="is-glossary-chapter" as="xs:boolean">
      <xsl:call-template name="chapter-is-glossary"/>
    </xsl:variable>
    <fo:table>
      <xsl:attribute name="margin-top">
        <xsl:choose>
          <xsl:when test="$paper-format='A4'">
            <xsl:value-of select="concat((number($option_top_margin_A4) - 30),'mm')"/>
          </xsl:when>
          <xsl:when test="$paper-format='A5'">
            <xsl:value-of select="concat((number($option_top_margin_A5) - 20),'mm')"/>
          </xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="margin-left">
        <xsl:choose>
          <xsl:when test="$page-margin='leftgap' and $paper-format='A5'">
            <xsl:value-of select="concat($option_outer_margin_A5_leftgap,'mm')"/>
          </xsl:when>
          <xsl:when test="$page-margin='leftgap'">
            <xsl:value-of select="concat($option_outer_margin_A4_leftgap,'mm')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($option_inner_outer_margin_A4_A5,'mm')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="not($look-and-feel='fashion')">
        <xsl:attribute name="color">black</xsl:attribute>
      </xsl:if>
      <fo:table-body>
        <fo:table-row>
          <xsl:if test="not($look-and-feel='fashion')">
            <xsl:attribute name="border-bottom">1pt black solid</xsl:attribute>
          </xsl:if>
          <xsl:if test="$format='book'">
            <fo:table-cell text-align="left" font-weight="bold">
              <xsl:attribute name="font-size">
                <xsl:choose>
                  <xsl:when test="$paper-format='A5'">18pt</xsl:when>
                  <xsl:otherwise>26pt</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="width">
                <xsl:choose>
                  <xsl:when test="$paper-format='A5' and not($look-and-feel='fashion')">22mm</xsl:when>
                  <xsl:when test="$paper-format='A5'">18mm</xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat((number($option_margin_width_A4) - 3),'mm')"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:if test="$look-and-feel='fashion'">
                <xsl:attribute name="color" select="$option_color3"/>
                <xsl:attribute name="background-color" select="$option_color1"/>
                <xsl:attribute name="display-align">center</xsl:attribute>
                <xsl:attribute name="text-align">center</xsl:attribute>
              </xsl:if>
              <fo:block start-indent="0" padding-top="2mm">
                <xsl:choose>
                  <xsl:when test="self::toc">Toc</xsl:when>
                  <xsl:when test="self::index">Idx</xsl:when>
                  <xsl:when test="self::appendix">Apx</xsl:when>
                  <xsl:when test="self::figure-index">Fig</xsl:when>
                  <xsl:when test="self::footnote-index">Lit</xsl:when>
                  <xsl:when test="$is-glossary-chapter">Glo</xsl:when>
                  <xsl:when test="string-length($section-number)=0">
                    <xsl:value-of select="substring($section-title,1,1)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$section-number"/>
                  </xsl:otherwise>
                </xsl:choose>
              </fo:block>
            </fo:table-cell>
          </xsl:if>
          <xsl:if test="$look-and-feel='fashion' and $format='book'">
            <fo:table-cell background-color="white" width="3mm">
              <fo:block/>
            </fo:table-cell>
          </xsl:if>
          <fo:table-cell font-size="13pt" start-indent="0mm" font-weight="bold">
            <xsl:if test="not($format='book') and not($look-and-feel='fashion')">
              <xsl:attribute name="display-align">after</xsl:attribute>
              <xsl:attribute name="padding-bottom">2mm</xsl:attribute>
            </xsl:if>
            <xsl:if test="not($look-and-feel='fashion') and $header='shortheader'">
              <xsl:choose>
                <xsl:when test="$layout='columns'">
                  <xsl:attribute name="text-align">left</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="text-align">right</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:attribute name="width">
              <xsl:choose>
                <xsl:when test="$format='book'">
                  <xsl:choose>
                    <xsl:when test="$paper-format='A5' and $page-margin='leftgap'">96mm</xsl:when>
                    <xsl:when test="$paper-format='A5'">86mm</xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="concat((210 - number($option_margin_width_A4) - number($option_outer_margin_A4_leftgap) - number($option_inner_margin_A4_leftgap)),'mm')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="$paper-format='A5' and $page-margin='leftgap'">121mm</xsl:when>
                    <xsl:when test="$paper-format='A5'">107mm</xsl:when>
                    <xsl:otherwise>160mm</xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="height">10mm</xsl:attribute>
            <xsl:attribute name="font-size">
              <xsl:choose>
                <xsl:when test="$paper-format='A5'">11pt</xsl:when>
                <xsl:otherwise>13pt</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:if test="$look-and-feel='fashion'">
              <xsl:attribute name="color" select="$option_color3"/>
              <xsl:attribute name="background-color" select="$option_color2"/>
              <xsl:attribute name="display-align">center</xsl:attribute>
              <xsl:attribute name="padding-left">6.5mm</xsl:attribute>
              <xsl:attribute name="height">
                <xsl:choose>
                  <xsl:when test="$paper-format='A5'">10mm</xsl:when>
                  <xsl:otherwise>16mm</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
            </xsl:if>
            <fo:block>
              <xsl:if test="not($look-and-feel='fashion') and $format='book'">
                <xsl:attribute name="padding-bottom">3px</xsl:attribute>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="$format='book'">
                  <xsl:call-template name="get-section-title"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="/document/title"/>
                </xsl:otherwise>
              </xsl:choose>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <xsl:if test="$look-and-feel='fashion' and $format='book' and self::chapter">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="3">
              <fo:block start-indent="0" text-align="left" margin-top="2mm" color="#999">
                <xsl:call-template name="running-header"/>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:if>
      </fo:table-body>
    </fo:table>
  </xsl:template>
  <xsl:template name="running-header">
    <fo:retrieve-marker retrieve-class-name="running-header" retrieve-boundary="page-sequence" retrieve-position="first-including-carryover"/>
  </xsl:template>
  <xsl:template name="odd-header">
    <xsl:choose>
      <xsl:when test="$layout='rtf'"/>
      <xsl:when test="$header='shortheader'">
        <xsl:call-template name="header-1-odd"/>
        <xsl:if test="not($layout='columns')">
          <xsl:call-template name="print-logo-in-header-odd"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="header-first-line-odd"/>
        <xsl:call-template name="header-second-line-odd"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="even-header">
    <xsl:choose>
      <xsl:when test="$layout='rtf'"/>
      <xsl:when test="$header='shortheader'">
        <xsl:call-template name="header-1-even"/>
        <xsl:if test="not($layout='columns')">
          <xsl:call-template name="print-logo-in-header-even"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="header-first-line-even"/>
        <xsl:call-template name="header-second-line-even"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="header-first-line-odd">
    <xsl:choose>
      <xsl:when test="$format='book'">
        <fo:block>
          <xsl:call-template name="header-odd-first-line-styles"/>
          <xsl:call-template name="get-section-title">
            <xsl:with-param name="position">subchapter</xsl:with-param>
          </xsl:call-template>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block>
          <xsl:call-template name="header-odd-first-line-styles"/>
          <xsl:apply-templates select="/document/meta/main-title"/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="header-second-line-odd">
    <xsl:choose>
      <xsl:when test="$format='book'">
        <fo:block>
          <xsl:call-template name="header-odd-second-line-styles"/>
          <xsl:call-template name="get-section-title">
            		</xsl:call-template>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block>
          <xsl:call-template name="header-odd-second-line-styles"/>
          <xsl:apply-templates select="/document/title"/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="header-first-line-even">
    <xsl:choose>
      <xsl:when test="$format='book'">
        <fo:block>
          <xsl:call-template name="header-even-first-line-styles"/>
          <xsl:call-template name="get-section-title">
            <xsl:with-param name="position">subchapter</xsl:with-param>
          </xsl:call-template>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block>
          <xsl:call-template name="header-odd-first-line-styles"/>
          <xsl:apply-templates select="/document/meta/main-title"/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="header-second-line-even">
    <xsl:choose>
      <xsl:when test="$format='book'">
        <fo:block>
          <xsl:call-template name="header-even-second-line-styles"/>
          <xsl:call-template name="get-section-title">
            		</xsl:call-template>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block>
          <xsl:call-template name="header-odd-second-line-styles"/>
          <xsl:apply-templates select="/document/title"/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="render-footer-page-number">
    
    </xsl:template>
  <xsl:template name="odd-footer">
    <fo:block>
      <xsl:call-template name="footer-odd-styles"/>
      <xsl:if test="$footer='shortfooter' and not($format='book')">
        <xsl:attribute name="text-align">center</xsl:attribute>
      </xsl:if>
      <xsl:if test="$paper-format='A5'">
        <xsl:attribute name="font-size">8pt</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="margin-top">
        <xsl:choose>
          <xsl:when test="$paper-format='A5'">2mm</xsl:when>
          <xsl:otherwise>-8mm</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$layout='rtf'"/>
        <xsl:when test="$footer='longfooter'  and $margins-changed='no'">
          <xsl:variable name="bcol" select="if ($look-and-feel='fashion') then $option_color3 else 'black'"/>
          <xsl:attribute name="border-top">
            <xsl:text>1pt </xsl:text>
            <xsl:value-of select="$bcol"/>
            <xsl:text> solid</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="padding-top">2mm</xsl:attribute>
          <fo:table table-layout="fixed">
            <xsl:attribute name="start-indent">
              <xsl:choose>
                <xsl:when test="$page-margin='leftgap' and $paper-format='A5'">20mm</xsl:when>
                <xsl:when test="$page-margin='leftgap'">25mm</xsl:when>
                <xsl:otherwise>20mm</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <fo:table-body>
              <fo:table-row>
                <fo:table-cell width="65mm" text-align="left">
                  <xsl:if test="$paper-format='A5'">
                    <xsl:attribute name="width">40mm</xsl:attribute>
                  </xsl:if>
                  <fo:block start-indent="0mm" end-indent="0mm">
                    <xsl:text>Version: </xsl:text>
                    <xsl:value-of select="$version"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell width="40mm" text-align="center">
                  <xsl:if test="$paper-format='A5'">
                    <xsl:attribute name="width">33mm</xsl:attribute>
                  </xsl:if>
                  <xsl:choose>
                    <xsl:when test="/descendant::cover-backpage">
                      <fo:block start-indent="0mm" end-indent="0mm">
                        <xsl:call-template name="boilerplate-lookup">
                          <xsl:with-param name="key">B_PAGE</xsl:with-param>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                        <fo:page-number/>
                        <xsl:if test="$format='book'">
                          <xsl:text> </xsl:text>
                          <xsl:text>(</xsl:text>
                          <fo:page-number-citation ref-id="EOF"/>
                          <xsl:text>)</xsl:text>
                        </xsl:if>
                      </fo:block>
                    </xsl:when>
                    <xsl:otherwise>
                      <fo:block>
                        <xsl:text>- </xsl:text>
                        <fo:page-number/>
                        <xsl:text> -</xsl:text>
                      </fo:block>
                    </xsl:otherwise>
                  </xsl:choose>
                </fo:table-cell>
                <fo:table-cell text-align="right">
                  <fo:block start-indent="0mm" end-indent="0mm">
                    <xsl:choose>
                      <xsl:when test="$header='shortheader'">
                        <xsl:apply-templates select=" if (normalize-space(/document/title)) then /document/title else /document/meta/main-title"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:apply-templates select="/descendant::meta/subtitle"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-body>
          </fo:table>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$format='book'">
              <xsl:call-template name="render-footer-page-number"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>- </xsl:text>
              <fo:page-number/>
              <xsl:text> -</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>
  <xsl:template name="even-footer">
    <fo:block>
      <xsl:call-template name="footer-even-styles"/>
      <xsl:if test="$footer='shortfooter' and not($format='book')">
        <xsl:attribute name="text-align">center</xsl:attribute>
      </xsl:if>
      <xsl:if test="$paper-format='A5'">
        <xsl:attribute name="font-size">8pt</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="margin-top">
        <xsl:choose>
          <xsl:when test="$paper-format='A5'">2mm</xsl:when>
          <xsl:otherwise>-8mm</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$layout='rtf'"/>
        <xsl:when test="$footer='longfooter' and $margins-changed='no'">
          <xsl:variable name="bcol" select="if ($look-and-feel='fashion') then $option_color3 else 'black'"/>
          <xsl:attribute name="border-top">
            <xsl:text>1pt </xsl:text>
            <xsl:value-of select="$bcol"/>
            <xsl:text> solid</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="padding-top">2mm</xsl:attribute>
          <fo:table table-layout="fixed">
            <xsl:attribute name="start-indent">
              <xsl:choose>
                <xsl:when test="$page-margin='leftgap' and $paper-format='A5'">
                  <xsl:value-of select="concat($option_outer_margin_A5_leftgap,'mm')"/>
                </xsl:when>
                <xsl:when test="$page-margin='leftgap'">
                  <xsl:value-of select="concat($option_outer_margin_A4_leftgap,'mm')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat($option_inner_margin_A5_leftgap,'mm')"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <fo:table-body>
              <fo:table-row>
                <fo:table-cell width="65mm" text-align="left">
                  <xsl:if test="$paper-format='A5'">
                    <xsl:attribute name="width">40mm</xsl:attribute>
                  </xsl:if>
                  <fo:block start-indent="0mm" end-indent="0mm">
                    <xsl:choose>
                      <xsl:when test="$header='shortheader'">
                        <xsl:apply-templates select="if (normalize-space(/document/title)) then /document/title else /document/meta/main-title"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:apply-templates select="/descendant::meta/subtitle"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell width="40mm" text-align="center">
                  <xsl:if test="$paper-format='A5'">
                    <xsl:attribute name="width">33mm</xsl:attribute>
                  </xsl:if>
                  <xsl:choose>
                    <xsl:when test="/descendant::cover-backpage">
                      <fo:block start-indent="0mm" end-indent="0mm">
                        <xsl:call-template name="boilerplate-lookup">
                          <xsl:with-param name="key">B_PAGE</xsl:with-param>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                        <fo:page-number/>
                        <xsl:if test="$format='book'">
                          <xsl:text> </xsl:text>
                          <xsl:text>(</xsl:text>
                          <fo:page-number-citation ref-id="EOF"/>
                          <xsl:text>)</xsl:text>
                        </xsl:if>
                      </fo:block>
                    </xsl:when>
                    <xsl:otherwise>
                      <fo:block>
                        <xsl:text>- </xsl:text>
                        <fo:page-number/>
                        <xsl:text> -</xsl:text>
                      </fo:block>
                    </xsl:otherwise>
                  </xsl:choose>
                </fo:table-cell>
                <fo:table-cell text-align="right">
                  <fo:block start-indent="0mm" end-indent="0mm">
                    <xsl:text>Version: </xsl:text>
                    <xsl:value-of select="$version"/>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-body>
          </fo:table>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$format='book'">
              <xsl:call-template name="render-footer-page-number"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>- </xsl:text>
              <fo:page-number/>
              <xsl:text> -</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>
  <xsl:template name="p">
    <xsl:attribute name="space-after">
      <xsl:value-of select="$p-space-after"/>
    </xsl:attribute>
    <xsl:if test="descendant::nb">
      <xsl:attribute name="hyphenate">false</xsl:attribute>
    </xsl:if>
    <xsl:if test="ancestor::*[self::danger or self::warning] and not(parent::li)">
      <xsl:attribute name="margin-bottom">
        <xsl:value-of select="$p-space-after"/>
      </xsl:attribute>
      <xsl:attribute name="margin-top">
        <xsl:value-of select="$p-space-after"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  <xsl:attribute-set name="figure">
    <xsl:attribute name="start-indent">0mm</xsl:attribute>
    <xsl:attribute name="space-after.conditionality">discard</xsl:attribute>
    <xsl:attribute name="margin-bottom" select="$fig-space-after"/>
    <xsl:attribute name="margin-top" select="$fig-space-before"/>
    <xsl:attribute name="keep-together.within-page">7</xsl:attribute>
  </xsl:attribute-set>
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
  </xsl:attribute-set>
  <xsl:attribute-set name="figure.img">
    <xsl:attribute name="src" select="if ($docker='no') then @src else concat('/teditor/',@src)"/>
    <xsl:attribute name="content-height" select="@height"/>
    <xsl:attribute name="content-width">
      <xsl:choose>
        <xsl:when test="../@pdfwidth='margin' and $layout='columns'">auto</xsl:when>
        <xsl:when test="$page-margin='leftright' and $paper-format='A5' and $layout='columns'">51mm</xsl:when>
        <xsl:when test="$page-margin='leftgap' and $paper-format='A5' and $layout='columns'">55mm</xsl:when>
        <xsl:when test="$paper-format='A4' and $layout='columns'">82mm</xsl:when>
        <xsl:when test="$paper-format='A4' and ../@pdfwidth='page' and ends-with(@src,'.svg') and not(contains(@src,'schematron'))">150mm</xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="string-length(@width)&gt;0">
              <xsl:value-of select="@width"/>
            </xsl:when>
            <xsl:otherwise>auto</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="hint">
    <xsl:attribute name="space-after">
      <xsl:value-of select="$hint-space-after"/>
    </xsl:attribute>
    <xsl:attribute name="keep-together.within-page">10</xsl:attribute>
    <xsl:attribute name="font-style">
      <xsl:choose>
        <xsl:when test="name() = 'note'">italic</xsl:when>
        <xsl:otherwise>normal</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="background-color">
      <xsl:choose>
        <xsl:when test="$layout='rtf'">white</xsl:when>
        <xsl:when test="name() = 'note'">
          <xsl:value-of select="$color-black-10"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$color-black-05"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="border-top">
      <xsl:choose>
        <xsl:when test="self::danger">3pt #DC0F14 solid</xsl:when>
        <xsl:when test="self::caution">3pt #FCED00 solid</xsl:when>
        <xsl:when test="self::warning">3pt #F77320 solid</xsl:when>
        <xsl:when test="self::notice">3pt #00579E solid</xsl:when>
        <xsl:otherwise>none</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="border-bottom">
      <xsl:choose>
        <xsl:when test="self::danger">3pt #DC0F14 solid</xsl:when>
        <xsl:when test="self::caution">3pt #FCED00 solid</xsl:when>
        <xsl:when test="self::warning">3pt #F77320 solid</xsl:when>
        <xsl:when test="self::notice">3pt #00579E solid</xsl:when>
        <xsl:otherwise>none</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="margin">0mm</xsl:attribute>
    <xsl:attribute name="padding-top">1mm</xsl:attribute>
    <xsl:attribute name="padding-bottom">1mm</xsl:attribute>
    <xsl:attribute name="padding-left">1mm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:template name="ul-title">
    <xsl:attribute name="space-after">
      <xsl:value-of select="$ul-title-space-after"/>
    </xsl:attribute>
    <xsl:attribute name="margin-top">
      <xsl:value-of select="$ul-space-before"/>
    </xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
  </xsl:template>
  <xsl:template name="ul-list-item">
    <xsl:attribute name="space-after">
      <xsl:value-of select="$ul-listitem-space-after"/>
    </xsl:attribute>
    <xsl:attribute name="start-indent">
      <xsl:choose>
        <xsl:when test="ancestor::*[self::danger or self::caution or self::warning or self::notice or self::note]     and ancestor::*[self::li]">6mm</xsl:when>
        <xsl:when test="ancestor::*[self::danger or self::caution or self::warning or self::notice or self::note]     and ancestor::*[self::step]">7mm</xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="count(ancestor::ul)=2">6mm</xsl:when>
            <xsl:when test="ancestor::info">12mm</xsl:when>
            <xsl:when test="count(ancestor-or-self::*[self::ul or self::procedure])=2">7mm</xsl:when>
            <xsl:when test="ancestor::procedure[@type='substeps']">7mm</xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="ancestor::consequence">2mm</xsl:when>
                <xsl:otherwise>0mm</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="ul-list-item-body">
    <xsl:attribute name="start-indent">
      <xsl:choose>
        <xsl:when test="ancestor::*[self::danger or self::caution or self::warning or self::notice or self::note]     and ancestor::*[self::li or self::step]">12mm</xsl:when>
        <xsl:when test="ancestor::*[self::danger or self::caution or self::warning or self::notice or self::note]     and ancestor::*[self::step]">13mm</xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="count(ancestor::ul)=2">12mm</xsl:when>
            <xsl:when test="ancestor::info">18mm</xsl:when>
            <xsl:when test="count(ancestor-or-self::*[self::ul or self::procedure])=2">13mm</xsl:when>
            <xsl:otherwise>6mm</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <!--  xsl:attribute name="keep-together.within-page">8</xsl:attribute-->
  </xsl:template>
  <xsl:template name="ol-list-item-body">
    <xsl:attribute name="start-indent">
      <xsl:choose>
        <xsl:when test="ancestor::procedure[@type='substeps']">17mm</xsl:when>
        <xsl:when test="ancestor::*[self::danger or self::caution or self::warning or self::notice or self::note]     and ancestor::*[self::li or self::step]">13mm</xsl:when>
        <xsl:when test="ancestor::*[self::danger or self::caution or self::warning or self::notice or self::note]     and ancestor::*[self::step]">14mm</xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="count(ancestor::ul)=2">13mm</xsl:when>
            <xsl:when test="count(ancestor::*[self::ul or self::procedure])=2">14mm</xsl:when>
            <xsl:otherwise>7mm</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="ul-label-1">
    <fo:inline font-family="Noto Sans Symbols" font-weight="bold">⌲ </fo:inline>
  </xsl:template>
  <xsl:template name="ul-label-2">–</xsl:template>
  <xsl:template name="b-styles">
    <xsl:choose>
      <xsl:when test="ancestor::verbatim">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="font-family">Noto Sans Bold</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:attribute-set name="sub">
    <xsl:attribute name="font-size">67%</xsl:attribute>
    <xsl:attribute name="baseline-shift">sub</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="nb">
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="background-color">#f3f3f3</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="sup">
    <xsl:attribute name="font-size">67%</xsl:attribute>
    <xsl:attribute name="baseline-shift">super</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="code">
    <xsl:attribute name="font-family">Courier New, monospace</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="gui-element">
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="font-family">Noto Sans Italic</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="symbol">
    <xsl:attribute name="max-height">11pt</xsl:attribute>
    <xsl:attribute name="baseline-shift">-2pt</xsl:attribute>
    <xsl:attribute name="src" select="if ($docker='no') then @src else concat('/teditor/',@src)"/>
  </xsl:attribute-set>
  <xsl:template match="footnote">
    <xsl:call-template name="footnote"/>
  </xsl:template>
  <xsl:template name="footnote">
    <xsl:variable name="num">
      <xsl:number level="any" count="footnote" format="1)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$layout='columns'">
        <fo:inline id="fnsource-{generate-id()}">
          <xsl:attribute name="font-size">67%</xsl:attribute>
          <xsl:attribute name="baseline-shift">super</xsl:attribute>
          <xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
          <xsl:choose>
            <xsl:when test="/descendant::footnote-index">
              <fo:basic-link internal-destination="fnidx-{generate-id()}">
                <xsl:choose>
                  <xsl:when test="key">
                                        [<xsl:value-of select="key"/>]
                                    </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$num"/>
                  </xsl:otherwise>
                </xsl:choose>
              </fo:basic-link>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="key">
                                    [<xsl:value-of select="key"/>]
                                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$num"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <fo:footnote>
          <fo:inline id="fnsource-{generate-id()}">
            <xsl:attribute name="font-size">67%</xsl:attribute>
            <xsl:attribute name="baseline-shift">super</xsl:attribute>
            <fo:basic-link internal-destination="fntarget-{generate-id()}">
              <xsl:choose>
                <xsl:when test="key">
                                    [<xsl:value-of select="key"/>]
                                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$num"/>
                </xsl:otherwise>
              </xsl:choose>
            </fo:basic-link>
          </fo:inline>
          <fo:footnote-body>
            <fo:list-block id="fntarget-{generate-id()}">
              <xsl:attribute name="provisional-distance-between-starts">
                <xsl:choose>
                  <xsl:when test="key">20mm</xsl:when>
                  <xsl:otherwise>7mm</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="color">#999</xsl:attribute>
              <fo:list-item>
                <fo:list-item-label end-indent="label-end()" start-indent="0">
                  <fo:block>
                    <fo:basic-link internal-destination="fnsource-{generate-id()}">
                      <xsl:choose>
                        <xsl:when test="key">
                                                    [<xsl:value-of select="key"/>]
                                                </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$num"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </fo:basic-link>
                  </fo:block>
                </fo:list-item-label>
                <fo:list-item-body start-indent="10mm">
                  <fo:block>
                    <xsl:apply-templates select="desc"/>
                  </fo:block>
                </fo:list-item-body>
              </fo:list-item>
            </fo:list-block>
          </fo:footnote-body>
        </fo:footnote>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-cover-bar-color">
    <xsl:value-of select="$color-black-15"/>
  </xsl:template>
  <xsl:template name="cover-outside">
    <xsl:if test="$look-and-feel='fashion'">
      <xsl:if test="$option_bg_block_center='yes'">
        <fo:block-container position="fixed" left="0mm" top="99mm" z-index="-50" background-color="{$option_color2}" width="{concat($page-width,$unit)}" height="99mm">
          <xsl:if test="$paper-format='A5'">
            <xsl:attribute name="top">70mm</xsl:attribute>
            <xsl:attribute name="height">70mm</xsl:attribute>
          </xsl:if>
          <fo:block/>
        </fo:block-container>
      </xsl:if>
      <xsl:if test="$option_bg_block_top='yes'">
        <fo:block-container position="fixed" left="0mm" top="0mm" background-color="{$option_color1}" z-index="-200" height="99mm" width="{concat($page-width,$unit)}">
          <xsl:if test="$paper-format='A5'">
            <xsl:attribute name="height">70mm</xsl:attribute>
          </xsl:if>
          <fo:block/>
        </fo:block-container>
        <fo:block-container position="fixed" left="20mm" top="210mm">
          <fo:block>
            <fo:external-graphic>
              <xsl:attribute name="content-width">
                <xsl:choose>
                  <xsl:when test="$paper-format='A5'">60mm</xsl:when>
                  <xsl:otherwise>80mm</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="src" select="xe:resolve-local-src('../../test/boilerplate/caution_animal_chipmunk.svg')"/>
            </fo:external-graphic>
          </fo:block>
        </fo:block-container>
      </xsl:if>
    </xsl:if>
    <xsl:if test="not($look-and-feel='fashion') and not($paper-format='A5')">
      <xsl:variable name="cover-bar-color">
        <xsl:call-template name="get-cover-bar-color"/>
      </xsl:variable>
      <fo:block-container position="fixed" left="0mm" top="0mm" width="10mm" height="{concat($page-height,$unit)}" background-color="{$cover-bar-color}">
        <fo:block/>
      </fo:block-container>
    </xsl:if>
    <fo:block-container>
      <xsl:attribute name="position">fixed</xsl:attribute>
      <xsl:attribute name="bottom">
        <xsl:choose>
          <xsl:when test="$paper-format='A5'">145mm</xsl:when>
          <xsl:otherwise>208mm</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="right">
        <xsl:choose>
          <xsl:when test="$paper-format='A5'">25mm</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="if ($custom) then doc($pdf-config)//cover-image-right else '15mm'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="display-align">after</xsl:attribute>
      <xsl:attribute name="text-align">right</xsl:attribute>
      <xsl:if test="$layout='rtf'">
        <xsl:attribute name="space-after">30pt</xsl:attribute>
      </xsl:if>
      <fo:block>
        <fo:external-graphic>
          <xsl:attribute name="content-width">
            <xsl:choose>
              <xsl:when test="$paper-format='A5'">60mm</xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="if ($custom) then doc($pdf-config)//cover-image-content-width else '80mm'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="src" select="xe:resolve-local-src(if ($custom) then doc($pdf-config)//cover-image else //cover-image)"/>
        </fo:external-graphic>
      </fo:block>
    </fo:block-container>
    <xsl:if test="not($layout='rtf')">
      <fo:block-container>
        <xsl:call-template name="cover-inside-logo-position"/>
        <fo:block>
          <fo:external-graphic>
            <xsl:if test="$look-and-feel='fashion'">
              <xsl:attribute name="border">
                <xsl:text>1pt </xsl:text>
                <xsl:value-of select="$option_color3"/>
                <xsl:text> solid</xsl:text>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="$paper-format='A5'">
              <xsl:attribute name="content-width">20mm</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="src" select="if ($docker='no') then xe:resolve-local-src(//logo-image) else concat('/teditor/',//logo-image)"/>
          </fo:external-graphic>
        </fo:block>
      </fo:block-container>
    </xsl:if>
    <fo:block-container>
      <xsl:call-template name="cover-title-position"/>
      <fo:block>
        <xsl:attribute name="font-size">
          <xsl:choose>
            <xsl:when test="$paper-format='A5'">24pt</xsl:when>
            <xsl:otherwise>30pt</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="space-after">24pt</xsl:attribute>
        <xsl:attribute name="line-height">120%</xsl:attribute>
        <xsl:attribute name="hyphenate">false</xsl:attribute>
        <xsl:attribute name="color">#666</xsl:attribute>
        <xsl:apply-templates select="/document/title"/>
      </fo:block>
      <fo:block>
        <xsl:attribute name="font-size">
          <xsl:choose>
            <xsl:when test="$paper-format='A5'">18pt</xsl:when>
            <xsl:otherwise>24pt</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="line-height">120%</xsl:attribute>
        <xsl:attribute name="space-after">24pt</xsl:attribute>
        <xsl:if test="$look-and-feel='fashion'">
          <xsl:attribute name="color" select="$option_color3"/>
        </xsl:if>
        <xsl:attribute name="hyphenate">false</xsl:attribute>
        <xsl:apply-templates select="main-title"/>
      </fo:block>
      <fo:block>
        <xsl:attribute name="font-size">
          <xsl:choose>
            <xsl:when test="$paper-format='A5'">14pt</xsl:when>
            <xsl:otherwise>17pt</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="line-height">100%</xsl:attribute>
        <xsl:attribute name="space-after">6pt</xsl:attribute>
        <xsl:attribute name="hyphenate">false</xsl:attribute>
        <xsl:apply-templates select="subtitle"/>
      </fo:block>
    </fo:block-container>
  </xsl:template>
  <xsl:template name="cover-outside-logo-position">
    <xsl:attribute name="position">fixed</xsl:attribute>
    <xsl:attribute name="bottom">15mm</xsl:attribute>
    <xsl:attribute name="right">
      <xsl:choose>
        <xsl:when test="$paper-format='A5'">25mm</xsl:when>
        <xsl:otherwise>15mm</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="display-align">after</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:template>
  <xsl:template name="cover-title-position">
    <xsl:attribute name="position">fixed</xsl:attribute>
    <xsl:attribute name="top">
      <xsl:choose>
        <xsl:when test="$paper-format='A5'">80mm</xsl:when>
        <xsl:otherwise>120mm</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="right">
      <xsl:choose>
        <xsl:when test="$paper-format='A5'">25mm</xsl:when>
        <xsl:otherwise>15mm</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:template>
  <xsl:template name="cover-inside">
    <fo:block-container>
      <xsl:attribute name="position">fixed</xsl:attribute>
      <xsl:attribute name="bottom">
        <xsl:choose>
          <xsl:when test="$paper-format='A5'">20mm</xsl:when>
          <xsl:otherwise>60mm</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="left">
        <xsl:choose>
          <xsl:when test="$paper-format='A5'">60mm</xsl:when>
          <xsl:otherwise>110mm</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="width">75mm</xsl:attribute>
      <xsl:attribute name="display-align">after</xsl:attribute>
      <fo:block>
        <xsl:apply-templates select="//meta/cover-text"/>
      </fo:block>
    </fo:block-container>
    <xsl:if test="not($paper-format='A5')">
      <fo:block-container>
        <xsl:call-template name="cover-outside-logo-position"/>
        <fo:block>
          <fo:external-graphic>
            <xsl:if test="$look-and-feel='fashion'">
              <xsl:attribute name="border">
                <xsl:text>1pt </xsl:text>
                <xsl:value-of select="$option_color3"/>
                <xsl:text> solid</xsl:text>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="src" select="if ($docker='no') then xe:resolve-local-src(//logo-image) else concat('/teditor/',//logo-image)"/>
          </fo:external-graphic>
        </fo:block>
      </fo:block-container>
    </xsl:if>
    <fo:block-container>
      <xsl:attribute name="position">fixed</xsl:attribute>
      <xsl:attribute name="bottom">
        <xsl:choose>
          <xsl:when test="$paper-format='A5'">20mm</xsl:when>
          <xsl:otherwise>15mm</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="left">
        <xsl:choose>
          <xsl:when test="$paper-format='A5'">20mm</xsl:when>
          <xsl:otherwise>15mm</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="width">80mm</xsl:attribute>
      <xsl:attribute name="display-align">after</xsl:attribute>
      <fo:block space-after="4pt">Version: <xsl:value-of select="$version"/></fo:block>
      <fo:block>
        <xsl:attribute name="space-after">6pt</xsl:attribute>
        <xsl:choose>
          <xsl:when test="$paper-format='A5'">
            <xsl:attribute name="font-size">9pt</xsl:attribute>
            <xsl:value-of select="//meta/language"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="font-size">11pt</xsl:attribute>
            <xsl:value-of select="//meta/date-of-last-change"/>
            <xsl:text> / </xsl:text>
            <xsl:value-of select="//meta/language"/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:block-container>
  </xsl:template>
  <xsl:template name="cover-inside-logo-position">
    <xsl:attribute name="position">fixed</xsl:attribute>
    <xsl:attribute name="bottom">15mm</xsl:attribute>
    <xsl:attribute name="right">25mm</xsl:attribute>
    <xsl:attribute name="display-align">after</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:template>
  <xsl:template name="cover-page">
    <xsl:call-template name="cover-outside"/>
    <xsl:if test="$format='book' and not($layout='rtf')">
      <fo:block break-after="page"/>
      <xsl:call-template name="cover-inside"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="meta/subtitle">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="meta/cover-text">
    <xsl:for-each select="tokenize(.,'&#10;')">
      <fo:block>
        <xsl:attribute name="space-after">
          <xsl:choose>
            <xsl:when test="$paper-format='A4'">2pt</xsl:when>
            <xsl:otherwise>1pt</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:if test="position()=1">
          <xsl:attribute name="font-weight">bold</xsl:attribute>
          <xsl:attribute name="space-after">
            <xsl:choose>
              <xsl:when test="$paper-format='A4'">6pt</xsl:when>
              <xsl:otherwise>3pt</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="$look-and-feel='fashion'">
            <xsl:attribute name="color" select="$option_color3"/>
          </xsl:if>
        </xsl:if>
        <xsl:value-of select="."/>
      </fo:block>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="cover-back-logo-styles">
    <xsl:attribute name="position">fixed</xsl:attribute>
    <xsl:attribute name="top">25mm</xsl:attribute>
    <xsl:attribute name="right">15mm</xsl:attribute>
    <xsl:attribute name="display-align">after</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:template>
  <xsl:template name="extra-backcover-image"/>
  <xsl:template name="copyright-backcover">
    <xsl:if test="$paper-format='A5'">
      <xsl:attribute name="top">199mm</xsl:attribute>
      <xsl:attribute name="font-size">9pt</xsl:attribute>
    </xsl:if>
    <fo:block>
      <xsl:value-of select="$option_copyright"/>
    </fo:block>
  </xsl:template>
  <xsl:template name="cover-outside-back">
    <fo:block-container position="fixed" height="99mm" top="0mm" z-index="-100">
      <xsl:if test="$paper-format='A5'">
        <xsl:attribute name="height">70mm</xsl:attribute>
      </xsl:if>
      <xsl:if test="$look-and-feel='fashion'">
        <xsl:attribute name="background-color" select="$option_color1"/>
      </xsl:if>
      <fo:block color="white"/>
    </fo:block-container>
    <fo:block-container>
      <xsl:call-template name="cover-back-logo-styles"/>
      <xsl:if test="$paper-format='A5'">
        <xsl:attribute name="top">10mm</xsl:attribute>
      </xsl:if>
      <fo:block>
        <fo:external-graphic>
          <xsl:if test="$look-and-feel='fashion'">
            <xsl:attribute name="border">
              <xsl:text>1pt </xsl:text>
              <xsl:value-of select="$option_color3"/>
              <xsl:text> solid</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$paper-format='A5'">
            <xsl:attribute name="content-width">20mm</xsl:attribute>
          </xsl:if>
          <xsl:attribute name="src" select="if ($docker='no') then xe:resolve-local-src(//logo-image) else concat('/teditor/',//logo-image)"/>
        </fo:external-graphic>
      </fo:block>
      <xsl:call-template name="extra-backcover-image"/>
    </fo:block-container>
    <fo:block-container position="fixed" left="18mm" top="25mm" width="170mm" keep-together.within-page="always">
      <xsl:if test="$paper-format='A5'">
        <xsl:attribute name="top">10mm</xsl:attribute>
        <xsl:attribute name="width">120mm</xsl:attribute>
      </xsl:if>
      <fo:block keep-together.within-page="always">
        <xsl:if test="$paper-format='A5'">
          <xsl:attribute name="font-size">7pt</xsl:attribute>
          <xsl:attribute name="margin-left">0mm</xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="//meta/cover-text"/>
      </fo:block>
    </fo:block-container>
    <fo:block-container position="fixed" left="18mm" top="275mm" font-size="14pt" id="EOF" color="{$option_color3}">
      <xsl:call-template name="copyright-backcover"/>
    </fo:block-container>
    <xsl:if test="not($look-and-feel='fashion')">
      <xsl:variable name="cover-bar-color">
        <xsl:call-template name="get-cover-bar-color"/>
      </xsl:variable>
      <fo:block-container position="fixed" left="200mm" top="0mm" width="10mm" height="{concat($page-height,$unit)}" background-color="{$cover-bar-color}">
        <fo:block/>
      </fo:block-container>
    </xsl:if>
  </xsl:template>
  <xsl:template name="cover-inside-back">
    </xsl:template>
  <xsl:template name="column-count">2</xsl:template>
  <xsl:template name="column-gap">5mm</xsl:template>
  <xsl:template name="page-layout">
    <fo:layout-master-set>
      <fo:simple-page-master master-name="odd-page">
        <xsl:call-template name="odd-page-styles"/>
        <fo:region-body>
          <xsl:call-template name="region-body-odd-page-styles"/>
          <xsl:if test="$layout='columns'">
            <xsl:attribute name="column-count">
              <xsl:call-template name="column-count"/>
            </xsl:attribute>
            <xsl:attribute name="column-gap">
              <xsl:call-template name="column-gap"/>
            </xsl:attribute>
          </xsl:if>
        </fo:region-body>
        <fo:region-before region-name="xsl-region-before-odd-page">
          <xsl:call-template name="region-before-odd-page-styles"/>
        </fo:region-before>
        <fo:region-after region-name="xsl-region-after-odd-page">
          <xsl:call-template name="region-after-odd-page-styles"/>
        </fo:region-after>
      </fo:simple-page-master>
      <fo:simple-page-master master-name="even-page">
        <xsl:call-template name="even-page-styles"/>
        <fo:region-body>
          <xsl:call-template name="region-body-even-page-styles"/>
          <xsl:if test="$layout='columns'">
            <xsl:attribute name="column-count">2</xsl:attribute>
            <xsl:attribute name="column-gap">5mm</xsl:attribute>
          </xsl:if>
        </fo:region-body>
        <fo:region-before region-name="xsl-region-before-even-page">
          <xsl:call-template name="region-before-even-page-styles"/>
        </fo:region-before>
        <fo:region-after region-name="xsl-region-after-even-page">
          <xsl:call-template name="region-after-even-page-styles"/>
        </fo:region-after>
      </fo:simple-page-master>
      <fo:simple-page-master master-name="odd-page-blank">
        <xsl:call-template name="odd-page-styles"/>
        <fo:region-body>
          <xsl:call-template name="region-body-odd-page-styles"/>
        </fo:region-body>
        <fo:region-before>
                </fo:region-before>
        <fo:region-after region-name="xsl-region-after-odd-page">
          <xsl:call-template name="region-after-odd-page-styles"/>
        </fo:region-after>
      </fo:simple-page-master>
      <fo:simple-page-master master-name="even-page-blank">
        <xsl:call-template name="even-page-styles"/>
        <fo:region-body>
          <xsl:call-template name="region-body-even-page-styles"/>
        </fo:region-body>
        <fo:region-before>
                </fo:region-before>
        <fo:region-after region-name="xsl-region-after-even-page">
          <xsl:call-template name="region-after-even-page-styles"/>
        </fo:region-after>
      </fo:simple-page-master>
      <fo:simple-page-master master-name="odd-page-twocol">
        <xsl:call-template name="odd-page-styles"/>
        <fo:region-body>
          <xsl:call-template name="region-body-twocol-even-page-styles"/>
        </fo:region-body>
        <fo:region-before region-name="xsl-region-before-odd-page">
          <xsl:call-template name="region-before-odd-page-styles"/>
        </fo:region-before>
        <fo:region-after region-name="xsl-region-after-odd-page">
          <xsl:call-template name="region-after-odd-page-styles"/>
        </fo:region-after>
      </fo:simple-page-master>
      <fo:simple-page-master master-name="even-page-twocol">
        <xsl:call-template name="even-page-styles"/>
        <fo:region-body>
          <xsl:call-template name="region-body-twocol-odd-page-styles"/>
        </fo:region-body>
        <fo:region-before region-name="xsl-region-before-even-page">
          <xsl:call-template name="region-before-even-page-styles"/>
        </fo:region-before>
        <fo:region-after region-name="xsl-region-after-even-page">
          <xsl:call-template name="region-after-even-page-styles"/>
        </fo:region-after>
      </fo:simple-page-master>
      <fo:simple-page-master master-name="odd-page-multicol-backcover">
        <xsl:call-template name="odd-page-styles"/>
        <fo:region-body>
          <xsl:call-template name="region-body-multicol-backcover-odd-page-styles"/>
        </fo:region-body>
        <fo:region-before region-name="xsl-region-before-odd-page">
          <xsl:call-template name="region-before-odd-page-styles"/>
        </fo:region-before>
        <fo:region-after region-name="xsl-region-after-odd-page">
          <xsl:call-template name="region-after-odd-page-styles"/>
        </fo:region-after>
      </fo:simple-page-master>
      <fo:simple-page-master master-name="even-page-multicol-backcover">
        <xsl:call-template name="even-page-styles"/>
        <fo:region-body>
          <xsl:call-template name="region-body-multicol-backcover-even-page-styles"/>
        </fo:region-body>
        <fo:region-before region-name="xsl-region-before-even-page">
          <xsl:call-template name="region-before-even-page-styles"/>
        </fo:region-before>
        <fo:region-after region-name="xsl-region-after-even-page">
          <xsl:call-template name="region-after-even-page-styles"/>
        </fo:region-after>
      </fo:simple-page-master>
      <fo:page-sequence-master master-name="page-sequence">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page-blank" blank-or-not-blank="blank"/>
          <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page-blank" blank-or-not-blank="blank"/>
          <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page" blank-or-not-blank="not-blank"/>
          <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page" blank-or-not-blank="not-blank"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>
      <fo:page-sequence-master master-name="twocol-page-sequence">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page-blank" blank-or-not-blank="blank"/>
          <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page-blank" blank-or-not-blank="blank"/>
          <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page-twocol" blank-or-not-blank="not-blank"/>
          <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page-twocol" blank-or-not-blank="not-blank"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>
      <fo:page-sequence-master master-name="multicol-page-sequence-backcover">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page-blank" blank-or-not-blank="blank"/>
          <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page-blank" blank-or-not-blank="blank"/>
          <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page-multicol-backcover" blank-or-not-blank="not-blank"/>
          <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page-multicol-backcover" blank-or-not-blank="not-blank"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>
    </fo:layout-master-set>
  </xsl:template>
  <xsl:template name="print-header-and-footer">
    <xsl:if test="not(parent::supplemental-directives) and not(self::appendix) and not(parent::cover-backpage) and not($layout='rtf')">
      <fo:static-content flow-name="xsl-region-before-odd-page">
        <xsl:call-template name="odd-header"/>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-before-even-page">
        <xsl:call-template name="even-header"/>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after-odd-page">
        <xsl:call-template name="odd-footer"/>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after-even-page">
        <xsl:call-template name="even-footer"/>
      </fo:static-content>
    </xsl:if>
  </xsl:template>
  <xsl:template name="print-header-and-footer-backcover">
    <fo:static-content flow-name="xsl-region-before-even-page">
      <xsl:call-template name="even-header-backcover"/>
    </fo:static-content>
    <fo:static-content flow-name="xsl-region-after-odd-page">
      <xsl:call-template name="odd-footer-backcover"/>
    </fo:static-content>
    <fo:static-content flow-name="xsl-region-after-even-page">
      <xsl:call-template name="even-footer-backcover"/>
    </fo:static-content>
  </xsl:template>
  <xsl:template name="print-logo-in-header-odd">
    <fo:block-container>
      <xsl:call-template name="odd-header-logo-styles"/>
      <fo:block>
        <xsl:if test="string-length(/descendant::logo-image)&gt;0 and not($paper-format='A5')">
          <fo:external-graphic>
            <xsl:attribute name="src">
              <xsl:value-of select="$logo_small_odd"/>
            </xsl:attribute>
          </fo:external-graphic>
        </xsl:if>
      </fo:block>
    </fo:block-container>
  </xsl:template>
  <xsl:template name="print-logo-in-header-even">
    <fo:block-container>
      <xsl:call-template name="even-header-logo-styles"/>
      <fo:block>
        <xsl:if test="string-length(/descendant::logo-image)&gt;0 and not($paper-format='A5')">
          <fo:external-graphic>
            <xsl:attribute name="src">
              <xsl:value-of select="$logo_small_even"/>
            </xsl:attribute>
          </fo:external-graphic>
        </xsl:if>
      </fo:block>
    </fo:block-container>
  </xsl:template>
  <xsl:template name="even-header-backcover">
    <fo:block-container position="fixed" height="99mm" top="99mm" z-index="-100">
      <xsl:if test="$paper-format='A5'">
        <xsl:attribute name="top">70mm</xsl:attribute>
        <xsl:attribute name="height">70mm</xsl:attribute>
      </xsl:if>
      <xsl:if test="$look-and-feel='fashion'">
        <xsl:attribute name="background-color">
          <xsl:value-of select="$option_color2"/>
        </xsl:attribute>
      </xsl:if>
      <fo:block color="white"/>
    </fo:block-container>
  </xsl:template>
  <xsl:template name="odd-footer-backcover">
    <fo:block/>
  </xsl:template>
  <xsl:template name="even-footer-backcover">
    <fo:block/>
  </xsl:template>
  <xsl:variable name="section-list" select="//appendix[not(ancestor::meta)] | //index | //chapter[not(ancestor::supplemental-directives) and not(ancestor::cover-backpage) and @ismodule='no'] | //figure-index | //footnote-index"/>
  <!-- Glossary chapter: [[glossary]] in body inserts descendant::glossary; map may use navtitle [[glossary]] with an empty topic title — then use topicref href / link-id. -->
  <xsl:template name="chapter-is-glossary" as="xs:boolean">
    <xsl:variable name="lid" select="lower-case(string(@link-id))"/>
    <xsl:variable name="href" select="lower-case(string(@data-src-href))"/>
    <xsl:sequence select="             exists(descendant::glossary)             or (                 (contains($lid, 'glossary') or contains($href, 'glossary'))                 and not(contains($lid, 'nonglossary'))                 and not(contains($href, 'nonglossary'))             )         "/>
  </xsl:template>
  <xsl:template name="get-section-level">
    <xsl:value-of select="count(ancestor-or-self::*[self::chapter or self::index or self::appendix or self::figure-index or self::footnote-index])"/>
  </xsl:template>
  <xsl:template name="get-section-number">
    <xsl:choose>
      <xsl:when test="false()">9999</xsl:when>
      <xsl:otherwise>
        <xsl:number count="chapter | index | appendix | figure-index | footnote-index" level="multiple" format="1.1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-section-title">
    <xsl:param name="position">first</xsl:param>
    <xsl:param name="for-toc">no</xsl:param>
    <xsl:param name="length">unknown</xsl:param>
    <xsl:choose>
      <xsl:when test="self::toc and $position='first'">
        <xsl:call-template name="boilerplate-lookup">
          <xsl:with-param name="key">B_TOC</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="self::index and $position='first'">
        <xsl:call-template name="boilerplate-lookup">
          <xsl:with-param name="key">B_INDEX</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="self::footnote-index and $position='first'">
        <xsl:call-template name="boilerplate-lookup">
          <xsl:with-param name="key">B_FOOTNOTE_INDEX</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="self::figure-index and $position='first'">
        <xsl:call-template name="boilerplate-lookup">
          <xsl:with-param name="key">B_FIGURE_INDEX</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="self::appendix and $position='first'">
        <xsl:call-template name="boilerplate-lookup">
          <xsl:with-param name="key">B_APPENDIX</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="self::chapter and $position='first'">
        <xsl:variable name="is-glossary-chapter" as="xs:boolean">
          <xsl:call-template name="chapter-is-glossary"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$is-glossary-chapter">
            <xsl:call-template name="boilerplate-lookup">
              <xsl:with-param name="key">B_GLOSSARY</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="apply-cut-text-elements">
              <xsl:with-param name="max-length" select="$length"/>
              <xsl:with-param name="length" select="0"/>
              <xsl:with-param name="nodes" select="title/node()"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$position='subchapter'">
            <xsl:apply-templates select="/document/title"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="apply-cut-text-elements">
              <xsl:with-param name="max-length" select="$length"/>
              <xsl:with-param name="length" select="0"/>
              <xsl:with-param name="nodes" select="title/node()"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-supplemental-directives-space-before-A5-twocol">68mm</xsl:template>
  <xsl:template name="section-content">
    <xsl:variable name="section-level">
      <xsl:call-template name="get-section-level"/>
    </xsl:variable>
    <xsl:variable name="is-glossary-chapter" as="xs:boolean">
      <xsl:call-template name="chapter-is-glossary"/>
    </xsl:variable>
    <xsl:if test="ancestor::supplemental-directives">
      <fo:block>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
      </fo:block>
    </xsl:if>
    <xsl:if test="not($is-glossary-chapter) and not(self::toc) and not(self::index) and not(self::appendix) and not(self::footnote-index) and not(self::figure-index)">
      <fo:block keep-with-next.within-page="always">
        <fo:marker marker-class-name="running-header">
          <xsl:choose>
            <xsl:when test="ancestor-or-self::chapter[last()-1]/title or                             ancestor-or-self::chapter[last()-2]/title or                            ancestor-or-self::chapter[last()-3]/title">
              <xsl:if test="ancestor-or-self::chapter[last()-1]/title">
                <xsl:call-template name="ul-label-1"/>
                <xsl:apply-templates select="ancestor-or-self::chapter[last()-1]/title" mode="running"/>
                <xsl:text> </xsl:text>
              </xsl:if>
              <xsl:if test="ancestor-or-self::chapter[last()-2]/title">
                <xsl:call-template name="ul-label-1"/>
                <xsl:apply-templates select="ancestor-or-self::chapter[last()-2]/title" mode="running"/>
                <xsl:text> </xsl:text>
              </xsl:if>
              <xsl:if test="ancestor-or-self::chapter[last()-3]/title">
                <xsl:call-template name="ul-label-1"/>
                <xsl:apply-templates select="ancestor-or-self::chapter[last()-3]/title" mode="running"/>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="ul-label-1"/>
              <xsl:apply-templates select="chapter[1]/title" mode="running"/>
              <xsl:text> </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </fo:marker>
      </fo:block>
    </xsl:if>
    <fo:block>
      <xsl:if test="$layout='columns' and ancestor::supplemental-directives">
        <xsl:attribute name="span">all</xsl:attribute>
        <xsl:if test="$paper-format='A5'">
          <xsl:attribute name="margin-top">
            <xsl:call-template name="get-supplemental-directives-space-before-A5-twocol"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$paper-format='A4'">
          <xsl:attribute name="margin-top">
            <xsl:call-template name="get-supplemental-directives-space-before-A4-twocol"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="not($format='book') and $section-level=1">
          <xsl:attribute name="margin-top" select="$section-between-space"/>
        </xsl:if>
      </xsl:if>
      <xsl:call-template name="section-styles">
        <xsl:with-param name="section-level" select="$section-level"/>
      </xsl:call-template>
      <xsl:call-template name="section-title">
        <xsl:with-param name="section-level" select="$section-level"/>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="self::appendix and //*[starts-with(name(),'memo-id')]">
          <xsl:call-template name="appendix"/>
        </xsl:when>
        <xsl:when test="self::index">
          <xsl:call-template name="index"/>
        </xsl:when>
        <xsl:when test="self::footnote-index">
          <xsl:call-template name="footnote-index"/>
        </xsl:when>
        <xsl:when test="self::figure-index">
          <xsl:call-template name="figure-index"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$section-level = 1 and descendant::chapter-toc">
            <xsl:call-template name="chapter-toc">
              <xsl:with-param name="root" select="ancestor-or-self::chapter[1]"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="$position-of-block-title!='main'">
              <xsl:apply-templates select="*[not(self::title or self::block-title[following-sibling::*])]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="*[not(self::title)]"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>
  <xsl:template name="section-title">
    <xsl:param name="section-level"/>
    <xsl:param name="type">numbered</xsl:param>
    <xsl:param name="is-bookmark">false</xsl:param>
    <xsl:variable name="is-glossary-chapter" as="xs:boolean">
      <xsl:call-template name="chapter-is-glossary"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="parent::supplemental-directives"/>
      <xsl:when test="@ismodule='yes'"/>
      <xsl:when test="$section-level &gt; 4 or $type='not-numbered' or parent::cover-backpage or $is-glossary-chapter or self::index or self::appendix or self::figure-index or self::footnote-index or not($format='book') or $layout='rtf'">
        <xsl:call-template name="not-numbered-title">
          <xsl:with-param name="section-level" select="$section-level"/>
          <xsl:with-param name="is-bookmark" select="$is-bookmark"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="numbered-title">
          <xsl:with-param name="section-level" select="$section-level"/>
          <xsl:with-param name="is-bookmark" select="$is-bookmark"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="section-number-styles"/>
  <xsl:template name="numbered-title">
    <xsl:param name="section-level"/>
    <xsl:param name="is-bookmark">false</xsl:param>
    <xsl:choose>
      <xsl:when test="$is-bookmark='false'">
        <fo:list-block>
          <xsl:attribute name="id" select="title/generate-id()"/>
          <xsl:call-template name="section-title-styles">
            <xsl:with-param name="section-level" select="$section-level"/>
          </xsl:call-template>
          <fo:list-item>
            <fo:list-item-label>
              <fo:block>
                <xsl:call-template name="section-number-styles"/>
                <xsl:call-template name="get-section-number"/>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <fo:block>
                <xsl:call-template name="get-section-title"/>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </fo:list-block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="get-section-number"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="get-section-title"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="not-numbered-title">
    <xsl:param name="section-level"/>
    <xsl:param name="is-bookmark">false</xsl:param>
    <xsl:choose>
      <xsl:when test="$is-bookmark='false'">
        <fo:block>
          <xsl:call-template name="section-title-styles">
            <xsl:with-param name="section-level" select="$section-level"/>
          </xsl:call-template>
          <xsl:call-template name="get-section-title"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="get-section-title"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="print-toc-entries">
    <xsl:param name="chapter-toc">no</xsl:param>
    <xsl:variable name="section-level">
      <xsl:call-template name="get-section-level"/>
    </xsl:variable>
    <xsl:variable name="is-glossary-chapter" as="xs:boolean">
      <xsl:call-template name="chapter-is-glossary"/>
    </xsl:variable>
    <xsl:if test="not($section-level &gt; 3 and $chapter-toc='yes')">
      <fo:block>
        <xsl:call-template name="toc-styles">
          <xsl:with-param name="chapter-toc" select="$chapter-toc"/>
        </xsl:call-template>
        <xsl:if test="$layout='columns'">
          <xsl:attribute name="span">all</xsl:attribute>
        </xsl:if>
        <fo:list-block>
          <fo:list-item>
            <xsl:call-template name="set-toc-entry-number-indent">
              <xsl:with-param name="chapter-toc" select="$chapter-toc"/>
            </xsl:call-template>
            <fo:list-item-label end-indent="label-end()">
              <fo:block>
                <xsl:if test="not(self::index or self::appendix or $is-glossary-chapter or self::figure-index or self::footnote-index or not($format='book') or ($section-level &gt; 3 and $chapter-toc='yes'))">
                  <xsl:call-template name="get-section-number"/>
                </xsl:if>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body>
              <xsl:call-template name="set-toc-entry-text-indent">
                <xsl:with-param name="chapter-toc" select="$chapter-toc"/>
              </xsl:call-template>
              <fo:block>
                <fo:basic-link>
                  <xsl:attribute name="internal-destination" select="generate-id()"/>
                  <xsl:choose>
                    <xsl:when test="false() and $section-level &gt; 3 and $chapter-toc='yes'">
                      <xsl:text>└  </xsl:text>
                      <xsl:apply-templates select="block-title/node()"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="get-section-title">
                        <xsl:with-param name="for-toc">yes</xsl:with-param>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                  <fo:leader>
                    <xsl:call-template name="toc-leader-styles"/>
                  </fo:leader>
                  <xsl:if test="$chapter-toc='yes'">
                    <xsl:text> ...  </xsl:text>
                  </xsl:if>
                  <fo:page-number-citation>
                    <xsl:call-template name="toc-page-number-styles"/>
                  </fo:page-number-citation>
                </fo:basic-link>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </fo:list-block>
      </fo:block>
    </xsl:if>
  </xsl:template>
  <xsl:template name="index">
    <fo:block id="index">
      <fo:block span="all"/>
      <xsl:call-template name="index-content-styles"/>
      <xsl:call-template name="sorter">
        <xsl:with-param name="xpath" select="//xe"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>
  <xsl:template name="sorter">
    <xsl:param name="xpath"/>
    <xsl:variable name="language" select="substring-before(string(root(.)/*/meta/language),'-')"/>
    <xsl:variable name="variant" select="substring-after(string(root(.)/*/meta/language),'-')"/>
    <xsl:variable name="group-label-numbers">
      <xsl:call-template name="boilerplate-lookup">
        <xsl:with-param name="key">B_SYMBOLS</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="group-label-symbols">
      <xsl:call-template name="boilerplate-lookup">
        <xsl:with-param name="key">B_SYMBOLS</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="default-symbols">0123456789ΑαΒβΓγΔδΕεΖζΗηΘθΙιΚκΛλΜμΝνΞξΟοΠπΡρΣσΤτΥυΦφΧχΨψΩω*</xsl:variable>
    <xsl:variable name="UNDEFINED">###UNDEFINED###</xsl:variable>
    <xsl:variable name="collatrrules_filename" select="$localize_file"/>
    <xsl:variable name="crules">
      <xsl:choose>
        <xsl:when test="$language='ko' or $language='zh' or $language='ja'">
          <xsl:value-of select="$UNDEFINED"/>
        </xsl:when>
        <xsl:when test="document($collatrrules_filename)//index/variant[@lang=$language]">
          <xsl:copy-of select="document($collatrrules_filename)//index/variant[@lang=$language]/*"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>xe ERROR: collation not found</xsl:message>
          <xsl:value-of select="$UNDEFINED"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="uentries">
      <xsl:variable name="collation-attribute" select="xe:collation-id($language,$variant,'',$default-symbols)"/>
      <xsl:for-each select="$xpath">
        <xsl:sort select="upper-case(first/@criterion)" data-type="text" lang="{$language}" collation="{$collation-attribute}"/>
        <xsl:sort select="upper-case(second/@criterion)" data-type="text" lang="{$language}" collation="{$collation-attribute}"/>
        <xsl:variable name="first-text" select="if (string-length(first/@synonym) &gt; 0) then (first/@synonym) else string(first)"/>
        <xe>
          <id>
            <xsl:value-of select="concat(generate-id(),'#',normalize-space(string(first)),normalize-space(string(second)))"/>
          </id>
          <first>
            <xsl:copy-of select="first/node()"/>
          </first>
          <second>
            <xsl:copy-of select="second/node()"/>
          </second>
          <group-label>
            <xsl:variable name="first-first-letter" select="substring($first-text,1,1)"/>
            <xsl:choose>
              <xsl:when test="$language='ko'  or ($language='ja')">
                <xsl:value-of select="if (string-length(normalize-space(@group-label)) &gt; 0) then @group-label else xe:korean-group-label($first-first-letter,'#')"/>
              </xsl:when>
              <xsl:when test="$language='zh' and $variant='TW'">
                <xsl:value-of select="if (string-length(normalize-space(@group-label)) &gt; 0) then @group-label else $UNDEFINED"/>
              </xsl:when>
              <xsl:when test="$language='zh' and $variant='CN'">
                <xsl:value-of select="if (string-length(normalize-space(@group-label)) &gt; 0) then @group-label else xe:zh-group-label($first-first-letter)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="$crules = $UNDEFINED"/>
                  <xsl:otherwise>
                    <xsl:variable name="pgl" as="xs:string*">
                      <xsl:for-each select="$crules//collation/rule">
                        <xsl:variable name="group-label" select="preceding-sibling::label"/>
                        <xsl:variable name="tokens" select="tokenize(.,concat('[','&lt;',',;=]'))" as="xs:string*"/>
                        <xsl:for-each select="$tokens">
                          <xsl:if test="starts-with($first-text,.) and string-length(.)&gt;0">
                            <xsl:sequence select="$group-label"/>
                          </xsl:if>
                        </xsl:for-each>
                      </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="result">
                      <xsl:value-of select="$pgl[position()=last()]"/>
                    </xsl:variable>
                    <xsl:choose>
                      <xsl:when test="$result = ''">
                        <xsl:choose>
                          <xsl:when test="contains($numbers,$first-first-letter)">###NUMBERS###</xsl:when>
                          <xsl:otherwise>
                            <xsl:choose>
                              <xsl:when test="$first-first-letter='#'">###SYMBOLS###</xsl:when>
                              <xsl:otherwise>
                                                                </xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$result"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </group-label>
        </xe>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="sentries">
      <xsl:for-each select="$xpath">
        <xe>
          <id>
            <xsl:value-of select="concat(generate-id(),'#',normalize-space(string(first)),normalize-space(string(second)))"/>
          </id>
          <first>
            <xsl:copy-of select="first/node()"/>
          </first>
          <second>
            <xsl:copy-of select="second/node()"/>
          </second>
        </xe>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="uss">
      <sortstructure>
        <unsorted>
          <xsl:copy-of select="$sentries"/>
        </unsorted>
        <sorted>
          <xsl:choose>
            <xsl:when test="$language='zh'">
              <xsl:for-each select="$uentries/*">
                <xsl:sort select="group-label" data-type="text"/>
                <xsl:copy-of select="."/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="$uentries"/>
            </xsl:otherwise>
          </xsl:choose>
        </sorted>
      </sortstructure>
    </xsl:variable>
    <xsl:variable name="uentries" select="$uss/sortstructure/unsorted"/>
    <xsl:variable name="sentries" select="$uss/sortstructure/sorted"/>
    <xsl:for-each select="$sentries/xe">
      <xsl:variable name="first-text">
        <xsl:value-of select="first"/>
      </xsl:variable>
      <xsl:variable name="second-text">
        <xsl:value-of select="second"/>
      </xsl:variable>
      <xsl:variable name="preceding-first-text">
        <xsl:value-of select="preceding-sibling::xe[1]/first"/>
      </xsl:variable>
      <xsl:variable name="preceding-second-text">
        <xsl:value-of select="preceding-sibling::xe[1]/second"/>
      </xsl:variable>
      <xsl:variable name="id" select="concat(normalize-space($first-text),normalize-space($second-text))"/>
      <xsl:variable name="pagenum">
        <xsl:for-each select="$uentries//xe[substring-after(id,'#') = $id]">
          <xsl:if test="not(position() = 1)">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <fo:basic-link internal-destination="{substring-before(id,'#')}">
            <fo:page-number-citation ref-id="{substring-before(id,'#')}"/>
          </fo:basic-link>
        </xsl:for-each>
      </xsl:variable>
      <xsl:if test="not(normalize-space($preceding-first-text) = normalize-space($first-text))  and string-length(normalize-space($first-text)) &gt; 0">
        <xsl:variable name="grp-label">
          <xsl:choose>
            <xsl:when test="group-label='###NUMBERS###'">
              <xsl:value-of select="$group-label-numbers"/>
            </xsl:when>
            <xsl:when test="group-label='###SYMBOLS###'">
              <xsl:value-of select="$group-label-symbols"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="group-label"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="pred-grp-label">
          <xsl:choose>
            <xsl:when test="preceding-sibling::xe[1]/group-label='###NUMBERS###'">
              <xsl:value-of select="$group-label-numbers"/>
            </xsl:when>
            <xsl:when test="preceding-sibling::xe[1]/group-label='###SYMBOLS###'">
              <xsl:value-of select="$group-label-symbols"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="preceding-sibling::xe[1]/group-label"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="not($grp-label=$pred-grp-label)">
          <fo:block>
            <xsl:call-template name="group-label-styles"/>
            <xsl:choose>
              <xsl:when test="group-label='###NUMBERS###'">
                <xsl:value-of select="$group-label-numbers"/>
              </xsl:when>
              <xsl:when test="group-label='###SYMBOLS###'">
                <xsl:value-of select="$group-label-symbols"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="group-label"/>
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </xsl:if>
        <fo:block>
          <xsl:call-template name="first-styles"/>
          <xsl:attribute name="text-align-last">left</xsl:attribute>
          <xsl:if test="string-length($second-text)=0">
            <xsl:attribute name="text-align-last">justify</xsl:attribute>
          </xsl:if>
          <xsl:apply-templates select="first" mode="fo"/>
          <xsl:if test="string-length($second-text)=0">
            <fo:leader keep-with-next="always">
              <xsl:call-template name="leader-styles"/>
            </fo:leader>
            <xsl:copy-of select="$pagenum"/>
          </xsl:if>
        </fo:block>
      </xsl:if>
      <xsl:if test="not(normalize-space($preceding-second-text) = normalize-space($second-text) and normalize-space($preceding-first-text) = normalize-space($first-text)) and string-length($second-text) &gt; 0">
        <fo:block>
          <xsl:call-template name="second-styles"/>
          <xsl:attribute name="text-align-last">justify</xsl:attribute>
          <xsl:variable name="second-text">
            <xsl:value-of select="second"/>
          </xsl:variable>
          <xsl:variable name="first-text">
            <xsl:value-of select="first"/>
          </xsl:variable>
          <xsl:variable name="preceding-first-text">
            <xsl:value-of select="preceding-sibling::xe[1]/first"/>
          </xsl:variable>
          <xsl:variable name="following-first-text">
            <xsl:value-of select="following-sibling::xe[1]/first"/>
          </xsl:variable>
          <xsl:attribute name="keep-with-previous.within-column">
            <xsl:choose>
              <xsl:when test="count(distinct-values(preceding-sibling::xe[string(second) != $second-text and string(first) = $first-text]/second)) lt 2">always</xsl:when>
              <xsl:when test="count(distinct-values(following-sibling::xe[string(second) != $second-text and string(first) = $first-text]/second)) lt 2">always</xsl:when>
              <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:apply-templates select="second" mode="fo"/>
          <fo:leader keep-with-next="always">
            <xsl:call-template name="leader-styles"/>
          </fo:leader>
          <xsl:copy-of select="$pagenum"/>
        </fo:block>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="first | second" mode="fo">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:variable name="lowercase">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="uppercase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="numbers">0123456789¼½¾</xsl:variable>
  <xsl:function name="xe:korean-group-label">
    <xsl:param name="char"/>
    <xsl:param name="default-symbols"/>
    <xsl:choose>
      <xsl:when test="contains($numbers,$char)">###NUMBERS###</xsl:when>
      <xsl:when test="contains($default-symbols,$char)">###SYMBOLS###</xsl:when>
      <xsl:when test="contains($lowercase,$char)">
        <xsl:value-of select="upper-case($char)"/>
      </xsl:when>
      <xsl:when test="$char='#'">###SYMBOLS###</xsl:when>
      <xsl:otherwise>
        <xsl:variable name="hangul-unicode-char" select="normalize-unicode($char, 'NFKD')"/>
        <xsl:variable name="first-particle" select="substring($hangul-unicode-char,1,1)"/>
        <xsl:value-of select="$first-particle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <xsl:function name="xe:collation-id">
    <xsl:param name="language"/>
    <xsl:param name="variant"/>
    <xsl:param name="collationrule-path-to-file"/>
    <xsl:param name="def-symbols"/>
    <xsl:variable name="prefix" select="concat('http://saxon.sf.net/collation?lang=',$language,'-',$variant,'&amp;rules=')"/>
    <xsl:variable name="collatrrules_filename" select="$localize_file"/>
    <xsl:variable name="crules">
      <xsl:choose>
        <xsl:when test="document($collatrrules_filename)//index/variant[@lang=$language]">
          <xsl:copy-of select="document($collatrrules_filename)//index/variant[@lang=$language]/*"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>INDEX ERROR!</xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="single-quot">'</xsl:variable>
    <xsl:variable name="crules-sequence" as="xs:string *">
      <xsl:for-each select="$crules//collation/rule">
        <xsl:variable name="tokens" select="tokenize(.,concat('[','&lt;',',;=]'))"/>
        <xsl:variable name="clean-tokens" as="xs:string *">
          <xsl:for-each select="$tokens">
            <xsl:if test="string-length(.)&gt;0">
              <xsl:sequence select="."/>
            </xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:sequence select="for $ch in $clean-tokens return concat('&lt;',$ch)"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="collatorules-string" select="substring(string-join($crules-sequence,''),1)"/>
    <xsl:variable name="default-chars" as="xs:string *">
      <xsl:sequence select="for $ch in string-to-codepoints($def-symbols) return concat('&lt;',$single-quot,codepoints-to-string($ch),$single-quot)"/>
    </xsl:variable>
    <xsl:variable name="default-symbol-rules" select="string-join($default-chars,'')"/>
    <xsl:message>
      <xsl:value-of select="$collatorules-string"/>
    </xsl:message>
    <xsl:variable name="uri-string">
      <xsl:choose>
        <xsl:when test="$language='ko' or $language='ja' or $language='zh'">
          <xsl:value-of select="$default-symbol-rules"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($default-symbol-rules,$collatorules-string)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat($prefix,encode-for-uri($uri-string))"/>
  </xsl:function>
  <xsl:function name="xe:zh-group-label">
    <xsl:param name="letter"/>
    <xsl:variable name="collatrrules_filename" select="$localize_file"/>
    <xsl:variable name="crules">
      <xsl:choose>
        <xsl:when test="document($collatrrules_filename)//index/variant[@lang='zh']">
          <xsl:copy-of select="document($collatrrules_filename)//index/variant[@lang='zh']/*"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>INDEX ERROR!</xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="chinese-group-letters" select="$crules/collation/rule"/>
    <xsl:variable name="index" select="string-to-codepoints($letter)-13312"/>
    <xsl:variable name="result">
      <xsl:choose>
        <xsl:when test="$index &gt; -1 and $index &lt; 50735">
          <xsl:value-of select="substring($chinese-group-letters,$index+1,1)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$letter"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($lowercase,$letter)">
        <xsl:value-of select="upper-case($letter)"/>
      </xsl:when>
      <xsl:when test="contains($numbers,$letter)">###NUMBERS###</xsl:when>
      <xsl:when test="$result='#' or $letter='#'">###SYMBOLS###</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$result"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <xsl:template match="xe">
    <fo:inline id="{generate-id()}" color="white" font-size="0pt" visibility="hidden">.</fo:inline>
  </xsl:template>
  <xsl:template name="footnote-index">
    <xsl:if test="/descendant::footnote">
      <fo:list-block id="fntarget-{generate-id()}">
        <xsl:attribute name="provisional-distance-between-starts">20mm</xsl:attribute>
        <xsl:for-each select="/descendant::footnote">
          <fo:list-item id="fnidx-{generate-id()}" space-after="6pt">
            <fo:list-item-label end-indent="label-end()">
              <fo:block>
                <xsl:if test="position()=1">
                  <xsl:attribute name="id">footnote-index</xsl:attribute>
                </xsl:if>
                <fo:basic-link internal-destination="fnsource-{generate-id()}">
                  <xsl:choose>
                    <xsl:when test="key">
                      <xsl:text>[</xsl:text>
                      <xsl:value-of select="key"/>
                      <xsl:text>]</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="position()"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </fo:basic-link>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <fo:block keep-with-next.within-page="always">
                <xsl:apply-templates select="desc"/>
              </fo:block>
              <fo:block font-style="italic" color="#666">
                <xsl:apply-templates select="add"/>
                <xsl:if test="not(ancestor::table)">
                  <xsl:if test="string-length(string(add))&gt;0">
                    <xsl:text>, </xsl:text>
                  </xsl:if>
                  <fo:inline font-style="italic">
                    <fo:basic-link internal-destination="fnsource-{generate-id()}">
                      <xsl:call-template name="boilerplate-lookup">
                        <xsl:with-param name="key">B_PAGE</xsl:with-param>
                      </xsl:call-template>
                      <xsl:text> </xsl:text>
                      <fo:page-number-citation ref-id="fnsource-{generate-id()}"/>
                    </fo:basic-link>
                  </fo:inline>
                </xsl:if>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </xsl:for-each>
      </fo:list-block>
    </xsl:if>
  </xsl:template>
  <xsl:template name="figure-index">
    <xsl:if test="/descendant::subtitle[not(ancestor::meta) and not(../@pdfwidth='margin')]">
      <fo:list-block>
        <xsl:attribute name="provisional-distance-between-starts">20mm</xsl:attribute>
        <xsl:for-each select="/descendant::subtitle[not(ancestor::meta) and not(../@pdfwidth='margin')]">
          <fo:list-item space-after="6pt">
            <fo:list-item-label end-indent="label-end()">
              <fo:block>
                <xsl:if test="position()=1">
                  <xsl:attribute name="id">figure-index</xsl:attribute>
                </xsl:if>
                <fo:basic-link internal-destination="{generate-id()}">
                  <xsl:call-template name="boilerplate-lookup">
                    <xsl:with-param name="key">B_FIG</xsl:with-param>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
                  <xsl:number count="subtitle[not(ancestor::meta)]" format="1" level="any"/>
                  <xsl:if test="string(.)">
                    <xsl:text>:</xsl:text>
                  </xsl:if>
                </fo:basic-link>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <fo:block>
                <fo:basic-link internal-destination="{generate-id()}">
                  <xsl:if test="string(.)">
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="node()[not(self::xe)]"/>
                  </xsl:if>
                  <xsl:text>, </xsl:text>
                  <fo:inline font-style="italic">
                    <xsl:call-template name="boilerplate-lookup">
                      <xsl:with-param name="key">B_PAGE</xsl:with-param>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                    <fo:page-number-citation ref-id="{generate-id()}"/>
                  </fo:inline>
                </fo:basic-link>
              </fo:block>
              <xsl:if test="ancestor::figure[1][desc]">
                <fo:block font-style="italic" color="#666" keep-with-previous.within-page="always">
                  <xsl:value-of select="ancestor::figure[1]/desc"/>
                </fo:block>
              </xsl:if>
            </fo:list-item-body>
          </fo:list-item>
        </xsl:for-each>
      </fo:list-block>
    </xsl:if>
  </xsl:template>
  <xsl:template name="chapter-toc">
    <xsl:param name="root"/>
    <xsl:choose>
      <xsl:when test="$layout='columns' or $layout='rtf' or $paper-format='A5'">
        <fo:block>
          <xsl:attribute name="space-after" select="$section-between-space"/>
          <fo:block>
            <xsl:call-template name="block-title-styles"/>
            <xsl:call-template name="boilerplate-lookup">
              <xsl:with-param name="key">B_CHAPTER_TOC</xsl:with-param>
            </xsl:call-template>
          </fo:block>
          <xsl:for-each select="$root/descendant::chapter">
            <xsl:call-template name="print-toc-entries">
              <xsl:with-param name="chapter-toc">yes</xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:table>
          <xsl:call-template name="block-styles"/>
          <xsl:attribute name="space-after" select="$section-between-space"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell vertical-align="top">
                <xsl:call-template name="margin-styles"/>
                <fo:block>
                  <xsl:call-template name="block-title-styles"/>
                  <xsl:call-template name="boilerplate-lookup">
                    <xsl:with-param name="key">B_CHAPTER_TOC</xsl:with-param>
                  </xsl:call-template>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell width="{concat($column-width,$unit)}">
                <fo:block>
                  <xsl:call-template name="block-styles"/>
                  <xsl:for-each select="$root/descendant::chapter">
                    <xsl:call-template name="print-toc-entries">
                      <xsl:with-param name="chapter-toc">yes</xsl:with-param>
                    </xsl:call-template>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="apply-cut-text-elements">
    <xsl:param name="nodes"/>
    <xsl:param name="length"/>
    <xsl:param name="max-length"/>
    <xsl:variable name="new-length" select="$length + string-length(normalize-space(string($nodes[1])))"/>
    <xsl:choose>
      <xsl:when test="$max-length='unknown'">
        <xsl:apply-templates select="$nodes"/>
      </xsl:when>
      <xsl:when test="$new-length &lt; number($max-length) and $nodes/following-sibling::node()">
        <xsl:apply-templates select="$nodes[1]"/>
        <xsl:call-template name="apply-cut-text-elements">
          <xsl:with-param name="nodes" select="$nodes/following-sibling::node()"/>
          <xsl:with-param name="length" select="$new-length"/>
          <xsl:with-param name="max-length" select="$max-length"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="offset" select="$max-length - $new-length"/>
        <xsl:variable name="text-rest-length">
          <xsl:choose>
            <xsl:when test="$offset &lt; 1">
              <xsl:value-of select="($max-length - $length) + 1"/>
            </xsl:when>
            <xsl:otherwise>none</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="text">
          <xsl:choose>
            <xsl:when test="$text-rest-length='none'">
              <xsl:value-of select="normalize-space(string($nodes[1]))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="substring(normalize-space(string($nodes[1])),1,$text-rest-length)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$nodes[1][self::*]">
            <xsl:variable name="result">
              <xsl:for-each select="$nodes[1]">
                <xsl:copy>
                  <xsl:value-of select="$text"/>
                </xsl:copy>
              </xsl:for-each>
            </xsl:variable>
            <xsl:apply-templates select="$result/*"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$text"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="boilerplate-lookup">
    <xsl:param name="key" select="none"/>
    <xsl:variable name="language" select="substring-before(//meta/language,'-')"/>
    <xsl:variable name="variant" select="substring-after(//meta/language,'-')"/>
    <xsl:variable name="boilerplate" select="document($localize_file)//boilerplate"/>
    <xsl:variable name="default-boilerplate" select="document($localize_file)//boilerplate"/>
    <xsl:variable name="missing-string">
      <xsl:value-of select="concat('ERROR! cannot be found in boilerplate text [', $language, ']')"/>
    </xsl:variable>
    <xsl:variable name="retval">
      <xsl:value-of select="$option_bottom_margin_A4"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="$boilerplate//text[@key=$key]/translation[@lang=$language]"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="string-length($retval) &gt; 0">
        <xsl:apply-templates select="$boilerplate//text[@key=$key]/translation[@lang=$language]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="default-retval">
          <xsl:value-of select="$default-boilerplate//text[@key=$key]/translation[@lang='de']"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length($default-retval) &gt; 0">
            <xsl:apply-templates select="$default-boilerplate//text[@key=$key]/translation[@lang='de']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($missing-string,'[',$key,']')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="create-bookmark-tree">
    <fo:bookmark-tree>
      <xsl:apply-templates select="document/toc|             document/chapter|             document/figure-index|             document/footnote-index|             document/index|document/appendix" mode="bookmarks"/>
    </fo:bookmark-tree>
  </xsl:template>
  <xsl:template match="/">
    <xsl:message>
      <xsl:text>PDF PARAMS BEGIN
</xsl:text>
      <xsl:text>docker=</xsl:text>
      <xsl:value-of select="$docker"/>
      <xsl:text>
</xsl:text>
      <xsl:text>pdf_config_uri=</xsl:text>
      <xsl:value-of select="$pdf_config_uri"/>
      <xsl:text>
</xsl:text>
      <xsl:text>localize_file=</xsl:text>
      <xsl:value-of select="$localize_file"/>
      <xsl:text>
</xsl:text>
      <xsl:text>version=</xsl:text>
      <xsl:value-of select="$version"/>
      <xsl:text>
</xsl:text>
      <xsl:text>imagedir=</xsl:text>
      <xsl:value-of select="$imagedir"/>
      <xsl:text>
</xsl:text>
      <xsl:text>theme=</xsl:text>
      <xsl:value-of select="$theme"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_color1=</xsl:text>
      <xsl:value-of select="$option_color1"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_color2=</xsl:text>
      <xsl:value-of select="$option_color2"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_color3=</xsl:text>
      <xsl:value-of select="$option_color3"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_color4=</xsl:text>
      <xsl:value-of select="$option_color4"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_outer_margin_A4_leftgap=</xsl:text>
      <xsl:value-of select="$option_outer_margin_A4_leftgap"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_outer_margin_A5_leftgap=</xsl:text>
      <xsl:value-of select="$option_outer_margin_A5_leftgap"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_outer_margin_A4_A5=</xsl:text>
      <xsl:value-of select="$option_outer_margin_A4_A5"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_inner_margin_A4_leftgap=</xsl:text>
      <xsl:value-of select="$option_inner_margin_A4_leftgap"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_inner_margin_A5_leftgap=</xsl:text>
      <xsl:value-of select="$option_inner_margin_A5_leftgap"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_inner_outer_margin_A4_A5=</xsl:text>
      <xsl:value-of select="$option_inner_outer_margin_A4_A5"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_top_margin_A4=</xsl:text>
      <xsl:value-of select="$option_top_margin_A4"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_top_margin_A5=</xsl:text>
      <xsl:value-of select="$option_top_margin_A5"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_bottom_margin_A4=</xsl:text>
      <xsl:value-of select="$option_bottom_margin_A4"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_bottom_margin_A5=</xsl:text>
      <xsl:value-of select="$option_bottom_margin_A5"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_bg_block_top=</xsl:text>
      <xsl:value-of select="$option_bg_block_top"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_bg_block_center=</xsl:text>
      <xsl:value-of select="$option_bg_block_center"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_default_font_size_A4=</xsl:text>
      <xsl:value-of select="$option_default_font_size_A4"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_headline_font_sizes_A4=</xsl:text>
      <xsl:value-of select="$option_headline_font_sizes_A4"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_default_font_size_A5=</xsl:text>
      <xsl:value-of select="$option_default_font_size_A5"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_headline_font_sizes_A5=</xsl:text>
      <xsl:value-of select="$option_headline_font_sizes_A5"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_margin_width_A4=</xsl:text>
      <xsl:value-of select="$option_margin_width_A4"/>
      <xsl:text>
</xsl:text>
      <xsl:text>option_default_font_family=</xsl:text>
      <xsl:value-of select="$option_default_font_family"/>
      <xsl:text>
</xsl:text>
      <xsl:text>print_format=</xsl:text>
      <xsl:value-of select="$print_format"/>
      <xsl:text>
</xsl:text>
      <xsl:text>print_layout=</xsl:text>
      <xsl:value-of select="$print_layout"/>
      <xsl:text>
</xsl:text>
      <xsl:text>print_paper_format=</xsl:text>
      <xsl:value-of select="$print_paper_format"/>
      <xsl:text>
</xsl:text>
      <xsl:text>print_page_margin=</xsl:text>
      <xsl:value-of select="$print_page_margin"/>
      <xsl:text>
</xsl:text>
      <xsl:text>print_page_margins=</xsl:text>
      <xsl:value-of select="$print_page_margins"/>
      <xsl:text>
</xsl:text>
      <xsl:text>print_spaces=</xsl:text>
      <xsl:value-of select="$print_spaces"/>
      <xsl:text>
</xsl:text>
      <xsl:text>print_header=</xsl:text>
      <xsl:value-of select="$print_header"/>
      <xsl:text>
</xsl:text>
      <xsl:text>print_footer=</xsl:text>
      <xsl:value-of select="$print_footer"/>
      <xsl:text>
</xsl:text>
      <xsl:text>print_look_and_feel=</xsl:text>
      <xsl:value-of select="$print_look_and_feel"/>
      <xsl:text>
</xsl:text>
      <xsl:text>print_table_layout=</xsl:text>
      <xsl:value-of select="$print_table_layout"/>
      <xsl:text>
</xsl:text>
      <xsl:text>print_chapter_on_right_page=</xsl:text>
      <xsl:value-of select="$print_chapter_on_right_page"/>
      <xsl:text>
</xsl:text>
      <xsl:text>effective.pdf-config=</xsl:text>
      <xsl:value-of select="$pdf-config"/>
      <xsl:text>
</xsl:text>
      <xsl:text>effective.format=</xsl:text>
      <xsl:value-of select="$format"/>
      <xsl:text>
</xsl:text>
      <xsl:text>effective.layout=</xsl:text>
      <xsl:value-of select="$layout"/>
      <xsl:text>
</xsl:text>
      <xsl:text>effective.paper-format=</xsl:text>
      <xsl:value-of select="$paper-format"/>
      <xsl:text>
</xsl:text>
      <xsl:text>effective.page-margin=</xsl:text>
      <xsl:value-of select="$page-margin"/>
      <xsl:text>
</xsl:text>
      <xsl:text>effective.spaces=</xsl:text>
      <xsl:value-of select="$spaces"/>
      <xsl:text>
</xsl:text>
      <xsl:text>effective.header=</xsl:text>
      <xsl:value-of select="$header"/>
      <xsl:text>
</xsl:text>
      <xsl:text>effective.footer=</xsl:text>
      <xsl:value-of select="$footer"/>
      <xsl:text>
</xsl:text>
      <xsl:text>effective.look-and-feel=</xsl:text>
      <xsl:value-of select="$look-and-feel"/>
      <xsl:text>
</xsl:text>
      <xsl:text>effective.table-layout=</xsl:text>
      <xsl:value-of select="$table-layout"/>
      <xsl:text>
</xsl:text>
      <xsl:text>effective.chapter-on-right-page=</xsl:text>
      <xsl:value-of select="$chapter-on-right-page"/>
      <xsl:text>
</xsl:text>
      <xsl:text>PDF PARAMS END</xsl:text>
    </xsl:message>
    <xsl:variable name="pre">
      <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
        <xsl:call-template name="default-page-styles"/>
        <xsl:call-template name="page-layout"/>
        <xsl:call-template name="create-bookmark-tree"/>
        <xsl:apply-templates/>
        <xsl:if test="$layout='rtf'">
          <fo:page-sequence master-reference="page-sequence">
            <xsl:attribute name="force-page-count">auto</xsl:attribute>
            <xsl:call-template name="print-header-and-footer"/>
            <fo:flow flow-name="xsl-region-body">
              <fo:block space-after="24pt">
                <fo:external-graphic>
                  <xsl:attribute name="src" select="if ($docker='no') then xe:resolve-local-src(//meta/logo-image) else concat('/teditor/',//meta/logo-image)"/>
                </fo:external-graphic>
              </fo:block>
              <xsl:apply-templates select="//meta/cover-text"/>
            </fo:flow>
          </fo:page-sequence>
        </xsl:if>
      </fo:root>
    </xsl:variable>
    <xsl:apply-templates select="$pre" mode="post"/>
  </xsl:template>
  <xsl:key name="ids" match="@id" use="."/>
  <xsl:template match="@id[count(key('ids',.)) gt 1]" mode="post">
    <xsl:attribute name="id" select="concat(.,'_',generate-id())"/>
  </xsl:template>
  <xsl:template match="node()|@*" mode="post">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="post"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
