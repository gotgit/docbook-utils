--- docbook-xsl-1.69.1/htmlhelp/htmlhelp-common.xsl	2005-12-19 23:33:53.000000000 +0800
+++ docbook-xsl/htmlhelp/htmlhelp-common.xsl	2005-12-26 18:09:06.671875000 +0800
@@ -49,6 +49,29 @@
   
 <!-- ==================================================================== -->
 
+<!-- split string and print them in seperate lines. (OpenSourceXpress.com)   -->
+<xsl:template name="string-split">
+  <xsl:param name="input" />
+  <xsl:param name="substr" />
+  <xsl:choose>
+    <xsl:when test="$substr and contains($input, $substr)">
+      <xsl:variable name="temp" select="substring-after($input, $substr)" />
+      <xsl:value-of select="concat(substring-before($input, $substr), '&#10;')" />
+      <xsl:if test="$temp">
+        <xsl:call-template name="string-split">
+          <xsl:with-param name="input" select="$temp" />
+          <xsl:with-param name="substr" select="$substr" />
+        </xsl:call-template>
+      </xsl:if>
+    </xsl:when>
+    <xsl:otherwise>
+      <xsl:value-of select="concat($input, '&#10;')" />
+    </xsl:otherwise>
+  </xsl:choose>
+</xsl:template>
+
+<!-- ==================================================================== -->
+
 <xsl:template match="/">
   <xsl:if test="$htmlhelp.only != 1">
     <xsl:choose>
@@ -334,6 +357,14 @@
   </xsl:choose>
 </xsl:if>
 
+<!-- Files in $htmlhelp.extra.files, will be added to project file. (OpenSourceXpress.com)   -->
+<xsl:if test="$htmlhelp.extra.files != ''">
+  <xsl:call-template name="string-split">
+    <xsl:with-param name="input" select="normalize-space($htmlhelp.extra.files)" />
+    <xsl:with-param name="substr" select="' '" />
+  </xsl:call-template>  
+</xsl:if>
+
 <xsl:if test="($htmlhelp.force.map.and.alias != 0) or 
               ($rootid = '' and //processing-instruction('dbhh')) or
               ($rootid != '' and key('id',$rootid)//processing-instruction('dbhh'))">
