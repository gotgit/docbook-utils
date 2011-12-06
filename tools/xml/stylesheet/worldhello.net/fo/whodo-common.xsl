<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- 本文件包含几个样式表的公共部分，供其它样式表包含 -->

<!-- 本地化定制 -->
<xsl:include href="../common/osx-l10n.xsl"/>

<xsl:param name="document_root" select="'/'"/>

<!-- 以图标方式显示警告 (admonitions) (from param.xsl) -->
<xsl:param name="admon.graphics" select="1"/>
<xsl:param name="admon.textlabel" select="0"/>
<xsl:param name="admon.graphics.path"><xsl:value-of select="$document_root"/>/includes/images/docbook/</xsl:param>
<xsl:param name="admon.graphics.extension">.png</xsl:param>

<!-- 以图标方式显示导航 (from param.xsl) -->
<xsl:param name="navig.graphics" select="1"/>
<xsl:param name="navig.graphics.path"><xsl:value-of select="$document_root"/>/includes/images/docbook/</xsl:param>
<xsl:param name="navig.graphics.extension">.png</xsl:param>

<!-- 以图标方式显示 callout (from param.xsl) -->
<xsl:param name="callout.graphics" select="1"/>
<xsl:param name="callout.graphics.path"><xsl:value-of select="$document_root"/>/includes/images/callouts/</xsl:param>
<xsl:param name="callout.graphics.extension">.png</xsl:param>
<xsl:param name="callout.graphics.number.limit">15</xsl:param>

<!-- 标题显示位置 (from param.xsl) -->
<xsl:param name="formal.title.placement">
figure after
example before
equation after
table before
procedure before
task before
</xsl:param>

<!-- 章节编号 (from param.xsl) -->
<xsl:param name="section.autolabel"   select="1"/>
<xsl:param name="part.autolabel"   select="1"/>
<xsl:param name="section.label.includes.component.label"   select="1"/>
<xsl:param name="component.label.includes.part.label"   select="1"/>
<xsl:param name="section.autolabel.max.depth" select="8"/>

<!-- 目录的级别，3 含义为显示到 sect3 (from param.xsl) -->
<xsl:param name="toc.section.depth">3</xsl:param>

<!-- 某些 sect 不显示在目录中 -->
<xsl:template match="sect1[@role = 'NotInToc']"  mode="toc" />

</xsl:stylesheet>
