<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:include href="../common/osx-xref.xsl"/>

<!-- 本文件包含几个样式表的公共部分，供其它样式表包含。 -->

<xsl:param name="document_root">../..</xsl:param>

<!-- 设置输出文件编码，否则为 ISO8859-1 (from chunker.xsl) -->
<xsl:param name="chunker.output.encoding">utf-8</xsl:param>

<!-- 更好的输出: 输出文件缩进控制, yes/no (from chunker.xsl) -->
<xsl:param name="chunker.output.indent">yes</xsl:param>

<!-- 本地化定制 -->
<xsl:include href="../common/osx-l10n.xsl"/>

<!-- 提供分页速度。需要 EXSLT node-set() 函数支持，Saxon, Xalan, 
     和 xsltproc 均支持 (from chunk-code.xsl) -->
<xsl:param name="chunk.fast" select="1"/>

<!-- 设置 CSS 样式表. (from param.xsl) -->
<xsl:param name="html.stylesheet.type">text/css</xsl:param>
<xsl:param name="html.stylesheet">/stylesheets/master.css /stylesheets/syntax.css <xsl:value-of select="$document_root" />/includes/css/docbook.css</xsl:param>
<xsl:param name="generate.id.attributes" select="0"/>

<!-- 以图标方式显示警告 (admonitions) (from param.xsl) -->
<xsl:param name="admon.graphics" select="1"/>
<xsl:param name="admon.textlabel" select="0"/>
<xsl:param name="admon.graphics.path"><xsl:value-of select="$document_root" />/includes/images/docbook/</xsl:param>
<xsl:param name="admon.graphics.extension">.png</xsl:param>

<!-- 以图标方式显示导航 (from param.xsl) -->
<xsl:param name="navig.graphics" select="1"/>
<xsl:param name="navig.graphics.path"><xsl:value-of select="$document_root" />/includes/images/docbook/</xsl:param>
<xsl:param name="navig.graphics.extension">.png</xsl:param>

<!-- 以图标方式显示 callout (from param.xsl) -->
<xsl:param name="callout.graphics" select="1"/>
<xsl:param name="callout.graphics.path"><xsl:value-of select="$document_root" />/includes/images/callouts/</xsl:param>
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

<!-- 是否根据元素 ID 确定文件名？ (from param.xsl) -->
<xsl:param name="use.id.as.filename" select="1"/>

<!-- 章节编号 (from param.xsl) -->
<xsl:param name="section.autolabel"   select="1"/>
<xsl:param name="section.label.includes.component.label"   select="1"/>
<xsl:param name="section.autolabel.max.depth" select="8"/>

<!-- 目录的级别，3 含义为显示到 sect3 (from param.xsl) -->
<xsl:param name="toc.section.depth">3</xsl:param>

<!-- 某些 sect 不显示在目录中 -->
<xsl:template match="sect1[@role = 'NotInToc']"  mode="toc" />

<!-- 模板: user.preroot, 显示在 <html> 标签之前 (from chunk-common.xsl) -->
<xsl:include href="user.preroot.xsl"/>

<!-- 模板: user.head.content, 显示在 <head> </head> 标签之间 
     (from chunk-common.xsl) -->
<xsl:include href="user.head.content.xsl"/>

<!-- 模板: user.header.navigation, 显示在顶部导航条上面，紧接着<body>之后。
     也许要 suppress.navigation 抑制原导航输出 (from chunk-common.xsl) -->
<xsl:include href="user.header.navigation.xsl"/>

<!-- 模板: user.header.content, 显示在顶部导航条下面，和内容之间的位置 
     (from chunk-common.xsl) -->
<xsl:include href="user.header.content.xsl"/>

<!-- 模板: user.footer.content, 显示在内容之后，底部导航条之前 
     (from chunk-common.xsl) -->
<xsl:include href="user.footer.content.xsl"/>

<!-- 模板: user.footer.navigation, 显示在底部导航条后面，</body>之前。
     也许要 suppress.navigation 抑制原导航输出 (from chunk-common.xsl) -->
<xsl:include href="user.footer.navigation.xsl"/>

</xsl:stylesheet>
