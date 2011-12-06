<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc html"
                version="1.0">

<xsl:import href="http://docbook.sourceforge.net/release/website/current/xsl/param.xsl"/>

<!-- Osx Extension -->

<!-- 文字版页脚处显示页面导航的文字 -->
<xsl:param name="prev.link.text">Prev</xsl:param>
<xsl:param name="next.link.text">Next</xsl:param>

<!-- 是否在所有页面显示 navhead, 否则只在首页显示 -->
<xsl:param name="navhead.in.allpage"	select="0"/>

</xsl:stylesheet>
