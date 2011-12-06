<?xml version="1.0" encoding="UTF-8"?>

<!-- 
docbook to mindmanager transformation
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/> 

  <xsl:template match="/">
    <xsl:apply-templates select="book|article|chapter|section|sect1"/>
  </xsl:template>

  <xsl:template match="book|article">
    <xsl:element name="map">
      <xsl:element name="data">
        <xsl:element name="text">
          <xsl:value-of select="//bookinfo/title"/>
        </xsl:element>
      </xsl:element>

      <xsl:apply-templates select="chapter|section|sect1"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="chapter|section|sect1">
    <xsl:element name="node">
      <xsl:element name="data">
        <xsl:element name="text">
          <xsl:value-of select="title"/>
        </xsl:element>
        <xsl:element name="note">
          <xsl:value-of select="para"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates select="chapter|section|sect1"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
