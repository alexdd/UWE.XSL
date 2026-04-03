<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:c="http://www.w3.org/ns/xproc-step" version="2.0">
  <xsl:output method="xml" encoding="utf-8" indent="no"/>
  <xsl:template match="/">
    <c:param-set>
      <c:param name="map-href" value="{base-uri()}"/>
    </c:param-set>
  </xsl:template>
</xsl:stylesheet>
