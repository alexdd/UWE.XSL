<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - Sub-pipeline: PDF generation (pretransform + FO + FOP).
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     Input: raw UWE XML + params-doc (viewport iteration doc with params).
     Output: gate count (for synchronization). -->
<p:library xmlns:p="http://www.w3.org/ns/xproc" xmlns:uwe="http://tekturcms.de/uwe/xproc" version="3.0">
  <p:import href="pdf-params-step.xpl"/>
  <p:declare-step type="uwe:pdf-generate" name="pdf-generate">
    <p:input port="source" primary="true"/>
    <p:input port="params-doc"/>
    <p:output port="result" primary="true" sequence="true">
      <p:pipe step="pdf-outputs-gate" port="result"/>
    </p:output>
    <p:option name="config-uri" required="true"/>
    <p:option name="localize-uri" required="true"/>
    <p:option name="document-lang" required="true"/>
    <p:option name="project-root" required="true"/>
    <p:option name="use-cmd-wrapper" select="'true'"/>
    <p:option name="fop-command" select="''"/>
    <p:option name="tmp-lang-dir" required="true"/>
    <p:option name="pdf-href" required="true"/>
    <p:option name="log-base" required="true"/>
    <p:option name="mapname" required="true"/>
    <p:option name="pre-xml-href" required="true"/>
    <!-- Path variables for FOP CLI -->
    <p:variable name="fixed-fo-uri" select="resolve-uri('fixed.fo', $tmp-lang-dir)"/>
    <p:variable name="at-uri" select="resolve-uri('at.xml', $tmp-lang-dir)"/>
    <p:variable name="at2-uri" select="resolve-uri('at2.xml', $tmp-lang-dir)"/>
    <p:variable name="project-path-raw" select="translate(replace($project-root, '^file:/+', '/'), '\', '/')"/>
    <p:variable name="project-path" select="replace(         if (matches($project-path-raw, '^/[A-Za-z]:/')) then substring($project-path-raw, 2) else $project-path-raw,         '/$', '')"/>
    <p:variable name="fop-command-resolved" select="if (normalize-space($fop-command) != '') then translate($fop-command, '\', '/') else concat($project-path, '/lib/fop/fop/fop.bat')"/>
    <p:variable name="fop-config-path" select="concat($project-path, '/conf/fop/fop-generated.xconf')"/>
    <p:variable name="fixed-fo-raw" select="translate(replace($fixed-fo-uri, '^file:/+', '/'), '\', '/')"/>
    <p:variable name="fixed-fo-path" select="if (matches($fixed-fo-raw, '^/[A-Za-z]:/')) then substring($fixed-fo-raw, 2) else $fixed-fo-raw"/>
    <p:variable name="at-raw" select="translate(replace($at-uri, '^file:/+', '/'), '\', '/')"/>
    <p:variable name="at-path" select="if (matches($at-raw, '^/[A-Za-z]:/')) then substring($at-raw, 2) else $at-raw"/>
    <p:variable name="at2-raw" select="translate(replace($at2-uri, '^file:/+', '/'), '\', '/')"/>
    <p:variable name="at2-path" select="if (matches($at2-raw, '^/[A-Za-z]:/')) then substring($at2-raw, 2) else $at2-raw"/>
    <p:variable name="pdf-raw" select="translate(replace($pdf-href, '^file:/+', '/'), '\', '/')"/>
    <p:variable name="pdf-path" select="if (matches($pdf-raw, '^/[A-Za-z]:/')) then substring($pdf-raw, 2) else $pdf-raw"/>
    <p:variable name="win" select="$use-cmd-wrapper = 'true'"/>
    <p:variable name="w-fop-cmd" select="if ($win) then translate($fop-command-resolved, '/', '\') else $fop-command-resolved"/>
    <p:variable name="w-config" select="if ($win) then translate($fop-config-path, '/', '\') else $fop-config-path"/>
    <p:variable name="w-fo" select="if ($win) then translate($fixed-fo-path, '/', '\') else $fixed-fo-path"/>
    <p:variable name="w-at" select="if ($win) then translate($at-path, '/', '\') else $at-path"/>
    <p:variable name="w-at2" select="if ($win) then translate($at2-path, '/', '\') else $at2-path"/>
    <p:variable name="w-pdf" select="if ($win) then translate($pdf-path, '/', '\') else $pdf-path"/>
    <p:variable name="w-cwd" select="if ($win) then translate($project-path, '/', '\') else $project-path"/>
    <p:variable name="fop-exec-command" select="if ($win) then 'cmd' else $fop-command-resolved"/>
    <p:variable name="fop-args-fo-to-at" select="if ($win) then ('/c', $w-fop-cmd, '-c', $w-config, '-fo', $w-fo, '-at', $w-at) else ('-c', $fop-config-path, '-fo', $fixed-fo-path, '-at', $at-path)"/>
    <p:variable name="fop-args-at-to-pdf" select="if ($win) then ('/c', $w-fop-cmd, '-c', $w-config, '-atin', $w-at2, '-pdf', $w-pdf) else ('-c', $fop-config-path, '-atin', $at2-path, '-pdf', $pdf-path)"/>
    <!-- Pretransform + FO generation -->
    <uwe:pdf-pretransform-fo name="pdf-step">
      <p:with-input port="params-doc">
        <p:pipe step="pdf-generate" port="params-doc"/>
      </p:with-input>
      <p:with-input port="source">
        <p:pipe step="pdf-generate" port="source"/>
      </p:with-input>
      <p:with-option name="config-uri" select="$config-uri"/>
      <p:with-option name="localize-uri" select="$localize-uri"/>
      <p:with-option name="document_lang" select="$document-lang"/>
      <p:with-option name="pre-store-href" select="$pre-xml-href"/>
    </uwe:pdf-pretransform-fo>
    <p:xslt name="fofix">
      <p:with-input port="source">
        <p:pipe step="pdf-step" port="result"/>
      </p:with-input>
      <p:with-input port="stylesheet" href="../../pdf/fofix.xsl"/>
    </p:xslt>
    <p:store name="store-fixed-fo">
      <p:with-input port="source">
        <p:pipe step="fofix" port="result"/>
      </p:with-input>
      <p:with-option name="href" select="$fixed-fo-uri"/>
    </p:store>
    <!-- Post-validation: report LINKTARGET errors in FO before FOP -->
    <p:xslt name="fo-link-errors-report" parameters="map{'lang': $document-lang}">
      <p:with-input port="source">
        <p:pipe step="store-fixed-fo" port="result"/>
      </p:with-input>
      <p:with-input port="stylesheet" href="../tools/fo-link-errors.xsl"/>
    </p:xslt>
    <p:store name="store-link-errors-report">
      <p:with-input port="source">
        <p:pipe step="fo-link-errors-report" port="result"/>
      </p:with-input>
      <p:with-option name="href" select="resolve-uri('fo-link-errors-' || $document-lang || '-' || replace($mapname, '\.ditamap$', '.xml'), $log-base)"/>
    </p:store>
    <!-- Trigger: run after store-fixed-fo so fixed.fo is on disk -->
    <p:xslt name="after-fixed-fo">
      <p:with-input port="source">
        <p:pipe step="store-fixed-fo" port="result"/>
      </p:with-input>
      <p:with-input port="stylesheet" href="../../pdf/trigger-done.xsl"/>
    </p:xslt>
    <!-- FOP: fixed.fo -> at.xml -->
    <p:os-exec name="fop-fo-to-at">
      <p:with-option name="command" select="$fop-exec-command"/>
      <p:with-option name="cwd" select="$w-cwd"/>
      <p:with-option name="args" select="$fop-args-fo-to-at"/>
      <p:with-option name="failure-threshold" select="0"/>
      <p:with-input port="source">
        <p:pipe step="after-fixed-fo" port="result"/>
      </p:with-input>
    </p:os-exec>
    <p:xslt name="after-fop-fo-to-at">
      <p:with-input port="source">
        <p:pipe step="fop-fo-to-at" port="result"/>
      </p:with-input>
      <p:with-input port="stylesheet" href="../../pdf/trigger-done.xsl"/>
    </p:xslt>
    <p:xslt name="load-at" parameters="map{'uri': $at-uri}">
      <p:with-input port="source">
        <p:pipe step="after-fop-fo-to-at" port="result"/>
      </p:with-input>
      <p:with-input port="stylesheet" href="../tools/load-by-uri.xsl"/>
    </p:xslt>
    <p:xslt name="at2at">
      <p:with-input port="source">
        <p:pipe step="load-at" port="result"/>
      </p:with-input>
      <p:with-input port="stylesheet" href="../../pdf/at2at.xsl"/>
    </p:xslt>
    <p:store name="store-at2">
      <p:with-input port="source">
        <p:pipe step="at2at" port="result"/>
      </p:with-input>
      <p:with-option name="href" select="$at2-uri"/>
    </p:store>
    <p:xslt name="after-at2">
      <p:with-input port="source">
        <p:pipe step="store-at2" port="result"/>
      </p:with-input>
      <p:with-input port="stylesheet" href="../../pdf/trigger-done.xsl"/>
    </p:xslt>
    <!-- FOP: at2.xml -> PDF -->
    <p:os-exec name="fop-at-to-pdf">
      <p:with-option name="command" select="$fop-exec-command"/>
      <p:with-option name="cwd" select="$w-cwd"/>
      <p:with-option name="args" select="$fop-args-at-to-pdf"/>
      <p:with-option name="failure-threshold" select="0"/>
      <p:with-input port="source">
        <p:pipe step="after-at2" port="result"/>
      </p:with-input>
    </p:os-exec>
    <p:xslt name="after-fop-at-to-pdf">
      <p:with-input port="source">
        <p:pipe step="fop-at-to-pdf" port="result"/>
      </p:with-input>
      <p:with-input port="stylesheet" href="../../pdf/trigger-done.xsl"/>
    </p:xslt>
    <!-- Gate: ensure all side-effect steps complete -->
    <p:count name="pdf-outputs-gate">
      <p:with-input>
        <p:pipe step="after-fop-at-to-pdf" port="result"/>
        <p:pipe step="store-link-errors-report" port="result"/>
      </p:with-input>
    </p:count>
  </p:declare-step>
</p:library>
