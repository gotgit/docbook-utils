<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc html"
                version="1.0">

<xsl:import href="http://docbook.sourceforge.net/release/website/current/xsl/tabular.xsl"/>

<!-- OSSXP.COM: PATCHES. -->
<!--
  OSSXP.COM Changes:
    文字版 LOGO 跳转到对应的美工页面，旁边增加一个首页链接。
    osx 扩展，增加到 文字版、图形界面版的链接
-->
<xsl:template match="webpage">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="webpage" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="tocentry" select="$autolayout/autolayout//*[$id=@id]"/>
  <xsl:variable name="toc" select="($tocentry/ancestor-or-self::toc
                                   |$autolayout/autolayout/toc[1])[last()]"/>

  <html>
    <xsl:apply-templates select="head" mode="head.mode"/>
    <xsl:apply-templates select="config" mode="head.mode"/>
    <body class="tabular">
      <xsl:call-template name="body.attributes"/>

      <div class="{name(.)}">
        <a name="{$id}"/>

        <xsl:call-template name="allpages.banner"/>

        <table xsl:use-attribute-sets="table.properties" border="0">
          <xsl:if test="$nav.table.summary!=''">
            <xsl:attribute name="summary">
              <xsl:value-of select="normalize-space($nav.table.summary)"/>
            </xsl:attribute>
          </xsl:if>
          <tr>
            <td xsl:use-attribute-sets="table.navigation.cell.properties">
              <img src="{$relpath}{$table.spacer.image}" alt=" " width="1" height="1"/>
            </td>
            <xsl:call-template name="hspacer">
              <xsl:with-param name="vspacer" select="1"/>
            </xsl:call-template>
            <td rowspan="3" xsl:use-attribute-sets="table.body.cell.properties">
              <xsl:if test="$navbodywidth != ''">
                <xsl:attribute name="width">
                  <xsl:value-of select="$navbodywidth"/>
                </xsl:attribute>
              </xsl:if>

              <xsl:if test="$autolayout/autolayout/toc[1]/@id = $id 
                            or $navhead.in.allpage">
                <table border="0" summary="home page extra headers"
                       cellpadding="0" cellspacing="0" width="100%">
                  <tr>
                    <xsl:call-template name="home.navhead.cell"/>
                    <xsl:call-template name="home.navhead.upperright.cell"/>
                  </tr>
                </table>
                <xsl:call-template name="home.navhead.separator"/>
              </xsl:if>
              <xsl:if test="($autolayout/autolayout/toc[1]/@id != $id 
                            and (not(/webpage/config[@param='suppress.page.title']/@value) 
                                or (/webpage/config[@param='suppress.page.title']/@value != 1) ) )
                            or ($autolayout/autolayout/toc[1]/@id = $id and $suppress.homepage.title = 0)">
                <xsl:apply-templates select="./head/title" mode="title.mode"/>
              </xsl:if>

              <xsl:apply-templates select="child::node()[not(self::webpage)]"/>
              <xsl:call-template name="process.footnotes"/>
              <br/>
            </td>
          </tr>
          <tr>
            <td xsl:use-attribute-sets="table.navigation.cell.properties">
              <xsl:if test="$navtocwidth != ''">
                <xsl:attribute name="width">
                  <xsl:choose>
                    <xsl:when test="/webpage/config[@param='navtocwidth']/@value[. != '']">
                      <xsl:value-of select="/webpage/config[@param='navtocwidth']/@value"/>
                    </xsl:when>
                    <xsl:when test="$autolayout/autolayout/config[@param='navtocwidth']/@value[. != '']">
                      <xsl:value-of select="$autolayout/autolayout/config[@param='navtocwidth']/@value"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$navtocwidth"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="$toc">
                  <div class="navtoc">
                    <xsl:apply-templates select="$toc">
                      <xsl:with-param name="pageid" select="@id"/>
                    </xsl:apply-templates>
                  </div>
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </td>
            <xsl:call-template name="hspacer"/>
          </tr>
          <xsl:call-template name="webpage.table.footer"/>
        </table>

        <xsl:call-template name="webpage.footer"/>
      </div>

    </body>
  </html>
</xsl:template>

<!-- OSSXP.COM: EXTENSIONS. -->
<xsl:include href="whodo-common.xsl"/>

<xsl:template name="webpage.table.footer">
  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="webpage" select="."/>
    </xsl:call-template>
  </xsl:variable>
  <tr class="toc">
    <td valign="bottom">
      <xsl:attribute name="bgcolor">
        <xsl:choose>
          <xsl:when test="/webpage/config[@param='navbgcolor']/@value[. != '']">
            <xsl:value-of select="/webpage/config[@param='navbgcolor']/@value"/>
          </xsl:when>
          <xsl:when test="$autolayout/autolayout/config[@param='navbgcolor']/@value[. != '']">
            <xsl:value-of select="$autolayout/autolayout/config[@param='navbgcolor']/@value"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$navbgcolor"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <a name="search"/>
      <table border="0" width="100%">
        <tr>
          <td>
            <div style="font-size:9pt;" align="center">
              <script language="javascript" src="{$relpath}includes/js/search.js" type="text/javascript"></script>
              <form action="" name="FormSearch" target="_blank" onsubmit="javascript: mysearch(FormSearch, 'google'); return false;">
                <div id='inputElements'></div>
                <input maxlength="256" size="25" name="content" value="" onmouseover="javascript:this.select()"/>
                <br/>
                <input type="radio" name="scope" value="worldhello" checked="yes"/>本网站 |
                <input type="radio" name="scope" value="all"/>所有
                <br/>
                <input type="button" value="古狗" name="btng" onclick="javascript: mysearch(FormSearch, 'google');"/> 
                <input type="button" value="百度" name="btnbaidu" onclick="javascript: mysearch(FormSearch, 'baidu');"/> 
                <input type="button" value="AF" name="btna" onclick="javascript: mysearch(FormSearch, 'acronym');"/> 
                <input type="button" value="Wiki" name="btnwiki" onclick="javascript: mysearch(FormSearch, 'wikipedia');"/>
              </form>
            </div>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</xsl:template>

<xsl:template name="home.navhead.cell">
  <xsl:variable name="text.pageuri">
    <xsl:call-template name="text.pageuri"/>
  </xsl:variable>
  
  <xsl:variable name="text.pagetext">
    <xsl:call-template name="text.pagetext"/>
  </xsl:variable>

  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="webpage" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <script language= "javascript" src="{$relpath}includes/js/navhead.js" type="text/javascript"></script>
  <script language= "javascript" type="text/javascript">
    write_navhead();
  </script>
  <td valign='middle' align='right'>
    <div class='navhead'>
    <a href="{$text.pageuri}"><xsl:value-of select='$text.pagetext'/></a><br/>
    <a href="/php/style.php?style=small" class="">-</a>&#160;
    <a href="/php/style.php?style=large" class="">+</a>
    </div>
  </td>
</xsl:template>

<xsl:template name="home.navhead.upperright.cell"/>

</xsl:stylesheet>
