<?xml version="1.0"?>
<!-- UWE.XSL - at2at pipeline: area tree XML → at2.xml (XSLT only, no exec)
     Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
     SPDX-License-Identifier: LGPL-3.0-only
     Invoke: calabash -i source=at.xml -o result=at2.xml src/xpl/tools/at2at.xpl -->
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0" name="at2at">
  <p:input port="source" primary="true"/>
  <p:output port="result" primary="true">
    <p:pipe step="transform" port="result"/>
  </p:output>
  <p:xslt name="transform">
    <p:input port="source">
      <p:pipe step="at2at" port="source"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../../pdf/at2at.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>
</p:declare-step>
