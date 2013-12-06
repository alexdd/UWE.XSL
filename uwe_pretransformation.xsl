<?xml version="1.0" encoding="utf-8"?>

<!-- ============================================================================
#    UWE.XSL generates good looking customizable PDF output from a single XML source 
#                 using Apache FOP as PDF formatter
#
#    < uwe_pretransformation.xsl />
#    This is the pretransformation stylesheet (uwe_pretransformation.xsl) which should be applied 
#    on the XML source before applying uwe.xsl
#
#    Set parameters in order to customize or override templates and import into your stylesheets.
#    You can also set localization options in file localize.xml
#
#    This file was automatically generated/assembled by a Python script (stylesheet_generator.py)
#    which has not yet been released to the public domain - because there is still some important work 
#    to do ...
#
#    Copyright (C) 2012-2013  by Alex Duesel <alex@alex-duesel.de>
#                                       homepage: http://www.mandarine.tv
#                                       See file license.txt for licensing issues
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Lesser General Public License as published by
#    the Free Software Foundation, either version 3 of the License.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Lesser General Public License for more details.
#
#    You should have received a copy of the GNU Lesser General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#============================================================================-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
    <xsl:param name="localize_file">uwe_localize.xml</xsl:param>
    <xsl:param name="print_supplemental_directives">no</xsl:param>
    <xsl:param name="print_toc">no</xsl:param>
    <xsl:param name="print_index">no</xsl:param>
    <xsl:param name="print_figure_index">no</xsl:param>
    <xsl:param name="print_footnote_index">no</xsl:param>
    <xsl:param name="print_cover_backpage">no</xsl:param>
    <xsl:param name="print_format">no</xsl:param>
    <xsl:param name="imagedir">sample</xsl:param>
    <xsl:variable name="supplemental-directives">
	<xsl:choose>
		<xsl:when test="$print_supplemental_directives='yes'">
			<xsl:value-of select="true()"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="if(//meta/structure/supplemental-directives) then true() else false()"/>
		</xsl:otherwise>
	</xsl:choose>
    </xsl:variable>
    <xsl:variable name="index">
	<xsl:choose>
		<xsl:when test="$print_index='yes'">
			<xsl:value-of select="true()"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="if(//meta/structure/index) then true() else false()"/>
		</xsl:otherwise>
	</xsl:choose>
    </xsl:variable>
    <xsl:variable name="toc">
	<xsl:choose>
		<xsl:when test="$print_toc='yes'">
			<xsl:value-of select="true()"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="if(//meta/structure/toc) then true() else false()"/>
		</xsl:otherwise>
	</xsl:choose>
    </xsl:variable>
    <xsl:variable name="figure-index">
	<xsl:choose>
		<xsl:when test="$print_figure_index">
			<xsl:value-of select="true()"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="if(//meta/structure/figure-index) then true() else false()"/>
		</xsl:otherwise>
	</xsl:choose>
    </xsl:variable>
   <xsl:variable name="footnote-index">
	<xsl:choose>
		<xsl:when test="$print_figure_index">
			<xsl:value-of select="true()"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="if(//meta/structure/footnote-index) then true() else false()"/>
		</xsl:otherwise>
	</xsl:choose>
    </xsl:variable>
   <xsl:variable name="cover-backpage">
	<xsl:choose>
		<xsl:when test="$print_cover_backpage">
			<xsl:value-of select="true()"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="if(//meta/structure/cover-backpage) then true() else false()"/>
		</xsl:otherwise>
	</xsl:choose>
    </xsl:variable>
	<xsl:variable name="format">
		<xsl:choose>
			<xsl:when test="$print_format='no'">
				<xsl:value-of select="//meta/format"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$print_format"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
    <xsl:template match="document">
        <xsl:copy>
            <xsl:copy-of select="title"/>
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
            <xsl:if test="$cover-backpage  and $format='book'">
                <cover-backpage>
                    <xsl:apply-templates select="chapter[position()=last() and not(position()=1)]"/>
                </cover-backpage>
            </xsl:if>
        </xsl:copy>
    </xsl:template>
   <xsl:template match="node()|@*" >
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="title[parent::block]" priority="10">
        <block-title>
            <xsl:apply-templates select="node()|@*"/>
        </block-title>
    </xsl:template>
    <xsl:template match="content">
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="block|table[@pdfwidth='page']">
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="verbatim | tbody[../@pdfwidth='page'] | figure[@pdfwidth='margin'] | figure[@pdfwidth='page']" priority="10" >
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
    <xsl:template match="@style|@class[not(parent::doclink)]" />
    <xsl:template match="li[string-length(normalize-space(string(.)))=0]" />
    <xsl:template match="step[string-length(normalize-space(string(.)))=0]" />
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
    <xsl:template match="text()[ancestor::chapter  and not(ancestor::code)]">
        <xsl:analyze-string select="." regex="\[\[(.*?)\]\]">
            <xsl:matching-substring>
                <xsl:variable name="flesh" select="normalize-space(.)"/>
                <xsl:choose>
                    <xsl:when test="$flesh=concat('[[$',$text_var_1_name,']]')">
                        <b><nb><xsl:value-of select="$text_var_1_value"/></nb></b>
                    </xsl:when>
                    <xsl:when test="$flesh=concat('[[$',$text_var_2_name,']]')">
                        <b><nb><xsl:value-of select="$text_var_2_value"/></nb></b>
                    </xsl:when>
                    <xsl:when test="$flesh=concat('[[$',$text_var_3_name,']]')">
                        <b><nb><xsl:value-of select="$text_var_3_value"/></nb></b>
                    </xsl:when>
                    <xsl:when test="$flesh=concat('[[$',$text_var_4_name,']]')">
                        <b><nb><xsl:value-of select="$text_var_4_value"/></nb></b>
                    </xsl:when>
                    <xsl:when test="$flesh=concat('[[$',$text_var_5_name,']]')">
                        <b><nb><xsl:value-of select="$text_var_5_value"/></nb></b>
                    </xsl:when>
                    <xsl:when test="$flesh=concat('[[$',$text_var_6_name,']]')">
                        <b><nb><xsl:value-of select="$text_var_6_value"/></nb></b>
                    </xsl:when>
                    <xsl:when test="$flesh='[[chaptertoc]]'">
                        <chapter-toc/>
                    </xsl:when>
                    <xsl:when test="$flesh='[[O]]'">
                        <unchecked/>
                    </xsl:when>
                    <xsl:when test="$flesh='[[X]]'">
                        <checked/>
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
                        <nb>
                            <xsl:value-of select="normalize-space(substring-before(substring-after($flesh,':'),']]'))"/>
                        </nb>
                    </xsl:when>
                    <xsl:when test="contains(translate($flesh,' ',''),'subtitle:')">
                        <subtitle>
                            <xsl:value-of select="normalize-space(substring-before(substring-after($flesh,':'),']]'))"/>
                        </subtitle>
                    </xsl:when>
                    <xsl:when test="contains(translate($flesh,' ',''),'fn:')">
                        <xsl:choose>
                            <xsl:when test="contains($flesh,';')">
                                <footnote>
                                    <key>
                                        <xsl:value-of select="normalize-space(substring-before(substring-after($flesh,':'),';'))"/>
                                    </key>
                                    <desc>
                                        <xsl:value-of select="normalize-space(substring-before(substring-after($flesh,';'),']]'))"/>
                                    </desc>
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
                    <xsl:otherwise></xsl:otherwise>
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
                        <xsl:variable name="second-char"
                            select="substring(normalize-space($element-text),2,1)"/>
                        <xsl:variable name="third-char"
                            select="substring(normalize-space($element-text),3,1)"/>
                        <xsl:variable name="fourth-char"
                            select="substring(normalize-space($element-text),4,1)"/>
                        <xsl:variable name="fifth-char"
                            select="substring(normalize-space($element-text),5,1)"/>
                        <xsl:variable name="sixth-char"
                            select="substring(normalize-space($element-text),6,1)"/>
                        <xsl:variable name="seventh-char"
                            select="substring(normalize-space($element-text),7,1)"/>
                        <xsl:variable name="eighth-char"
                            select="substring(normalize-space($element-text),8,1)"/>
                        <xsl:variable name="ninth-char"
                            select="substring(normalize-space($element-text),9,1)"/>
                        <xsl:variable name="numeric-part">
                            <xsl:choose>
                                <xsl:when
                                    test="not(contains($numbers,$second-char)) or string-length($second-char)=0">
                                    <xsl:value-of
                                        select="concat('00000000',normalize-space($element-text))"/>
                                </xsl:when>
                                <xsl:when
                                    test="not(contains($numbers,$third-char)) or string-length($third-char)=0">
                                    <xsl:value-of
                                        select="concat('0000000',normalize-space($element-text))"/>
                                </xsl:when>
                                <xsl:when
                                    test="not(contains($numbers,$fourth-char)) or string-length($fourth-char)=0">
                                    <xsl:value-of
                                        select="concat('000000',normalize-space($element-text))"/>
                                </xsl:when>
                                <xsl:when
                                    test="not(contains($numbers,$fifth-char)) or string-length($fifth-char)=0">
                                    <xsl:value-of
                                        select="concat('00000',normalize-space($element-text))"/>
                                </xsl:when>
                                <xsl:when
                                    test="not(contains($numbers,$sixth-char)) or string-length($sixth-char)=0">
                                    <xsl:value-of
                                        select="concat('0000',normalize-space($element-text))"/>
                                </xsl:when>
                                <xsl:when
                                    test="not(contains($numbers,$seventh-char)) or string-length($seventh-char)=0">
                                    <xsl:value-of
                                        select="concat('000',normalize-space($element-text))"/>
                                </xsl:when>
                                <xsl:when
                                    test="not(contains($numbers,$eighth-char)) or string-length($eighth-char)=0">
                                    <xsl:value-of
                                        select="concat('00',normalize-space($element-text))"/>
                                </xsl:when>
                                <xsl:when
                                    test="not(contains($numbers,$ninth-char)) or string-length($ninth-char)=0">
                                    <xsl:value-of
                                        select="concat('0',normalize-space($element-text))"/>
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
                        <xsl:variable name="second-char"
                            select="substring(normalize-space($unicode-codepoint-number),2,1)"/>
                        <xsl:variable name="third-char"
                            select="substring(normalize-space($unicode-codepoint-number),3,1)"/>
                        <xsl:variable name="fourth-char"
                            select="substring(normalize-space($unicode-codepoint-number),4,1)"/>
                        <xsl:variable name="codepoint-string">
                            <xsl:choose>
                                <xsl:when
                                    test="not(contains($numbers,$second-char)) or string-length($second-char)=0">
                                    <xsl:value-of select="concat('000',$unicode-codepoint-number)"/>
                                </xsl:when>
                                <xsl:when
                                    test="not(contains($numbers,$third-char)) or string-length($third-char)=0">
                                    <xsl:value-of select="concat('00',$unicode-codepoint-number)"/>
                                </xsl:when>
                                <xsl:when
                                    test="not(contains($numbers,$fourth-char)) or string-length($fourth-char)=0">
                                    <xsl:value-of select="concat('0',$unicode-codepoint-number)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$unicode-codepoint-number"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of
                            select="concat('#',$codepoint-string,normalize-space($element-text))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space($element-text)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="new_criterion">
                <xsl:value-of select="translate(translate($criterion,'&#65289;',')'),'&#65288;','(')"/>
            </xsl:variable>
            <xsl:value-of select="translate(translate($new_criterion,'ー',''),'ｰ','')"/>
    </xsl:template>
    <xsl:template match="code">
	<xsl:copy><nb><xsl:apply-templates/></nb></xsl:copy>
    </xsl:template>
</xsl:stylesheet>
