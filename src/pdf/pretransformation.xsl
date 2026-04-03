<?xml version="1.0" encoding="utf-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:include href="glossary.xsl"/>
  <xsl:output method="xml" indent="yes" encoding="utf-8"/>
  <xsl:param name="text_var_1_name"/>
  <xsl:param name="text_var_2_name"/>
  <xsl:param name="text_var_3_name"/>
  <xsl:param name="text_var_4_name"/>
  <xsl:param name="text_var_5_name"/>
  <xsl:param name="text_var_6_name"/>
  <xsl:param name="text_var_1_value"/>
  <xsl:param name="text_var_2_value"/>
  <xsl:param name="text_var_3_value"/>
  <xsl:param name="text_var_4_value"/>
  <xsl:param name="text_var_5_value"/>
  <xsl:param name="text_var_6_value"/>
  <xsl:param name="alphanum-prefix1">AAA</xsl:param>
  <xsl:param name="alphanum-prefix2">HHH</xsl:param>
  <xsl:param name="alphanum-prefix3">GGG</xsl:param>
  <xsl:param name="localize_file">localize.xml</xsl:param>
  <xsl:param name="print_supplemental_directives">no</xsl:param>
  <xsl:param name="print_toc">no</xsl:param>
  <xsl:param name="print_index">no</xsl:param>
  <xsl:param name="print_figure_index">no</xsl:param>
  <xsl:param name="print_footnote_index">no</xsl:param>
  <xsl:param name="print_appendix">no</xsl:param>
  <xsl:param name="print_cover_backpage">no</xsl:param>
  <xsl:param name="print_format">no</xsl:param>
  <xsl:param name="imagedir">sample</xsl:param>
  <xsl:variable name="supplemental-directives" select="if($print_supplemental_directives='yes') then true() else false()"/>
  <xsl:variable name="index" select="if($print_index='yes') then true() else false()"/>
  <xsl:variable name="toc" select="if($print_toc='yes') then true() else false()"/>
  <xsl:variable name="figure-index" select="if($print_figure_index='yes') then true() else false()"/>
  <xsl:variable name="footnote-index" select="if($print_footnote_index='yes') then true() else false()"/>
  <xsl:variable name="cover-backpage" select="if($print_cover_backpage='yes') then true() else false()"/>
  <xsl:variable name="appendix" select="if($print_appendix='yes') then true() else false()"/>
  <xsl:variable name="format">
    <xsl:choose>
      <xsl:when test="$print_format='no'">
        <xsl:value-of select="//meta/structure/format"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$print_format"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:template match="document">
    <xsl:copy>
      <title>
        <xsl:choose>
          <xsl:when test="title='[[$service-manual]]'">
            <xsl:call-template name="boilerplate-lookup">
              <xsl:with-param name="key">B_SERVICE_MANUAL</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="title='[[$installation-manual]]'">
            <xsl:call-template name="boilerplate-lookup">
              <xsl:with-param name="key">B_INSTALLATION_MANUAL</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="title='[[$user-manual]]'">
            <xsl:call-template name="boilerplate-lookup">
              <xsl:with-param name="key">B_OPERATING_MANUAL</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="title='[[$system-manual]]'">
            <xsl:call-template name="boilerplate-lookup">
              <xsl:with-param name="key">B_SYSTEM_MANUAL</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="title='[[$manual]]'">
            <xsl:call-template name="boilerplate-lookup">
              <xsl:with-param name="key">B_MANUAL</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="title"/>
          </xsl:otherwise>
        </xsl:choose>
      </title>
      <meta>
        <xsl:apply-templates select="meta/*[not(self::structure) and not(self::design)]"/>
        <structure>
          <xsl:apply-templates select="meta/structure/*[not(self::supplemental-directives) and not(self::index) and not(self::toc) and not(self::figure-index) and not(self::footnote-index)]"/>
        </structure>
        <xsl:apply-templates select="meta/design"/>
      </meta>
      <xsl:if test="$supplemental-directives and $format='book'">
        <supplemental-directives>
          <xsl:apply-templates select="chapter[position()=1]"/>
        </supplemental-directives>
      </xsl:if>
      <xsl:if test="$toc">
        <toc/>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$supplemental-directives and $cover-backpage and $format='book'">
          <xsl:apply-templates select="chapter[not(position()=1) and not(position()=last())]"/>
        </xsl:when>
        <xsl:when test="$supplemental-directives and $format='book'">
          <xsl:apply-templates select="chapter[not(position()=1)]"/>
        </xsl:when>
        <xsl:when test="$cover-backpage and $format='book'">
          <xsl:apply-templates select="chapter[not(position()=last())]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="chapter"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$figure-index">
        <figure-index/>
      </xsl:if>
      <xsl:if test="$footnote-index">
        <footnote-index/>
      </xsl:if>
      <xsl:if test="$index">
        <index/>
      </xsl:if>
      <xsl:if test="$appendix">
        <xsl:copy-of select="/document/meta/structure/appendix"/>
      </xsl:if>
      <xsl:if test="$cover-backpage  and $format='book'">
        <cover-backpage>
          <xsl:apply-templates select="chapter[position()=last() and not(position()=1)]"/>
        </cover-backpage>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="indexterm[not(ancestor::indexterm)]" priority="10">
    <xe>
      <first>
        <xsl:attribute name="criterion">
          <xsl:call-template name="get-criterion">
            <xsl:with-param name="sort-text" select="normalize-space(string-join(node()[not(self::indexterm)], ''))"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:copy-of select="node()[not(self::indexterm)]"/>
      </first>
      <xsl:if test="indexterm[1]">
        <second>
          <xsl:attribute name="criterion">
            <xsl:call-template name="get-criterion">
              <xsl:with-param name="sort-text" select="normalize-space(string-join(indexterm[1]/node()[not(self::indexterm)], ''))"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:copy-of select="indexterm[1]/node()[not(self::indexterm)]"/>
        </second>
      </xsl:if>
    </xe>
  </xsl:template>
  <xsl:template match="indexterm[ancestor::indexterm]" priority="10"/>
  <xsl:template match="chapter">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="id" select="generate-id()"/>
      <!-- link-id: prefer filename from data-src-href (topicref @href) so doclink class="filename.dita" resolves -->
      <xsl:attribute name="link-id" select="string(replace(string((@data-src-href, @id)[. != ''][1]), '^.*/', ''))"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="title[parent::block]" priority="10">
    <block-title>
      <xsl:apply-templates select="node()|@*"/>
    </block-title>
  </xsl:template>
  <xsl:template match="content">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="block|table[@pdfwidth='page']">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="*[@type='dl' and not(self::entry)] | danger | caution | notice | warning | verbatim | tbody[../@pdfwidth='page'] | figure[@pdfwidth='margin'] | figure[@pdfwidth='page']" priority="10">
    <page-wide-element>
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </page-wide-element>
    <xsl:if test="self::figure[@pdfwidth='margin'] and not(following-sibling::*)">
      <column-wide-element>
        <p/>
      </column-wide-element>
    </xsl:if>
  </xsl:template>
  <xsl:template match="block/*[not(self::table[@pdfwidth='page'])]|table[@pdfwidth='page']/caption|figure[@pdfwidth='page']/subtitle">
    <column-wide-element>
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </column-wide-element>
  </xsl:template>
  <xsl:template match="img">
    <img>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()"/>
    </img>
  </xsl:template>
  <xsl:template match="@style|@class[not(parent::doclink)]"/>
  <xsl:template match="li[string-length(normalize-space(string(.)))=0]"/>
  <xsl:template match="step[string-length(normalize-space(string(.)))=0]"/>
  <xsl:template match="cover-image|logo-image">
    <xsl:copy>
      <xsl:value-of select="."/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="page-margin">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="$format='book'">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:otherwise>leftright</xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="ul[preceding-sibling::*[1][self::figure[normalize-space(string(child::subtitle))='[[warning]]']]]">
    <column-wide-element>
      <warning>
        <cause>
          <xsl:value-of select="title"/>
        </cause>
        <xsl:for-each select="li">
          <consequence>
            <xsl:apply-templates select="p[string-length(normalize-space(string(.)))&gt;0]"/>
          </consequence>
        </xsl:for-each>
      </warning>
    </column-wide-element>
  </xsl:template>
  <xsl:template match="ul[preceding-sibling::*[1][self::figure[normalize-space(string(child::subtitle))='[[caution]]']]]">
    <column-wide-element>
      <caution>
        <cause>
          <xsl:value-of select="title"/>
        </cause>
        <xsl:for-each select="li">
          <consequence>
            <xsl:apply-templates select="p[string-length(normalize-space(string(.)))&gt;0]"/>
          </consequence>
        </xsl:for-each>
      </caution>
    </column-wide-element>
  </xsl:template>
  <xsl:template match="ul[preceding-sibling::*[1][self::figure[normalize-space(string(child::subtitle))='[[danger]]']]]">
    <column-wide-element>
      <danger>
        <cause>
          <xsl:value-of select="title"/>
        </cause>
        <xsl:for-each select="li">
          <consequence>
            <xsl:apply-templates select="p[string-length(normalize-space(string(.)))&gt;0]"/>
          </consequence>
        </xsl:for-each>
      </danger>
    </column-wide-element>
  </xsl:template>
  <xsl:template match="ul[preceding-sibling::*[1][self::figure[normalize-space(string(child::subtitle))='[[notice]]']]]">
    <column-wide-element>
      <notice>
        <cause>
          <xsl:value-of select="title"/>
        </cause>
        <xsl:for-each select="li">
          <consequence>
            <xsl:apply-templates select="p[string-length(normalize-space(string(.)))&gt;0]"/>
          </consequence>
        </xsl:for-each>
      </notice>
    </column-wide-element>
  </xsl:template>
  <xsl:template match="figure[normalize-space(string(child::subtitle))='[[warning]]']"/>
  <xsl:template match="figure[normalize-space(string(child::subtitle))='[[caution]]']"/>
  <xsl:template match="figure[normalize-space(string(child::subtitle))='[[danger]]']"/>
  <xsl:template match="figure[normalize-space(string(child::subtitle))='[[notice]]']"/>
  <xsl:template match="text()[ancestor::verbatim]" priority="10">
    <xsl:analyze-string select="." regex="&lt;[^&gt;^!]+&gt;">
      <xsl:matching-substring>
        <xsl:choose>
          <xsl:when test="contains(current(),' ')">
            <color name="green">
              <xsl:value-of select="substring-before(current(),' ')"/>
            </color>
            <xsl:text> </xsl:text>
            <xsl:choose>
              <xsl:when test="contains(current(),'/&gt;')">
                <xsl:value-of select="substring-before(substring-after(current(),' '),'/&gt;')"/>
                <color name="green">
                  <xsl:text>/&gt;</xsl:text>
                </color>
              </xsl:when>
              <xsl:when test="contains(current(),'&gt;')">
                <xsl:value-of select="substring-before(substring-after(current(),' '),'&gt;')"/>
                <color name="green">
                  <xsl:text>&gt;</xsl:text>
                </color>
              </xsl:when>
              <xsl:otherwise>
            				</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <color name="green">
              <xsl:value-of select="current()"/>
            </color>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:analyze-string select="." regex="for |let |return |where |order |if |then |                                                   else |declare |function |namespace |module |variable | in |\w[a-zA-Z\-]+:[a-zA-Z\-]+\(|\$[a-zA-Z\-]+">
          <xsl:matching-substring>
            <xsl:choose>
              <xsl:when test="contains(.,'(')">
                <color name="blue">
                  <xsl:value-of select="substring-before(current(),'(')"/>
                </color>
                <xsl:text>(</xsl:text>
              </xsl:when>
              <xsl:when test="contains(.,'$')">
                <color name="red">
                  <xsl:value-of select="current()"/>
                </color>
              </xsl:when>
              <xsl:otherwise>
                <color name="brown">
                  <xsl:value-of select="current()"/>
                </color>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <xsl:value-of select="."/>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>
  <xsl:template match="text()[ancestor::chapter  and not(ancestor::code)]">
    <xsl:analyze-string select="." regex="\[\[(.*?)\]\]">
      <xsl:matching-substring>
        <xsl:variable name="flesh" select="normalize-space(.)"/>
        <xsl:choose>
          <xsl:when test="$flesh=concat('[[$',$text_var_1_name,']]')">
            <ph outputclass="nb">
              <xsl:value-of select="replace($text_var_1_value,'\+',' ')"/>
            </ph>
          </xsl:when>
          <xsl:when test="$flesh=concat('[[$',$text_var_2_name,']]')">
            <ph outputclass="nb">
              <xsl:value-of select="replace($text_var_2_value,'\+',' ')"/>
            </ph>
          </xsl:when>
          <xsl:when test="$flesh=concat('[[$',$text_var_3_name,']]')">
            <ph outputclass="nb">
              <xsl:value-of select="replace($text_var_3_value,'\+',' ')"/>
            </ph>
          </xsl:when>
          <xsl:when test="$flesh=concat('[[$',$text_var_4_name,']]')">
            <ph outputclass="nb">
              <xsl:value-of select="replace($text_var_4_value,'\+',' ')"/>
            </ph>
          </xsl:when>
          <xsl:when test="$flesh=concat('[[$',$text_var_5_name,']]')">
            <ph outputclass="nb">
              <xsl:value-of select="replace($text_var_5_value,'\+',' ')"/>
            </ph>
          </xsl:when>
          <xsl:when test="$flesh=concat('[[$',$text_var_6_name,']]')">
            <ph outputclass="nb">
              <xsl:value-of select="replace($text_var_6_value,'\+',' ')"/>
            </ph>
          </xsl:when>
          <xsl:when test="$flesh='[[glossary]]'">
            <glossary/>
          </xsl:when>
          <xsl:when test="$flesh='[[link]]'"/>
          <xsl:when test="$flesh='[[chaptertoc]]'">
            <chapter-toc/>
          </xsl:when>
          <xsl:when test="$flesh='[[O]]'">
            <unchecked/>
          </xsl:when>
          <xsl:when test="$flesh='[[X]]'">
            <checked/>
          </xsl:when>
          <xsl:when test="$flesh='[[br]]'">
            <br/>
          </xsl:when>
          <xsl:when test="$flesh='[[colbr]]'">
            <colbr/>
          </xsl:when>
          <xsl:when test="contains($flesh,'xe1') or contains($flesh,'xe2')">
            <xe>
              <first>
                <xsl:attribute name="criterion">
                  <xsl:choose>
                    <xsl:when test="contains(.,'xe2')">
                      <xsl:call-template name="get-criterion">
                        <xsl:with-param name="sort-text" select="normalize-space(substring-after(substring-before($flesh, ';'),':'))"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="get-criterion">
                        <xsl:with-param name="sort-text" select="normalize-space(substring-after(substring-before($flesh, ']]'),':'))"/>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="contains(.,'xe2')">
                    <xsl:value-of select="normalize-space(substring-after(substring-before($flesh, ';'),':'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(substring-after(substring-before($flesh, ']]'),':'))"/>
                  </xsl:otherwise>
                </xsl:choose>
              </first>
              <xsl:if test="contains(.,'xe2')">
                <second>
                  <xsl:attribute name="criterion">
                    <xsl:call-template name="get-criterion">
                      <xsl:with-param name="sort-text" select="normalize-space(substring-after(substring-before(substring-after(.,';'),']]'),':'))"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:value-of select="normalize-space(substring-after(substring-before(substring-after(.,';'),']]'),':'))"/>
                </second>
              </xsl:if>
            </xe>
          </xsl:when>
          <xsl:when test="contains(translate($flesh,' ',''),'nb:')">
            <ph outputclass="nb">
              <xsl:value-of select="normalize-space(substring-before(substring-after($flesh,':'),']]'))"/>
            </ph>
          </xsl:when>
          <xsl:when test="contains(translate($flesh,' ',''),'cellcol:')">
            <cellcol color="{normalize-space(substring-before(substring-after($flesh,':'),']]'))}"/>
          </xsl:when>
          <xsl:when test="contains(translate($flesh,' ',''),'colcol:')">
            <colcol color="{normalize-space(substring-before(substring-after($flesh,':'),']]'))}"/>
          </xsl:when>
          <xsl:when test="contains(translate($flesh,' ',''),'rowcol:')">
            <rowcol color="{normalize-space(substring-before(substring-after($flesh,':'),']]'))}"/>
          </xsl:when>
          <xsl:when test="contains(translate($flesh,' ',''),'txtcol:')">
            <txtcol color="{normalize-space(substring-before(substring-after($flesh,':'),']]'))}"/>
          </xsl:when>
          <xsl:when test="contains(translate($flesh,' ',''),'subtitle:')">
            <chapter-subtitle>
              <xsl:value-of select="normalize-space(substring-before(substring-after($flesh,':'),']]'))"/>
            </chapter-subtitle>
          </xsl:when>
          <xsl:when test="contains(translate($flesh,' ',''),'code:')">
            <code>
              <ph outputclass="nb">
                <xsl:value-of select="normalize-space(substring-before(substring-after($flesh,':'),']]'))"/>
              </ph>
            </code>
          </xsl:when>
          <xsl:when test="contains(translate($flesh,' ',''),'fn:')">
            <xsl:choose>
              <xsl:when test="contains($flesh,';')">
                <footnote>
                  <xsl:choose>
                    <xsl:when test="contains($flesh,'*')">
                      <key>
                        <xsl:value-of select="normalize-space(substring-before(substring-after($flesh,':'),';'))"/>
                      </key>
                      <desc>
                        <xsl:value-of select="normalize-space(substring-before(substring-after($flesh,';'),'*'))"/>
                      </desc>
                      <add>
                        <xsl:value-of select="normalize-space(substring-before(substring-after($flesh,'*'),']]'))"/>
                      </add>
                    </xsl:when>
                    <xsl:otherwise>
                      <key>
                        <xsl:value-of select="normalize-space(substring-before(substring-after($flesh,':'),';'))"/>
                      </key>
                      <desc>
                        <xsl:value-of select="normalize-space(substring-before(substring-after($flesh,';'),']]'))"/>
                      </desc>
                    </xsl:otherwise>
                  </xsl:choose>
                </footnote>
              </xsl:when>
              <xsl:when test="contains($flesh,'*')">
                <footnote>
                  <desc>
                    <xsl:value-of select="normalize-space(substring-before(substring-after($flesh,':'),'*'))"/>
                  </desc>
                  <add>
                    <xsl:value-of select="normalize-space(substring-before(substring-after($flesh,'*'),']]'))"/>
                  </add>
                </footnote>
              </xsl:when>
              <xsl:otherwise>
                <footnote>
                  <desc>
                    <xsl:value-of select="normalize-space(substring-before(substring-after($flesh,':'),']]'))"/>
                  </desc>
                </footnote>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>
  <xsl:template name="boilerplate-lookup">
    <xsl:param name="key" select="none"/>
    <xsl:variable name="language" select="substring-before(//meta/language,'-')"/>
    <xsl:variable name="variant" select="substring-after(//meta/language,'-')"/>
    <xsl:variable name="boilerplate" select="document($localize_file)//boilerplate"/>
    <xsl:variable name="default-boilerplate" select="document($localize_file)//boilerplate"/>
    <xsl:variable name="missing-string">
      <xsl:value-of select="concat('ERROR! cannot be found in boilerplate text [', $language, ']')"/>
    </xsl:variable>
    <xsl:variable name="retval">
      <xsl:value-of select="$boilerplate//text[@key=$key]/translation[@lang=$language]"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="string-length($retval) &gt; 0">
        <xsl:apply-templates select="$boilerplate//text[@key=$key]/translation[@lang=$language]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="default-retval">
          <xsl:value-of select="$default-boilerplate//text[@key=$key]/translation[@lang='de']"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length($default-retval) &gt; 0">
            <xsl:apply-templates select="$default-boilerplate//text[@key=$key]/translation[@lang='de']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($missing-string,'[',$key,']')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="get-criterion">
    <xsl:param name="sort-text"/>
    <xsl:variable name="numbers">0123456789</xsl:variable>
    <xsl:variable name="special-chars">ΑαΒβΓγΔδΕεΖζΗηΘθΙιΚκΛλΜμΝνΞξΟοΠπΡρΣσΤτΥυΦφΧχΨψΩω'!•"#%&amp;()*,-./:;?@[\]_{|}¡¦©«¬­®°µ¶·»¿–‘—’‚“”„†‡…‰‹›⁄$¢£¤¥€ℓ™Ω℮+&lt;=&gt;±×÷∂∆∏∑−√∞∫≈≠≤≥◊"</xsl:variable>
    <xsl:variable name="special-numbers">¼½¾</xsl:variable>
    <xsl:variable name="element-text">
      <xsl:choose>
        <xsl:when test="starts-with($sort-text,$alphanum-prefix1)">
          <xsl:value-of select="substring-after($sort-text,$alphanum-prefix1)"/>
        </xsl:when>
        <xsl:when test="starts-with($sort-text,$alphanum-prefix2)">
          <xsl:value-of select="substring-after($sort-text,$alphanum-prefix2)"/>
        </xsl:when>
        <xsl:when test="starts-with($sort-text,$alphanum-prefix3)">
          <xsl:value-of select="substring-after($sort-text,$alphanum-prefix3)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$sort-text"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="first-char">
      <xsl:value-of select="substring(normalize-space($element-text),1,1)"/>
    </xsl:variable>
    <xsl:variable name="criterion">
      <xsl:choose>
        <xsl:when test="contains($numbers,$first-char)">
          <xsl:variable name="second-char" select="substring(normalize-space($element-text),2,1)"/>
          <xsl:variable name="third-char" select="substring(normalize-space($element-text),3,1)"/>
          <xsl:variable name="fourth-char" select="substring(normalize-space($element-text),4,1)"/>
          <xsl:variable name="fifth-char" select="substring(normalize-space($element-text),5,1)"/>
          <xsl:variable name="sixth-char" select="substring(normalize-space($element-text),6,1)"/>
          <xsl:variable name="seventh-char" select="substring(normalize-space($element-text),7,1)"/>
          <xsl:variable name="eighth-char" select="substring(normalize-space($element-text),8,1)"/>
          <xsl:variable name="ninth-char" select="substring(normalize-space($element-text),9,1)"/>
          <xsl:variable name="numeric-part">
            <xsl:choose>
              <xsl:when test="not(contains($numbers,$second-char)) or string-length($second-char)=0">
                <xsl:value-of select="concat('00000000',normalize-space($element-text))"/>
              </xsl:when>
              <xsl:when test="not(contains($numbers,$third-char)) or string-length($third-char)=0">
                <xsl:value-of select="concat('0000000',normalize-space($element-text))"/>
              </xsl:when>
              <xsl:when test="not(contains($numbers,$fourth-char)) or string-length($fourth-char)=0">
                <xsl:value-of select="concat('000000',normalize-space($element-text))"/>
              </xsl:when>
              <xsl:when test="not(contains($numbers,$fifth-char)) or string-length($fifth-char)=0">
                <xsl:value-of select="concat('00000',normalize-space($element-text))"/>
              </xsl:when>
              <xsl:when test="not(contains($numbers,$sixth-char)) or string-length($sixth-char)=0">
                <xsl:value-of select="concat('0000',normalize-space($element-text))"/>
              </xsl:when>
              <xsl:when test="not(contains($numbers,$seventh-char)) or string-length($seventh-char)=0">
                <xsl:value-of select="concat('000',normalize-space($element-text))"/>
              </xsl:when>
              <xsl:when test="not(contains($numbers,$eighth-char)) or string-length($eighth-char)=0">
                <xsl:value-of select="concat('00',normalize-space($element-text))"/>
              </xsl:when>
              <xsl:when test="not(contains($numbers,$ninth-char)) or string-length($ninth-char)=0">
                <xsl:value-of select="concat('0',normalize-space($element-text))"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space($element-text)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="starts-with($sort-text,$alphanum-prefix1)">
              <xsl:value-of select="concat($alphanum-prefix1,$numeric-part)"/>
            </xsl:when>
            <xsl:when test="starts-with($sort-text,$alphanum-prefix2)">
              <xsl:value-of select="concat($alphanum-prefix2,$numeric-part)"/>
            </xsl:when>
            <xsl:when test="starts-with($sort-text,$alphanum-prefix3)">
              <xsl:value-of select="concat($alphanum-prefix3,$numeric-part)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$numeric-part"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($special-numbers,$first-char)">
          <xsl:value-of select="concat('9999',normalize-space($element-text))"/>
        </xsl:when>
        <xsl:when test="contains($special-chars,$first-char)">
          <xsl:variable name="unicode-codepoint-number">
            <xsl:value-of select="string-to-codepoints($first-char)"/>
          </xsl:variable>
          <xsl:variable name="second-char" select="substring(normalize-space($unicode-codepoint-number),2,1)"/>
          <xsl:variable name="third-char" select="substring(normalize-space($unicode-codepoint-number),3,1)"/>
          <xsl:variable name="fourth-char" select="substring(normalize-space($unicode-codepoint-number),4,1)"/>
          <xsl:variable name="codepoint-string">
            <xsl:choose>
              <xsl:when test="not(contains($numbers,$second-char)) or string-length($second-char)=0">
                <xsl:value-of select="concat('000',$unicode-codepoint-number)"/>
              </xsl:when>
              <xsl:when test="not(contains($numbers,$third-char)) or string-length($third-char)=0">
                <xsl:value-of select="concat('00',$unicode-codepoint-number)"/>
              </xsl:when>
              <xsl:when test="not(contains($numbers,$fourth-char)) or string-length($fourth-char)=0">
                <xsl:value-of select="concat('0',$unicode-codepoint-number)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$unicode-codepoint-number"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:value-of select="concat('#',$codepoint-string,normalize-space($element-text))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space($element-text)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="new_criterion">
      <xsl:value-of select="translate(translate($criterion,'）',')'),'（','(')"/>
    </xsl:variable>
    <xsl:value-of select="translate(translate($new_criterion,'ー',''),'ｰ','')"/>
  </xsl:template>
  <xsl:template match="colspec">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="string-length(@colwidth)&gt;0">
        <xsl:variable name="total-colwidth" select="sum(../*/@colwidth)"/>
        <xsl:variable name="this-colwidth" select="@colwidth"/>
        <xsl:attribute name="colwidth" select="concat($this-colwidth div $total-colwidth,'*')"/>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="abstract/abstract">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="symbol[not(parent::p)]">
    <figure pdfwidth="column">
      <img src="{@src}"/>
    </figure>
  </xsl:template>
  <xsl:template match="symbol[parent::p]">
    <xsl:copy-of select="."/>
  </xsl:template>
</xsl:stylesheet>
