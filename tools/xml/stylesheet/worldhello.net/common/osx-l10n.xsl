<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- 设置缺省语种 -->
<xsl:param name="l10n.gentext.default.language">zh_cn</xsl:param>
<!-- xsl:param name="l10n.gentext.language">zh_cn</xsl:param -->

<!-- 开始对 common/zh_cn.xsl 进行本地化定制 -->
<xsl:param name="local.l10n.xml" select="document('')"/>
<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n language="zh_cn">
    <!-- 定制中文姓名显示方式 -->
    <l:context name="styles">
       <l:template name="person-name" text="family-given"/>
    </l:context>

    <l:context name="title">
      <l:template name="webpage" text="%t"/>
    </l:context>
    <l:context name="xref">
      <l:template name="webpage" text="%t"/>
    </l:context>
    
    <!-- 首页 -->
    <l:gentext key="nav-home" text="&#39318;&#39029;"/>
  </l:l10n>
</l:i18n>

<!-- 符合中国人习惯的人名定制 -->
<xsl:template name="person.name.family-given">
  <xsl:param name="node" select="."/>

  <xsl:if test="$node//surname">
    <xsl:apply-templates select="$node//surname[1]"/>
  </xsl:if>

  <xsl:if test="$node//othername and $author.othername.in.middle != 0">
    <xsl:if test="$node//surname">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$node//othername[1]"/>
  </xsl:if>

  <xsl:if test="$node//firstname">
    <xsl:if test="$node//surname
                  or ($node//othername and $author.othername.in.middle != 0)">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$node//firstname[1]"/>
  </xsl:if>

  <xsl:if test="$node//lineage">
    <xsl:text>, </xsl:text>
    <xsl:apply-templates select="$node//lineage[1]"/>
  </xsl:if>

  <xsl:if test="$node//honorific">
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="$node//honorific[1]"/>
    <xsl:value-of select="$punct.honorific"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>