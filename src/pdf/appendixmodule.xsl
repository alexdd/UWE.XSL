<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">
  <xsl:template name="appendix">
    <xsl:if test="*[starts-with(name(),'appendix-title')][normalize-space(.)]">
      <fo:block-container id="{name()}" break-before="page">
        <xsl:apply-templates select="*[starts-with(name(),'memo-id')]"/>
      </fo:block-container>
    </xsl:if>
  </xsl:template>
  <xsl:template match="*[starts-with(name(),'memo-id')]">
    <xsl:variable name="id" select="substring-after(name(),'memo-id')"/>
    <xsl:if test="string-length(preceding-sibling::*[name()=concat('appendix-title',$id)])&gt;0">
      <fo:block id="{concat(.,'-memo-',$id)}">
        <xsl:value-of select="preceding-sibling::*[name()=concat('appendix-title',$id)]"/>
      </fo:block>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
