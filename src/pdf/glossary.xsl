<?xml version="1.0"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xe="http://www.xes.future" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
  <!-- Topic may use empty title + map navtitle [[glossary]]; after pretrans, content/ is unwrapped — detect via link-id / data-src-href too. -->
  <xsl:template match="table[@type='dl' and ancestor::chapter[      contains(string(content/title),'[[glossary]]')      or (contains(lower-case(string(@link-id)),'glossary') and not(contains(lower-case(string(@link-id)),'nonglossary')))      or (contains(lower-case(string(@data-src-href)),'glossary') and not(contains(lower-case(string(@data-src-href)),'nonglossary')))  ]]" priority="50">
    <xsl:for-each-group select="tgroup/tbody/row[position() gt 1]" group-by="substring(normalize-space(string(entry[1])),1,1)">
      <xsl:sort select="normalize-space(replace(replace(replace(lower-case(string(entry[1])),'&#xFC;','uzz'),'&#xE4;','azz'),'&#xF6;','ozz'))"/>
      <block-title style="larger">
        <title>
          <b>
            <xsl:value-of select="upper-case(replace(replace(replace(lower-case(current-grouping-key()),'&#xFC;','u'),'&#xE4;','a'),'&#xF6;','o'))"/>
          </b>
        </title>
      </block-title>
      <column-wide-element>
        <table type="dl">
          <xsl:if test="position()=1">
            <xsl:attribute name="id">glossary</xsl:attribute>
          </xsl:if>
          <tgroup>
            <colspec colwidth="2*"/>
            <colspec colwidth="4*"/>
            <tbody>
              <xsl:for-each select="current-group()">
                <row>
                  <entry htmlwidth="30%">
                    <b>
                      <xsl:apply-templates select="entry[1]/node()"/>
                    </b>
                  </entry>
                  <entry htmlwidth="70%">
                    <xsl:apply-templates select="entry[2]/node()"/>
                  </entry>
                </row>
              </xsl:for-each>
            </tbody>
          </tgroup>
        </table>
      </column-wide-element>
    </xsl:for-each-group>
  </xsl:template>
</xsl:stylesheet>
