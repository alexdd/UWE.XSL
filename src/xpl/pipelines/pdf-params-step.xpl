<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - Sub-pipeline: params doc + UWE source → pretransform + FO.
     Params and XSLT option maps are kept here so pipeline.xpl stays small.
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     Inputs: params-doc (primary) = viewport iteration doc with /*/params; source = UWE XML.
     Outputs: pre = pretransform result; result = FO. pre-store-href receives the
     on-disk copy of the pretransform (pre_pdf.xml under …/uwe/ in main.xpl).
     FO entry: p:load of carbook.xsl vs uwe.xsl from /*/params/@car_book, then p:xslt name uwe-fo. -->
<p:library xmlns:p="http://www.w3.org/ns/xproc" xmlns:uwe="http://tekturcms.de/uwe/xproc" version="3.0">
  <p:declare-step type="uwe:pdf-pretransform-fo">
    <p:input port="params-doc" primary="true"/>
    <p:input port="source"/>
    <p:output port="pre">
      <p:pipe step="pretransform" port="result"/>
    </p:output>
    <p:output port="result">
      <p:pipe step="uwe-fo" port="result"/>
    </p:output>
    <p:option name="config-uri" select="''"/>
    <p:option name="localize-uri" select="''"/>
    <p:option name="document_lang" select="''"/>
    <p:option name="pre-store-href" required="true"/>
    <!-- Language from viewport (params-doc root is <l id="de"> etc.); passed to pretransform so meta/language is set for collation -->
    <p:variable name="doc_lang" select="string(/*/@id)"/>
    <!-- Params from conf/params/a4_margin_book.xml (embedded in /*/params by combine-langs-params) -->
    <p:variable name="p_option_color1" select="string(/*/params/@option_color1)"/>
    <p:variable name="p_option_color2" select="string(/*/params/@option_color2)"/>
    <p:variable name="p_option_color3" select="string(/*/params/@option_color3)"/>
    <p:variable name="p_option_color4" select="string(/*/params/@option_color4)"/>
    <p:variable name="p_option_outer_margin_A4_leftgap" select="string(/*/params/@option_outer_margin_A4_leftgap)"/>
    <p:variable name="p_option_outer_margin_A5_leftgap" select="string(/*/params/@option_outer_margin_A5_leftgap)"/>
    <p:variable name="p_option_inner_margin_A4_leftgap" select="string(/*/params/@option_inner_margin_A4_leftgap)"/>
    <p:variable name="p_option_inner_margin_A5_leftgap" select="string(/*/params/@option_inner_margin_A5_leftgap)"/>
    <p:variable name="p_option_outer_margin_A4_A5" select="string(/*/params/@option_outer_margin_A4_A5)"/>
    <p:variable name="p_option_inner_outer_margin_A4_A5" select="string(/*/params/@option_inner_outer_margin_A4_A5)"/>
    <p:variable name="p_option_top_margin_A4" select="string(/*/params/@option_top_margin_A4)"/>
    <p:variable name="p_option_bottom_margin_A4" select="string(/*/params/@option_bottom_margin_A4)"/>
    <p:variable name="p_option_top_margin_A5" select="string(/*/params/@option_top_margin_A5)"/>
    <p:variable name="p_option_bottom_margin_A5" select="string(/*/params/@option_bottom_margin_A5)"/>
    <p:variable name="p_option_default_font_size_A4" select="string(/*/params/@option_default_font_size_A4)"/>
    <p:variable name="p_option_default_font_size_A5" select="string(/*/params/@option_default_font_size_A5)"/>
    <p:variable name="p_option_headline_font_sizes_A4" select="string(/*/params/@option_headline_font_sizes_A4)"/>
    <p:variable name="p_option_headline_font_sizes_A5" select="string(/*/params/@option_headline_font_sizes_A5)"/>
    <p:variable name="p_option_margin_width_A4" select="string(/*/params/@option_margin_width_A4)"/>
    <p:variable name="p_print_page_margin" select="string(/*/params/@print_page_margin)"/>
    <p:variable name="p_print_header" select="string(/*/params/@print_header)"/>
    <p:variable name="p_print_footer" select="string(/*/params/@print_footer)"/>
    <p:variable name="p_print_look_and_feel" select="string(/*/params/@print_look_and_feel)"/>
    <p:variable name="p_print_spaces" select="string(/*/params/@print_spaces)"/>
    <p:variable name="p_print_table_layout" select="string(/*/params/@print_table_layout)"/>
    <p:variable name="p_print_paper_format" select="string(/*/params/@print_paper_format)"/>
    <p:variable name="p_theme" select="string(/*/params/@theme)"/>
    <p:variable name="p_print_appendix" select="string(/*/params/@print_appendix)"/>
    <p:variable name="p_print_format" select="string(/*/params/@print_format)"/>
    <p:variable name="p_print_layout" select="string(/*/params/@print_layout)"/>
    <p:variable name="p_print_page_margins" select="string(/*/params/@print_page_margins)"/>
    <p:variable name="p_print_figure_layout" select="string(/*/params/@print_figure_layout)"/>
    <p:variable name="p_print_chapter_on_right_page" select="string(/*/params/@print_chapter_on_right_page)"/>
    <p:variable name="p_print_toc" select="string(/*/params/@print_toc)"/>
    <p:variable name="p_print_index" select="string(/*/params/@print_index)"/>
    <p:variable name="p_print_figure_index" select="string(/*/params/@print_figure_index)"/>
    <p:variable name="p_print_footnote_index" select="string(/*/params/@print_footnote_index)"/>
    <p:variable name="p_print_supplemental_directives" select="string(/*/params/@print_supplemental_directives)"/>
    <p:variable name="p_print_cover_backpage" select="string(/*/params/@print_cover_backpage)"/>
    <p:variable name="p_print_watermark" select="string(/*/params/@print_watermark)"/>
    <p:variable name="p_option_toc_font_sizes_A4" select="string(/*/params/@option_toc_font_sizes_A4)"/>
    <p:variable name="p_option_toc_font_sizes_A5" select="string(/*/params/@option_toc_font_sizes_A5)"/>
    <p:variable name="p_option_default_font_family" select="string(/*/params/@option_default_font_family)"/>
    <p:variable name="p_car_book" select="string(/*/params/@car_book)"/>
    <p:variable name="uwe-fo-params" select="map{         'pdf_config_uri': $config-uri,         'localize_file': $localize-uri,         'lang': (if (string($document_lang) != '') then $document_lang else $doc_lang),         'option_color1': $p_option_color1,         'option_color2': $p_option_color2,         'option_color3': $p_option_color3,         'option_color4': $p_option_color4,         'option_outer_margin_A4_leftgap': $p_option_outer_margin_A4_leftgap,         'option_outer_margin_A5_leftgap': $p_option_outer_margin_A5_leftgap,         'option_inner_margin_A4_leftgap': $p_option_inner_margin_A4_leftgap,         'option_inner_margin_A5_leftgap': $p_option_inner_margin_A5_leftgap,         'option_outer_margin_A4_A5': $p_option_outer_margin_A4_A5,         'option_inner_outer_margin_A4_A5': $p_option_inner_outer_margin_A4_A5,         'option_top_margin_A4': $p_option_top_margin_A4,         'option_bottom_margin_A4': $p_option_bottom_margin_A4,         'option_top_margin_A5': $p_option_top_margin_A5,         'option_bottom_margin_A5': $p_option_bottom_margin_A5,         'option_default_font_size_A4': $p_option_default_font_size_A4,         'option_default_font_size_A5': $p_option_default_font_size_A5,         'option_headline_font_sizes_A4': $p_option_headline_font_sizes_A4,         'option_headline_font_sizes_A5': $p_option_headline_font_sizes_A5,         'option_margin_width_A4': $p_option_margin_width_A4,         'print_page_margin': $p_print_page_margin,         'print_header': $p_print_header,         'print_footer': $p_print_footer,         'print_look_and_feel': $p_print_look_and_feel,         'print_spaces': $p_print_spaces,         'print_table_layout': $p_print_table_layout,         'print_paper_format': $p_print_paper_format,         'theme': $p_theme,         'print_format': $p_print_format,         'print_layout': $p_print_layout,         'print_page_margins': $p_print_page_margins,         'print_chapter_on_right_page': $p_print_chapter_on_right_page,         'print_figure_layout': $p_print_figure_layout,         'option_toc_font_sizes_A4': $p_option_toc_font_sizes_A4,         'option_toc_font_sizes_A5': $p_option_toc_font_sizes_A5,         'option_default_font_family': $p_option_default_font_family,         'car_book': $p_car_book       }"/>
    <p:xslt name="pretransform">
      <p:with-input port="source">
        <p:pipe port="source"/>
      </p:with-input>
      <p:with-input port="stylesheet" href="../../pdf/pretransformation.xsl"/>
      <p:with-option name="parameters" select="map{         'localize_file': $localize-uri,         'lang': $doc_lang,         'print_appendix': $p_print_appendix,         'print_toc': $p_print_toc,         'print_index': $p_print_index,         'print_figure_index': $p_print_figure_index,         'print_footnote_index': $p_print_footnote_index,         'print_supplemental_directives': $p_print_supplemental_directives,         'print_cover_backpage': $p_print_cover_backpage,         'print_watermark': $p_print_watermark       }"/>
    </p:xslt>
    <p:store name="store-pre-pdf">
      <p:with-input port="source">
        <p:pipe step="pretransform" port="result"/>
      </p:with-input>
      <p:with-option name="href" select="$pre-store-href"/>
    </p:store>
    <p:variable name="fo-stylesheet-uri" select="if ($p_car_book = 'true') then resolve-uri('../../pdf/carbook.xsl', static-base-uri()) else resolve-uri('../../pdf/uwe.xsl', static-base-uri())"/>
    <p:load name="load-fo-stylesheet">
      <p:with-option name="href" select="$fo-stylesheet-uri"/>
    </p:load>
    <p:xslt name="uwe-fo">
      <p:with-input port="source">
        <p:pipe step="store-pre-pdf" port="result"/>
      </p:with-input>
      <p:with-input port="stylesheet">
        <p:pipe step="load-fo-stylesheet" port="result"/>
      </p:with-input>
      <p:with-option name="parameters" select="$uwe-fo-params"/>
    </p:xslt>
  </p:declare-step>
</p:library>
