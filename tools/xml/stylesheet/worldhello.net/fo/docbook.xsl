<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="1.0">

<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl"/>
<xsl:import href="whodo-common.xsl"/>

<!-- 设置中文字体 -->
<xsl:param name="body.font.family" select="'SimSun'"/>
<xsl:param name="body.font.master">12</xsl:param>
<xsl:param name="body.font.size">
 <xsl:value-of select="$body.font.master"/><xsl:text>pt</xsl:text>
</xsl:param>
<xsl:param name="dingbat.font.family" select="'SimSun'"/>
<xsl:param name="title.font.family" select="'SimSun'"/>

<!-- Turn off the default 'full justify' and go with 'left justify'
     instead.  This avoids the large gaps that can sometimes appear
     between words in fully-justified documents.  -->
<xsl:param name="alignment">start</xsl:param>

<!-- Shade Verbatim Sections such as programlisting and screen -->
<xsl:param name="shade.verbatim" select="1"/>

<!-- 在 .PDF files 中创建书签 (bookmarks)  -->
<xsl:param name="fop.extensions" select="1"/>

<!-- 支持硬分页符的 PI -->
<xsl:template match="processing-instruction('hard-pagebreak')">
  <fo:block break-before='page'/>
</xsl:template>

<xsl:param name="variablelist.as.blocks" select="1" />

<xsl:param name="draft.watermark.image" select="'/opt/docbook/includes/images/docbook/draft.png'"/>

</xsl:stylesheet>
