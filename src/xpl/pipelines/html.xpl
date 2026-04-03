<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - Sub-pipeline: HTML generation (pre-xml store + XSLT + asset copy).
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     Input: raw UWE XML. Output: gate count (for synchronization). -->
<p:library xmlns:p="http://www.w3.org/ns/xproc" xmlns:uwe="http://tekturcms.de/uwe/xproc" version="3.0">
  <p:declare-step type="uwe:html-generate" name="html-generate">
    <p:input port="source" primary="true"/>
    <p:output port="result" primary="true" sequence="true">
      <p:pipe step="html-outputs-gate" port="result"/>
    </p:output>
    <p:option name="html-dir-href" required="true"/>
    <p:option name="input-images-href" required="true"/>
    <p:option name="res-src-href" required="true"/>
    <p:option name="lang" required="true"/>
    <p:option name="mapname" required="true"/>
    <p:option name="pre-xml-href" required="true"/>
    <!-- Snapshot UWE source before HTML XSLT (same document; no separate pretransform step) -->
    <p:store name="store-pre-html">
      <p:with-input port="source">
        <p:pipe step="html-generate" port="source"/>
      </p:with-input>
      <p:with-option name="href" select="$pre-xml-href"/>
    </p:store>
    <!-- Copy template assets, then replace full library sources with dist-only files -->
    <p:file-copy name="copy-html-res">
      <p:with-option name="href" select="$res-src-href"/>
      <p:with-option name="target" select="$html-dir-href"/>
    </p:file-copy>
    <p:file-delete name="clean-output-lib">
      <p:with-option name="href" select="$html-dir-href || 'res/lib'"/>
      <p:with-option name="recursive" select="true()"/>
    </p:file-delete>
    <p:file-copy name="copy-lib-lunr">
      <p:with-option name="href" select="resolve-uri('lib/lunr/lunr.js', $res-src-href)"/>
      <p:with-option name="target" select="$html-dir-href || 'res/lib/lunr.js'"/>
    </p:file-copy>
    <p:file-copy name="copy-lib-mark">
      <p:with-option name="href" select="resolve-uri('lib/markjs/dist/mark.min.js', $res-src-href)"/>
      <p:with-option name="target" select="$html-dir-href || 'res/lib/mark.min.js'"/>
    </p:file-copy>
    <p:if test="$lang != 'en'" name="copy-lib-lunr-lang">
      <p:file-copy>
        <p:with-option name="href" select="resolve-uri('lib/lunr-languages/lunr.stemmer.support.js', $res-src-href)"/>
        <p:with-option name="target" select="$html-dir-href || 'res/lib/lunr.stemmer.support.js'"/>
      </p:file-copy>
      <p:file-copy>
        <p:with-option name="href" select="resolve-uri('lib/lunr-languages/lunr.' || $lang || '.js', $res-src-href)"/>
        <p:with-option name="target" select="$html-dir-href || 'res/lib/lunr.' || $lang || '.js'"/>
      </p:file-copy>
    </p:if>
    <!-- Copy project images -->
    <p:file-copy name="copy-html-images">
      <p:with-option name="href" select="$input-images-href"/>
      <p:with-option name="target" select="$html-dir-href"/>
    </p:file-copy>
    <!-- Set source base-uri to the html output directory so Saxon resolves
         xsl:result-document relative hrefs against it -->
    <p:set-properties name="html-source-rebase">
      <p:with-input>
        <p:pipe step="store-pre-html" port="result"/>
      </p:with-input>
      <p:with-option name="properties" select="map{'base-uri': resolve-uri('_source.xml', $html-dir-href)}"/>
    </p:set-properties>
    <!-- Native p:xslt transformation; xsl:result-document outputs appear on secondary port -->
    <p:xslt name="html-transform">
      <p:with-input port="source">
        <p:pipe step="html-source-rebase" port="result"/>
      </p:with-input>
      <p:with-input port="stylesheet" href="../../html/uwe.xsl"/>
      <p:with-option name="output-base-uri" select="$html-dir-href"/>
      <p:with-option name="parameters" select="map{'mapid': replace($mapname, '\.ditamap$', '')}"/>
    </p:xslt>
    <!-- Store each xsl:result-document secondary output -->
    <p:for-each name="store-html-files">
      <p:with-input>
        <p:pipe step="html-transform" port="secondary"/>
      </p:with-input>
      <p:output port="result" sequence="true"/>
      <p:variable name="target" select="if (normalize-space(base-uri(/)) != '')           then base-uri(/)           else resolve-uri('../appendix.json', $html-dir-href)"/>
      <p:store name="write-html-file">
        <p:with-option name="href" select="$target"/>
        <p:with-option name="serialization" select="             if (ends-with($target, '.html'))             then map{'method': 'xhtml', 'omit-xml-declaration': true(), 'indent': false()}             else map{'method': 'text'}"/>
      </p:store>
    </p:for-each>
    <p:sink name="sink-html-primary">
      <p:with-input>
        <p:pipe step="html-transform" port="result"/>
      </p:with-input>
    </p:sink>
    <!-- Gate: ensure all side-effect steps complete -->
    <p:count name="html-outputs-gate">
      <p:with-input>
        <p:pipe step="store-html-files" port="result"/>
        <p:pipe step="copy-html-images" port="result"/>
        <p:pipe step="store-pre-html" port="result"/>
      </p:with-input>
    </p:count>
  </p:declare-step>
</p:library>
