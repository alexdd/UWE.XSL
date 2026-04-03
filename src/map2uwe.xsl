<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:include href="./topic2uwe.xsl"/>
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:param name="alphanum-prefix1">UNDEFINED</xsl:param>
  <xsl:param name="alphanum-prefix2">UNDEFINED</xsl:param>
  <xsl:param name="alphanum-prefix3">UNDEFINED</xsl:param>
  <xsl:param name="print_supplemental_directives">UNDEFINED</xsl:param>
  <xsl:param name="print_toc">UNDEFINED</xsl:param>
  <xsl:param name="print_index">UNDEFINED</xsl:param>
  <xsl:param name="print_figure_index">UNDEFINED</xsl:param>
  <xsl:param name="print_footnote_index">UNDEFINED</xsl:param>
  <xsl:param name="print_cover_backpage">UNDEFINED</xsl:param>
  <xsl:param name="imagedir">UNDEFINED</xsl:param>
  <xsl:param name="option_color1">UNDEFINED</xsl:param>
  <xsl:param name="option_color2">UNDEFINED</xsl:param>
  <xsl:param name="option_color3">UNDEFINED</xsl:param>
  <xsl:param name="option_color4">UNDEFINED</xsl:param>
  <xsl:param name="option_copyright">UNDEFINED</xsl:param>
  <xsl:param name="version">UNDEFINED</xsl:param>
  <xsl:param name="localize_file">UNDEFINED</xsl:param>
  <xsl:param name="option_outer_margin_A4_leftgap">UNDEFINED</xsl:param>
  <xsl:param name="option_outer_margin_A5_leftgap">UNDEFINED</xsl:param>
  <xsl:param name="option_outer_margin_A4_A5">UNDEFINED</xsl:param>
  <xsl:param name="option_inner_margin_A4_leftgap">UNDEFINED</xsl:param>
  <xsl:param name="option_inner_margin_A5_leftgap">UNDEFINED</xsl:param>
  <xsl:param name="option_inner_outer_margin_A4_A5">UNDEFINED</xsl:param>
  <xsl:param name="option_top_margin_A4">UNDEFINED</xsl:param>
  <xsl:param name="option_top_margin_A5">UNDEFINED</xsl:param>
  <xsl:param name="option_bottom_margin_A4">UNDEFINED</xsl:param>
  <xsl:param name="option_bottom_margin_A5">UNDEFINED</xsl:param>
  <xsl:param name="option_bg_block_top">UNDEFINED</xsl:param>
  <xsl:param name="option_bg_block_center">UNDEFINED</xsl:param>
  <xsl:param name="option_default_font_size_A4">UNDEFINED</xsl:param>
  <xsl:param name="option_headline_font_sizes_A4">UNDEFINED</xsl:param>
  <xsl:param name="option_default_font_size_A5">UNDEFINED</xsl:param>
  <xsl:param name="option_headline_font_sizes_A5">UNDEFINED</xsl:param>
  <xsl:param name="option_margin_width_A4">UNDEFINED</xsl:param>
  <xsl:param name="print_format">UNDEFINED</xsl:param>
  <xsl:param name="print_layout">UNDEFINED</xsl:param>
  <xsl:param name="print_paper_format">UNDEFINED</xsl:param>
  <xsl:param name="print_page_margins">UNDEFINED</xsl:param>
  <xsl:param name="print_spaces">UNDEFINED</xsl:param>
  <xsl:param name="print_header">UNDEFINED</xsl:param>
  <xsl:param name="print_footer">UNDEFINED</xsl:param>
  <xsl:param name="print_look_and_feel">UNDEFINED</xsl:param>
  <xsl:param name="print_appendix">UNDEFINED</xsl:param>
  <xsl:param name="print_table_layout">UNDEFINED</xsl:param>
  <xsl:param name="print_chapter_on_right_page">UNDEFINED</xsl:param>
  <!-- From params file (combine-langs → main.xpl); used when coverdata.xml is absent. -->
  <xsl:param name="default_cover_text" select="''"/>
  <xsl:param name="safety_messages_content" select="''"/>
  <xsl:param name="publication_description" select="''"/>
  <xsl:param name="path"/>
  <xsl:param name="owner"/>
  <xsl:param name="created"/>
  <xsl:param name="updated"/>
  <!-- Base directory for resolving topicref @href (same dir as map or absolute). -->
  <!-- Empty = derive from ancestor map (correct when the stylesheet base-uri is not the map). -->
  <xsl:param name="topic-base" select="''"/>
  <!-- Optional coverdata.xml URL; if empty, cover/title from cover-data are skipped. -->
  <xsl:param name="coverdata-href" select="''"/>
  <xsl:param name="mapid" select="''"/>
  <xsl:param name="language" select="(/map/@xml:lang, 'en')[1]"/>
  <xsl:variable name="cover-data" select="if (normalize-space($coverdata-href) != '') then doc($coverdata-href) else ()"/>
  <xsl:template name="make-meta-section">
    <xsl:variable name="pipeline_params_uri" select="     if (exists(/processing-instruction('uwe-viewport-params')))     then replace(normalize-space(string((/processing-instruction('uwe-viewport-params'))[1])), '^uri=', '')     else ''"/>
    <xsl:variable name="_vp" select="if (normalize-space($pipeline_params_uri) != '') then doc($pipeline_params_uri)/*[1] else ()"/>
    <xsl:variable name="_fp" select="$_vp/params"/>
    <xsl:variable name="_lang" select="if (exists($_vp/@id) and string($_vp/@id) != '') then string($_vp/@id) else $language"/>
    <xsl:variable name="effective-language" select="      if (contains($_lang, '-')) then $_lang      else if ($_lang = 'de') then 'de-DE'      else if ($_lang = 'en') then 'en-US'      else $_lang"/>
    <xsl:variable name="effective-mapid" select="      if (exists($_vp/@map) and string($_vp/@map) != '') then replace(string($_vp/@map), '\.ditamap$', '')      else if (normalize-space($mapid) != '') then $mapid else 'map'"/>
    <xsl:variable name="eff_path" select="      if (exists($_vp/@uwe_image_path) and normalize-space(string($_vp/@uwe_image_path)) != '') then string($_vp/@uwe_image_path) else $path"/>
    <xsl:variable name="eff_owner" select="if ($_fp/@owner) then string($_fp/@owner) else $owner"/>
    <xsl:variable name="eff_created" select="if ($_fp/@created) then string($_fp/@created) else $created"/>
    <xsl:variable name="eff_updated" select="if ($_fp/@updated) then string($_fp/@updated) else $updated"/>
    <xsl:variable name="eff_version" select="if ($_fp/@version) then string($_fp/@version) else $version"/>
    <xsl:variable name="eff_publication_description" select="if ($_fp/@publication_description) then string($_fp/@publication_description) else $publication_description"/>
    <xsl:variable name="eff_print_format" select="if ($_fp/@print_format) then string($_fp/@print_format) else $print_format"/>
    <xsl:variable name="eff_print_supplemental_directives" select="if ($_fp/@print_supplemental_directives) then string($_fp/@print_supplemental_directives) else $print_supplemental_directives"/>
    <xsl:variable name="eff_print_toc" select="if ($_fp/@print_toc) then string($_fp/@print_toc) else $print_toc"/>
    <xsl:variable name="eff_print_index" select="if ($_fp/@print_index) then string($_fp/@print_index) else $print_index"/>
    <xsl:variable name="eff_print_footnote_index" select="if ($_fp/@print_footnote_index) then string($_fp/@print_footnote_index) else $print_footnote_index"/>
    <xsl:variable name="eff_print_figure_index" select="if ($_fp/@print_figure_index) then string($_fp/@print_figure_index) else $print_figure_index"/>
    <xsl:variable name="eff_print_chapter_on_right_page" select="if ($_fp/@print_chapter_on_right_page) then string($_fp/@print_chapter_on_right_page) else $print_chapter_on_right_page"/>
    <xsl:variable name="eff_print_cover_backpage" select="if ($_fp/@print_cover_backpage) then string($_fp/@print_cover_backpage) else $print_cover_backpage"/>
    <xsl:variable name="eff_print_appendix" select="if ($_fp/@print_appendix) then string($_fp/@print_appendix) else $print_appendix"/>
    <xsl:variable name="eff_print_layout" select="if ($_fp/@print_layout) then string($_fp/@print_layout) else $print_layout"/>
    <xsl:variable name="eff_print_paper_format" select="if ($_fp/@print_paper_format) then string($_fp/@print_paper_format) else $print_paper_format"/>
    <xsl:variable name="eff_print_page_margins" select="if ($_fp/@print_page_margins) then string($_fp/@print_page_margins) else $print_page_margins"/>
    <xsl:variable name="eff_print_spaces" select="if ($_fp/@print_spaces) then string($_fp/@print_spaces) else $print_spaces"/>
    <xsl:variable name="eff_print_header" select="if ($_fp/@print_header) then string($_fp/@print_header) else $print_header"/>
    <xsl:variable name="eff_print_footer" select="if ($_fp/@print_footer) then string($_fp/@print_footer) else $print_footer"/>
    <xsl:variable name="eff_print_look_and_feel" select="if ($_fp/@print_look_and_feel) then string($_fp/@print_look_and_feel) else $print_look_and_feel"/>
    <xsl:variable name="eff_print_table_layout" select="if ($_fp/@print_table_layout) then string($_fp/@print_table_layout) else $print_table_layout"/>
    <meta>
      <owner>
        <xsl:value-of select="$eff_owner"/>
      </owner>
      <date-of-creation>
        <xsl:value-of select="if (contains($eff_created,'GMT')) then substring-before($eff_created,'GMT') else $eff_created"/>
      </date-of-creation>
      <date-of-last-change>
        <xsl:value-of select="if (contains($eff_updated,'GMT')) then substring-before($eff_updated,'GMT') else $eff_updated"/>
      </date-of-last-change>
      <language>
        <xsl:value-of select="$effective-language"/>
      </language>
      <status>
        <xsl:value-of select="$eff_version"/>
      </status>
      <description>
        <xsl:value-of select="if (normalize-space($eff_publication_description) != '') then $eff_publication_description else string(/map/topicmeta/shortdesc)"/>
      </description>
      <logo-image>
        <xsl:value-of select="concat($eff_path,'logo.png')"/>
      </logo-image>
      <cover-image>
        <xsl:value-of select="concat($eff_path,'cover.png')"/>
      </cover-image>
      <main-title id="{concat($effective-mapid,'-main-title')}">
        <xsl:value-of select="/map/@title"/>
      </main-title>
      <subtitle id="{concat($effective-mapid,'-subtitle')}">
        <xsl:value-of select="/map/topicmeta/navtitle"/>
      </subtitle>
      <cover-text>
        <xsl:choose>
          <xsl:when test="normalize-space($cover-data//*[name()='default-cover-text']) != ''">
            <xsl:value-of select="$cover-data//*[name()='default-cover-text']"/>
          </xsl:when>
          <xsl:when test="normalize-space(string($_fp/default-cover-text)) != ''">
            <xsl:value-of select="string($_fp/default-cover-text)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$default_cover_text"/>
          </xsl:otherwise>
        </xsl:choose>
      </cover-text>
      <structure>
        <format>
          <xsl:value-of select="$eff_print_format"/>
        </format>
        <xsl:if test="$eff_print_supplemental_directives='yes'">
          <supplemental-directives/>
        </xsl:if>
        <xsl:if test="$eff_print_toc='yes'">
          <toc/>
        </xsl:if>
        <xsl:if test="$eff_print_index='yes'">
          <index/>
        </xsl:if>
        <xsl:if test="$eff_print_footnote_index='yes'">
          <footnote-index/>
        </xsl:if>
        <xsl:if test="$eff_print_figure_index='yes'">
          <figure-index/>
        </xsl:if>
        <xsl:if test="$eff_print_chapter_on_right_page='yes'">
          <chapter-on-right-page/>
        </xsl:if>
        <xsl:if test="$eff_print_cover_backpage='yes'">
          <cover-backpage/>
        </xsl:if>
        <xsl:if test="$eff_print_appendix='yes'">
          <appendix>
            <xsl:apply-templates select="/map/topicmeta/othermeta[contains(@name,'appendix') or contains(@name,'memo')]"/>
          </appendix>
        </xsl:if>
      </structure>
      <design>
        <layout>
          <xsl:value-of select="$eff_print_layout"/>
        </layout>
        <paper-format>
          <xsl:value-of select="$eff_print_paper_format"/>
        </paper-format>
        <page-margin>
          <xsl:value-of select="$eff_print_page_margins"/>
        </page-margin>
        <spaces>
          <xsl:value-of select="$eff_print_spaces"/>
        </spaces>
        <header>
          <xsl:value-of select="$eff_print_header"/>
        </header>
        <footer>
          <xsl:value-of select="$eff_print_footer"/>
        </footer>
        <look-and-feel>
          <xsl:value-of select="$eff_print_look_and_feel"/>
        </look-and-feel>
        <table-layout>
          <xsl:value-of select="$eff_print_table_layout"/>
        </table-layout>
      </design>
      <safety-messages>
        <xsl:choose>
          <xsl:when test="normalize-space($cover-data//*[name()='safety-messages']) != ''">
            <xsl:value-of select="$cover-data//*[name()='safety-messages']"/>
          </xsl:when>
          <xsl:when test="normalize-space(string($_fp/safety-messages)) != ''">
            <xsl:value-of select="string($_fp/safety-messages)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$safety_messages_content"/>
          </xsl:otherwise>
        </xsl:choose>
      </safety-messages>
    </meta>
  </xsl:template>
  <xsl:template match="/">
    <document>
      <title>
        <xsl:if test="$cover-data and $cover-data//*[name()='default-manual-title'] != 'n/a'">
          <xsl:value-of select="$cover-data//*[name()='default-manual-title']"/>
        </xsl:if>
        <xsl:if test="not($cover-data)">
          <xsl:value-of select="/map/@title"/>
        </xsl:if>
      </title>
      <xsl:call-template name="make-meta-section"/>
      <xsl:apply-templates select="/map/topicref"/>
    </document>
    <xsl:if test="$cover-data and normalize-space($cover-data//*[name()='default-manual-title']) != ''">
      <xsl:result-document href="{concat('./dita/', translate($cover-data//*[name()='default-manual-title'], ' \[\]:;-+#?!', '________'), '0_book.ditamap')}" method="xml" indent="no">
        <xsl:call-template name="write-dita"/>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>
  <xsl:template name="write-dita">
    <xsl:copy-of select="/map"/>
  </xsl:template>
  <xsl:template match="topicref">
    <xsl:variable name="topic-base-resolved" select="     if (normalize-space($topic-base) != '') then $topic-base     else replace(base-uri(ancestor::map[1]), '[^/\\]+$', '')"/>
    <xsl:variable name="topic-path" select="concat($topic-base-resolved, @href)"/>
    <chapter hyphenation="yes" chapterpage="no" id="{if (@id) then @id else generate-id(.)}" data-src-href="{@href}">
      <xsl:attribute name="ismodule">
        <xsl:choose>
          <xsl:when test="self::task">yes</xsl:when>
          <xsl:otherwise>no</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="document($topic-path)/*">
        <xsl:with-param name="topic-id" select="@id" tunnel="yes"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="topicref"/>
    </chapter>
  </xsl:template>
  <xsl:template match="othermeta[contains(@name,'appendix') or contains(@name,'memo')]">
    <xsl:element name="{@name}">
      <xsl:value-of select="@content"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
