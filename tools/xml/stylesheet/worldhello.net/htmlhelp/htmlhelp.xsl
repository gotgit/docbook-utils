<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:exsl="http://exslt.org/common"
                xmlns:set="http://exslt.org/sets"
		version="1.0"
                exclude-result-prefixes="doc exsl set">

<xsl:import href="../html/chunk.xsl"/>
<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/htmlhelp/htmlhelp-common.xsl"/>
<xsl:include href="osx-patch.xsl"/>

<xsl:param name="document_root" select="'/'"/>

<!-- 由于 htmlhelp 将链接到工程目录之外的文件，都放在工程的根目录，导致编译的 chm 文件中
     引用工程外文件失败，因此将工程目录外的文件路径统一设置为工程根目录。   -->
<xsl:param name="admon.graphics.path"></xsl:param>
<xsl:param name="navig.graphics.path"></xsl:param>
<xsl:param name="callout.graphics.path"></xsl:param>
<xsl:param name="html.stylesheet">docbook.css</xsl:param>

<!-- 分页 HTML 的前缀，这样 htmlhelp 临时文件不会覆盖其它输出文件  -->
<!--xsl:param name="osx.html.prefix">hh-</xsl:param-->

<!-- 分页 HTML 的后缀，这样 htmlhelp 临时文件不会覆盖其它输出文件  -->
<xsl:param name="html.ext">-hhfile.htm</xsl:param>

<!-- 设置主页文件名 -->
<xsl:param name="htmlhelp.button.home.url">hh-index.htm</xsl:param>

<!-- 是否显示根元素 -->
<xsl:param name="htmlhelp.hhc.show.root" select="0"/>

<!-- 设置 chm 输出文件编码，否则为 ISO8859-1 -->
<xsl:param name="htmlhelp.encoding">utf-8</xsl:param>

<!-- 是否将图片枚举在工程文件中 -->
<xsl:param name="htmlhelp.enumerate.images" select="1"/>

<!-- 是否启用 Index -->
<xsl:param name="htmlhelp.use.hhk" select="1"/>

<!-- 按钮定制 -->
<xsl:param name="htmlhelp.button.hideshow" select="1"/>
<xsl:param name="htmlhelp.button.back" select="1"/>
<xsl:param name="htmlhelp.button.forward" select="1"/>
<xsl:param name="htmlhelp.button.print" select="1"/>
<xsl:param name="htmlhelp.button.options" select="1"/>
<xsl:param name="htmlhelp.button.zoom" select="1"/>
<xsl:param name="htmlhelp.button.locate" select="0"/>
<xsl:param name="htmlhelp.button.stop" select="0"/>
<xsl:param name="htmlhelp.button.refresh" select="0"/>

<!-- 启用网页分页的导航条，而禁用窗口的导航按钮 -->
<xsl:param name="suppress.navigation" select="0"/>
<xsl:param name="htmlhelp.button.home" select="0"/>
<xsl:param name="htmlhelp.button.next" select="0"/>
<xsl:param name="htmlhelp.button.previous" select="0"/>

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

<!-- 如下文件加入到 hemlhelp.hpp 的文件列表中 -->
<xsl:param name="htmlhelp.extra.files">
<xsl:value-of select="$document_root"/>/includes/images/docbook/*.png
<xsl:value-of select="$document_root"/>/includes/images/callouts/*.png
<xsl:value-of select="$document_root"/>/includes/images/*.png
<xsl:value-of select="$document_root"/>/includes/css/docbook.css
<xsl:value-of select="$document_root"/>/includes/js/hh-header.js
<xsl:value-of select="$document_root"/>/includes/js/hh-footer.js
</xsl:param>

</xsl:stylesheet>
