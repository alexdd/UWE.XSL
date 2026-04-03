<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text.
     Loads a document by URI and outputs it. Used when order matters (source = previous step); p:load has no source port. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
  <xsl:param name="uri" as="xs:string" required="yes"/>
  <xsl:template match="/">
    <xsl:copy-of select="document($uri)"/>
  </xsl:template>
</xsl:stylesheet>
