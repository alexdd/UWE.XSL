<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets (XProc 3.0)
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     FOP via p:os-exec (or use extension JAR for in-process FOP). -->
<p:library xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:uwe="http://tekturcms.de/uwe/xproc" version="3.0">
  <p:import href="pipelines/pdf.xpl"/>
  <p:import href="pipelines/html.xpl"/>
  <p:declare-step name="main">
    <p:option name="input-base" select="resolve-uri('../../test/input/XmlHandsOn/', static-base-uri())"/>
    <p:option name="output-base" select="resolve-uri('../../test/output/XmlHandsOn/', static-base-uri())"/>
    <p:option name="log-base" select="resolve-uri('../../test/logs/', static-base-uri())"/>
    <p:option name="tmp-base" select="resolve-uri('../../test/tmp/', static-base-uri())"/>
    <p:option name="project-root" select="resolve-uri('../../', static-base-uri())"/>
    <p:option name="use-cmd-wrapper" select="'true'"/>
    <p:option name="fop-command" select="''"/>
    <p:variable name="config-uri" select="resolve-uri('conf/params/a4_margin_book.xml', $project-root)"/>
    <p:variable name="localize-uri" select="resolve-uri('../localize.xml', static-base-uri())"/>
    <p:variable name="clean-dirs-uri" select="resolve-uri('tools/clean-output-dirs.xml', static-base-uri())"/>
    <p:variable name="params-href" select="resolve-uri('conf/params/a4_margin_book.xml', $project-root)"/>
    <p:output port="result" primary="true">
      <p:pipe step="result-summary" port="result"/>
    </p:output>
    <!-- Clean: build list (lang × subdir) from config, then delete and create each path -->
    <p:load name="load-localize">
      <p:with-option name="href" select="$localize-uri"/>
    </p:load>
    <p:xslt name="extract-langs">
      <p:with-input port="source">
        <p:pipe step="load-localize" port="result"/>
      </p:with-input>
      <p:with-input port="stylesheet" href="tools/extract-langs.xsl"/>
    </p:xslt>
    <p:xslt name="expand-clean-paths" parameters="map{'output-dirs-uri': $clean-dirs-uri}">
      <p:with-input port="source">
        <p:pipe step="extract-langs" port="result"/>
      </p:with-input>
      <p:with-input port="stylesheet" href="tools/expand-clean-paths.xsl"/>
    </p:xslt>
    <p:for-each name="clean-each-dir">
      <p:with-input select="//path">
        <p:pipe step="expand-clean-paths" port="result"/>
      </p:with-input>
      <p:output port="result" sequence="true"/>
      <p:variable name="clean-href" select="resolve-uri(string(/*/@lang) || '/' || string(/*/@subdir), $output-base)"/>
      <p:file-delete name="clean-dir">
        <p:with-option name="href" select="$clean-href"/>
        <p:with-option name="recursive" select="true()"/>
        <p:with-option name="fail-on-error" select="false()"/>
      </p:file-delete>
      <p:file-mkdir name="mkdir-dir">
        <p:with-option name="href" select="$clean-href"/>
      </p:file-mkdir>
      <p:identity name="clean-out"/>
    </p:for-each>
    <p:file-delete name="clean-tmp-dir">
      <p:with-option name="href" select="$tmp-base"/>
      <p:with-option name="recursive" select="true()"/>
      <p:with-option name="fail-on-error" select="false()"/>
    </p:file-delete>
    <p:file-mkdir name="mkdir-tmp-dir">
      <p:with-option name="href" select="$tmp-base"/>
    </p:file-mkdir>
    <p:for-each name="mkdir-tmp-lang-dirs">
      <p:with-input select="//l">
        <p:pipe step="extract-langs" port="result"/>
      </p:with-input>
      <p:output port="result" sequence="true"/>
      <p:variable name="tmp-lang-href" select="resolve-uri(string(/*/@id), $tmp-base)"/>
      <p:file-mkdir name="mkdir-tmp-lang-dir">
        <p:with-option name="href" select="$tmp-lang-href"/>
      </p:file-mkdir>
      <p:identity name="tmp-lang-out"/>
    </p:for-each>
    <p:xslt name="combine-langs-params" parameters="map{'params-doc-uri': $params-href}">
      <p:with-input port="source">
        <p:pipe step="extract-langs" port="result"/>
      </p:with-input>
      <p:with-input port="stylesheet" href="tools/combine-langs-params.xsl"/>
    </p:xslt>
    <!-- Gate: ensure all clean/mkdir steps complete before the viewport starts.
       Without this, XProc's graph-based execution may interleave clean-each-dir
       with per-lang, deleting output the viewport has already written. -->
    <p:count name="clean-gate">
      <p:with-input>
        <p:pipe step="clean-each-dir" port="result"/>
        <p:pipe step="mkdir-tmp-lang-dirs" port="result"/>
      </p:with-input>
    </p:count>
    <p:insert name="viewport-ready" match="/*" position="last-child">
      <p:with-input port="source">
        <p:pipe step="combine-langs-params" port="result"/>
      </p:with-input>
      <p:with-input port="insertion">
        <p:pipe step="clean-gate" port="result"/>
      </p:with-input>
    </p:insert>
    <p:delete name="viewport-input" match="c:result">
      <p:with-input>
        <p:pipe step="viewport-ready" port="result"/>
      </p:with-input>
    </p:delete>
    <p:load name="load-config">
      <p:with-option name="href" select="$config-uri"/>
    </p:load>
    <p:xslt name="params-pdf" parameters="map{'project-root': $project-root}">
      <p:with-input port="source">
        <p:pipe step="load-config" port="result"/>
      </p:with-input>
      <p:with-input port="stylesheet" href="tools/param-pdf-uris.xsl"/>
    </p:xslt>
    <!-- For each language: map2uwe, validate, then delegate to PDF and HTML sub-pipelines -->
    <p:viewport name="per-lang" match="//l">
      <p:with-input>
        <p:pipe step="viewport-input" port="result"/>
      </p:with-input>
      <p:output port="result" sequence="true">
        <p:pipe step="out-status" port="result"/>
      </p:output>
      <p:variable name="lang" select="string(/*/@id)"/>
      <p:variable name="mapname" select="string(/*/@map)"/>
      <p:variable name="in-href" select="resolve-uri($lang || '/' || $mapname, $input-base)"/>
      <p:variable name="out-name" select="replace($mapname, '\.ditamap$', '.uwe.xml')"/>
      <p:variable name="out-href" select="resolve-uri($lang || '/uwe/' || $out-name, $output-base)"/>
      <p:variable name="pre-html-href" select="resolve-uri($lang || '/uwe/pre_html.xml', $output-base)"/>
      <p:variable name="pre-pdf-href" select="resolve-uri($lang || '/uwe/pre_pdf.xml', $output-base)"/>
      <p:variable name="viewport-params-href" select="resolve-uri($lang || '/uwe/.pipeline_viewport.xml', $output-base)"/>
      <p:variable name="tmp-lang-dir" select="resolve-uri($lang || '/', $tmp-base)"/>
      <p:variable name="pdf-href" select="resolve-uri($lang || '/pdf/' || $lang || '.pdf', $output-base)"/>
      <p:variable name="html-dir-href" select="resolve-uri($lang || '/html/', $output-base)"/>
      <p:variable name="html-start-href" select="resolve-uri($lang || '/html/index.html', $output-base)"/>
      <p:variable name="input-images-href" select="resolve-uri('images/', $input-base)"/>
      <p:variable name="res-src-href" select="resolve-uri('../html/res/', static-base-uri())"/>
      <p:identity name="viewport-doc"/>
      <!-- Enrich <l> with pipeline-only paths (XPath in Calabash has no map:* for dynamic param maps). -->
      <p:add-attribute name="l-enrich-path" match="/*" attribute-name="uwe_image_path">
        <p:with-option name="attribute-value" select="string(resolve-uri('images/', $input-base))"/>
        <p:with-input port="source">
          <p:pipe step="viewport-doc" port="result"/>
        </p:with-input>
      </p:add-attribute>
      <p:add-attribute name="l-enriched" match="/*" attribute-name="localize_file">
        <p:with-option name="attribute-value" select="string($localize-uri)"/>
        <p:with-input port="source">
          <p:pipe step="l-enrich-path" port="result"/>
        </p:with-input>
      </p:add-attribute>
      <p:add-attribute name="l-with-viewport-uri" match="/*" attribute-name="uwe_viewport_uri">
        <p:with-option name="attribute-value" select="string($viewport-params-href)"/>
        <p:with-input port="source">
          <p:pipe step="l-enriched" port="result"/>
        </p:with-input>
      </p:add-attribute>
      <p:store name="store-viewport-l">
        <p:with-input port="source">
          <p:pipe step="l-with-viewport-uri" port="result"/>
        </p:with-input>
        <p:with-option name="href" select="$viewport-params-href"/>
      </p:store>
      <!-- Ensure store finishes before map2uwe reads doc($viewport-params-href): sequence [store ack, map]. -->
      <p:load name="load-map">
        <p:with-option name="href" select="$in-href"/>
        <p:with-option name="content-type" select="'application/xml'"/>
      </p:load>
      <p:add-attribute name="map-with-xml-base" match="/map" attribute-name="xml:base">
        <p:with-option name="attribute-value" select="string($in-href)"/>
        <p:with-input port="source">
          <p:pipe step="load-map" port="result"/>
        </p:with-input>
      </p:add-attribute>
      <p:identity name="store-then-map-order">
        <p:with-input port="source">
          <p:pipe step="store-viewport-l" port="result"/>
          <p:pipe step="map-with-xml-base" port="result"/>
        </p:with-input>
      </p:identity>
      <p:split-sequence name="map-doc-only" test="position() = 2">
        <p:with-input port="source">
          <p:pipe step="store-then-map-order" port="result"/>
        </p:with-input>
      </p:split-sequence>
      <p:wrap-sequence wrapper="uwe-viewport-inject" name="wrapped-map">
        <p:with-input port="source">
          <p:pipe step="map-doc-only" port="matched"/>
        </p:with-input>
      </p:wrap-sequence>
      <p:add-attribute name="wrapped-with-uri" match="/*" attribute-name="viewport-uri">
        <p:with-option name="attribute-value" select="$viewport-params-href"/>
        <p:with-input port="source">
          <p:pipe step="wrapped-map" port="result"/>
        </p:with-input>
      </p:add-attribute>
      <p:xslt name="inject-viewport-uri-pi-xsl">
        <p:with-input port="source">
          <p:pipe step="wrapped-with-uri" port="result"/>
        </p:with-input>
        <p:with-input port="stylesheet" href="tools/inject-viewport-uri-pi.xsl"/>
      </p:xslt>
      <p:xslt name="transform">
        <p:with-input port="source">
          <p:pipe step="inject-viewport-uri-pi-xsl" port="result"/>
        </p:with-input>
        <p:with-input port="stylesheet" href="../map2uwe.xsl"/>
      </p:xslt>
      <p:xslt name="params-map">
        <p:with-input port="source">
          <p:pipe step="load-map" port="result"/>
        </p:with-input>
        <p:with-input port="stylesheet" href="tools/param-map-href.xsl"/>
      </p:xslt>
      <!-- Validate resolve and store UWE + SVRL -->
      <p:xslt name="validate-resolve">
        <p:with-input port="source">
          <p:pipe step="transform" port="result"/>
        </p:with-input>
        <p:with-input port="stylesheet" href="tools/uwe-resolves-topics.xsl"/>
        <p:with-option name="parameters" select="map{'map-href': $in-href}"/>
      </p:xslt>
      <p:store name="store-uwe">
        <p:with-input port="source">
          <p:pipe step="transform" port="result"/>
        </p:with-input>
        <p:with-option name="href" select="$out-href"/>
      </p:store>
      <p:xslt name="abort-on-resolve-error">
        <p:with-input port="source">
          <p:pipe step="validate-resolve" port="result"/>
        </p:with-input>
        <p:with-input port="stylesheet" href="tools/uwe-resolve-abort-on-error.xsl"/>
      </p:xslt>
      <p:sink name="sink-abort">
        <p:with-input port="source">
          <p:pipe step="abort-on-resolve-error" port="result"/>
        </p:with-input>
      </p:sink>
      <p:store name="store-svrl">
        <p:with-input port="source">
          <p:pipe step="validate-resolve" port="result"/>
        </p:with-input>
        <p:with-option name="href" select="resolve-uri('uwe-resolve-' || $lang || '-' || replace($mapname, '\.ditamap$', '.svrl.xml'), $log-base)"/>
      </p:store>
      <!-- HTML first: pre_html.xml + site (so a late PDF/FOP failure still leaves HTML + pre) -->
      <uwe:html-generate name="html-gen">
        <p:with-input port="source">
          <p:pipe step="transform" port="result"/>
        </p:with-input>
        <p:with-option name="html-dir-href" select="$html-dir-href"/>
        <p:with-option name="input-images-href" select="$input-images-href"/>
        <p:with-option name="res-src-href" select="$res-src-href"/>
        <p:with-option name="lang" select="$lang"/>
        <p:with-option name="mapname" select="$mapname"/>
        <p:with-option name="pre-xml-href" select="$pre-html-href"/>
      </uwe:html-generate>
      <!-- PDF generation (pretransform + FO + FOP); writes pre_pdf.xml in pdf-step -->
      <uwe:pdf-generate name="pdf-gen">
        <p:with-input port="source">
          <p:pipe step="transform" port="result"/>
        </p:with-input>
        <p:with-input port="params-doc">
          <p:pipe step="viewport-doc" port="result"/>
        </p:with-input>
        <p:with-option name="config-uri" select="$config-uri"/>
        <p:with-option name="localize-uri" select="$localize-uri"/>
        <p:with-option name="document-lang" select="$lang"/>
        <p:with-option name="project-root" select="$project-root"/>
        <p:with-option name="use-cmd-wrapper" select="$use-cmd-wrapper"/>
        <p:with-option name="fop-command" select="$fop-command"/>
        <p:with-option name="tmp-lang-dir" select="$tmp-lang-dir"/>
        <p:with-option name="pdf-href" select="$pdf-href"/>
        <p:with-option name="log-base" select="$log-base"/>
        <p:with-option name="mapname" select="$mapname"/>
        <p:with-option name="pre-xml-href" select="$pre-pdf-href"/>
      </uwe:pdf-generate>
      <!-- Gate: ensure sub-pipelines and validation stores complete -->
      <p:count name="all-outputs-gate">
        <p:with-input>
          <p:pipe step="pdf-gen" port="result"/>
          <p:pipe step="html-gen" port="result"/>
          <p:pipe step="store-svrl" port="result"/>
        </p:with-input>
      </p:count>
      <p:add-attribute name="out-lang" match="/*" attribute-name="lang">
        <p:with-input port="source">
          <p:pipe step="all-outputs-gate" port="result"/>
        </p:with-input>
        <p:with-option name="attribute-value" select="$lang"/>
      </p:add-attribute>
      <p:add-attribute name="out-pdf" match="/*" attribute-name="pdf">
        <p:with-input port="source">
          <p:pipe step="out-lang" port="result"/>
        </p:with-input>
        <p:with-option name="attribute-value" select="$pdf-href"/>
      </p:add-attribute>
      <p:add-attribute name="out-html" match="/*" attribute-name="html">
        <p:with-input port="source">
          <p:pipe step="out-pdf" port="result"/>
        </p:with-input>
        <p:with-option name="attribute-value" select="$html-start-href"/>
      </p:add-attribute>
      <p:add-attribute name="out-status" match="/*" attribute-name="status">
        <p:with-input port="source">
          <p:pipe step="out-html" port="result"/>
        </p:with-input>
        <p:with-option name="attribute-value" select="'ok'"/>
      </p:add-attribute>
    </p:viewport>
    <p:wrap-sequence wrapper="pipeline-run" name="result-summary">
      <p:with-input port="source">
        <p:pipe step="per-lang" port="result"/>
      </p:with-input>
    </p:wrap-sequence>
  </p:declare-step>
</p:library>
