<?xml version="1.0" encoding="UTF-8" ?>

<!--
        : This code released under the GPL.
        : (http://www.gnu.org/copyleft/gpl.html)
    Document   : mindmap2html.xsl
    Created on : 01 February 2004, 17:17
    Author     : joerg feuerhake joerg.feuerhake@free-penguin.org
    Description: transforms freemind mm format to html, handles crossrefs font declarations
                    and colors. feel free to customize it while leaving the ancient authors
                    mentioned. thank you
    ChangeLog:
    
    See: http://freemind.sourceforge.net/
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html"  indent="no" encoding="utf-8" />
<!-- fc, 20.10.2004: The following parameter is set by freemind. -->
<xsl:param name="document_root"></xsl:param>
<xsl:param name="freemind_src"></xsl:param>
<xsl:param name="freemind_dir_css">/includes/css/</xsl:param>
<xsl:param name="freemind_dir_js">/includes/js/</xsl:param>
<xsl:param name="freemind_dir_img">/includes/images/freemind/</xsl:param>
<xsl:param name="freemind_dir_flash">/includes/mmflash/</xsl:param>

    <xsl:template match="/">
    <xsl:variable name="mapversion" select="map/@version"/>---
layout: master
title: WorldHello Document
stylesheets: ["<xsl:value-of select="$document_root" />/includes/css/docbook.css"]
---

<h1><xsl:call-template name="output-title" /></h1>

<p>
<xsl:apply-templates/>
</p>
  <p class="info">
<xsl:value-of select="map/node/@TEXT"/>//mm2html.xsl FreemindVersion:<xsl:value-of select="$mapversion"/>
&#xA;
</p>

    </xsl:template>

<xsl:template match="node">

<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
<xsl:variable name="nodetext" select="@TEXT"/>
<xsl:variable name="thisid" select="@ID"/>
<xsl:variable name="thiscolor" select="@COLOR"/>
<xsl:variable name="fontface" select="font/@NAME"/>
<xsl:variable name="fontbold" select="font/@BOLD"/>
<xsl:variable name="fontitalic" select="font/@ITALIC"/>
<xsl:variable name="fontsize" select="font/@SIZE"/>
<xsl:variable name="target" select="arrowlink/@DESTINATION"/>

    <ul>&#xA;
        <li>&#xA;

        <xsl:if test="@ID != ''">
            <a>
            <xsl:attribute name="name">
            	<xsl:value-of select="$thisid"/>
            </xsl:attribute>
            </a>&#xA;
        </xsl:if>

        <xsl:if test="arrowlink/@DESTINATION != ''">
            <a >
            <xsl:attribute name="style">
                <xsl:if test="$thiscolor != ''">
                 <xsl:text>color:</xsl:text><xsl:value-of select="$thiscolor"/><xsl:text>;</xsl:text>
                </xsl:if>
                <xsl:if test="$fontface != ''">
                 <xsl:text>font-family:</xsl:text><xsl:value-of select="translate($fontface,$ucletters,$lcletters)"/><xsl:text>;</xsl:text>
                </xsl:if>
                <xsl:if test="$fontsize != ''">
                <xsl:text>font-size:</xsl:text><xsl:value-of select="$fontsize"/><xsl:text>;</xsl:text>
               </xsl:if> 
               <xsl:if test="$fontbold = 'true'">
                    <xsl:text>font-weight:bold;</xsl:text>
                </xsl:if>
                <xsl:if test="$fontitalic = 'true'">
                    <xsl:text>font-style:italic;</xsl:text>
                </xsl:if>
                </xsl:attribute>

            <xsl:attribute name="href">
        	<xsl:text>#</xsl:text><xsl:value-of select="$target"/>
            </xsl:attribute>
            
            <xsl:value-of select="$nodetext"/>
            </a>&#xA;
        </xsl:if>

        <xsl:if test="not(arrowlink/@DESTINATION)">
            
         <span>
           
                <xsl:attribute name="style">
                <xsl:if test="$thiscolor != ''">
                    <xsl:text>color:</xsl:text><xsl:value-of select="$thiscolor"/><xsl:text>;</xsl:text>
                </xsl:if>
                <xsl:if test="$fontface != ''">
                    <xsl:text>font-family:</xsl:text><xsl:value-of select="translate($fontface,$ucletters,$lcletters)"/><xsl:text>;</xsl:text>
                </xsl:if>
                <xsl:if test="$fontsize != ''">
                    <xsl:text>font-size:</xsl:text><xsl:value-of select="$fontsize"/><xsl:text>;</xsl:text>
               </xsl:if> 
               <xsl:if test="$fontbold = 'true'">
                    <xsl:text>font-weight:bold;</xsl:text>
                </xsl:if>
                <xsl:if test="$fontitalic = 'true'">
                    <xsl:text>font-style:italic;</xsl:text>
                </xsl:if>
                </xsl:attribute>
                <xsl:value-of select="$nodetext"/>&#xA;
            </span>&#xA;
        </xsl:if>


        <xsl:apply-templates/>
        </li>&#xA;
    </ul>&#xA;
</xsl:template>

<xsl:template name="output-title">
	<!-- look if there is any node inside the map (there should never be
		none, but who knows?) and take its text as the title -->
	<xsl:choose>
	<xsl:when test="/map/node/@TEXT">
		<xsl:value-of select="/map/node/@TEXT" />
	</xsl:when>
	<xsl:when test="/map/node/richcontent[@TYPE='NODE']">
		<xsl:apply-templates select="/map/node/richcontent[@TYPE='NODE']/html/body" mode="strip-tags" />
	</xsl:when>
	<xsl:otherwise>
		<xsl:text>FreeMind2HTML Mindmap</xsl:text>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet> 
