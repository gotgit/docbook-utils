<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc html"
                version="1.0">

<xsl:import href="http://docbook.sourceforge.net/release/website/current/xsl/olink.xsl"/>

<!-- 
  OSSXP.COM ChangeLog:
    olink do not add root-rel if baseuri is URL like: http:|https:|ftp:|mailto: ...
    olink 生成链接增加前缀 filename-prefi
-->
<xsl:template name="make.olink.href">
  <xsl:param name="olink.key" select="''"/>
  <xsl:param name="target.database"/>

  <xsl:if test="$olink.key != ''">

    <xsl:variable name="targetdoc">
      <xsl:value-of select="substring-before($olink.key, '/')"/>
    </xsl:variable>
  
    <xsl:variable name="targetptr">
      <xsl:value-of select="substring-before(substring-after($olink.key, '/'),'/')"/>
    </xsl:variable>
  
    <xsl:variable name="target.href" >
      <xsl:for-each select="$target.database" >
        <xsl:value-of select="key('targetptr-key', $olink.key)/@href" />
      </xsl:for-each>
    </xsl:variable>
  
    <xsl:variable name="target.dir" >
      <xsl:for-each select="$target.database" >
        <xsl:value-of select="key('targetdoc-key', $targetdoc)/@dir" />
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="target.element" >
      <xsl:for-each select="$target.database" >
        <xsl:value-of select="key('targetptr-key', $olink.key)/@element" />
      </xsl:for-each>
    </xsl:variable>

    <!-- Does the target database use a sitemap? -->
    <xsl:variable name="use.sitemap">
      <xsl:choose>
        <xsl:when test="$target.database//sitemap">1</xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
  
  
    <!-- Get the baseuri for this targetptr -->
    <xsl:variable name="baseuri" >
      <xsl:choose>
        <!-- Does the database use a sitemap? -->
        <xsl:when test="$use.sitemap != 0" >
          <xsl:choose>
            <!-- Was current.docid parameter set? -->
            <xsl:when test="$current.docid != ''">
              <!-- Was it found in the database? -->
              <xsl:variable name="currentdoc.key" >
                <xsl:for-each select="$target.database" >
                  <xsl:value-of select="key('targetdoc-key',
                                        $current.docid)/@targetdoc" />
                </xsl:for-each>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="$currentdoc.key != ''">
                  <xsl:for-each select="$target.database" >
                    <xsl:call-template name="targetpath" >
                      <xsl:with-param name="dirnode" 
                          select="key('targetdoc-key', $current.docid)/parent::dir"/>
                      <xsl:with-param name="targetdoc" select="$targetdoc"/>
                    </xsl:call-template>
                  </xsl:for-each >
                </xsl:when>
                <xsl:otherwise>
                  <xsl:message>
                    <xsl:text>Olink error: cannot compute relative </xsl:text>
                    <xsl:text>sitemap path because $current.docid '</xsl:text>
                    <xsl:value-of select="$current.docid"/>
                    <xsl:text>' not found in target database.</xsl:text>
                  </xsl:message>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message>
                <xsl:text>Olink warning: cannot compute relative </xsl:text>
                <xsl:text>sitemap path without $current.docid parameter</xsl:text>
              </xsl:message>
            </xsl:otherwise>
          </xsl:choose> 
          <!-- In either case, add baseuri from its document entry-->
          <xsl:variable name="docbaseuri">
            <xsl:for-each select="$target.database" >
              <xsl:value-of select="key('targetdoc-key', $targetdoc)/@baseuri" />
            </xsl:for-each>
          </xsl:variable>
          <xsl:if test="$docbaseuri != ''" >
            <xsl:value-of select="$docbaseuri"/>
          </xsl:if>
        </xsl:when>
        <!-- No database sitemap in use -->
        <xsl:otherwise>
          <xsl:variable name="docbaseuri">
            <xsl:for-each select="$target.database" >
              <xsl:value-of select="key('targetdoc-key',
                                        $targetdoc)/@baseuri" />
            </xsl:for-each>
          </xsl:variable>
          
          <!-- if $docbaseuri not a relative/absolute path, i.e. is a URL, then DO NOT add root-rel and target.dir  -->
          <xsl:choose>
            <xsl:when test="substring-before($docbaseuri, ':') != ''">
              <xsl:value-of select="$docbaseuri"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- compute a root-relative path if current page has a @dir -->
              <xsl:variable name="root-rel">
                <xsl:call-template name="root-rel-path"/>
              </xsl:variable>
              <xsl:if test="$root-rel != ''">
                <xsl:value-of select="$root-rel"/>
              </xsl:if>
              <!-- Add the target's @dir to the path -->
              <xsl:if test="$target.dir != ''">
                <xsl:value-of select="$target.dir"/>
              </xsl:if>
              <!-- Text only version, add prefix -->
              <xsl:if test="$filename-prefix != ''" >
                <xsl:value-of select="$filename-prefix"/>
              </xsl:if>
              <!-- Just use any baseuri from its document entry -->
              <xsl:if test="$docbaseuri != ''" >
                <xsl:value-of select="$docbaseuri"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
  
    <!-- Form the href information -->
    <xsl:if test="$baseuri != ''">
      <xsl:value-of select="$baseuri"/>
      <xsl:if test="substring($target.href,1,1) != '#'">
        <!--xsl:text>/</xsl:text-->
      </xsl:if>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$target.element = 'webpage' and
                      $targetdoc = $targetptr">
        <!-- Don't output #id because not needed -->
      </xsl:when>
      <!-- optionally turn off frag for PDF references -->
      <xsl:when test="not($insert.olink.pdf.frag = 0 and
            translate(substring($baseuri, string-length($baseuri) - 3),
                      'PDF', 'pdf') = '.pdf'
            and starts-with($target.href, '#') )">
        <xsl:value-of select="$target.href"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$target.href"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
