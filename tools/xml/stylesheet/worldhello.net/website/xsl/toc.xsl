<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc html"
                version="1.0">

<xsl:import href="http://docbook.sourceforge.net/release/website/current/xsl/toc.xsl"/>

<!--
  OSSXP.COM Changes:
    文字版 LOGO 跳转到对应的美工页面，旁边增加一个首页链接。
    osx 扩展，增加到 文字版、图形界面版的链接
-->
<xsl:template match="toc">
  <xsl:param name="pageid" select="@id"/>

  <xsl:variable name="relpath">
    <xsl:call-template name="toc-rel-path">
      <xsl:with-param name="pageid" select="$pageid"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="homebanner"
                select="/autolayout/config[@param='homebanner'][1]"/>

  <xsl:variable name="banner"
                select="/autolayout/config[@param='banner'][1]"/>

  <xsl:variable name="homebannertext"
                select="/autolayout/config[@param='homebannertext'][1]"/>

  <xsl:variable name="bannertext"
                select="/autolayout/config[@param='bannertext'][1]"/>

  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="$relpath"/>
      <xsl:call-template name="tabular.pageuri">
        <xsl:with-param name="pageid" select="$pageid"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="alt">
      <xsl:call-template name="tabular.pagetext"/>
    </xsl:attribute>
       
    <xsl:choose>
      <xsl:when test="$pageid = @id">
        <xsl:choose>
          <xsl:when test="$homebanner">
            <img border="0">
              <xsl:attribute name="src">
                <xsl:value-of select="$relpath"/>
                <xsl:value-of select="$homebanner/@value"/>
              </xsl:attribute>
              <xsl:attribute name="alt">
                <xsl:value-of select="$homebanner/@altval"/>
              </xsl:attribute>
            </img>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="tabular.pagetext"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$banner">
            <img border="0">
              <xsl:attribute name="src">
                <xsl:value-of select="$relpath"/>
                <xsl:value-of select="$banner/@value"/>
              </xsl:attribute>
              <xsl:attribute name="alt">
                <xsl:value-of select="$banner/@altval"/>
              </xsl:attribute>
            </img>
          </xsl:when>
          <xsl:when test="$bannertext">
            <xsl:value-of select="$bannertext/@value"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="tabular.pagetext"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </a>

  <xsl:text> | </xsl:text>

  <xsl:choose>
    <xsl:when test="$pageid = @id">
      <xsl:call-template name="gentext.nav.home"/>
      <xsl:value-of select="$currentpage.marker"/>
    </xsl:when>
    <xsl:otherwise>
      <a href="{$relpath}{@dir}{$filename-prefix}{@filename}">
        <xsl:call-template name="gentext.nav.home"/>
      </a>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:text> | </xsl:text>

  <xsl:call-template name="process-children">
    <xsl:with-param name="pageid" select="$pageid"/>
    <xsl:with-param name="relpath" select="$relpath"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
