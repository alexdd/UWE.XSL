<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text.
     Embeds flattened params into each //l for viewport.
     Source = langs document, param params-doc-uri = conf/params/a4_margin_book.xml. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:param name="params-doc-uri" required="yes"/>
  <xsl:variable name="r" select="doc($params-doc-uri)/*"/>
  <xsl:variable name="font_colors" select="tokenize(normalize-space($r//fcm/font_colors), ',')"/>
  <xsl:variable name="bg_colors" select="tokenize(normalize-space($r//fcm/background_colors), ',')"/>
  <xsl:variable name="outer_inner" select="tokenize(normalize-space($r//fcm/outer_inner_margin), '\|')"/>
  <xsl:variable name="top_bottom" select="tokenize(normalize-space($r//fcm/top_bottom_margin), '\|')"/>
  <xsl:variable name="font_size" select="tokenize(normalize-space($r//fcm/default_font_size), '\|')"/>
  <xsl:variable name="headline_size" select="tokenize(normalize-space($r//fcm/headline_font_size), '\|')"/>
  <xsl:variable name="toc_size" select="tokenize(normalize-space($r//fcm/toc_font_size), '\|')"/>
  <xsl:variable name="params-el">
    <params option_color1="{($font_colors[1], '#E2E0E0')[1]}" option_color2="{($font_colors[2], '#EFEDED')[1]}" option_color3="{($bg_colors[1], '#747575')[1]}" option_color4="{($bg_colors[2], '#7F7F7F')[1]}" option_outer_margin_A4_leftgap="{(tokenize($outer_inner[1], ',')[2], '15')[1]}" option_outer_margin_A5_leftgap="{(tokenize($outer_inner[2], ',')[2], '10')[1]}" option_inner_margin_A4_leftgap="{(tokenize($outer_inner[1], ',')[1], '25')[1]}" option_inner_margin_A5_leftgap="{(tokenize($outer_inner[2], ',')[1], '15')[1]}" option_outer_margin_A4_A5="25" option_inner_outer_margin_A4_A5="25" option_top_margin_A4="{(tokenize($top_bottom[1], ',')[1], '40')[1]}" option_bottom_margin_A4="{(tokenize($top_bottom[1], ',')[2], '20')[1]}" option_top_margin_A5="{(tokenize($top_bottom[2], ',')[1], '35')[1]}" option_bottom_margin_A5="{(tokenize($top_bottom[2], ',')[2], '20')[1]}" option_default_font_size_A4="{($font_size[1], '10')[1]}" option_default_font_size_A5="{($font_size[2], '9')[1]}" option_headline_font_sizes_A4="{($headline_size[1], '16,14,13,11,11')[1]}" option_headline_font_sizes_A5="{($headline_size[2], '12,11,10,9,9')[1]}" option_toc_font_sizes_A4="{($toc_size[1], '16,14,13,11,11')[1]}" option_toc_font_sizes_A5="{($toc_size[2], '12,11,10,9,9')[1]}" option_margin_width_A4="{(normalize-space($r//fcm/margin_width), '30')[1]}" option_default_font_family="{(normalize-space($r//fcm/default_font_family), 'Noto Sans Regular, Noto Sans Symbols, DejaVu Sans')[1]}" print_page_margin="{if (normalize-space($r//layout/margin) = 'true') then 'yes' else 'no'}" print_page_margins="{(normalize-space($r//layout/print_page_margins), 'leftgap')[1]}" print_format="{(normalize-space($r//layout/print_format), 'no')[1]}" print_layout="{(normalize-space($r//layout/print_layout), 'no')[1]}" print_paper_format="{(normalize-space($r//layout/paper_format), 'no')[1]}" print_header="{(normalize-space($r//layout/print_header), if (normalize-space($r//layout/short_header) = 'true') then 'yes' else 'no')[1]}" print_footer="{(normalize-space($r//layout/print_footer), if (normalize-space($r//layout/short_footer) = 'true') then 'yes' else 'no')[1]}" print_look_and_feel="{(normalize-space($r//layout/print_look_and_feel), if (normalize-space($r//layout/fancy_style) = 'true') then 'yes' else 'no')[1]}" print_spaces="{(normalize-space($r//layout/print_spaces), if (normalize-space($r//layout/wide_spaces) = 'true') then 'yes' else 'no')[1]}" print_table_layout="{(normalize-space($r//layout/print_table_layout), if (normalize-space($r//layout/table_borders_only) = 'true') then 'yes' else 'no')[1]}" print_figure_layout="{(normalize-space($r//layout/print_figure_layout), if (normalize-space($r//layout/figure_left_aligned) = 'true') then 'left' else 'no')[1]}" theme="{if (normalize-space($r//theme/fancy_theme) = 'true') then 'fancy' else (if (normalize-space($r//theme/clean_theme) = 'true') then 'clean' else (if (normalize-space($r//theme/two_col_theme) = 'true') then 'two-col' else (if (normalize-space($r//theme/car_book_theme) = 'true') then 'carbook' else 'custom')))}" car_book="{if (normalize-space($r//theme/car_book_theme) = 'true') then 'true' else 'false'}" print_appendix="{if (matches(normalize-space($r//structure/print_appendix), '^(yes|true)$', 'i')) then 'yes' else 'no'}" print_toc="{if (matches(normalize-space($r//structure/print_toc), '^(yes|true)$', 'i')) then 'yes' else 'no'}" print_index="{if (matches(normalize-space($r//structure/print_index), '^(yes|true)$', 'i')) then 'yes' else 'no'}" print_figure_index="{if (matches(normalize-space($r//structure/print_figure_index), '^(yes|true)$', 'i')) then 'yes' else 'no'}" print_footnote_index="{if (matches(normalize-space($r//structure/print_footnote_index), '^(yes|true)$', 'i')) then 'yes' else 'no'}" print_supplemental_directives="{if (matches(normalize-space($r//structure/print_supplemental_directives), '^(yes|true)$', 'i')) then 'yes' else 'no'}" print_chapter_on_right_page="{if (matches(normalize-space($r//structure/print_chapter_on_right_page), '^(yes|true)$', 'i')) then 'yes' else 'no'}" print_cover_backpage="{if (matches(normalize-space($r//structure/print_cover_backpage), '^(yes|true)$', 'i')) then 'yes' else 'no'}" print_watermark="{if (matches(normalize-space($r//structure/print_watermark), '^(yes|true)$', 'i')) then 'yes' else 'no'}" option_copyright="{normalize-space($r//pdf-config/copyright-url)}" imagedir="{if (normalize-space($r//pdf-config/imagedir) != '') then normalize-space($r//pdf-config/imagedir) else '../../test/boilerplate'}" version="{normalize-space($r//publication/version)}" owner="{normalize-space($r//publication/owner)}" created="{normalize-space($r//publication/date-created)}" updated="{normalize-space($r//publication/date-updated)}" publication_description="{normalize-space($r//publication/description)}" option_bg_block_top="{if (normalize-space($r//layout/option_bg_block_top) != '') then normalize-space($r//layout/option_bg_block_top) else 'yes'}" option_bg_block_center="{if (normalize-space($r//layout/option_bg_block_center) != '') then normalize-space($r//layout/option_bg_block_center) else 'yes'}" alphanum-prefix1="{if (normalize-space($r//publication/alphanum-prefix1) != '') then normalize-space($r//publication/alphanum-prefix1) else 'AAA'}" alphanum-prefix2="{if (normalize-space($r//publication/alphanum-prefix2) != '') then normalize-space($r//publication/alphanum-prefix2) else 'HHH'}" alphanum-prefix3="{if (normalize-space($r//publication/alphanum-prefix3) != '') then normalize-space($r//publication/alphanum-prefix3) else 'GGG'}">
      <default-cover-text>
        <xsl:value-of select="$r//cover/default_cover_text"/>
      </default-cover-text>
      <safety-messages>
        <xsl:value-of select="$r//cover/safety_messages"/>
      </safety-messages>
    </params>
  </xsl:variable>
  <xsl:template match="/">
    <xsl:apply-templates select="/*" mode="combine"/>
  </xsl:template>
  <xsl:template match="*" mode="combine">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="node()" mode="combine"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="l" mode="combine">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="$params-el"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
