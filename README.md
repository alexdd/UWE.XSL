UWE.XSL  
=================

XSL Stylesheets which generate good looking customizable PDF output (and RTF) from a single XML source using [Apache FOP](http://xmlgraphics.apache.org/fop/) as PDF formatter.
May also be used as core library in your FOP stylesheet project.

Most asian languages are supported; avanced Back-of-the-Book index sorting routines included; plus translated boilerplate text library.

Copyright (C) 2012-2013  by Alex Duesel <alex@alex-duesel.de>

[Homepage](http://www.mandarine.tv)

UWE.XSL was one big component of UWE (_U_WE is not a _W_YSIWYG _E_ditor)
UWE aimed to be a simple but yet powerful web-based "single-source" word processor optimized for technical documents.
Due to a lack of spare time UWE project was abandoned in Dec 2013.

Anyway, have fun with the stylesheets :-] 

Hint:

You may map your custom DTD onto UWE.xsl's document structure by using a XSLT transformation.
For examples you may investigate the folder "samples"... 


Document Structure
-------------

	<document>
		
	  <title>
		
	  <meta>
		
			<owner> PCDATA 
			<date-of-creation> PCDATA 
			<date-of-last-change> PCDATA 
			<language> { en-us | de-DE | fr-FR | it-IT | es-EN | pt-PT | ru-RU | ko-KR | ja-JP | cs-CZ | zh-CN }
			<status> PCDATA
			<description> PCDATA
			<logo-image> PCDATA ( filesystem path )
			<cover-image> PCDATA ( filesystem path )
			<main-title> PCDATA 
			<subtitle> PCDATA
			<cover-text> PCDATA

			<structure>
				
				<format> { book | info }
				<suplemental-directives/>  (optional)
				<toc/>  (optional)
				<index/>  (optional)
				<footnote-index/>  (optional)
				<figure-index/> (optional)
				<chapter-on-right-page/>  (optional)
				<cover-backpage/>  (optional)
			   
			<design>
			
				<layout>  { margin | columns }
				<paper-format>  { A4 | A5 }
				<page-margins>  { leftgap | leftright }
				<spaces> { small | large }
				<header> { shortheader | longheader }
				<footer> { shortfooter | longfooter }
				<look-and-feel> { fashion | technical }
				<table-layout> { advanced | simple }
				
			<chapter @ismodule={yes|no} @hyphenation={yes|no} @chapterpage={yes|no} >
				
				<content>
				
					<title> PCDATA
					
					<block>
					
						<title>
						
						<p> PCDATA | <url> | <code> | <sup> | <sub> | <i> | <b> | <nb> | <doclink> | <checked/> | <unchecked/> | <xe><first> | <xe><second> | <footnote>
						
						<ul><li><p> 
						<ul><li><figure>
						<ul><li><danger> 
						
						
						<procedure><step><action><p> 
						<procedure><step><action><figure>
						<procedure><step><action><danger>
						
						<figure @pdfwidth= { margin | column  | page }
						
							<img @src @width @height />
							
							<subtitle> PCDATA
							
						<verbatim> PCDATA | <b>
						
						<warning | danger | notice | note | caution>
							
							<cause> PCDATA
							
							<consequence> <p>
							
						<table>
							
							<caption> PCDATA
							
							<tbody>
							
								<tr>
								
									<td @width>
									
				
				<chapter>
					
					[...]
			<chapter>
				
				[...]

For a complete DTD you may run Michael Kay's [DTDGenerator](http://saxon.sourceforge.net/dtdgen.html) on the sample XML and fine tune ;-]
							
Options
-------------
							
document/meta/structure and document/meta/design elements are optional and options can also be set as transformation parameters, like so (windows batch) :

	echo "generating A5 two column layout info format with technical style" 

	java -jar lib\saxon\saxon8.jar  -t sample/uwe_manual.xml uwe_pretransformation.xsl >tmp/tmp.xml localize_file=uwe_localize.xml print_layout=columns print_format=info print_look_and_feel=technical print_header=longheader print_paper_format=A5
	java -jar lib\saxon\saxon8.jar  -t tmp/tmp.xml uwe.xsl >tmp/output.fo localize_file=uwe_localize.xml print_layout=columns print_format=info print_look_and_feel=technical print_header=longheader print_paper_format=A5
	lib\fop-1.0\fop -c lib\fop-1.0\conf\fop.xconf tmp/output.fo -pdf sample/uwe_manual_A5_two_col_info_technical.pdf

							
Available parameters are:


Document structure: (elements in document/meta/structure and document/meta/design have priority)
							
	<xsl:param name="print_supplemental_directives"> { yes | no }
	<xsl:param name="print_toc"> { yes | no }
	<xsl:param name="print_index"> { yes | no }
	<xsl:param name="print_figure_index"> { yes | no }	
	<xsl:param name="print_footnote_index"> { yes | no }
	<xsl:param name="print_cover_backpage"> { yes | no }
	<xsl:param name="print_format"> { book | info }
	<xsl:param name="print_layout"> { margin | column | rtf }
	<xsl:param name="print_paper_format"> { A4 | A5 }
	<xsl:param name="print_page_margin"> { leftgap | leftright }
	<xsl:param name="print_spaces"> { small | large }
	<xsl:param name="print_header"> { shortheader | longheader }
	<xsl:param name="print_footer"> { shortfooter | longfooter }
	<xsl:param name="print_look_and_feel"> { technical | fashion }
	<xsl:param name="print_table_layout"> { technical | fashion }
	<xsl:param name="print_chapter_on_right_page"> { yes | no }


Measurement:

	<xsl:param name="option_outer_margin_A4_leftgap">15</xsl:param>
	<xsl:param name="option_outer_margin_A5_leftgap">10</xsl:param>
	<xsl:param name="option_outer_margin_A4_A5">20</xsl:param>
	<xsl:param name="option_inner_margin_A4_leftgap">25</xsl:param>
	<xsl:param name="option_inner_margin_A5_leftgap">20</xsl:param>
	<xsl:param name="option_inner_outer_margin_A4_A5">20</xsl:param>
	<xsl:param name="option_top_margin_A4">45</xsl:param>
	<xsl:param name="option_top_margin_A5">35</xsl:param>
	<xsl:param name="option_bottom_margin_A4">30</xsl:param>
	<xsl:param name="option_bottom_margin_A5">20</xsl:param>
	<xsl:param name="option_margin_width_A4">30</xsl:param>
	
	all units in mm


Font sizes:

	<xsl:param name="option_default_font_size_A4">10</xsl:param>
	<xsl:param name="option_headline_font_sizes_A4">16,14,13,11,11</xsl:param> (TOC levels comma separated)
	<xsl:param name="option_default_font_size_A5">9</xsl:param>
	<xsl:param name="option_headline_font_sizes_A5">12,11,10,9,9</xsl:param>   


	all font sizes in pt


Text variables will be substituted throughout the document flow and will be referenced in floating text like so: [[$foo]]

	<xsl:param name="text_var_1_name"> PCDATA | foo
	<xsl:param name="text_var_1_value"> PCDATA | bar
	[...]
	<xsl:param name="text_var_6_name">
	<xsl:param name="text_var_6_value">
	
	
Colors:

 	<xsl:param name="option_color1">#E2E0E0</xsl:param>
	<xsl:param name="option_color2">#EFEDED</xsl:param>
	<xsl:param name="option_color3">#3875D7</xsl:param>
	<xsl:param name="option_color4">#7F7F7F</xsl:param>
	

Misc:

	<xsl:param name="option_bg_block_top">yes</xsl:param>
	<xsl:param name="option_bg_block_center">yes</xsl:param>
	<xsl:param name="option_copyright">www.mandarine.tv</xsl:param>
	<xsl:param name="version">1234</xsl:param>
	<xsl:param name="imagedir">sample/images</xsl:param>
	<xsl:param name="localize_file">../uwe_localize.xml</xsl:param>
                 

and much more parameterization options... find out by yourself :-} Or if you dare you may also import UWE.XSL as 
core library into your stylesheet project and override some of UWE's XSLT templates...


Prerequisites
-------------

* Java Runtime Environment
* Batch file run tested on Windows 


Test-Run
-------

Execute uwe.bat on your Windows command line and investigate output in folder "sample"


License
-------

UWE.XSL is licensed under the GNU Lesser General Public License, see file license.txt. Chinese group labels were extrachted from the Unicode Website, see
UNICODE, INC. LICENSE AGREEMENT - DATA FILES AND SOFTWARE


