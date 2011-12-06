<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/html/onechunk.xsl"/>
<xsl:import href="whodo-common.xsl"/>

<!-- 设置输出文件扩展名，和分页HTML的扩展名不同，避免同名覆盖！ -->
<xsl:param name="html.ext">.htm</xsl:param>
<xsl:param name="root.filename">index</xsl:param>

<!-- 设置输出目录
<xsl:param name="base.dir">./</xsl:param>
-->

</xsl:stylesheet>
