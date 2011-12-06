<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:include href="http://www.worldhello.net/docbook/xsl/current/common/osx-xref.xsl"/>
<xsl:include href="osx-footer.xsl"/>

<!-- 本文件包含几个样式表的公共部分，供其它样式表包含。 -->

<!-- 设置输出网页编码以及排版与否 -->
<xsl:output method="html" encoding="UTF-8" indent="yes"/>
            
<!-- 本地化定制 -->
<xsl:include href="http://www.worldhello.net/docbook/xsl/current/common/osx-l10n.xsl"/>

<!-- 设置 CSS 样式表. (from param.xsl) -->
<xsl:param name="html.stylesheet.type">text/css</xsl:param>
<!--xsl:param name="html.stylesheet">includes/css/tabular.css</xsl:param-->
<xsl:param name="generate.id.attributes" select="0"/>

<!-- 是否用水平分隔线分隔正文于 header 和 footer (from param.xsl) -->
<xsl:param name="header.hr" select="1"/>
<xsl:param name="footer.hr" select="1"/>

<!-- 导航条以及正文的背景颜色设置 (from param.xsl) -->
<xsl:param name="textbgcolor">white</xsl:param>
<xsl:param name="navbgcolor">#4080FF</xsl:param>

<!-- 以图标方式显示警告 (admonitions) (from param.xsl) -->
<xsl:param name="admon.graphics" select="1"/>
<xsl:param name="admon.textlabel" select="0"/>
<xsl:param name="admon.graphics.path">includes/images/docbook/</xsl:param>
<xsl:param name="admon.graphics.extension">.png</xsl:param>

<!-- 以图标方式显示导航 (from param.xsl) -->
<xsl:param name="navig.graphics" select="1"/>
<xsl:param name="navig.graphics.path">includes/images/docbook/</xsl:param>
<xsl:param name="navig.graphics.extension">.png</xsl:param>

<!-- 以图标方式显示 callout (from param.xsl) -->
<xsl:param name="callout.graphics" select="1"/>
<xsl:param name="callout.graphics.path">includes/images/callouts/</xsl:param>
<xsl:param name="callout.graphics.extension">.png</xsl:param>
<xsl:param name="callout.graphics.number.limit">15</xsl:param>

<!-- 图片位置 -->
<!-- 绝对路径要去掉前面的 "/"，因为系统会在前面增加到根目录的相对路径。
	以免出现如同 "..//images/" 中的两个斜线 -->
<xsl:param name="toc.spacer.image">includes/images/docbook/blank.png</xsl:param>
<xsl:param name="toc.pointer.image">includes/images/docbook/arrow.png</xsl:param>
<xsl:param name="toc.blank.image">includes/images/docbook/blank.png</xsl:param>
<xsl:param name="table.spacer.image">includes/images/docbook/spacer.png</xsl:param>
<xsl:param name="nav.icon.path">includes/images/navicons/</xsl:param>
<xsl:param name="nav.icon.extension">.gif</xsl:param>

<!-- 章节编号 (from param.xsl) -->
<xsl:param name="section.autolabel"   select="1"/>
<xsl:param name="section.label.includes.component.label"   select="1"/>
<xsl:param name="section.autolabel.max.depth" select="8"/>

<!-- 是否在网页最下方显示上一页、下一页，以便可以顺序的浏览整个网站 -->
<xsl:param name="sequential.links" select="0"/>

<!-- 标题显示位置 (from param.xsl) -->
<xsl:param name="formal.title.placement">
figure after
example before
equation after
table before
procedure before
task before
</xsl:param>

<!-- 页面反馈。如果定义 feedback.with.ids 为 1, 则将本页 ID 加到 feedback.href 之后 -->
<xsl:param name="feedback.href"/>
<xsl:param name="feedback.with.ids" select="0"/>
<xsl:param name="feedback.link.text">反馈</xsl:param>

<!-- revisionflag 文字 -->
<xsl:param name="nav.text.revisionflag.added">新增</xsl:param>
<xsl:param name="nav.text.revisionflag.changed">修改</xsl:param>
<xsl:param name="nav.text.revisionflag.deleted"></xsl:param>
<xsl:param name="nav.text.revisionflag.off"></xsl:param>

<!-- revisionflag 样式 -->
<xsl:param name="nav.icon.style">triangle</xsl:param>

<!-- 导航条宽度 -->
<xsl:param name="navtocwidth">220</xsl:param>

<xsl:param name="toc.expand.depth" select="3"/> 

<!-- Osx Extension -->
<xsl:param name="prev.link.text">[&lt;]</xsl:param>
<xsl:param name="next.link.text">[&gt;]</xsl:param>
<xsl:param name="navhead.in.allpage"	select="1"/>

<xsl:template name="tabular.homeuri">
  <xsl:param name="addprefix" select="0"/>
  <xsl:param name="page" select="ancestor-or-self::webpage"/>
  <xsl:variable name="id" select="$page/@id"/>
  <xsl:variable name="tocentry"
                select="$autolayout//*[@id=$id]"/>
  <xsl:variable name="toc" select="$tocentry/ancestor::toc"/>
  <xsl:variable name="first-toc"
                select="$autolayout/autolayout/toc[1]"/>

  <xsl:call-template name="root-rel-path"/>
  <xsl:choose>
    <xsl:when test="$toc">
      <xsl:choose>
        <xsl:when test="starts-with($toc/@dir, '/')">
          <xsl:value-of select="substring($toc/@dir, 2)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$toc/@dir"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$addprefix">
        <xsl:call-template name="text.page.prefix"/>
      </xsl:if>
      <xsl:value-of select="$toc/@filename"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="starts-with($first-toc/@dir, '/')">
          <xsl:value-of select="substring($first-toc/@dir, 2)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$first-toc/@dir"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$addprefix">
        <xsl:call-template name="text.page.prefix"/>
      </xsl:if>
      <xsl:value-of select="$first-toc/@filename"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="text.homeuri">
  <xsl:call-template name="tabular.homeuri">
    <xsl:with-param name="addprefix" select="1"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="tabular.pageuri">
  <xsl:param name="addprefix" select="0"/>
  <xsl:param name="pageid" select="ancestor-or-self::webpage/@id"/>
  
  <xsl:variable name="tocentry"
                select="$autolayout//*[@id=$pageid]"/>

  <xsl:call-template name="root-rel-path"/>
  <xsl:choose>
    <xsl:when test="$tocentry">
      <xsl:choose>
        <xsl:when test="starts-with($tocentry/@dir, '/')">
          <xsl:value-of select="substring($tocentry/@dir, 2)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$tocentry/@dir"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$addprefix">
        <xsl:call-template name="text.page.prefix"/>
      </xsl:if>
      <xsl:value-of select="$tocentry/@filename"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="tabular.homeuri">
        <xsl:with-param name="addprefix" select="$addprefix"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="text.pageuri">
  <xsl:param name="pageid" select="ancestor-or-self::webpage/@id"/>
  
  <xsl:call-template name="tabular.pageuri">
    <xsl:with-param name="addprefix" select="1"/>
    <xsl:with-param name="pageid" select="$pageid"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="text.page.prefix">
  <xsl:choose>
    <xsl:when test="$autolayout/autolayout/config[@param='text.website.prefix'][1]">
      <xsl:value-of select="$autolayout/autolayout/config[@param='text.website.prefix'][1]/@value"/>
    </xsl:when>
    <xsl:when test="$text.website.prefix != ''">
      <xsl:value-of select="$text.website.prefix"/>
    </xsl:when>
    <xsl:when test="$filename-prefix != ''">
      <xsl:value-of select="$filename-prefix"/>
    </xsl:when>
    <xsl:otherwise>
      n-
    </xsl:otherwise>      
  </xsl:choose>
</xsl:template>

<xsl:template name="text.pagetext">
  <xsl:choose>
    <xsl:when test="$autolayout/autolayout/config[@param='text.website.text'][1]">
      <xsl:value-of select="$autolayout/autolayout/config[@param='text.website.text'][1]/@value"/>
    </xsl:when>
    <xsl:when test="$text.website.text != ''">
      <xsl:value-of select="$text.website.text"/>
    </xsl:when>
    <xsl:otherwise>
      文字版
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tabular.pagetext">
  <xsl:choose>
    <xsl:when test="$autolayout/autolayout/config[@param='gui.website.text'][1]">
      <xsl:value-of select="$autolayout/autolayout/config[@param='gui.website.text'][1]/@value"/>
    </xsl:when>
    <xsl:when test="$gui.website.text != ''">
      <xsl:value-of select="$gui.website.text"/>
    </xsl:when>
    <xsl:otherwise>
      美工版
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
