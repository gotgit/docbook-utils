<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc html"
                version="1.0">

<xsl:import href="http://docbook.sourceforge.net/release/website/current/xsl/website-common.xsl"/>

<!--
  OSSXP.COM Changes:
    文字版 LOGO 跳转到对应的美工页面，旁边增加一个首页链接。
    osx 扩展，增加到 文字版、图形界面版的链接
-->
<xsl:template name="webpage.footer">
  <xsl:variable name="page" select="."/>
  <xsl:variable name="footers" select="$page/config[@param='footer']
                                       |$page/config[@param='footlink']
                                       |$autolayout/autolayout/config[@param='footer']
                                       |$autolayout/autolayout/config[@param='footlink']"/>

  <xsl:variable name="tocentry" select="$autolayout//*[@id=$page/@id]"/>
  <xsl:variable name="toc" select="($tocentry/ancestor-or-self::toc[1]
                                   | $autolayout//toc[1])[last()]"/>

  <xsl:variable name="feedback">
    <xsl:choose>
      <xsl:when test="$page/config[@param='feedback.href']">
        <xsl:value-of select="($page/config[@param='feedback.href'])[1]/@value"/>
      </xsl:when>
      <xsl:when test="$autolayout/autolayout/config[@param='feedback.href']">
        <xsl:value-of select="($autolayout/autolayout/config[@param='feedback.href'])[1]/@value"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$feedback.href"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <div class="navfoot">
    <xsl:if test="$footer.hr != 0"><hr/></xsl:if>
    <table width="100%" border="0" summary="Footer navigation">
      <tr>
        <td width="33%" align="left">
          <span class="footdate">
            <xsl:call-template name="rcsdate.format">
              <xsl:with-param name="rcsdate"
                              select="$page/config[@param='rcsdate']/@value"/>
            </xsl:call-template>
          </span>
        </td>
        <td width="34%" align="center">
          <xsl:choose>
            <xsl:when test="not($toc)">
              <xsl:message>
                <xsl:text>Cannot determine TOC for </xsl:text>
                <xsl:value-of select="$page/@id"/>
              </xsl:message>
            </xsl:when>
            <xsl:when test="$toc/@id = $page/@id">
              <!-- nop; this is the home page -->
            </xsl:when>
            <xsl:otherwise>
              <span class="foothome">
                <a>
                  <xsl:attribute name="href">
                    <xsl:call-template name="homeuri"/>
                  </xsl:attribute>
                  <xsl:call-template name="gentext.nav.home"/>
                </a>
                <xsl:if test="$footers">
                  <xsl:text> | </xsl:text>
                </xsl:if>
              </span>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:apply-templates select="$footers" mode="footer.link.mode">
            <xsl:with-param name="webpage" select="ancestor-or-self::webpage"/>
          </xsl:apply-templates>
        </td>
        <td width="33%" align="right">
            <xsl:choose>
              <xsl:when test="$feedback != ''">
                <span class="footfeed">
                  <a>
                    <xsl:choose>
                      <xsl:when test="$feedback.with.ids != 0">
                        <xsl:attribute name="href">
                          <xsl:value-of select="$feedback"/>
                          <xsl:value-of select="$page/@id"/>
                        </xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="href">
                          <xsl:value-of select="$feedback"/>
                        </xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="$feedback.link.text"/>
                  </a>
                </span>
              </xsl:when>
              <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
        </td>
      </tr>
      <tr>
        <td colspan="3" align="right">
          <span class="footcopy">
            <xsl:choose>
              <xsl:when test="head/copyright">
                <xsl:apply-templates select="head/copyright" mode="footer.mode"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates mode="footer.mode"
                                     select="$autolayout/autolayout/copyright"/>
              </xsl:otherwise>
            </xsl:choose>
          </span>
        </td>
      </tr>
      <xsl:if test="$sequential.links != 0">
        <tr>
          <xsl:variable name="prev">
            <xsl:call-template name="prev.page"/>
          </xsl:variable>
          <xsl:variable name="next">
            <xsl:call-template name="next.page"/>
          </xsl:variable>
          <xsl:variable name="ptoc"
                        select="$autolayout/autolayout//*[$prev=@id]"/>
          <xsl:variable name="ntoc"
                        select="$autolayout/autolayout//*[$next=@id]"/>

          <td align="left" valign="top">
            <span class="footnav">
            <xsl:choose>
              <xsl:when test="$prev != ''">
                <xsl:call-template name="link.to.page">
                  <xsl:with-param name="frompage" select="$tocentry"/>
                  <xsl:with-param name="page" select="$ptoc"/>
                  <xsl:with-param name="linktext" select="$prev.link.text"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
            </span>
          </td>
          <td>&#160;</td>
          <td align="right" valign="top">
            <span class="footnav">
            <xsl:choose>
              <xsl:when test="$next != ''">
                <xsl:call-template name="link.to.page">
                  <xsl:with-param name="frompage" select="$tocentry"/>
                  <xsl:with-param name="page" select="$ntoc"/>
                  <xsl:with-param name="linktext" select="$next.link.text"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
            </span>
          </td>
        </tr>
      </xsl:if>
    </table>
  </div>
</xsl:template>

<xsl:template match="config" mode="footer.link.mode">
  <xsl:param name="webpage" select="ancestor-or-self::webpage"/>

  <span class="foothome">
    <xsl:if test="position() &gt; 1">
      <xsl:text> | </xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@param='footlink'">
        <xsl:variable name="id" select="@value"/>
        <xsl:variable name="tocentry"
                      select="$autolayout//*[@id=$id]"/>
        <xsl:if test="count($tocentry) != 1">
          <xsl:message>
            <xsl:text>Footlink to </xsl:text>
            <xsl:value-of select="$id"/>
            <xsl:text> does not id a unique page.</xsl:text>
          </xsl:message>
        </xsl:if>
        <xsl:variable name="dir">
          <xsl:choose>
            <xsl:when test="starts-with($tocentry/@dir, '/')">
              <xsl:value-of select="substring($tocentry/@dir, 2)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$tocentry/@dir"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <a>
          <xsl:attribute name="href">
            <!-- if config is in autolayout, current context is not in webpage -->
            <xsl:call-template name="root-rel-path">
              <xsl:with-param name="webpage" select="$webpage"/>
            </xsl:call-template>
            <xsl:value-of select="$dir"/>
            <xsl:value-of select="$filename-prefix"/>
            <xsl:value-of select="$tocentry/@filename"/>
          </xsl:attribute>
          <xsl:value-of select="@altval"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a href="{@value}">
          <xsl:value-of select="@altval"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

</xsl:stylesheet>
