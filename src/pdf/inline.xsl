<?xml version="1.0" encoding="utf-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xe="http://www.xes.future" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
  <!-- ========== Inline: Emphasis and font ========== -->
  <xsl:template match="u">
    <xsl:choose>
      <xsl:when test="@background-color">
        <fo:inline background-color="{@background-color}" text-decoration="{@text-decoration}">
          <xsl:apply-templates/>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <fo:inline text-decoration="underline">
          <xsl:apply-templates/>
        </fo:inline>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="b">
    <xsl:choose>
      <xsl:when test="@text-decoration">
        <fo:inline>
          <xsl:choose>
            <xsl:when test="ancestor::verbatim">
              <xsl:attribute name="font-weight">bold</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="font-family">Noto Sans Bold</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:attribute name="text-decoration">underline</xsl:attribute>
          <xsl:attribute name="font-size" select="@font-size"/>
          <xsl:apply-templates/>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <fo:inline>
          <xsl:call-template name="b-styles"/>
          <xsl:apply-templates/>
        </fo:inline>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="i">
    <fo:inline xsl:use-attribute-sets="gui-element">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <xsl:template match="sup">
    <fo:inline xsl:use-attribute-sets="sup">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <xsl:template match="sub">
    <fo:inline xsl:use-attribute-sets="sub">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <xsl:template match="ph[@outputclass='nb']">
    <fo:inline xsl:use-attribute-sets="nb" hyphenate="false">
      <xsl:value-of select="string-join(for $ch in string-to-codepoints(.) return concat(codepoints-to-string($ch),'﻿'),'')"/>
    </fo:inline>
  </xsl:template>
  <xsl:template match="code">
    <fo:inline xsl:use-attribute-sets="code">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <!-- ========== Inline: Links ========== -->
  <xsl:template match="url">
    <fo:basic-link external-destination="url({@address})">
      <xsl:call-template name="url-styles"/>
      <xsl:value-of select="normalize-space(.)"/>
    </fo:basic-link>
  </xsl:template>
  <xsl:template match="doclink">
    <xsl:variable name="target" select="normalize-space(@class)"/>
    <xsl:variable name="is-external-url" select="             starts-with($target, 'http:') or             starts-with($target, 'https:') or             starts-with($target, 'www.')"/>
    <!-- Normalize internal target to filename so it matches chapter link-id (from topicref @href) -->
    <xsl:variable name="target-filename" select="replace($target, '^.*/', '')"/>
    <xsl:variable name="target-id" select="$rooty/descendant::*[@link-id = $target-filename or @link-id = $target]/generate-id()"/>
    <xsl:choose>
      <xsl:when test="$is-external-url">
        <fo:basic-link external-destination="{$target}" color="blue">
          <fo:inline keep-together.within-line="6" hyphenate="false">
            <xsl:call-template name="link-styles"/>
            <xsl:apply-templates/>
          </fo:inline>
        </fo:basic-link>
      </xsl:when>
      <xsl:when test="string-length($target-id)&gt;0">
        <fo:basic-link internal-destination="{$target-id}" color="blue">
          <fo:inline keep-together.within-line="6" hyphenate="false">
            <xsl:call-template name="link-styles"/>
            <xsl:value-of select="."/>
            <xsl:if test="@type='topic'">
              <xsl:text> </xsl:text>
              <xsl:call-template name="boilerplate-lookup">
                <xsl:with-param name="key">B_ON</xsl:with-param>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:call-template name="boilerplate-lookup">
                <xsl:with-param name="key">B_PAGE</xsl:with-param>
              </xsl:call-template>
              <xsl:text> </xsl:text>
              <fo:page-number-citation ref-id="{$target-id}"/>
            </xsl:if>
          </fo:inline>
        </fo:basic-link>
      </xsl:when>
      <xsl:otherwise>
        <fo:inline color="red">ERROR! Linktarget does not exist <xsl:value-of select="$target"/></fo:inline>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ========== Inline: Farbe, Markierung, Symbol ========== -->
  <xsl:template match="color">
    <fo:inline>
      <xsl:attribute name="color">
        <xsl:choose>
          <xsl:when test="@name='blue'">#000099</xsl:when>
          <xsl:when test="@name='brown'">#7F3300</xsl:when>
          <xsl:when test="@name='green'">#527F3F</xsl:when>
          <xsl:when test="@name='red'">#7F0037</xsl:when>
          <xsl:otherwise>black</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <xsl:template match="s">
    <fo:inline>
      <xsl:attribute name="background-color">#D4D4D4</xsl:attribute>
      <xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
      <xsl:attribute name="hyphenate">false</xsl:attribute>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <xsl:template match="symbol">
    <fo:external-graphic xsl:use-attribute-sets="symbol">
        </fo:external-graphic>
  </xsl:template>
  <!-- ========== Inline: Checkbox-Darstellung ========== -->
  <xsl:template match="checked">
    <fo:inline font-family="Noto Sans Symbols" font-size="180%">🅇</fo:inline>
  </xsl:template>
  <xsl:template match="unchecked">
    <fo:inline font-family="Noto Sans Symbols" font-size="180%" baseline-shift="-2px">⏍</fo:inline>
  </xsl:template>
</xsl:stylesheet>
