rem    UWE.XSL generates a good looking customizable PDF output from a single XML source 
rem                   using Apache FOP as PDF formatter
rem
rem    < uwe.bat />
rem    This is a windows batch file when executed xml sample in sample/uwe_manual.xml will be transformed 
rem    into *.pdf Files in the same folder...
rem
rem    Copyright (C) 2012-2013   by Alex Duesel <alex@alex-duesel.de>
rem                                        homepage: http://www.mandarine.tv
rem                                        See file license.txt for licensing issues
rem
rem    This program is free software: you can redistribute it and/or modify
rem    it under the terms of the GNU Lesser General Public License as published by
rem    the Free Software Foundation, either version 3 of the License.
rem
rem    This program is distributed in the hope that it will be useful,
rem    but WITHOUT ANY WARRANTY; without even the implied warranty of
rem    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
rem    GNU Lesser General Public License for more details.
rem
rem    You should have received a copy of the GNU Lesser General Public License
rem    along with this program.  If not, see <http://www.gnu.org/licenses/>.


rem echo "generating A4 margin layout book format with fashion style" 

rem java -jar lib\saxon\saxon8.jar  -t sample/uwe_manual.xml uwe_pretransformation.xsl >tmp/tmp.xml localize_file=uwe_localize.xml
rem java -jar lib\saxon\saxon8.jar  -t tmp/tmp.xml uwe.xsl >tmp/output.fo localize_file=uwe_localize.xml
rem lib\fop-1.0\fop -c lib\fop-1.0\conf\fop.xconf tmp/output.fo -pdf sample/uwe_manual_A4_margin_book_fashion.pdf

rem echo "generating A4 two column layout book format with fashion style" 

rem java -jar lib\saxon\saxon8.jar  -t sample/uwe_manual.xml uwe_pretransformation.xsl >tmp/tmp.xml localize_file=uwe_localize.xml print_layout=columns
rem java -jar lib\saxon\saxon8.jar  -t tmp/tmp.xml uwe.xsl >tmp/output.fo localize_file=uwe_localize.xml print_layout=columns
rem lib\fop-1.0\fop -c lib\fop-1.0\conf\fop.xconf tmp/output.fo -pdf sample/uwe_manual_A4_two_col_book_fashion.pdf

rem echo "generating A4 two column layout info format with technical style" 

rem java -jar lib\saxon\saxon8.jar  -t sample/uwe_manual.xml uwe_pretransformation.xsl >tmp/tmp.xml localize_file=uwe_localize.xml print_layout=columns print_format=info print_look_and_feel=technical print_header=longheader
rem java -jar lib\saxon\saxon8.jar  -t tmp/tmp.xml uwe.xsl >tmp/output.fo localize_file=uwe_localize.xml print_layout=columns print_format=info print_look_and_feel=technical print_header=longheader
rem lib\fop-1.0\fop -c lib\fop-1.0\conf\fop.xconf tmp/output.fo -pdf sample/uwe_manual_A4_two_col_info_technical.pdf

rem echo "generating A5 two column layout info format with technical style" 

rem java -jar lib\saxon\saxon8.jar  -t sample/uwe_manual.xml uwe_pretransformation.xsl >tmp/tmp.xml localize_file=uwe_localize.xml print_layout=columns print_format=info print_look_and_feel=technical print_header=longheader print_paper_format=A5
rem java -jar lib\saxon\saxon8.jar  -t tmp/tmp.xml uwe.xsl >tmp/output.fo localize_file=uwe_localize.xml print_layout=columns print_format=info print_look_and_feel=technical print_header=longheader print_paper_format=A5
rem lib\fop-1.0\fop -c lib\fop-1.0\conf\fop.xconf tmp/output.fo -pdf sample/uwe_manual_A5_two_col_info_technical.pdf

rem echo "generating A5 book format with technical style" 

rem java -jar lib\saxon\saxon8.jar  -t sample/uwe_manual.xml uwe_pretransformation.xsl >tmp/tmp.xml localize_file=uwe_localize.xml print_format=book print_look_and_feel=technical print_header=longheader print_paper_format=A5
rem java -jar lib\saxon\saxon8.jar  -t tmp/tmp.xml uwe.xsl >tmp/output.fo localize_file=uwe_localize.xml print_format=book print_look_and_feel=technical print_header=longheader print_paper_format=A5
rem lib\fop-1.0\fop -c lib\fop-1.0\conf\fop.xconf tmp/output.fo -pdf sample/uwe_manual_A5_book_technical.pdf

echo "generating RTF" 

java -jar lib\saxon\saxon8.jar  -t sample/uwe_manual.xml uwe_pretransformation.xsl >tmp/tmp.xml localize_file=uwe_localize.xml print_layout=rtf 
java -jar lib\saxon\saxon8.jar  -t tmp/tmp.xml uwe.xsl >tmp/output.fo localize_file=uwe_localize.xml print_layout=rtf 
lib\fop-1.0\fop -c lib\fop-1.0\conf\fop.xconf tmp/output.fo -rtf sample/uwe_manual.rtf
