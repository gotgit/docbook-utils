<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:suwl="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.UnwrapLinks"
    version="1.0">

<xsl:template match="ulink" name="ulink">
  <xsl:variable name="link">
    <a>
      <xsl:if test="@id">
        <xsl:attribute name="name">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
      <xsl:choose>
        <xsl:when test="@type = 'new'">
          <xsl:attribute name="target">_blank</xsl:attribute>
        </xsl:when>
        <xsl:when test="@type != 'replace'">
          <xsl:attribute name="target">
            <xsl:value-of select="@type"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="$ulink.target != ''">
          <xsl:attribute name="target">
            <xsl:value-of select="$ulink.target"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="count(child::node())=0">
          <xsl:value-of select="@url"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('suwl:unwrapLinks')">
      <xsl:copy-of select="suwl:unwrapLinks($link)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$link"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>