<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:db="http://docbook.org/ns/docbook"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="atom h db dc f m t xlink xs"
		version="2.0">

<xsl:import href="../build/docbook/xslt/base/html/final-pass.xsl"/>

<xsl:output name="final"
	    method="xhtml"
	    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
	    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

<xsl:param name="autolabel.elements">
  <db:appendix format="A"/>
  <db:chapter/>
</xsl:param>

<xsl:param name="linenumbering" as="element()*">
<ln path="literallayout" everyNth="0"/>
<ln path="programlisting" everyNth="0"/>
<ln path="programlistingco" everyNth="0"/>
<ln path="screen" everyNth="0"/>
<ln path="synopsis" everyNth="0"/>
<ln path="address" everyNth="0"/>
<ln path="epigraph/literallayout" everyNth="0"/>
</xsl:param>

<!-- ============================================================ -->

<xsl:variable name="sitemenu" select="document('../etc/menu.xml')/*"
	      as="element()"/>

<xsl:variable name="whatsnew" select="document('../atom/whatsnew.xml')/*"
	      as="element()"/>

<!-- ============================================================ -->

<xsl:template match="*" mode="m:css">
  <xsl:param name="node" select="."/>

  <link rel="stylesheet" type="text/css" href="/css/docbook.css"/>
  <link rel="stylesheet" type="text/css" href="/css/tabs.css" />
  <link rel="stylesheet" type="text/css" href="/css/website.css" />
  <link rel="icon" href="/graphics/icon.ico" type="image/ico"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:article[@xml:id]">
  <xsl:variable name="header" select="doc('../include/header.html')"/>
  <xsl:apply-templates select="$header" mode="to-xhtml"/>

  <xsl:if test="not($sitemenu//h:li[@id = current()/@xml:id])">
    <xsl:message terminate="yes">
      <xsl:text>Error: page is not in the menu: </xsl:text>
      <xsl:value-of select="@xml:id"/>
    </xsl:message>
  </xsl:if>

  <xsl:if test="not($sitemenu//h:li[@id = current()/@xml:id])">
    <xsl:message terminate="yes">
      <xsl:text>Error: page is not in the menu: </xsl:text>
      <xsl:value-of select="@xml:id"/>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="menu"
                select="concat('../menus/', @xml:id, '.html')"/>

  <xsl:apply-templates select="doc($menu)" mode="to-xhtml"/>

  <div class="{local-name(.)}">
    <h1>
      <!-- HACK! -->
      <xsl:choose>
	<xsl:when test="@xml:id = 'home'">
	  <xsl:text>Welcome to XProc.org</xsl:text>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="db:info/db:title" mode="titlepage"/>
	</xsl:otherwise>
      </xsl:choose>
    </h1>

    <xsl:apply-templates/>

    <xsl:call-template name="t:process-footnotes"/>

<!--
    <div id="overlayDiv" class="footer">
      <table border="0" cellpadding="0" cellspacing="0" summary="Footer"
	     width="100%">
	<tr>
	  <td align="left" valign="top">
	    <xsl:text>Modified: </xsl:text>
	    <xsl:choose>
	      <xsl:when test="@xml:id='home'">
		<xsl:value-of select="format-date(current-date(),'[F,*-3], [D01] [MNn,*-3] [Y0001]')"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="substring-before(substring-after(db:info/db:pubdate,'('),')')"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </td>
	  <td align="center">
	    <xsl:text>&#160;</xsl:text>
	  </td>
	  <td align="right">Copyright © 2006 Norman Walsh</td>
	</tr>
      </table>
    </div>
-->
  </div>
</xsl:template>

<xsl:template match="element()" mode="to-xhtml">
  <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="@*,node()" mode="to-xhtml"/>
  </xsl:element>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()" mode="to-xhtml">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
