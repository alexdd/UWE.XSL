<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
  <xsl:include href="images.xsl"/>
  <xsl:include href="meta.xsl"/>
  <xsl:include href="utils.xsl"/>
  <xsl:include href="tablemodule.xsl"/>
  <xsl:param name="body-element" select="'document'"/>
  <xsl:param name="appendix-element" select="'appendix'"/>
  <xsl:param name="head-element" select="'meta'"/>
  <xsl:param name="custom" select="false()"/>
  <xsl:param name="document-name" select="string((//meta/main-title, //title)[1])"/>
  <xsl:variable name="language" select="substring-before(//language,'-')"/>
  <xsl:template name="boilerplate-lookup">
    <xsl:param name="key"/>
    <xsl:choose>
      <xsl:when test="$key='B_FIG'">Figure</xsl:when>
      <xsl:when test="$key='B_FN'">
        <xsl:choose>
          <xsl:when test="$language='de'">Fußnoten</xsl:when>
          <xsl:otherwise>Footnotes</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$key='B_GLOSSARY'">
        <xsl:choose>
          <xsl:when test="$language='de'">Glossar</xsl:when>
          <xsl:otherwise>Glossary</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$key='B_INDEX'">
        <xsl:choose>
          <xsl:when test="$language='de'">Stichwortregister</xsl:when>
          <xsl:otherwise>Index</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$key"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Footnote callout text: matches PDF (main.xsl footnote): numbered 1) or [key] when key is set. -->
  <xsl:template name="footnote-marker-text">
    <xsl:choose>
      <xsl:when test="key">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="normalize-space(key)"/>
        <xsl:text>]</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:number level="any" count="footnote" format="1)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="make-element-name"/>
  <xsl:template name="warning">
    <xsl:param name="simple" select="false()"/>
    <div class="{name()}">
      <div class="warning-title">
        <xsl:value-of select="upper-case(name())"/>
      </div>
      <div class="warning-content">
        <xsl:apply-templates mode="simple"/>
      </div>
    </div>
  </xsl:template>
  <xsl:template name="chapter-is-glossary" as="xs:boolean">
    <xsl:variable name="lid" select="lower-case(string(@link-id))"/>
    <xsl:variable name="href" select="lower-case(string(@data-src-href))"/>
    <xsl:sequence select="
      exists(descendant::glossary)
      or (
      (contains($lid, 'glossary') or contains($href, 'glossary'))
      and not(contains($lid, 'nonglossary'))
      and not(contains($href, 'nonglossary'))
      )"/>
  </xsl:template>
  <xsl:template name="write-simple">
    <xsl:result-document href="./nav.html" method="xhtml">
      <xsl:call-template name="write-simple-navigation"/>
    </xsl:result-document>
    <xsl:apply-templates select="//*[name()=$body-element or name()=$appendix-element]/chapter" mode="simple"/>
    <xsl:call-template name="write-keyword-index-html"/>
    <xsl:result-document href="./index.html" method="xhtml">
      <xsl:call-template name="make-meta"/>
    </xsl:result-document>
    <xsl:variable name="keyword-index-lunr-text" select="normalize-space(string-join(//*[name()=$body-element or name()=$appendix-element]//indexterm//text(), ' '))"/>
    <xsl:variable name="keyword-index-lunr-escaped" select="replace(replace($keyword-index-lunr-text, '\\', '\\\\'), '&quot;', '\\&quot;')"/>
    <xsl:result-document href="./res/index.js" method="text">
      <xsl:text>documents = [</xsl:text>
      <xsl:apply-templates select="descendant::chapter" mode="idx"/>
      <!-- chapter mode="idx" ends each object with "}, so no leading comma here (would be },,{) -->
      <xsl:text>{"tid":"keyword-index","content":"</xsl:text>
      <xsl:value-of select="$keyword-index-lunr-escaped"/>
      <xsl:text>"}</xsl:text>
      <xsl:text>];</xsl:text>
      <xsl:text>mapping = {</xsl:text>
      <xsl:apply-templates select="descendant::chapter" mode="mapping"/>
      <!-- mapping mode ends each entry with ", so no leading comma before _keyword-index -->
      <!-- Quoted key: _keyword-index unquoted is parsed as subtraction (Unexpected token '-') -->
      <xsl:text>"_keyword-index":"</xsl:text>
      <xsl:call-template name="boilerplate-lookup">
        <xsl:with-param name="key" select="'B_INDEX'"/>
      </xsl:call-template>
      <xsl:text>"};</xsl:text>
    </xsl:result-document>
    <xsl:result-document href="../appendix.json" method="text">
      <xsl:apply-templates select="(descendant::appendix)[1]" mode="appendix"/>
    </xsl:result-document>
  </xsl:template>
  <xsl:template match="appendix" mode="appendix">
    <xsl:text>{</xsl:text>
    <xsl:apply-templates mode="appendix"/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="appendix/*" mode="appendix">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>":"</xsl:text>
    <xsl:apply-templates mode="json"/>
    <xsl:text>"</xsl:text>
    <xsl:if test="following-sibling::*">,</xsl:if>
  </xsl:template>
  <xsl:template match="chapter" mode="idx">
    <xsl:text>{"tid":"</xsl:text>
    <xsl:call-template name="make-chapter-fname"/>
    <xsl:text>","content":"</xsl:text>
    <xsl:apply-templates select="(title, content/title)[1]/descendant::text() | descendant::text()[ancestor::chapter[1] is current()]" mode="json"/>
    <xsl:text>"},</xsl:text>
  </xsl:template>
  <!-- create mapping of topic id vs title -->
  <xsl:template match="chapter" mode="mapping">
    <xsl:text>_</xsl:text>
    <xsl:call-template name="make-chapter-fname"/>
    <xsl:text>:"</xsl:text>
    <xsl:apply-templates select="(title, content/title)[1]/descendant::text()" mode="json"/>
    <xsl:text>",</xsl:text>
  </xsl:template>
  <xsl:template match="*" mode="idx">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template name="write-simple-chunk-header">
    <head>
      <title>
        <xsl:variable name="docname" select="//meta/main-title"/>
        <xsl:choose>
          <xsl:when test="string-length($docname)&gt;0">
            <xsl:value-of select="$docname"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="replace($document-name,'&quot;','')"/>
          </xsl:otherwise>
        </xsl:choose>
      </title>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <link rel="stylesheet" href="./res/TekturHelp.css"/>
      <script type="text/javascript" src="./res/lib/mark.min.js"/>
      <script type="text/javascript" src="./res/TekturHelp.js"/>
      <script type="text/javascript" src="./res/main.js"/>
    </head>
  </xsl:template>
  <xsl:template name="write-simple-chunk-body">
    <xsl:param name="tid"/>
    <!-- Current chapter: pass explicitly; default select="." is not reliable for all processors inside result-document. -->
    <xsl:param name="chunk-chapter" as="element()?" select="."/>
    <!-- Footnotes only for this chunk's body: nested child chapters are separate HTML pages
		     and their footnotes are not rendered here (see apply-templates *[not(self::chapter)]). -->
    <xsl:variable name="footnotes-this-page" select="$chunk-chapter//footnote[ancestor::chapter[1] is $chunk-chapter]"/>
    <xsl:variable name="is-glossary-page" as="xs:boolean">
      <xsl:choose>
        <xsl:when test="$chunk-chapter">
          <xsl:for-each select="$chunk-chapter">
            <xsl:call-template name="chapter-is-glossary"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="false()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <body>
      <xsl:attribute name="id">TekturHelpContent</xsl:attribute>
      <xsl:if test="$is-glossary-page">
        <xsl:attribute name="class">uwe-glossary-page</xsl:attribute>
      </xsl:if>
      <div id="TekturHelpType" style="display:none">content</div>
      <div id="tid" style="display:none">
        <xsl:value-of select="$tid"/>
      </div>
      <div class="content-buttons">
        <img id="print-icon" title="print" src="./res/images/printer.gif"/>
      </div>
      <xsl:apply-templates select="$chunk-chapter/*[not(self::chapter)]" mode="simple"/>
      <xsl:if test="$footnotes-this-page">
        <aside class="uwe-footnotes">
          <xsl:attribute name="aria-label">
            <xsl:call-template name="boilerplate-lookup">
              <xsl:with-param name="key" select="'B_FN'"/>
            </xsl:call-template>
          </xsl:attribute>
          <div class="uwe-footnotes-heading">
            <xsl:call-template name="boilerplate-lookup">
              <xsl:with-param name="key" select="'B_FN'"/>
            </xsl:call-template>
          </div>
          <xsl:for-each select="$footnotes-this-page">
            <div class="uwe-footnote-item" id="fn-{generate-id()}">
              <span class="uwe-footnote-label">
                <a href="#fnref-{generate-id()}" class="uwe-footnote-back">
                  <xsl:call-template name="footnote-marker-text"/>
                </a>
              </span>
              <div class="uwe-footnote-body">
                <xsl:apply-templates select="desc/node()" mode="simple"/>
                <xsl:for-each select="add">
                  <span class="uwe-footnote-add">
                    <xsl:apply-templates select="node()" mode="simple"/>
                  </span>
                </xsl:for-each>
              </div>
            </div>
          </xsl:for-each>
        </aside>
      </xsl:if>
      <button id="scrollTopBtn" title="Go to top">
        <img src="./res/images/arrow_right.png"/>
      </button>
    </body>
  </xsl:template>
  <xsl:template match="title[not(parent::title)]" mode="simple">
    <xsl:variable name="ch" select="ancestor::chapter[1]"/>
    <xsl:variable name="is-glossary" as="xs:boolean">
      <xsl:choose>
        <xsl:when test="$ch">
          <xsl:for-each select="$ch">
            <xsl:call-template name="chapter-is-glossary"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="false()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="level" select="count(ancestor::chapter) + 1"/>
    <xsl:variable name="hname" select="concat('h',$level)"/>
    <xsl:choose>
      <!-- Glossary topics often use an empty/whitespace title in DITA; show localized label (same as TOC). -->
      <xsl:when test="$is-glossary and not(normalize-space(.))">
        <xsl:element name="{$hname}">
          <xsl:attribute name="class">uwe-glossary-title</xsl:attribute>
          <xsl:if test="parent::chapter">
            <span class="number">
              <xsl:number count="chapter" level="multiple" format="1.1"/>
              <xsl:text>  </xsl:text>
            </span>
          </xsl:if>
          <xsl:call-template name="boilerplate-lookup">
            <xsl:with-param name="key" select="'B_GLOSSARY'"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{$hname}">
          <xsl:if test="parent::chapter">
            <span class="number">
              <xsl:number count="chapter" level="multiple" format="1.1"/>
              <xsl:text>  </xsl:text>
            </span>
          </xsl:if>
          <xsl:apply-templates select="node()" mode="simple"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="title[parent::title]">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- PDF-style: superscript marker in text; full text in .uwe-footnotes (see write-simple-chunk-body). -->
  <xsl:template match="footnote" mode="simple">
    <xsl:variable name="fnid" select="generate-id()"/>
    <sup class="fn-marker">
      <a href="#fn-{$fnid}" id="fnref-{$fnid}" class="fn-call">
        <xsl:call-template name="footnote-marker-text"/>
      </a>
    </sup>
  </xsl:template>
  <!-- Index markers: not shown in body (PDF-style); entries appear on keyword-index.html -->
  <xsl:template match="indexterm" mode="simple toc" priority="2"/>
  <xsl:template match="*" mode="simple">
    <xsl:choose>
      <xsl:when test="ancestor::p or ancestor::title">
        <span class="{name()}">
          <xsl:apply-templates select="node()" mode="simple"/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <div class="{name()}">
          <xsl:apply-templates select="node()[not(self::chapter)]" mode="simple"/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="text()" mode="simple">
    <xsl:value-of select="."/>
  </xsl:template>
  <xsl:template match="chapter" mode="simple-toc-entry">
    <xsl:variable name="url">
      <xsl:call-template name="make-chapter-fname"/>
    </xsl:variable>
    <li>
      <span style="display:inline">
        <xsl:if test="child::chapter">
          <xsl:attribute name="class">caret</xsl:attribute>
        </xsl:if>
      </span>
      <a target="content" class="toc-link" data-tid="{$url}" href="{concat($url,'.html?tid=',$url)}" style="display:inline">
        <!-- xsl:number count="chapter" level="multiple" format="1.1"/>
            	<xsl:text>&#160;&#160;</xsl:text-->
        <xsl:variable name="is-glossary" as="xs:boolean">
          <xsl:call-template name="chapter-is-glossary"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$is-glossary">
            <xsl:call-template name="boilerplate-lookup">
              <xsl:with-param name="key" select="'B_GLOSSARY'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="(title, content/title)[1]/node()" mode="toc"/>
          </xsl:otherwise>
        </xsl:choose>
      </a>
      <xsl:if test="child::chapter">
        <ul class="nested">
          <xsl:apply-templates select="chapter" mode="simple-toc-entry"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>
  <xsl:template name="write-keyword-index-html">
    <xsl:if test="exists(//*[name()=$body-element or name()=$appendix-element]//indexterm)">
      <xsl:result-document href="./keyword-index.html" method="xhtml">
        <html>
          <xsl:comment> UWE.XSL - DITA Publishing Stylesheets | Copyright (C) 2012-2026 Alex Duesel | LGPL-3.0-only </xsl:comment>
          <head>
            <title>
              <xsl:call-template name="boilerplate-lookup">
                <xsl:with-param name="key" select="'B_INDEX'"/>
              </xsl:call-template>
              <xsl:text> — </xsl:text>
              <xsl:value-of select="//meta/main-title"/>
            </title>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
            <link rel="stylesheet" href="./res/TekturHelp.css"/>
            <script type="text/javascript" src="./res/lib/mark.min.js"/>
            <script type="text/javascript" src="./res/TekturHelp.js"/>
            <script type="text/javascript" src="./res/main.js"/>
          </head>
          <body id="TekturHelpContent">
            <div id="TekturHelpType" style="display:none">content</div>
            <div id="tid" style="display:none">keyword-index</div>
            <div class="content-buttons">
              <img id="print-icon" title="print" src="./res/images/printer.gif"/>
            </div>
            <div class="uwe-keyword-index">
              <h1 class="uwe-register-title">
                <xsl:call-template name="boilerplate-lookup">
                  <xsl:with-param name="key" select="'B_INDEX'"/>
                </xsl:call-template>
              </h1>
              <xsl:for-each-group select="//indexterm[not(indexterm)][ancestor::chapter]" group-by="string-join(for $n in reverse(./ancestor-or-self::indexterm) return normalize-space(string-join($n/node()[not(self::indexterm)], '')), '|||')">
                <xsl:sort select="current-grouping-key()"/>
                <xsl:if test="normalize-space(current-grouping-key()) != ''">
                  <div class="uwe-index-entry">
                    <div class="uwe-index-term">
                      <xsl:value-of select="replace(current-grouping-key(), '\|\|\|', ' › ')"/>
                    </div>
                    <ul class="uwe-index-links">
                      <xsl:for-each-group select="current-group()" group-by="generate-id((./ancestor::chapter)[1])">
                        <xsl:sort select="normalize-space(string((current-group()[1]/ancestor::chapter[1]/title, current-group()[1]/ancestor::chapter[1]/content/title)[1]))" lang="{$language}"/>
                        <li>
                          <xsl:variable name="ch" select="current-group()[1]/ancestor::chapter[1]"/>
                          <xsl:variable name="href">
                            <xsl:for-each select="$ch">
                              <xsl:call-template name="make-chapter-fname"/>
                            </xsl:for-each>
                          </xsl:variable>
                          <a class="content-link" target="content" href="{concat($href, '.html?tid=', $href)}">
                            <xsl:for-each select="$ch">
                              <xsl:variable name="is-glossary" as="xs:boolean">
                                <xsl:call-template name="chapter-is-glossary"/>
                              </xsl:variable>
                              <xsl:choose>
                                <xsl:when test="$is-glossary">
                                  <xsl:call-template name="boilerplate-lookup">
                                    <xsl:with-param name="key" select="'B_GLOSSARY'"/>
                                  </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of select="normalize-space(string((title, content/title)[1]))"/>
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:for-each>
                          </a>
                        </li>
                      </xsl:for-each-group>
                    </ul>
                  </div>
                </xsl:if>
              </xsl:for-each-group>
            </div>
            <button id="scrollTopBtn" title="Go to top">
              <img src="./res/images/arrow_right.png"/>
            </button>
          </body>
        </html>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>
  <xsl:template name="write-simple-navigation">
    <html>
      <xsl:comment> UWE.XSL - DITA Publishing Stylesheets | Copyright (C) 2012-2026 Alex Duesel | LGPL-3.0-only </xsl:comment>
      <head>
        <meta charset="UTF-8"/>
        <link rel="stylesheet" href="./res/TekturHelp.css"/>
        <script type="text/javascript" src="./res/lib/lunr.js"/>
        <script type="text/javascript" src="./res/lib/lunr.stemmer.support.js"/>
        <script type="text/javascript" src="./res/lib/lunr.{$language}.js"/>
        <script type="text/javascript" src="./res/index.js"/>
        <script type="text/javascript" src="./res/TekturHelp.js"/>
        <script type="text/javascript" src="./res/main.js"/>
      </head>
      <body id="TekturHelpNavigation">
        <div id="TekturHelpType" style="display:none">nav</div>
        <div id="sidenav" class="sidenav">
          <ul id="topic-tree">
            <!-- TOC order: non-glossary top-level chapters first (map order), then glossary chapters — e.g. Tektur CCMS before Glossar when the map lists glossary first -->
            <xsl:for-each select="//*[name()=$body-element or name()=$appendix-element]/chapter">
              <xsl:sort select="
                  if (exists(descendant::glossary)
                    or ((contains(lower-case(string(@link-id)), 'glossary') or contains(lower-case(string(@data-src-href)), 'glossary'))
                      and not(contains(lower-case(string(@link-id)), 'nonglossary'))
                      and not(contains(lower-case(string(@data-src-href)), 'nonglossary'))))
                  then 1 else 0" order="ascending" data-type="number"/>
              <xsl:sort select="count(preceding-sibling::chapter)" order="ascending" data-type="number"/>
              <xsl:apply-templates select="." mode="simple-toc-entry"/>
            </xsl:for-each>
            <xsl:if test="exists(//*[name()=$body-element or name()=$appendix-element]//indexterm)">
              <li>
                <span style="display:inline"></span>
                <a target="content" class="toc-link" data-tid="keyword-index" href="keyword-index.html?tid=keyword-index" style="display:inline">
                  <xsl:call-template name="boilerplate-lookup">
                    <xsl:with-param name="key" select="'B_INDEX'"/>
                  </xsl:call-template>
                </a>
              </li>
            </xsl:if>
          </ul>
        </div>
        <div id="main">
          <div id="language" style="display:none">
            <xsl:value-of select="$language"/>
          </div>
          <div id="bar">
            <span id="bar-main-title">
              <xsl:value-of select="//meta/main-title"/>
            </span>
          </div>
          <div id="breadcrumbs"/>
          <div id="topbuttons">
            <a id="pdfbtn" title="show pdf" target="_blank" href="../pdf/{$language}.pdf">
              <img src="./res/images/pdficon.png"/>
            </a>
            <div id="sidebarbtn" title="show / hide sidebar">
              <img src="./res/images/book_icon.png"/>
            </div>
            <div id="nexttopicbtn" title="nextpage">
              <img src="./res/images/arrow_right.png"/>
            </div>
            <div id="prevtopicbtn" title="previous page">
              <img src="./res/images/arrow_left.png"/>
            </div>
            <form autocomplete="off" id="search-form">
              <div class="autocomplete">
                <input id="search" type="search" name="search" placeholder="search 🔍"/>
              </div>
            </form>
          </div>
          <iframe id="iframe" width="100%" name="content" frameborder="0" src="index.html"/>
          <ul id="search-result"/>
        </div>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="chapter" mode="simple">
    <xsl:variable name="url">
      <xsl:call-template name="make-chapter-fname"/>
    </xsl:variable>
    <xsl:result-document href="{concat('./', $url, '.html')}">
      <html>
        <xsl:comment> UWE.XSL - DITA Publishing Stylesheets | Copyright (C) 2012-2026 Alex Duesel | LGPL-3.0-only </xsl:comment>
        <xsl:call-template name="write-simple-chunk-header"/>
        <xsl:call-template name="write-simple-chunk-body">
          <xsl:with-param name="tid" select="$url"/>
          <xsl:with-param name="chunk-chapter" select="."/>
        </xsl:call-template>
      </html>
    </xsl:result-document>
    <xsl:apply-templates select="chapter" mode="simple"/>
  </xsl:template>
  <xsl:template match="verbatim" mode="simple">
    <pre class="verbatim">
      <xsl:apply-templates/>
    </pre>
  </xsl:template>
  <xsl:template match="ul" mode="simple">
    <ul class="ul">
      <xsl:apply-templates mode="simple"/>
    </ul>
  </xsl:template>
  <xsl:template match="li" mode="simple">
    <li class="li">
      <xsl:apply-templates mode="simple"/>
    </li>
  </xsl:template>
  <xsl:template match="figure/subtitle" mode="simple">
    <h5 class="subtitle">
      <xsl:variable name="fixtext">
        <xsl:call-template name="boilerplate-lookup">
          <xsl:with-param name="key">B_FIG</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="concat($fixtext,': ')"/>
      <xsl:number count="figure[child::subtitle]" level="any" format="1"/>
      <xsl:text>  </xsl:text>
      <xsl:apply-templates mode="simple"/>
    </h5>
  </xsl:template>
  <xsl:template match="figure" mode="simple">
    <xsl:apply-templates select="desc" mode="simple"/>
    <xsl:apply-templates select="img" mode="simple"/>
    <xsl:apply-templates select="subtitle" mode="simple"/>
    <xsl:apply-templates select="legend" mode="simple"/>
  </xsl:template>
  <xsl:template match="legend" mode="simple">
    <table cellpadding="0" cellspacing="0" class="callout-list">
      <xsl:apply-templates mode="simple"/>
    </table>
  </xsl:template>
  <xsl:template match="leg-entry" mode="simple">
    <tr class="callout-item">
      <xsl:apply-templates mode="simple"/>
    </tr>
  </xsl:template>
  <xsl:template match="leg-pos" mode="simple">
    <td class="calloutref" valign="top" style="border:none">
      <xsl:apply-templates mode="simple"/>
    </td>
  </xsl:template>
  <xsl:template match="leg-name" mode="simple">
    <td style="border:none">
      <xsl:apply-templates mode="simple"/>
    </td>
  </xsl:template>
  <xsl:template match="caution | warning | note | notice | danger" mode="simple">
    <xsl:call-template name="warning">
      <xsl:with-param name="simple" select="true()"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="p" mode="simple">
    <p>
      <xsl:apply-templates mode="simple"/>
    </p>
  </xsl:template>
  <xsl:template match="table" mode="simple">
    <div class="table">
      <xsl:call-template name="make-element-name"/>
      <xsl:apply-templates select="*[not(self::caption)]" mode="simple"/>
      <xsl:apply-templates select="caption" mode="simple"/>
    </div>
  </xsl:template>
  <xsl:template match="table/caption" mode="simple">
    <div class="caption">
      <xsl:text>Tab. </xsl:text>
      <xsl:number count="table[child::caption]" level="any" format="1"/>
      <xsl:text>  </xsl:text>
      <xsl:apply-templates mode="simple"/>
    </div>
  </xsl:template>
  <xsl:template match="color" mode="simple">
    <span>
      <xsl:attribute name="style">
        <xsl:choose>
          <xsl:when test="@name='blue'">color:#000099</xsl:when>
          <xsl:when test="@name='brown'">color:#7F3300</xsl:when>
          <xsl:when test="@name='green'">color:#527F3F</xsl:when>
          <xsl:when test="@name='red'">color:#7F0037</xsl:when>
          <xsl:otherwise>color:black</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  <xsl:template match="sub" mode="simple">
    <sub>
      <xsl:apply-templates mode="simple"/>
    </sub>
  </xsl:template>
  <xsl:template match="sup" mode="simple">
    <sup>
      <xsl:apply-templates mode="simple"/>
    </sup>
  </xsl:template>
  <xsl:template match="b" mode="simple">
    <b id="{@id}">
      <xsl:call-template name="make-element-name"/>
      <xsl:apply-templates mode="simple"/>
    </b>
  </xsl:template>
  <xsl:template match="i" mode="simple">
    <i>
      <xsl:apply-templates mode="simple"/>
    </i>
  </xsl:template>
  <xsl:template match="u" mode="simple">
    <u>
      <xsl:apply-templates mode="simple"/>
    </u>
  </xsl:template>
  <xsl:template match="ph[@outputclass='nb']" mode="simple">
    <xsl:value-of select="translate(.,' ',' ')"/>
  </xsl:template>
  <xsl:template match="code | codeph" mode="simple">
    <span style="font-family:Courier New, monospace">
      <xsl:apply-templates mode="simple"/>
    </span>
  </xsl:template>
  <xsl:key name="chapters" match="chapter" use="@id"/>
  <!-- xref href is usually the topic file (e.g. 2_Anwendungsgebiete.dita); chapter @id is map/topicref id. -->
  <xsl:key name="chapters-by-dita-href" match="chapter[normalize-space(@data-src-href) != '']" use="lower-case(replace(normalize-space(@data-src-href), '^.*[\\/]', ''))"/>
  <xsl:key name="chapters-by-full-href" match="chapter[normalize-space(@data-src-href) != '']" use="lower-case(normalize-space(@data-src-href))"/>
  <xsl:template match="doclink" mode="simple">
    <xsl:variable name="raw-href" select="normalize-space(@class)"/>
    <xsl:variable name="file-part" select="if (contains($raw-href, '#')) then substring-before($raw-href, '#') else $raw-href"/>
    <xsl:variable name="frag" select="if (contains($raw-href, '#')) then substring-after($raw-href, '#') else ''"/>
    <xsl:variable name="href-basename" select="lower-case(replace($file-part, '^.*[\\/]', ''))"/>
    <xsl:variable name="target-chapter" as="element(chapter)?">
      <xsl:choose>
        <xsl:when test="key('chapters', $raw-href)[1]">
          <xsl:sequence select="key('chapters', $raw-href)[1]"/>
        </xsl:when>
        <xsl:when test="string-length($file-part) &gt; 0 and key('chapters', $file-part)[1]">
          <xsl:sequence select="key('chapters', $file-part)[1]"/>
        </xsl:when>
        <xsl:when test="string-length($file-part) &gt; 0 and key('chapters-by-full-href', lower-case($file-part))[1]">
          <xsl:sequence select="key('chapters-by-full-href', lower-case($file-part))[1]"/>
        </xsl:when>
        <xsl:when test="string-length($href-basename) &gt; 0 and key('chapters-by-dita-href', $href-basename)[1]">
          <xsl:sequence select="key('chapters-by-dita-href', $href-basename)[1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="is-external-url" select="             starts-with($raw-href, 'http:') or             starts-with($raw-href, 'https:') or             starts-with($raw-href, 'www.')"/>
    <xsl:choose>
      <xsl:when test="$is-external-url">
        <a href="{$raw-href}" class="content-link" target="_blank" rel="noopener">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="exists($target-chapter)">
        <xsl:variable name="target-href">
          <xsl:apply-templates select="$target-chapter" mode="doclink"/>
        </xsl:variable>
        <xsl:variable name="href-with-frag" select="                     if (string-length($frag) &gt; 0) then concat($target-href, '#', $frag) else string($target-href)"/>
        <a href="{$href-with-frag}" class="content-link" target="content">
          <xsl:value-of select="."/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <span style="color:red">ERROR! Linktarget does not exist <xsl:value-of select="$raw-href"/></span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="chapter" mode="doclink">
    <xsl:variable name="fname">
      <xsl:call-template name="make-chapter-fname"/>
    </xsl:variable>
    <xsl:value-of select="concat($fname,'.html?tid=',$fname)"/>
  </xsl:template>
  <xsl:template match="checked" mode="simple">
    <span style="font-family:Wingdings;font-size:14pt">þ</span>
  </xsl:template>
  <xsl:template match="unchecked" mode="simple">
    <apan style="font-family:Wingdings;font-size:14pt">¨</apan>
  </xsl:template>
  <xsl:template match="url" mode="simple">
    <a href="{@address}" title="{@address}" target="_blank">
      <xsl:apply-templates/>
    </a>
  </xsl:template>
  <xsl:template match="action/p" priority="10" mode="simple">
    <p>
      <xsl:choose>
        <xsl:when test="ancestor::procedure[@type='ol']">
          <xsl:if test="count(ancestor::procedure)&gt;1">
            <xsl:value-of select="count(ancestor::procedure)"/>
            <xsl:text>.</xsl:text>
          </xsl:if>
          <xsl:number count="action" from="procedure" format="1." level="any"/>
        </xsl:when>
        <xsl:otherwise>▷</xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:apply-templates mode="simple"/>
    </p>
  </xsl:template>
  <xsl:template match="*[name()=$head-element]" mode="simple">
    <xsl:variable name="status-value" select="normalize-space((//status)[1])"/>
    <div class="head">
      <img id="cover-image">
        <xsl:attribute name="src">
          <xsl:choose>
            <xsl:when test="$custom">
              <xsl:value-of select="'res/images/Lines_xml_handson_2.svg'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'images/cover.png'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </img>
      <div class="cover">
        <xsl:apply-templates select="descendant::main-title" mode="simple"/>
        <xsl:apply-templates select="descendant::subtitle" mode="simple"/>
        <xsl:apply-templates select="descendant::cover-text" mode="simple"/>
      </div>
      <div class="cover-footer">
        <div class="version">
          <b>Version: </b>
          <xsl:value-of select="if ($status-value != '' and upper-case($status-value) != 'UNDEFINED') then $status-value else '-'"/>
          <xsl:text> / </xsl:text>
          <xsl:value-of select="//language"/>
          <br/>
          <xsl:value-of select="//date-of-last-change"/>
        </div>
      </div>
      <img id="logo-image" src="images/logo.png"/>
    </div>
  </xsl:template>
</xsl:stylesheet>
