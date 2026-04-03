<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
  <xsl:key name="ids" match="@id" use="."/>
  <xsl:template match="@id[count(key('ids',.)) gt 1]">
    <xsl:attribute name="id" select="concat(.,'_',generate-id(parent::*))"/>
  </xsl:template>
  <!-- FOP strict mode rejects empty language; default to 'en' -->
  <xsl:template match="@language[normalize-space(.) = '']">
    <xsl:attribute name="language" select="'en'"/>
  </xsl:template>
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
