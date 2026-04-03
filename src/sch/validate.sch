<?xml version="1.0" encoding="UTF-8"?>
<!-- UWE.XSL - DITA Publishing Stylesheets
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     See license.txt for the full license text. -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <sch:title>UWE Content Model Validation</sch:title>
  <sch:pattern id="allowed-children">
    <sch:rule context="abstract/*">
      <sch:report test="not(self::shortdesc | self::dl | self::fig | self::note | self::hazardstatement | self::ol | self::p | self::simpletable | self::table | self::ul | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'abstract'. Allowed children: shortdesc, dl, fig, note, hazardstatement, ol, p, simpletable, table, ul, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="author/*">
      <sch:report test="true()">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'author'. No child elements are permitted.
      </sch:report>
    </sch:rule>
    <sch:rule context="b/*">
      <sch:report test="not(self::xref | self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'b'. Allowed children: xref, b, i, sup, sub, tt, codeph, u, menucascade, uicontrol.
      </sch:report>
    </sch:rule>
    <sch:rule context="body/*">
      <sch:report test="not(self::dl | self::fig | self::note | self::hazardstatement | self::ol | self::p | self::pre | self::simpletable | self::table | self::ul | self::draft-comment | self::section)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'body'. Allowed children: dl, fig, note, hazardstatement, ol, p, pre, simpletable, table, ul, draft-comment, section.
      </sch:report>
    </sch:rule>
    <sch:rule context="chdesc/*">
      <sch:report test="not(self::dl | self::fig | self::note | self::hazardstatement | self::ol | self::p | self::pre | self::ul | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'chdesc'. Allowed children: dl, fig, note, hazardstatement, ol, p, pre, ul, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="chdeschd/*">
      <sch:report test="not(self::dl | self::fig | self::note | self::hazardstatement | self::ol | self::p | self::pre | self::ul | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'chdeschd'. Allowed children: dl, fig, note, hazardstatement, ol, p, pre, ul, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="chhead/*">
      <sch:report test="not(self::choptionhd | self::chdeschd)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'chhead'. Allowed children: choptionhd, chdeschd.
      </sch:report>
    </sch:rule>
    <sch:rule context="choice/*">
      <sch:report test="not(self::p | self::ol | self::ul | self::fig | self::pre | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'choice'. Allowed children: p, ol, ul, fig, pre, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="choices/*">
      <sch:report test="not(self::choice)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'choices'. Allowed children: choice.
      </sch:report>
    </sch:rule>
    <sch:rule context="choicetable/*">
      <sch:report test="not(self::chhead | self::chrow)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'choicetable'. Allowed children: chhead, chrow.
      </sch:report>
    </sch:rule>
    <sch:rule context="choption/*">
      <sch:report test="not(self::dl | self::fig | self::note | self::hazardstatement | self::ol | self::p | self::pre | self::ul | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'choption'. Allowed children: dl, fig, note, hazardstatement, ol, p, pre, ul, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="choptionhd/*">
      <sch:report test="not(self::dl | self::fig | self::note | self::hazardstatement | self::ol | self::p | self::pre | self::ul | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'choptionhd'. Allowed children: dl, fig, note, hazardstatement, ol, p, pre, ul, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="chrow/*">
      <sch:report test="not(self::choption | self::chdesc)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'chrow'. Allowed children: choption, chdesc.
      </sch:report>
    </sch:rule>
    <sch:rule context="cmd/*">
      <sch:report test="not(self::xref | self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol | self::image | self::draft-comment | self::indexterm)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'cmd'. Allowed children: xref, b, i, sup, sub, tt, codeph, u, menucascade, uicontrol, image, draft-comment, indexterm.
      </sch:report>
    </sch:rule>
    <sch:rule context="codeph/*">
      <sch:report test="true()">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'codeph'. No child elements are permitted.
      </sch:report>
    </sch:rule>
    <sch:rule context="colspec/*">
      <sch:report test="true()">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'colspec'. No child elements are permitted.
      </sch:report>
    </sch:rule>
    <sch:rule context="consequence/*">
      <sch:report test="not(self::xref | self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'consequence'. Allowed children: xref, b, i, sup, sub, tt, codeph, u, menucascade, uicontrol.
      </sch:report>
    </sch:rule>
    <sch:rule context="context/*">
      <sch:report test="not(self::p | self::ul | self::ol | self::fig | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'context'. Allowed children: p, ul, ol, fig, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="dd/*">
      <sch:report test="not(self::dl | self::fig | self::note | self::hazardstatement | self::ol | self::p | self::pre | self::ul | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'dd'. Allowed children: dl, fig, note, hazardstatement, ol, p, pre, ul, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="ddhd/*">
      <sch:report test="not(self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol | self::image)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'ddhd'. Allowed children: b, i, sup, sub, tt, codeph, u, menucascade, uicontrol, image.
      </sch:report>
    </sch:rule>
    <sch:rule context="desc/*">
      <sch:report test="not(self::xref | self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol | self::indexterm)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'desc'. Allowed children: xref, b, i, sup, sub, tt, codeph, u, menucascade, uicontrol, indexterm.
      </sch:report>
    </sch:rule>
    <sch:rule context="dl/*">
      <sch:report test="not(self::dlhead | self::dlentry)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'dl'. Allowed children: dlhead, dlentry.
      </sch:report>
    </sch:rule>
    <sch:rule context="dlentry/*">
      <sch:report test="not(self::dt | self::dd)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'dlentry'. Allowed children: dt, dd.
      </sch:report>
    </sch:rule>
    <sch:rule context="dlhead/*">
      <sch:report test="not(self::dthd | self::ddhd)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'dlhead'. Allowed children: dthd, ddhd.
      </sch:report>
    </sch:rule>
    <sch:rule context="draft-comment/*">
      <sch:report test="not(self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'draft-comment'. Allowed children: b, i, sup, sub, tt, codeph, u, menucascade, uicontrol.
      </sch:report>
    </sch:rule>
    <sch:rule context="dt/*">
      <sch:report test="not(self::xref | self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol | self::image)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'dt'. Allowed children: xref, b, i, sup, sub, tt, codeph, u, menucascade, uicontrol, image.
      </sch:report>
    </sch:rule>
    <sch:rule context="dthd/*">
      <sch:report test="not(self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol | self::image)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'dthd'. Allowed children: b, i, sup, sub, tt, codeph, u, menucascade, uicontrol, image.
      </sch:report>
    </sch:rule>
    <sch:rule context="entry/*">
      <sch:report test="not(self::dl | self::fig | self::note | self::hazardstatement | self::ol | self::p | self::pre | self::ul | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'entry'. Allowed children: dl, fig, note, hazardstatement, ol, p, pre, ul, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="fig/*">
      <sch:report test="not(self::title | self::desc | self::draft-comment | self::image | self::legend)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'fig'. Allowed children: title, desc, draft-comment, image, legend.
      </sch:report>
    </sch:rule>
    <sch:rule context="frontbody/*">
      <sch:report test="not(self::dl | self::fig | self::note | self::hazardstatement | self::ol | self::p | self::pre | self::simpletable | self::table | self::ul | self::draft-comment | self::section)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'frontbody'. Allowed children: dl, fig, note, hazardstatement, ol, p, pre, simpletable, table, ul, draft-comment, section.
      </sch:report>
    </sch:rule>
    <sch:rule context="frontpage/*">
      <sch:report test="not(self::title | self::prolog | self::frontbody | self::no-topic-nesting)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'frontpage'. Allowed children: title, prolog, frontbody, no-topic-nesting.
      </sch:report>
    </sch:rule>
    <sch:rule context="hazardstatement/*">
      <sch:report test="not(self::messagepanel)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'hazardstatement'. Allowed children: messagepanel.
      </sch:report>
    </sch:rule>
    <sch:rule context="howtoavoid/*">
      <sch:report test="not(self::xref | self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'howtoavoid'. Allowed children: xref, b, i, sup, sub, tt, codeph, u, menucascade, uicontrol.
      </sch:report>
    </sch:rule>
    <sch:rule context="i/*">
      <sch:report test="not(self::xref | self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'i'. Allowed children: xref, b, i, sup, sub, tt, codeph, u, menucascade, uicontrol.
      </sch:report>
    </sch:rule>
    <sch:rule context="image[@href]">
      <sch:report test="not(starts-with(@href, '../images/'))">
        Image href '<sch:value-of select="@href"/>' must start with '../images/'. Actual value does not match the expected relative path.
      </sch:report>
      <sch:report test="not(matches(@href, '\.(png|jpe?g|svg|gif)$', 'i'))">
        Image href '<sch:value-of select="@href"/>' has an unsupported file extension. Allowed: png, jpg, jpeg, svg, gif.
      </sch:report>
    </sch:rule>
    <sch:rule context="image">
      <sch:report test="not(@href)">
        Element 'image' is missing required attribute 'href'.
      </sch:report>
    </sch:rule>
    <sch:rule context="image/*">
      <sch:report test="true()">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'image'. No child elements are permitted.
      </sch:report>
    </sch:rule>
    <sch:rule context="indexterm/*">
      <sch:report test="not(self::indexterm)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'indexterm'. Allowed children: indexterm.
      </sch:report>
    </sch:rule>
    <sch:rule context="info/*">
      <sch:report test="not(self::p | self::ol | self::ul | self::pre | self::fig | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'info'. Allowed children: p, ol, ul, pre, fig, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="leg-entry/*">
      <sch:report test="not(self::leg-pos | self::leg-name)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'leg-entry'. Allowed children: leg-pos, leg-name.
      </sch:report>
    </sch:rule>
    <sch:rule context="leg-name/*">
      <sch:report test="not(self::p)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'leg-name'. Allowed children: p.
      </sch:report>
    </sch:rule>
    <sch:rule context="leg-pos/*">
      <sch:report test="not(self::p)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'leg-pos'. Allowed children: p.
      </sch:report>
    </sch:rule>
    <sch:rule context="legend/*">
      <sch:report test="not(self::leg-entry)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'legend'. Allowed children: leg-entry.
      </sch:report>
    </sch:rule>
    <sch:rule context="li/*">
      <sch:report test="not(self::p | self::fig | self::pre | self::ol | self::ul)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'li'. Allowed children: p, fig, pre, ol, ul.
      </sch:report>
    </sch:rule>
    <sch:rule context="link/*">
      <sch:report test="not(self::linktext | self::desc)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'link'. Allowed children: linktext, desc.
      </sch:report>
    </sch:rule>
    <sch:rule context="linkinfo/*">
      <sch:report test="not(self::xref | self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'linkinfo'. Allowed children: xref, b, i, sup, sub, tt, codeph, u, menucascade, uicontrol.
      </sch:report>
    </sch:rule>
    <sch:rule context="linklist/*">
      <sch:report test="not(self::title | self::desc | self::linklist | self::link | self::linkinfo)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'linklist'. Allowed children: title, desc, linklist, link, linkinfo.
      </sch:report>
    </sch:rule>
    <sch:rule context="linkpool/*">
      <sch:report test="not(self::linkpool | self::link)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'linkpool'. Allowed children: linkpool, link.
      </sch:report>
    </sch:rule>
    <sch:rule context="linktext/*">
      <sch:report test="not(self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'linktext'. Allowed children: b, i, sup, sub, tt, codeph, u, menucascade, uicontrol.
      </sch:report>
    </sch:rule>
    <sch:rule context="menucascade/*">
      <sch:report test="not(self::uicontrol)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'menucascade'. Allowed children: uicontrol.
      </sch:report>
    </sch:rule>
    <sch:rule context="messagepanel/*">
      <sch:report test="not(self::typeofhazard | self::consequence | self::howtoavoid)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'messagepanel'. Allowed children: typeofhazard, consequence, howtoavoid.
      </sch:report>
    </sch:rule>
    <sch:rule context="metadata/*">
      <sch:report test="not(self::othermeta)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'metadata'. Allowed children: othermeta.
      </sch:report>
    </sch:rule>
    <sch:rule context="navtitle/*">
      <sch:report test="not(self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'navtitle'. Allowed children: b, i, sup, sub, tt, codeph, u, menucascade, uicontrol.
      </sch:report>
    </sch:rule>
    <sch:rule context="no-topic-nesting/*">
      <sch:report test="true()">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'no-topic-nesting'. No child elements are permitted.
      </sch:report>
    </sch:rule>
    <sch:rule context="note/*">
      <sch:report test="not(self::fig | self::ol | self::p | self::pre | self::ul | self::draft-comment | self::indexterm)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'note'. Allowed children: fig, ol, p, pre, ul, draft-comment, indexterm.
      </sch:report>
    </sch:rule>
    <sch:rule context="ol/*">
      <sch:report test="not(self::li)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'ol'. Allowed children: li.
      </sch:report>
    </sch:rule>
    <sch:rule context="othermeta/*">
      <sch:report test="true()">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'othermeta'. No child elements are permitted.
      </sch:report>
    </sch:rule>
    <!-- DITA 1.3: <fn> is allowed in <p> via %txt.incl in %para.cnt (commonElements.mod). -->
    <sch:rule context="p/*">
      <sch:report test="not(self::xref | self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol | self::indexterm | self::image | self::ph | self::fn)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'p'. Allowed children: xref, b, i, sup, sub, tt, codeph, u, menucascade, uicontrol, indexterm, image, ph, fn.
      </sch:report>
    </sch:rule>
    <sch:rule context="ph/*">
      <sch:report test="true()">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'ph'. No child elements are permitted.
      </sch:report>
    </sch:rule>
    <sch:rule context="postreq/*">
      <sch:report test="not(self::dl | self::fig | self::note | self::hazardstatement | self::ol | self::p | self::pre | self::simpletable | self::table | self::ul | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'postreq'. Allowed children: dl, fig, note, hazardstatement, ol, p, pre, simpletable, table, ul, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="pre/*">
      <sch:report test="not(self::xref | self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol | self::draft-comment | self::indexterm)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'pre'. Allowed children: xref, b, i, sup, sub, tt, codeph, u, menucascade, uicontrol, draft-comment, indexterm.
      </sch:report>
    </sch:rule>
    <sch:rule context="prereq/*">
      <sch:report test="not(self::dl | self::fig | self::note | self::hazardstatement | self::ol | self::p | self::pre | self::simpletable | self::table | self::ul | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'prereq'. Allowed children: dl, fig, note, hazardstatement, ol, p, pre, simpletable, table, ul, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="prolog/*">
      <sch:report test="not(self::author | self::source | self::publisher | self::metadata)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'prolog'. Allowed children: author, source, publisher, metadata.
      </sch:report>
    </sch:rule>
    <sch:rule context="publisher/*">
      <sch:report test="true()">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'publisher'. No child elements are permitted.
      </sch:report>
    </sch:rule>
    <sch:rule context="related-links/*">
      <sch:report test="not(self::link | self::linklist | self::linkpool)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'related-links'. Allowed children: link, linklist, linkpool.
      </sch:report>
    </sch:rule>
    <sch:rule context="result/*">
      <sch:report test="not(self::dl | self::fig | self::note | self::hazardstatement | self::ol | self::p | self::pre | self::simpletable | self::table | self::ul | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'result'. Allowed children: dl, fig, note, hazardstatement, ol, p, pre, simpletable, table, ul, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="row/*">
      <sch:report test="not(self::entry)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'row'. Allowed children: entry.
      </sch:report>
    </sch:rule>
    <sch:rule context="searchtitle/*">
      <sch:report test="not(self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'searchtitle'. Allowed children: b, i, sup, sub, tt, codeph, u, menucascade, uicontrol.
      </sch:report>
    </sch:rule>
    <sch:rule context="section/*">
      <sch:report test="not(self::indexterm | self::title | self::dl | self::fig | self::note | self::hazardstatement | self::ol | self::p | self::pre | self::simpletable | self::table | self::ul | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'section'. Allowed children: indexterm, title, dl, fig, note, hazardstatement, ol, p, pre, simpletable, table, ul, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="shortdesc/*">
      <sch:report test="not(self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol | self::image | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'shortdesc'. Allowed children: b, i, sup, sub, tt, codeph, u, menucascade, uicontrol, image, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="simpletable/*">
      <sch:report test="not(self::sthead | self::strow)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'simpletable'. Allowed children: sthead, strow.
      </sch:report>
    </sch:rule>
    <sch:rule context="source/*">
      <sch:report test="true()">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'source'. No child elements are permitted.
      </sch:report>
    </sch:rule>
    <sch:rule context="stentry/*">
      <sch:report test="not(self::dl | self::fig | self::note | self::hazardstatement | self::ol | self::p | self::pre | self::ul | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'stentry'. Allowed children: dl, fig, note, hazardstatement, ol, p, pre, ul, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="step/*">
      <sch:report test="not(self::note | self::hazardstatement | self::cmd | self::substeps | self::choices | self::choicetable | self::info | self::stepresult)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'step'. Allowed children: note, hazardstatement, cmd, substeps, choices, choicetable, info, stepresult.
      </sch:report>
    </sch:rule>
    <sch:rule context="stepresult/*">
      <sch:report test="not(self::p | self::ol | self::ul | self::pre | self::fig | self::table | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'stepresult'. Allowed children: p, ol, ul, pre, fig, table, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="stepsection/*">
      <sch:report test="not(self::p | self::ol | self::ul | self::fig | self::pre | self::draft-comment)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'stepsection'. Allowed children: p, ol, ul, fig, pre, draft-comment.
      </sch:report>
    </sch:rule>
    <sch:rule context="steps/*">
      <sch:report test="not(self::stepsection | self::step)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'steps'. Allowed children: stepsection, step.
      </sch:report>
    </sch:rule>
    <sch:rule context="sthead/*">
      <sch:report test="not(self::stentry)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'sthead'. Allowed children: stentry.
      </sch:report>
    </sch:rule>
    <sch:rule context="strow/*">
      <sch:report test="not(self::stentry)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'strow'. Allowed children: stentry.
      </sch:report>
    </sch:rule>
    <sch:rule context="sub/*">
      <sch:report test="not(self::xref | self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'sub'. Allowed children: xref, b, i, sup, sub, tt, codeph, u, menucascade, uicontrol.
      </sch:report>
    </sch:rule>
    <sch:rule context="substep/*">
      <sch:report test="not(self::note | self::hazardstatement | self::cmd | self::info | self::stepresult)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'substep'. Allowed children: note, hazardstatement, cmd, info, stepresult.
      </sch:report>
    </sch:rule>
    <sch:rule context="substeps/*">
      <sch:report test="not(self::substep)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'substeps'. Allowed children: substep.
      </sch:report>
    </sch:rule>
    <sch:rule context="sup/*">
      <sch:report test="not(self::xref | self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'sup'. Allowed children: xref, b, i, sup, sub, tt, codeph, u, menucascade, uicontrol.
      </sch:report>
    </sch:rule>
    <sch:rule context="table/*">
      <sch:report test="not(self::title | self::desc | self::tgroup)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'table'. Allowed children: title, desc, tgroup.
      </sch:report>
    </sch:rule>
    <sch:rule context="task/*">
      <sch:report test="not(self::title | self::titlealts | self::abstract | self::shortdesc | self::prolog | self::taskbody | self::related-links | self::no-topic-nesting)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'task'. Allowed children: title, titlealts, abstract, shortdesc, prolog, taskbody, related-links, no-topic-nesting.
      </sch:report>
    </sch:rule>
    <sch:rule context="taskbody/*">
      <sch:report test="not(self::prereq | self::context | self::steps | self::result | self::postreq)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'taskbody'. Allowed children: prereq, context, steps, result, postreq.
      </sch:report>
    </sch:rule>
    <sch:rule context="tbody/*">
      <sch:report test="not(self::row)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'tbody'. Allowed children: row.
      </sch:report>
    </sch:rule>
    <sch:rule context="tgroup/*">
      <sch:report test="not(self::colspec | self::thead | self::tbody)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'tgroup'. Allowed children: colspec, thead, tbody.
      </sch:report>
    </sch:rule>
    <sch:rule context="thead/*">
      <sch:report test="not(self::row)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'thead'. Allowed children: row.
      </sch:report>
    </sch:rule>
    <sch:rule context="title/*">
      <sch:report test="not(self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol | self::image)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'title'. Allowed children: b, i, sup, sub, tt, codeph, u, menucascade, uicontrol, image.
      </sch:report>
    </sch:rule>
    <sch:rule context="titlealts/*">
      <sch:report test="not(self::navtitle | self::searchtitle)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'titlealts'. Allowed children: navtitle, searchtitle.
      </sch:report>
    </sch:rule>
    <sch:rule context="topic/*">
      <sch:report test="not(self::title | self::titlealts | self::shortdesc | self::abstract | self::prolog | self::body | self::related-links | self::no-topic-nesting)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'topic'. Allowed children: title, titlealts, shortdesc, abstract, prolog, body, related-links, no-topic-nesting.
      </sch:report>
    </sch:rule>
    <sch:rule context="tt/*">
      <sch:report test="not(self::xref | self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'tt'. Allowed children: xref, b, i, sup, sub, tt, codeph, u, menucascade, uicontrol.
      </sch:report>
    </sch:rule>
    <sch:rule context="typeofhazard/*">
      <sch:report test="not(self::xref | self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol | self::indexterm)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'typeofhazard'. Allowed children: xref, b, i, sup, sub, tt, codeph, u, menucascade, uicontrol, indexterm.
      </sch:report>
    </sch:rule>
    <sch:rule context="u/*">
      <sch:report test="not(self::xref | self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'u'. Allowed children: xref, b, i, sup, sub, tt, codeph, u, menucascade, uicontrol.
      </sch:report>
    </sch:rule>
    <sch:rule context="uicontrol/*">
      <sch:report test="true()">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'uicontrol'. No child elements are permitted.
      </sch:report>
    </sch:rule>
    <sch:rule context="ul/*">
      <sch:report test="not(self::li)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'ul'. Allowed children: li.
      </sch:report>
    </sch:rule>
    <sch:rule context="xref/*">
      <sch:report test="not(self::b | self::i | self::sup | self::sub | self::tt | self::codeph | self::u | self::menucascade | self::uicontrol)">
        Element '<sch:value-of select="local-name()"/>' is not allowed as a child of 'xref'. Allowed children: b, i, sup, sub, tt, codeph, u, menucascade, uicontrol.
      </sch:report>
    </sch:rule>
    <!-- xref link text should be short (e.g. one term or phrase); long text suggests description was used instead of link text -->
    <sch:rule context="xref[string-length(normalize-space(.)) &gt; 80]">
      <sch:report test="true()" role="warning">
        xref link text is too long (<sch:value-of select="string-length(normalize-space(.))"/> chars). Use a short link text (e.g. one word) and put the description outside the link or in a footnote. href="<sch:value-of select="normalize-space(@href)"/>"
      </sch:report>
    </sch:rule>
  </sch:pattern>
</sch:schema>
