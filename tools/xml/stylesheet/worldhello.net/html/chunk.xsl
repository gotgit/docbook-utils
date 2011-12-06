<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import  href="http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl"/>
<xsl:include href="whodo-common.xsl"/>

<!-- 分页相关 -->
<!-- 是否将目录页从首页独立出来？ -->
<xsl:param name="chunk.tocs.and.lots" select="0"/>
<xsl:param name="chunk.separate.lots" select="0"/>

<!-- 设置输出文件扩展名，和单页 HTM 的扩展名不同，避免同名覆盖！ -->
<xsl:param name="html.ext">.html</xsl:param>
<xsl:param name="root.filename">index</xsl:param>

<!-- 文章分页粒度，默认是粒度为1 -->
<xsl:param name="chunk.section.depth">2</xsl:param>

<!-- 是否将第一章内容与标题、TOC 分开？ -->
<xsl:param name="chunk.first.sections" select="1"/>

<!-- 是否在章节中创建小型的目录索引？(from param.xsl) -->
<xsl:param name="generate.section.toc.level">2</xsl:param>
<xsl:param name="generate.toc">
appendix  toc,title
article/appendix  nop
article   toc,title
book      toc,title,figure,table,example,equation
chapter   toc,title
part      toc,title
preface   toc,title
qandadiv  toc
qandaset  toc
reference toc,title
sect1     toc
sect2     toc
sect3     toc
sect4     toc
sect5     toc
section   toc
set       toc,title
</xsl:param>

<!-- 设置输出目录
<xsl:param name="base.dir">./</xsl:param>
-->

</xsl:stylesheet>
