<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dyxml="http://www.docufy.de/ns/dyxml" exclude-result-prefixes="#all" version="3.0">
  <!-- create meta topic (cover page) in separate file -->
  <xsl:template name="make-meta">
    <html>
      <xsl:comment> UWE.XSL - DITA Publishing Stylesheets | Copyright (C) 2012-2026 Alex Duesel | LGPL-3.0-only </xsl:comment>
      <head>
        <meta charset="UTF-8"/>
        <link rel="stylesheet" href="./res/TekturHelp.css"/>
        <script type="text/javascript" src="./res/TekturHelp.js"/>
        <script type="text/javascript" src="./res/main.js"/>
      </head>
      <body id="TekturHelpMeta">
        <div id="TekturHelpType" style="display:none">meta</div>
        <div id="startbtn" title="start browsing">
          <xsl:attribute name="data-href">
            <xsl:text>1</xsl:text>
            <xsl:call-template name="make-chapter-fname">
              <xsl:with-param name="context" select="(descendant::chapter)[1]"/>
            </xsl:call-template>
            <xsl:text>.html</xsl:text>
          </xsl:attribute>
          <img src="./res/images/arrow_right.png"/>
        </div>
        <xsl:apply-templates mode="simple"/>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="appendix" mode="simple">
    <xsl:if test="string-length(appendix-title1) &gt;0 or         string-length(appendix-title2) &gt;0 or        string-length(appendix-title3) &gt;0 or        string-length(appendix-title4) &gt;0">
      <div id="appendix-container">
        <div id="appendix-label">Attachments</div>
        <xsl:if test="string-length(appendix-title1)&gt;0">
          <a href="appendix-{memo-id1}.pdf" target="_blank" class="appendix" id="pdf-appendix-1" title="show attachment PDF">
            <div class="image">
              <img src="res/images/pdficon.png"/>
            </div>
            <div class="title">
              <xsl:value-of select="appendix-title1"/>
            </div>
          </a>
        </xsl:if>
        <xsl:if test="string-length(appendix-title2)&gt;0">
          <a href="appendix-{memo-id2}.pdf" target="_blank" class="appendix" id="pdf-appendix-2" title="show attachment PDF">
            <div class="image">
              <img src="res/images/pdficon.png"/>
            </div>
            <div class="title">
              <xsl:value-of select="appendix-title2"/>
            </div>
          </a>
        </xsl:if>
        <xsl:if test="string-length(appendix-title3)&gt;0">
          <a href="appendix-{memo-id3}.pdf" target="_blank" class="appendix" id="pdf-appendix-3" title="show attachment PDF">
            <div class="image">
              <img src="res/images/pdficon.png"/>
            </div>
            <div class="title">
              <xsl:value-of select="appendix-title3"/>
            </div>
          </a>
        </xsl:if>
        <xsl:if test="string-length(appendix-title4)&gt;0">
          <a href="appendix-{memo-id4}.pdf" target="_blank" class="appendix" id="pdf-appendix-4" title="show attachment PDF">
            <div class="image">
              <img src="res/images/pdficon.png"/>
            </div>
            <div class="title">
              <xsl:value-of select="appendix-title4"/>
            </div>
          </a>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>
  <xsl:template match="meta/cover-text" mode="simple">
    <xsl:for-each select="tokenize(.,'&#10;')">
      <p class="cover-text">
        <xsl:choose>
          <xsl:when test="position()=1">
            <b>
              <xsl:value-of select="."/>
            </b>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="starts-with(.,'www.')">
                <a href="{concat('http://',.)}" target="_blank">
                  <xsl:value-of select="."/>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </p>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
