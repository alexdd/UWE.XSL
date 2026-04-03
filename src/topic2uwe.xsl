<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:include href="./dita/main.xsl"/>
  <xsl:output method="xml" encoding="utf-8"/>
  <!-- mapid and language are defined in map2uwe.xsl when topic2uwe is used for map→UWE -->
  <xsl:param name="output_location">pdf</xsl:param>
  <xsl:param name="is-topic">no</xsl:param>
  <xsl:param name="element-id"/>
  <xsl:template match="topic|task">
    <xsl:element name="{if($is-topic='yes') then 'chapter' else 'content'}">
      <xsl:if test="$is-topic='yes'">
        <xsl:attribute name="language" select="$language"/>
        <xsl:attribute name="hyphenation">yes</xsl:attribute>
      </xsl:if>
      <title id="{title/@id}">
        <xsl:apply-templates select="title/node()"/>
      </title>
      <block>
        <xsl:if test="string-length(string(abstract))&gt;0">
          <xsl:choose>
            <xsl:when test="self::task">
              <title>
                <xsl:apply-templates select="abstract"/>
              </title>
            </xsl:when>
            <xsl:otherwise>
              <title/>
              <abstract type="abstract" mode="{name()}">
                <xsl:apply-templates select="abstract"/>
              </abstract>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:apply-templates select="*[not(self::title) and not(self::abstract)]"/>
      </block>
    </xsl:element>
  </xsl:template>
  <xsl:template match="ul|choices">
    <ul id="{@id}">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
  <xsl:template match="li">
    <li id="{concat(@id,'-li')}">
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  <xsl:template match="choice">
    <li type="choice" id="{concat(@id,'-li')}">
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  <xsl:template match="p">
    <p id="{@id}">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <!-- DITA fn → UWE footnote (key/desc/add) for PDF: @callout → key; body → desc;
	     paragraphs with outputclass containing fn-add → add (supplement for footnote index). -->
  <xsl:template match="fn">
    <xsl:variable name="addPs" select="p[contains(concat(' ', normalize-space(@outputclass), ' '), ' fn-add ')]"/>
    <footnote>
      <xsl:if test="normalize-space(@callout) != ''">
        <key>
          <xsl:value-of select="normalize-space(@callout)"/>
        </key>
      </xsl:if>
      <desc>
        <xsl:apply-templates select="node()[not(. intersect $addPs)]"/>
      </desc>
      <xsl:for-each select="$addPs">
        <add>
          <xsl:apply-templates select="node()"/>
        </add>
      </xsl:for-each>
    </footnote>
  </xsl:template>
  <xsl:template match="section">
    <xsl:choose>
      <xsl:when test="starts-with($output_location,'html5')">
        <chapter hyphenation="yes" chapterpage="no" ismodule="yes" id="{@id}" issection="yes">
          <content>
            <title id="{@id}">
              <xsl:apply-templates select="title/node()"/>
            </title>
            <xsl:apply-templates select="*[not(self::title)]"/>
          </content>
        </chapter>
      </xsl:when>
      <xsl:otherwise>
        <title id="{@id}">
          <xsl:apply-templates select="title/node()"/>
        </title>
        <xsl:apply-templates select="*[not(self::title)]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="body|taskbody">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="ol">
    <procedure type="ol" id="{@id}">
      <xsl:apply-templates/>
    </procedure>
  </xsl:template>
  <xsl:template match="ol/li">
    <step id="{concat(@id,'-step')}">
      <action>
        <xsl:apply-templates/>
      </action>
    </step>
  </xsl:template>
  <xsl:template match="steps|substeps">
    <xsl:apply-templates select="stepsection"/>
    <procedure type="{name()}" id="{@id}">
      <xsl:apply-templates select="*[not(self::stepsection)]"/>
    </procedure>
  </xsl:template>
  <xsl:template match="stepsection">
    <abstract type="stepsection" id="{@id}">
      <xsl:apply-templates/>
    </abstract>
  </xsl:template>
  <xsl:template match="step|substep">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="cmd">
    <step type="steps" id="{concat(parent::*/@id,'-step')}">
      <action>
        <p id="{parent::*/@id}">
          <xsl:apply-templates/>
        </p>
      </action>
    </step>
  </xsl:template>
  <xsl:template match="stepresult">
    <stepresult id="{@id}">
      <xsl:apply-templates/>
    </stepresult>
  </xsl:template>
  <xsl:template match="hazardstatement">
    <xsl:element name="{@type}">
      <xsl:attribute name="id" select="@id"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="note">
    <note id="{@id}">
      <consequence id="{@id}-consequence">
        <xsl:apply-templates/>
      </consequence>
    </note>
  </xsl:template>
  <xsl:template match="messagepanel">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="typeofhazard">
    <cause id="{@id}">
      <xsl:apply-templates/>
    </cause>
  </xsl:template>
  <xsl:template match="consequence">
    <consequence id="{@id}">
      <xsl:apply-templates/>
    </consequence>
  </xsl:template>
  <xsl:template match="howtoavoid">
    <consequence id="{@id}">
      <xsl:apply-templates/>
    </consequence>
  </xsl:template>
  <xsl:template match="fig">
    <figure id="{@id}">
      <xsl:attribute name="pdfwidth">
        <xsl:choose>
          <xsl:when test="@expanse='spread'">margin</xsl:when>
          <xsl:when test="@expanse='column'">column</xsl:when>
          <xsl:otherwise>page</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </figure>
  </xsl:template>
  <xsl:template match="legend">
    <legend id="{@id}">
      <xsl:apply-templates/>
    </legend>
  </xsl:template>
  <xsl:template match="legend[string-length(normalize-space(string(.)))=0]"/>
  <xsl:template match="leg-pos">
    <leg-pos id="{@id}">
      <xsl:apply-templates/>
    </leg-pos>
  </xsl:template>
  <xsl:template match="leg-name">
    <leg-name id="{@id}">
      <xsl:apply-templates/>
    </leg-name>
  </xsl:template>
  <xsl:template match="image|symbol">
    <xsl:param name="topic-id" tunnel="yes"/>
    <xsl:variable name="resolved-src">
      <xsl:choose>
        <xsl:when test="starts-with($output_location,'html5')">
          <xsl:value-of select="concat('./client/data/', if ($element-id) then $element-id else $topic-id, '/', @href)"/>
        </xsl:when>
        <xsl:when test="string-length(normalize-space(base-uri(.))) &gt; 0">
          <xsl:value-of select="resolve-uri(normalize-space(@href), base-uri(.))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(@href)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="parent::p">
        <symbol id="{@id}" src="{$resolved-src}"/>
      </xsl:when>
      <xsl:otherwise>
        <img src="{$resolved-src}"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="pre">
    <xsl:element name="verbatim">
      <xsl:attribute name="id" select="@id"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="b">
    <b>
      <xsl:apply-templates/>
    </b>
  </xsl:template>
  <xsl:template match="table/title">
    <caption id="{@id}">
      <xsl:apply-templates/>
    </caption>
  </xsl:template>
  <xsl:template match="fig/title">
    <subtitle id="{@id}">
      <xsl:apply-templates/>
    </subtitle>
  </xsl:template>
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="colspec">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="cw" select="substring-before(@colwidth,'px')"/>
      <xsl:variable name="cwidth">
        <xsl:choose>
          <xsl:when test="string-length($cw)&gt;0">
            <xsl:value-of select="$cw"/>
          </xsl:when>
          <xsl:otherwise>10</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:attribute name="colwidth" select="number($cwidth)"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="table|tgroup|thead|tfoot|tbody|row|entry">
    <xsl:copy>
      <xsl:if test="self::table and @pgwide='1'">
        <xsl:attribute name="pdfwidth">page</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
    <xsl:if test="self::table and @pgwide='1'">
      <p/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="dl">
    <table type="dl" id="{@id}">
      <xsl:if test="descendant::pre">
        <xsl:attribute name="pdfwidth">page</xsl:attribute>
      </xsl:if>
      <tgroup>
        <colspec colwidth="100"/>
        <colspec colwidth="300"/>
        <tbody>
          <xsl:apply-templates/>
        </tbody>
      </tgroup>
    </table>
  </xsl:template>
  <xsl:template match="choicetable">
    <table type="choicetable">
      <tgroup>
        <colspec colwidth="100"/>
        <colspec colwidth="100"/>
        <tbody>
          <xsl:apply-templates/>
        </tbody>
      </tgroup>
    </table>
  </xsl:template>
  <xsl:template match="dlhead|dlentry">
    <row>
      <xsl:apply-templates/>
    </row>
  </xsl:template>
  <xsl:template match="dthd|ddhd">
    <entry>
      <b id="{@id}">
        <xsl:apply-templates/>
      </b>
    </entry>
  </xsl:template>
  <xsl:template match="chhead|chrow">
    <row>
      <xsl:apply-templates/>
    </row>
  </xsl:template>
  <xsl:template match="choptionhd|chdeschd">
    <entry>
      <b id="{@id}">
        <xsl:apply-templates/>
      </b>
    </entry>
  </xsl:template>
  <xsl:template match="choption|chdesc">
    <entry id="{@id}">
      <xsl:apply-templates/>
    </entry>
  </xsl:template>
  <xsl:template match="dt|dd">
    <entry id="{@id}" type="dl">
      <xsl:apply-templates/>
    </entry>
  </xsl:template>
  <!-- External link: scope="external" or href starts with http(s): or www. → url; else internal → doclink -->
  <xsl:template match="xref">
    <xsl:variable name="href-norm" select="normalize-space(@href)"/>
    <xsl:variable name="is-external" select="    @scope = 'external' or    starts-with($href-norm, 'http:') or    starts-with($href-norm, 'https:') or    starts-with($href-norm, 'www.')"/>
    <xsl:choose>
      <xsl:when test="$is-external">
        <url address="{@href}" id="{@id}">
          <xsl:apply-templates/>
        </url>
      </xsl:when>
      <xsl:otherwise>
        <doclink class="{@href}" id="{@id}" type="{@type}">
          <xsl:apply-templates/>
        </doclink>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="prereq|context|postreq">
    <abstract type="{name()}" id="{@id}">
      <xsl:apply-templates/>
    </abstract>
  </xsl:template>
  <xsl:template match="substep/info">
    <info type="substeps">
      <xsl:apply-templates/>
    </info>
  </xsl:template>
  <xsl:template match="step/info">
    <info type="steps">
      <xsl:apply-templates/>
    </info>
  </xsl:template>
  <xsl:template match="substep/stepresult">
    <result type="substeps">
      <xsl:apply-templates/>
    </result>
  </xsl:template>
  <xsl:template match="step/stepresult">
    <result type="steps">
      <xsl:apply-templates/>
    </result>
  </xsl:template>
</xsl:stylesheet>
