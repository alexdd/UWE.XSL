<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:template name="keep-regeln-legende">
    <xsl:param name="this-row"/>
    <xsl:param name="last-row"/>
    <xsl:attribute name="keep-together.within-page">20</xsl:attribute>
    <xsl:choose>
      <xsl:when test="$this-row = $last-row and preceding-sibling::leg-entry">
        <xsl:attribute name="keep-with-previous.within-page">15</xsl:attribute>
      </xsl:when>
      <xsl:when test="$this-row = 1 and following-sibling::leg-entry">
        <xsl:attribute name="keep-with-next.within-page">15</xsl:attribute>
      </xsl:when>
      <xsl:when test="$this-row = 2 and following-sibling::leg-entry">
        <xsl:attribute name="keep-with-next.within-page">15</xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="legend">
    <fo:block-container keep-with-previous="10" space-after="16pt">
      <xsl:choose>
        <xsl:when test="count(leg-entry) &lt; 3">
          <fo:table width="100%" start-indent="0mm">
            <fo:table-body>
              <fo:table-row>
                <fo:table-cell padding-left="2mm" width="15mm">
                  <xsl:apply-templates select="leg-entry[1]/leg-pos"/>
                </fo:table-cell>
                <fo:table-cell width="3mm">
                  <fo:block>...</fo:block>
                </fo:table-cell>
                <fo:table-cell padding-right="2mm" padding-left="1mm" max-width="70%">
                  <xsl:apply-templates select="leg-entry[1]/leg-name"/>
                </fo:table-cell>
              </fo:table-row>
              <xsl:if test="count(leg-entry) &gt; 1">
                <fo:table-row>
                  <xsl:attribute name="keep-with-previous.within-page">15</xsl:attribute>
                  <fo:table-cell padding-left="2mm" width="15mm">
                    <xsl:apply-templates select="leg-entry[2]/leg-pos"/>
                  </fo:table-cell>
                  <fo:table-cell width="3mm">
                    <fo:block>...</fo:block>
                  </fo:table-cell>
                  <fo:table-cell padding-right="2mm" padding-left="1mm" max-width="70%">
                    <xsl:apply-templates select="leg-entry[2]/leg-name"/>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>
            </fo:table-body>
          </fo:table>
        </xsl:when>
        <xsl:otherwise>
          <fo:table width="100%" start-indent="0mm">
            <fo:table-body>
              <xsl:call-template name="leg-entry"/>
            </fo:table-body>
          </fo:table>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block-container>
  </xsl:template>
  <xsl:template name="leg-entry">
    <xsl:variable name="leg-entry-cnt" select="count(leg-entry)"/>
    <xsl:for-each select="leg-entry">
      <xsl:if test="position() mod 2">
        <fo:table-row>
          <xsl:call-template name="keep-regeln-legende">
            <xsl:with-param name="this-row" select="((position()-1) div 2)+1"/>
            <xsl:with-param name="last-row" select="$leg-entry-cnt div 2"/>
          </xsl:call-template>
          <fo:table-cell padding-left="2mm" width="15mm">
            <xsl:apply-templates select="leg-pos"/>
          </fo:table-cell>
          <fo:table-cell width="3mm">
            <fo:block>...</fo:block>
          </fo:table-cell>
          <fo:table-cell padding-right="2mm" padding-left="1mm" max-width="30%">
            <xsl:apply-templates select="leg-name"/>
          </fo:table-cell>
          <xsl:for-each select="following-sibling::leg-entry[1]">
            <fo:table-cell padding-left="2mm" width="15mm">
              <xsl:apply-templates select="leg-pos"/>
            </fo:table-cell>
            <fo:table-cell width="3mm">
              <fo:block>...</fo:block>
            </fo:table-cell>
            <fo:table-cell padding-right="2mm" padding-left="1mm" max-width="30%">
              <xsl:apply-templates select="leg-name"/>
            </fo:table-cell>
          </xsl:for-each>
          <xsl:if test="position() = last() and last() mod 2 = 1">
            <fo:table-cell padding-left="2mm" width="15mm">
              <fo:block/>
            </fo:table-cell>
            <fo:table-cell width="3mm">
              <fo:block/>
            </fo:table-cell>
            <fo:table-cell padding-right="2mm" padding-left="1mm" max-width="30%">
              <fo:block/>
            </fo:table-cell>
          </xsl:if>
        </fo:table-row>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="leg-pos">
    <fo:block font-weight="bold">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="leg-name">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
</xsl:stylesheet>
