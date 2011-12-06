<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template name="user.footer.content">
<table class="copyright" border="0" cellpadding="0" cellspacing="0" width="100%"><col width="33%"/><col width="33%"/><col width="33%"/>
  <tr>
    <td><xsl:value-of select="//releaseinfo[1]"/></td>
    <td align="center" valign="center">
      
    </td>
    <td align="right" valign="center">
      <p class="copyright">
      Copyright &#x000A9; 2006 <a href="http://www.worldhello.net/doc/"><b>WorldHello 开放文档之源</b> 计划</a></p>
    </td>
  </tr>
</table>
</xsl:template>

</xsl:stylesheet>
