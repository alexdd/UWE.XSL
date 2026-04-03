<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - Report FO link errors (ERROR! Linktarget does not exist) before FOP.
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     Input: fixed FO document. Output: report XML for logging. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:param name="lang" select="''"/>
  <xsl:template match="/">
    <link-errors-report lang="{$lang}">
      <xsl:variable name="error-prefix" select="'ERROR! Linktarget does not exist '"/>
      <xsl:for-each select=".//fo:inline[contains(., $error-prefix)]">
        <error>
          <target>
            <xsl:value-of select="normalize-space(replace(., concat('.*', $error-prefix), ''))"/>
          </target>
          <context>
            <xsl:value-of select="normalize-space(substring(string(.), 1, 200))"/>
          </context>
        </error>
      </xsl:for-each>
      <summary total="{count(.//fo:inline[contains(., $error-prefix)])}"/>
    </link-errors-report>
  </xsl:template>
</xsl:stylesheet>
