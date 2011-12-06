<?xml version="1.0" encoding="UTF-8"?>
<!-- xslt to transform files from MindManager exported files to docbook xml
     files (MindManager exports using the mmp.xsd schema) -->
<!-- 
 - authorInfo/email: how to use?
-->
 <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" 
	doctype-system="http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" 
     doctype-public="-//OASIS//DTD DocBook XML V4.1.2//EN"
     version="1.0" encoding="UTF-8" indent="yes"/> 

  <xsl:template match="/">
    <xsl:element name="article">
    
    <!-- build the abstract from the root node (map title) -->
      <xsl:element name="abstract">
        <xsl:element name="title">
  	      <xsl:value-of select="/map/data/text"/>
        </xsl:element>
        <xsl:element name="para">
          <xsl:value-of select="/map/data/note/text"/>
        </xsl:element>
      </xsl:element>
      
      <xsl:element name="articleinfo">
        
        <!-- do i really need the title twice? -->
        <xsl:element name="title">
  	      <xsl:value-of select="/map/data/text"/>
        </xsl:element>
        <xsl:element name="author">

          <!-- the schema provides full names only, therefore we use the
               othername tag -->
          <xsl:element name="othername">
            <xsl:value-of select="/map/mapInfo/author/name"/>
          </xsl:element>

<!-- hmm, need to get some help about the email type -->
          <xsl:element name="email">
            <xsl:value-of select="/map/mapInfo/author/email"/>
          </xsl:element>
-->
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates select="map/node"/>
    </xsl:element>
  </xsl:template>
  
  <!-- for each section extract a title and the note as content -->
  <xsl:template match="data">
    <xsl:element name="title">
      <xsl:value-of select="text"/>
    </xsl:element>
    <xsl:element name="para">
      <xsl:value-of select="note/text"/>
    </xsl:element>
  </xsl:template>

  <!-- any node becomes a section -->
  <xsl:template match="node">
    <xsl:element name="section">
      <xsl:apply-templates select="data"/>
      <xsl:apply-templates select="node"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
