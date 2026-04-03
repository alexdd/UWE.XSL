<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets (XProc 3.0 validation)
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text.
     Run: scripts/run.bat validate.xpl  or  scripts/run.sh validate.xpl -->
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:err="http://www.w3.org/ns/xproc-error" name="main" version="3.0">
  <p:option name="input-base" select="resolve-uri('../../../test/input/XmlHandsOn/', static-base-uri())"/>
  <p:option name="output-base" select="resolve-uri('../../../test/validate-output/XmlHandsOn/', static-base-uri())"/>
  <p:option name="log-href" select="resolve-uri('../../../test/logs/validate-run.xml', static-base-uri())"/>
  <p:option name="sch-href" select="resolve-uri('../../sch/validate.sch', static-base-uri())"/>
  <!-- ── DE ────────────────────────────────────────────────── -->
  <p:directory-list name="list-de">
    <p:with-option name="path" select="concat($input-base, 'de')"/>
    <p:with-option name="include-filter" select="'.*\.(dita|ditamap)$'"/>
  </p:directory-list>
  <p:for-each name="process-de">
    <p:with-input select="//c:file">
      <p:pipe step="list-de" port="result"/>
    </p:with-input>
    <p:output port="result" sequence="true"/>
    <p:variable name="name" select="/*/@name"/>
    <p:variable name="in-href" select="resolve-uri(concat('de/', $name), $input-base)"/>
    <p:variable name="out-href" select="resolve-uri(concat('de/', $name), $output-base)"/>
    <p:try name="try-de">
      <p:output port="result" primary="true" sequence="true"/>
      <p:group>
        <p:load name="dtd-loaded-de" parameters="map{QName('','dtd-validate'): true()}">
          <p:with-option name="href" select="$in-href"/>
          <p:with-option name="content-type" select="'application/xml'"/>
        </p:load>
        <p:store name="store-de">
          <p:with-input port="source">
            <p:pipe step="dtd-loaded-de" port="result"/>
          </p:with-input>
          <p:with-option name="href" select="$out-href"/>
        </p:store>
        <p:load name="load-sch-de">
          <p:with-option name="href" select="$sch-href"/>
        </p:load>
        <p:xslt name="compile-de">
          <p:with-input port="source">
            <p:pipe step="load-sch-de" port="result"/>
          </p:with-input>
          <p:with-input port="stylesheet" href="../../../lib/schxslt/core/src/main/resources/xslt/2.0/pipeline-for-svrl.xsl"/>
        </p:xslt>
        <p:xslt name="svrl-de">
          <p:with-input port="source">
            <p:pipe step="dtd-loaded-de" port="result"/>
          </p:with-input>
          <p:with-input port="stylesheet">
            <p:pipe step="compile-de" port="result"/>
          </p:with-input>
        </p:xslt>
        <p:choose>
          <p:when test="//svrl:successful-report">
            <p:output port="result"/>
            <p:wrap-sequence wrapper="schematron-error"/>
            <p:add-attribute match="/*" attribute-name="file">
              <p:with-option name="attribute-value" select="concat('de/', $name)"/>
            </p:add-attribute>
          </p:when>
          <p:otherwise>
            <p:output port="result"/>
            <p:sink/>
            <p:identity>
              <p:with-input>
                <p:inline>
                  <valid/>
                </p:inline>
              </p:with-input>
            </p:identity>
            <p:add-attribute match="/*" attribute-name="file">
              <p:with-option name="attribute-value" select="concat('de/', $name)"/>
            </p:add-attribute>
          </p:otherwise>
        </p:choose>
      </p:group>
      <p:catch name="catch-de">
        <p:output port="result" primary="true" sequence="true"/>
        <p:identity>
          <p:with-input port="source">
            <p:pipe step="catch-de" port="error"/>
          </p:with-input>
        </p:identity>
        <p:wrap-sequence wrapper="dtd-error"/>
        <p:add-attribute match="/*" attribute-name="file">
          <p:with-option name="attribute-value" select="concat('de/', $name)"/>
        </p:add-attribute>
      </p:catch>
    </p:try>
  </p:for-each>
  <!-- ── EN ────────────────────────────────────────────────── -->
  <p:sink>
    <p:with-input port="source">
      <p:pipe step="process-de" port="result"/>
    </p:with-input>
  </p:sink>
  <p:directory-list name="list-en">
    <p:with-option name="path" select="concat($input-base, 'en')"/>
    <p:with-option name="include-filter" select="'.*\.(dita|ditamap)$'"/>
  </p:directory-list>
  <p:for-each name="process-en">
    <p:with-input select="//c:file">
      <p:pipe step="list-en" port="result"/>
    </p:with-input>
    <p:output port="result" sequence="true"/>
    <p:variable name="name" select="/*/@name"/>
    <p:variable name="in-href" select="resolve-uri(concat('en/', $name), $input-base)"/>
    <p:variable name="out-href" select="resolve-uri(concat('en/', $name), $output-base)"/>
    <p:try name="try-en">
      <p:output port="result" primary="true" sequence="true"/>
      <p:group>
        <p:load name="dtd-loaded-en" parameters="map{QName('','dtd-validate'): true()}">
          <p:with-option name="href" select="$in-href"/>
          <p:with-option name="content-type" select="'application/xml'"/>
        </p:load>
        <p:store name="store-en">
          <p:with-input port="source">
            <p:pipe step="dtd-loaded-en" port="result"/>
          </p:with-input>
          <p:with-option name="href" select="$out-href"/>
        </p:store>
        <p:load name="load-sch-en">
          <p:with-option name="href" select="$sch-href"/>
        </p:load>
        <p:xslt name="compile-en">
          <p:with-input port="source">
            <p:pipe step="load-sch-en" port="result"/>
          </p:with-input>
          <p:with-input port="stylesheet" href="../../../lib/schxslt/core/src/main/resources/xslt/2.0/pipeline-for-svrl.xsl"/>
        </p:xslt>
        <p:xslt name="svrl-en">
          <p:with-input port="source">
            <p:pipe step="dtd-loaded-en" port="result"/>
          </p:with-input>
          <p:with-input port="stylesheet">
            <p:pipe step="compile-en" port="result"/>
          </p:with-input>
        </p:xslt>
        <p:choose>
          <p:when test="//svrl:successful-report">
            <p:output port="result"/>
            <p:wrap-sequence wrapper="schematron-error"/>
            <p:add-attribute match="/*" attribute-name="file">
              <p:with-option name="attribute-value" select="concat('en/', $name)"/>
            </p:add-attribute>
          </p:when>
          <p:otherwise>
            <p:output port="result"/>
            <p:sink/>
            <p:identity>
              <p:with-input>
                <p:inline>
                  <valid/>
                </p:inline>
              </p:with-input>
            </p:identity>
            <p:add-attribute match="/*" attribute-name="file">
              <p:with-option name="attribute-value" select="concat('en/', $name)"/>
            </p:add-attribute>
          </p:otherwise>
        </p:choose>
      </p:group>
      <p:catch name="catch-en">
        <p:output port="result" primary="true" sequence="true"/>
        <p:identity>
          <p:with-input port="source">
            <p:pipe step="catch-en" port="error"/>
          </p:with-input>
        </p:identity>
        <p:wrap-sequence wrapper="dtd-error"/>
        <p:add-attribute match="/*" attribute-name="file">
          <p:with-option name="attribute-value" select="concat('en/', $name)"/>
        </p:add-attribute>
      </p:catch>
    </p:try>
  </p:for-each>
  <!-- ── Build and store log ───────────────────────────────── -->
  <p:wrap-sequence wrapper="validate-run" name="build-log">
    <p:with-input port="source">
      <p:pipe step="process-de" port="result"/>
      <p:pipe step="process-en" port="result"/>
    </p:with-input>
  </p:wrap-sequence>
  <p:store name="store-log">
    <p:with-input port="source">
      <p:pipe step="build-log" port="result"/>
    </p:with-input>
    <p:with-option name="href" select="$log-href"/>
  </p:store>
  <!-- Strict mode: fail the pipeline if any DTD or Schematron errors occurred.
       (The errors are still written to the validate-run.xml log above.) -->
  <p:identity name="log-doc">
    <p:with-input port="source">
      <p:pipe step="build-log" port="result"/>
    </p:with-input>
  </p:identity>
  <p:choose>
    <p:with-input>
      <p:pipe step="log-doc" port="result"/>
    </p:with-input>
    <p:when test="count(/validate-run/dtd-error | /validate-run/schematron-error) gt 0">
      <p:error code="err:UWE0001" message="Validation failed: DTD/Schematron errors detected. See validate-run.xml."/>
    </p:when>
    <p:otherwise>
      <p:identity/>
    </p:otherwise>
  </p:choose>
</p:declare-step>
