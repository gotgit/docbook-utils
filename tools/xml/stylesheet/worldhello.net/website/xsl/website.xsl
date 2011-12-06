<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="html doc"
                version="1.0">

<xsl:import href="http://docbook.sourceforge.net/release/website/current/xsl/website.xsl"/>

<!-- 是否在网页最下方显示上一页、下一页，以便可以顺序的浏览整个网站 -->
<xsl:param name="sequential.links" select="1"/>

<!-- 在导航条上方或下方显示 banner -->
<xsl:param name="banner.before.navigation" select="1"/>

<xsl:include href="whodo-common.xsl"/>

</xsl:stylesheet>
