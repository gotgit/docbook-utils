<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template name="user.header.navigation">
  <script language= "javascript" type="text/javascript">
    <xsl:attribute name="src"><xsl:value-of select="$document_root" />/includes/js/header.js</xsl:attribute>
  </script>
  <script language= "javascript"> write_header("<xsl:value-of select="$document_root" />"); </script>
</xsl:template>

</xsl:stylesheet>
