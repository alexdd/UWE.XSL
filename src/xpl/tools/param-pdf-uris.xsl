<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     Outputs c:param-set with pdf_config_uri and localize_file (absolute URIs).
     Input: conf/params/a4_margin_book.xml (merged config). project-root from pipeline. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:c="http://www.w3.org/ns/xproc-step" version="2.0">
  <xsl:param name="project-root" required="yes"/>
  <xsl:output method="xml" encoding="utf-8" indent="no"/>
  <xsl:template match="/">
    <xsl:variable name="config-uri" select="base-uri()"/>
    <xsl:variable name="localize-uri" select="resolve-uri('src/localize.xml', $project-root)"/>
    <c:param-set>
      <c:param name="pdf_config_uri" value="{$config-uri}"/>
      <c:param name="localize_file" value="{$localize-uri}"/>
    </c:param-set>
  </xsl:template>
</xsl:stylesheet>
