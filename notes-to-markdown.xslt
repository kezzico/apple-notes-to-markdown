<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="html">
    <xsl:output method="text" encoding="UTF-8" />
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:text>---</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="//table" />
        <xsl:text>---</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <!-- ignore object tags to hide tables from content -->
    <xsl:template match="object">
    </xsl:template>
    
    <xsl:template match="table">
        <xsl:for-each select="tbody/tr">
            <xsl:variable name="key" select="normalize-space(td[1]/div)" />
            <xsl:variable name="value" select="normalize-space(td[2]/div)" />
            <xsl:if test="$key and $value">
                <xsl:value-of select="concat($key, ': &quot;', $value, '&quot;')" />
                <xsl:text>&#10;</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

  <xsl:template match="div/text()">
    <xsl:value-of select="normalize-space(.)" />
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="div[tt]">
    <xsl:if test="position() = 1 or not(preceding-sibling::div[tt])">
      <xsl:text>```&#10;</xsl:text>
    </xsl:if>

    <xsl:value-of select="." />    
    <xsl:text>&#10;</xsl:text>
    
    <xsl:if test="position() = last() or not(following-sibling::div[tt])">
      <xsl:text>```&#10;&#10;</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- HEADINGS -->
  <xsl:template match="h1">
      <xsl:text># </xsl:text><xsl:value-of select="."/><xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="h2">
      <xsl:text>## </xsl:text><xsl:value-of select="."/><xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="h3">
      <xsl:text>### </xsl:text><xsl:value-of select="."/><xsl:text>&#10;</xsl:text>
  </xsl:template>
  
  <!-- NEW LINE -->
  <xsl:template match="br">
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

    <!-- List templates -->
    <xsl:template match="ul">
        <xsl:apply-templates select="li"/>
    </xsl:template>

    <xsl:template match="li">
        <xsl:text>- </xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>&#10;</xsl:text>
    </xsl:template>

    <xsl:template match="ol/li">
        <xsl:number format="1. "/><xsl:value-of select="normalize-space(.)"/><xsl:text>&#10;</xsl:text>
    </xsl:template>

    <!-- Link and Image templates -->
    <xsl:template match="a">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>](</xsl:text>
        <xsl:value-of select="@href"/><xsl:text>)
        </xsl:text>
    </xsl:template>
</xsl:stylesheet>
