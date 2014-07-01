<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xmlns:mods="http://www.loc.gov/mods/v3">

  <xsl:output encoding="UTF-8" method="xml" indent="yes" />

  <xsl:template match=".">
    <xsl:call-template name="work_mods_generator" />
  </xsl:template>

  <xsl:template name="work_mods_generator">
    <mods:mods version="3.5" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
      <xsl:for-each select="fields">

      </xsl:for-each>
      <xsl:copy-of select="descMetadata/mods:mods/mods:genre" />
      <xsl:copy-of select="descMetadata/mods:mods/mods:identifier[@type='isbn']" />
      <xsl:copy-of select="descMetadata/mods:mods/mods:locator" />
      <xsl:copy-of select="descMetadata/mods:mods/mods:language" />
      <xsl:copy-of select="descMetadata/mods:mods/mods:originInfo" />
      <xsl:copy-of select="descMetadata/mods:mods/mods:physicalDescription" />
      <xsl:copy-of select="descMetadata/mods:mods/mods:subject" />
      <xsl:copy-of select="descMetadata/mods:mods/mods:titleInfo" />
      <xsl:for-each select="author">
        <xsl:element name="mods:name">
          <xsl:attribute name="valueURI">
            <xsl:value-of select="concat('urn:uuid:', uuid)" />
          </xsl:attribute>
          <xsl:element name="mods:namePart">
            <xsl:value-of select="name" />
          </xsl:element>
          <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
              <xsl:attribute name="type">
                <xsl:value-of select="'text'" />
              </xsl:attribute>
              <xsl:attribute name="authority">
                <xsl:value-of select="'marcrelator'" />
              </xsl:attribute>
              <xsl:value-of select="'author'" />
            </xsl:element>
            <xsl:element name="mods:roleTerm">
              <xsl:attribute name="type">
                <xsl:value-of select="'code'" />
              </xsl:attribute>
              <xsl:attribute name="authority">
                <xsl:value-of select="'marcrelator'" />
              </xsl:attribute>
              <xsl:value-of select="'aut'" />
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
      <xsl:for-each select="related_person">
        <xsl:element name="mods:name">
          <xsl:attribute name="valueURI">
            <xsl:value-of select="concat('urn:uuid:', uuid)" />
          </xsl:attribute>
          <xsl:element name="mods:namePart">
            <xsl:value-of select="name" />
          </xsl:element>
          <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
              <xsl:attribute name="type">
                <xsl:value-of select="'text'" />
              </xsl:attribute>
              <xsl:value-of select="'related person'" />
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </mods:mods>

  </xsl:template>
</xsl:transform> 