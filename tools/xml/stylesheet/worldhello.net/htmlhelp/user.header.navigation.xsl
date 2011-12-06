<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template name="user.header.navigation">
  <script language= "javascript" src="hh-header.js" type="text/javascript"></script>
  <script language= "javascript"> write_header("<xsl:value-of select="$document_root" />"); </script>
</xsl:template>

</xsl:stylesheet>
