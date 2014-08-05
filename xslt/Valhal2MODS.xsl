<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xmlns:mods="http://www.loc.gov/mods/v3">

  <xsl:output encoding="UTF-8" method="xml" indent="yes" />

  <xsl:template match="metadata">
    <xsl:call-template name="mods_generator" />
  </xsl:template>

  <xsl:template name="mods_generator">
    <mods:mods version="3.5" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
      <!-- Adding genre[@type='work_type'] of type 'work_type' -->
      <xsl:for-each select="fields/workType">
        <xsl:element name="mods:genre">
          <xsl:attribute name="type">
            <xsl:value-of select="'work_type'" />
          </xsl:attribute>
          <xsl:value-of select="." />
        </xsl:element>
      </xsl:for-each>

      <!-- Adding genre from field 'genre' -->
      <xsl:for-each select="fields/genre">
        <xsl:element name="mods:genre">
          <xsl:value-of select="." />
        </xsl:element>
      </xsl:for-each>

      <!-- Adding identifier with attribute displayLabel from identifier objects -->
      <xsl:for-each select="fields/identifier">
        <xsl:element name="mods:identifier">
          <xsl:if test="displayLabel">
            <xsl:attribute name="displayLabel">
              <xsl:value-of select="displayLabel" />
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="value" />
        </xsl:element>
      </xsl:for-each>

      <!-- Adding language with attribute authority from language objects -->
      <xsl:if test="fields/language">
        <xsl:element name="mods:language">
          <xsl:for-each select="fields/language">
            <xsl:element name="mods:languageTerm">
              <xsl:if test="authority">
                <xsl:attribute name="authorityURI">
                  <xsl:value-of select="authority" />
                </xsl:attribute>
              </xsl:if>
              <xsl:value-of select="value" />
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:if>

      <!-- Adding shelfLocator from field 'shelfLocator' -->
      <xsl:for-each select="fields/shelfLocator">
        <xsl:element name="mods:location">
          <xsl:element name="mods:shelfLocator">
            <xsl:value-of select="." />
          </xsl:element>
        </xsl:element>
      </xsl:for-each>

      <!-- Adding addressee relations for both agent/person and agent/organization -->
      <!-- TODO handle multiple references (currently only handling one reference) -->
      <xsl:for-each select="hasAddressee">
        <xsl:element name="mods:name">
          <xsl:attribute name="type">
            <xsl:choose>
              <xsl:when test="type='agent/person'">
                <xsl:value-of select="'personal'" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'corporate'" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="reference">
            <xsl:attribute name="authorityURI">
              <xsl:value-of select="reference" />
            </xsl:attribute>
          </xsl:if>
          <xsl:element name="mods:namePart">
            <xsl:value-of select="value" />
          </xsl:element>
          <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
              <xsl:attribute name="authorityURI">
                <xsl:value-of select="'http://id.loc.gov/vocabulary/relators/rcp.html'" />
              </xsl:attribute>
              <xsl:value-of select="'Addressee'" />
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>

      <!-- Adding author relations for both agent/person and agent/organization -->
      <!-- TODO handle multiple references (currently only handling one reference) -->
      <xsl:for-each select="hasAuthor">
        <xsl:element name="mods:name">
          <xsl:attribute name="type">
            <xsl:choose>
              <xsl:when test="type='agent/person'">
                <xsl:value-of select="'personal'" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'corporate'" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="reference">
            <xsl:attribute name="authorityURI">
              <xsl:value-of select="reference" />
            </xsl:attribute>
          </xsl:if>
          <xsl:element name="mods:namePart">
            <xsl:value-of select="value" />
          </xsl:element>
          <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
              <xsl:attribute name="authorityURI">
                <xsl:value-of select="'http://id.loc.gov/vocabulary/relators/aut.html'" />
              </xsl:attribute>
              <xsl:value-of select="'Author'" />
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>

      <!-- Adding contributor relations for both agent/person and agent/organization -->
      <!-- TODO handle multiple references (currently only handling one reference) -->
      <xsl:for-each select="hasContributor">
        <xsl:element name="mods:name">
          <xsl:attribute name="type">
            <xsl:choose>
              <xsl:when test="type='agent/person'">
                <xsl:value-of select="'personal'" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'corporate'" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="reference">
            <xsl:attribute name="authorityURI">
              <xsl:value-of select="reference" />
            </xsl:attribute>
          </xsl:if>
          <xsl:element name="mods:namePart">
            <xsl:value-of select="value" />
          </xsl:element>
          <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
              <xsl:attribute name="authorityURI">
                <xsl:value-of select="'http://id.loc.gov/vocabulary/relators/ctb.html'" />
              </xsl:attribute>
              <xsl:value-of select="'Contributor'" />
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>

      <!-- Adding creator relations for both agent/person and agent/organization -->
      <!-- TODO handle multiple references (currently only handling one reference) -->
      <xsl:for-each select="hasCreator">
        <xsl:element name="mods:name">
          <xsl:attribute name="type">
            <xsl:choose>
              <xsl:when test="type='agent/person'">
                <xsl:value-of select="'personal'" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'corporate'" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="reference">
            <xsl:attribute name="authorityURI">
              <xsl:value-of select="reference" />
            </xsl:attribute>
          </xsl:if>
          <xsl:element name="mods:namePart">
            <xsl:value-of select="value" />
          </xsl:element>
          <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
              <xsl:attribute name="authorityURI">
                <xsl:value-of select="'http://id.loc.gov/vocabulary/relators/cre.html'" />
              </xsl:attribute>
              <xsl:value-of select="'Creator'" />
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>

      <!-- Adding owner relations for both agent/person and agent/organization -->
      <!-- TODO handle multiple references (currently only handling one reference) -->
      <xsl:for-each select="hasOwner">
        <xsl:element name="mods:name">
          <xsl:attribute name="type">
            <xsl:choose>
              <xsl:when test="type='agent/person'">
                <xsl:value-of select="'personal'" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'corporate'" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="reference">
            <xsl:attribute name="authorityURI">
              <xsl:value-of select="reference" />
            </xsl:attribute>
          </xsl:if>
          <xsl:element name="mods:namePart">
            <xsl:value-of select="value" />
          </xsl:element>
          <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
              <xsl:attribute name="authorityURI">
                <xsl:value-of select="'http://id.loc.gov/vocabulary/relators/own.html'" />
              </xsl:attribute>
              <xsl:value-of select="'Owner'" />
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>

      <!-- Adding patron relations for both agent/person and agent/organization -->
      <!-- TODO handle multiple references (currently only handling one reference) -->
      <xsl:for-each select="hasPatron">
        <xsl:element name="mods:name">
          <xsl:attribute name="type">
            <xsl:choose>
              <xsl:when test="type='agent/person'">
                <xsl:value-of select="'personal'" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'corporate'" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="reference">
            <xsl:attribute name="authorityURI">
              <xsl:value-of select="reference" />
            </xsl:attribute>
          </xsl:if>
          <xsl:element name="mods:namePart">
            <xsl:value-of select="value" />
          </xsl:element>
          <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
              <xsl:attribute name="authorityURI">
                <xsl:value-of select="'http://id.loc.gov/vocabulary/relators/pat.html'" />
              </xsl:attribute>
              <xsl:value-of select="'Patron'" />
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>

      <!-- Adding publisher relations for both agent/person and agent/organization -->
      <!-- TODO handle multiple references (currently only handling one reference) -->
      <xsl:for-each select="hasPublisher">
        <xsl:element name="mods:name">
          <xsl:attribute name="type">
            <xsl:choose>
              <xsl:when test="type='agent/person'">
                <xsl:value-of select="'personal'" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'corporate'" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="reference">
            <xsl:attribute name="authorityURI">
              <xsl:value-of select="reference" />
            </xsl:attribute>
          </xsl:if>
          <xsl:element name="mods:namePart">
            <xsl:value-of select="value" />
          </xsl:element>
          <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
              <xsl:attribute name="authorityURI">
                <xsl:value-of select="'http://id.loc.gov/vocabulary/relators/pbl.html'" />
              </xsl:attribute>
              <xsl:value-of select="'Publisher'" />
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>

      <!-- Adding photographer relations for both agent/person and agent/organization -->
      <!-- TODO handle multiple references (currently only handling one reference) -->
      <xsl:for-each select="hasPhotographer">
        <xsl:element name="mods:name">
          <xsl:attribute name="type">
            <xsl:choose>
              <xsl:when test="type='agent/person'">
                <xsl:value-of select="'personal'" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'corporate'" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="reference">
            <xsl:attribute name="authorityURI">
              <xsl:value-of select="reference" />
            </xsl:attribute>
          </xsl:if>
          <xsl:element name="mods:namePart">
            <xsl:value-of select="value" />
          </xsl:element>
          <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
              <xsl:attribute name="authorityURI">
                <xsl:value-of select="'http://id.loc.gov/vocabulary/relators/pht.html'" />
              </xsl:attribute>
              <xsl:value-of select="'Photographer'" />
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>

      <!-- Adding performer relations for both agent/person and agent/organization -->
      <!-- TODO handle multiple references (currently only handling one reference) -->
      <xsl:for-each select="hasPerformer">
        <xsl:element name="mods:name">
          <xsl:attribute name="type">
            <xsl:choose>
              <xsl:when test="type='agent/person'">
                <xsl:value-of select="'personal'" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'corporate'" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="reference">
            <xsl:attribute name="authorityURI">
              <xsl:value-of select="reference" />
            </xsl:attribute>
          </xsl:if>
          <xsl:element name="mods:namePart">
            <xsl:value-of select="value" />
          </xsl:element>
          <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
              <xsl:attribute name="authorityURI">
                <xsl:value-of select="'http://id.loc.gov/vocabulary/relators/prf.html'" />
              </xsl:attribute>
              <xsl:value-of select="'Performer'" />
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>

      <!-- Adding printer relations for both agent/person and agent/organization -->
      <!-- TODO handle multiple references (currently only handling one reference) -->
      <xsl:for-each select="hasPrinter">
        <xsl:element name="mods:name">
          <xsl:attribute name="type">
            <xsl:choose>
              <xsl:when test="type='agent/person'">
                <xsl:value-of select="'personal'" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'corporate'" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="reference">
            <xsl:attribute name="authorityURI">
              <xsl:value-of select="reference" />
            </xsl:attribute>
          </xsl:if>
          <xsl:element name="mods:namePart">
            <xsl:value-of select="value" />
          </xsl:element>
          <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
              <xsl:attribute name="authorityURI">
                <xsl:value-of select="'http://id.loc.gov/vocabulary/relators/prt.html'" />
              </xsl:attribute>
              <xsl:value-of select="'Printer'" />
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>

      <!-- Adding scribe relations for both agent/person and agent/organization -->
      <!-- TODO handle multiple references (currently only handling one reference) -->
      <xsl:for-each select="hasScribe">
        <xsl:element name="mods:name">
          <xsl:attribute name="type">
            <xsl:choose>
              <xsl:when test="type='agent/person'">
                <xsl:value-of select="'personal'" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'corporate'" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="reference">
            <xsl:attribute name="authorityURI">
              <xsl:value-of select="reference" />
            </xsl:attribute>
          </xsl:if>
          <xsl:element name="mods:namePart">
            <xsl:value-of select="value" />
          </xsl:element>
          <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
              <xsl:attribute name="authorityURI">
                <xsl:value-of select="'http://id.loc.gov/vocabulary/relators/scr.html'" />
              </xsl:attribute>
              <xsl:value-of select="'Scribe'" />
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>

      <!-- Adding translator relations for both agent/person and agent/organization -->
      <!-- TODO handle multiple references (currently only handling one reference) -->
      <xsl:for-each select="hasTranslator">
        <xsl:element name="mods:name">
          <xsl:attribute name="type">
            <xsl:choose>
              <xsl:when test="type='agent/person'">
                <xsl:value-of select="'personal'" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'corporate'" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="reference">
            <xsl:attribute name="authorityURI">
              <xsl:value-of select="reference" />
            </xsl:attribute>
          </xsl:if>
          <xsl:element name="mods:namePart">
            <xsl:value-of select="value" />
          </xsl:element>
          <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
              <xsl:attribute name="authorityURI">
                <xsl:value-of select="'http://id.loc.gov/vocabulary/relators/trl.html'" />
              </xsl:attribute>
              <xsl:value-of select="'Translator'" />
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>

      <!-- Adding digitizer relations for both agent/person and agent/organization -->
      <!-- TODO handle multiple references (currently only handling one reference) -->
      <xsl:for-each select="hasDigitizer">
        <xsl:element name="mods:name">
          <xsl:attribute name="type">
            <xsl:choose>
              <xsl:when test="type='agent/person'">
                <xsl:value-of select="'personal'" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'corporate'" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="reference">
            <xsl:attribute name="authorityURI">
              <xsl:value-of select="reference" />
            </xsl:attribute>
          </xsl:if>
          <xsl:element name="mods:namePart">
            <xsl:value-of select="value" />
          </xsl:element>
          <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
              <xsl:value-of select="'Digitizer'" />
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
      <!-- TODO Add all the other 'name' elements -->

      <!-- Adding note from 'note' element -->
      <xsl:for-each select="fields/note">
        <xsl:element name="mods:note">
          <xsl:if test="displayLabel">
            <xsl:attribute name="displayLabel">
              <xsl:value-of select="displayLabel" />
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="value" />
        </xsl:element>
      </xsl:for-each>

      <!-- Adding originInfo for fields 'dateCreated', 'dateIssued' and 'dateOther' -->
      <xsl:if test="fields/dateCreated or fields/dateIssued or fields/dateOther">
        <xsl:element name="mods:originInfo">
          <xsl:for-each select="fields/dateCreated">
            <xsl:element name="mods:dateCreated">
              <xsl:value-of select="." />
            </xsl:element>
          </xsl:for-each>
          <xsl:for-each select="fields/dateIssued">
            <xsl:element name="mods:dateIssued">
              <xsl:value-of select="." />
            </xsl:element>
          </xsl:for-each>
          <xsl:for-each select="fields/dateOther">
            <xsl:element name="mods:dateOther">
              <xsl:value-of select="." />
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:if>

      <!-- Adding originInfo for place with relation origin -->
      <xsl:if test="hasOrigin/type='place'">
        <xsl:element name="mods:originInfo">
          <xsl:element name="mods:place">
            <xsl:for-each select="hasOrigin[type='place']">
              <xsl:element name="mods:placeTerm">
                <xsl:if test="reference">
                  <xsl:attribute name="authorityURI">
                    <xsl:value-of select="reference" />
                  </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="value" />
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:if>

      <!-- Adding originInfo for agent with relation publisher -->
      <xsl:if test="hasPublisher">
        <xsl:element name="mods:originInfo">
          <xsl:for-each select="hasPublisher">
            <xsl:element name="mods:publisher">
              <xsl:value-of select="value" />
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:if>

      <!-- Adding physicalDescription for field 'physicalDescriptionForm' -->
      <xsl:if test="fields/physicalDescriptionForm">
        <xsl:element name="mods:physicalDescription">
          <xsl:for-each select="fields/physicalDescriptionForm">
            <xsl:element name="mods:form">
              <xsl:value-of select="." />
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:if>

      <!-- Adding physicalDescription for field 'physicalDescriptionNote' -->
      <xsl:if test="fields/physicalDescriptionNote">
        <xsl:element name="mods:physicalDescription">
          <xsl:for-each select="fields/physicalDescriptionNote">
            <xsl:element name="mods:note">
              <xsl:value-of select="." />
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:if>

      <!-- Adding recordInfo for field 'languageOfCataloging' -->
      <xsl:if test="fields/languageOfCataloging">
        <xsl:element name="mods:recordInfo">
          <xsl:for-each select="fields/languageOfCataloging">
            <xsl:element name="mods:languageOfCataloging">
              <xsl:element name="mods:languageTerm">
                <xsl:value-of select="." />
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:if>

      <!-- Adding recordInfo for field 'recordOriginInfo' -->
      <xsl:if test="fields/recordOriginInfo">
        <xsl:element name="mods:recordInfo">
          <xsl:for-each select="fields/recordOriginInfo">
            <xsl:element name="mods:recordOrigin">
              <xsl:value-of select="." />
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:if>
      
      <!-- Adding subject for field 'cartographicsScale' -->
      <xsl:if test="fields/cartographicsScale">
        <xsl:element name="mods:subject">
          <xsl:element name="mods:cartographics">
            <xsl:for-each select="fields/cartographicsScale">
              <xsl:element name="mods:scale">
                <xsl:value-of select="." />
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:if>

      <!-- Adding subject for field 'cartographicsCoordinates' -->
      <xsl:if test="fields/cartographicsCoordinates">
        <xsl:element name="mods:subject">
          <xsl:element name="mods:cartographics">
            <xsl:for-each select="fields/cartographicsCoordinates">
              <xsl:element name="mods:coordinates">
                <xsl:value-of select="." />
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:if>

      <!-- Adding subject for place with relation topic -->
      <xsl:if test="hasTopic/type='place'">
        <xsl:element name="mods:subject">
          <xsl:attribute name="displayLabel">
            <xsl:value-of select="'place'" />
          </xsl:attribute>
          <xsl:for-each select="hasTopic[type='place']">
            <xsl:element name="mods:geographic">
              <xsl:if test="reference">
                <xsl:attribute name="authorityURI">
                  <xsl:value-of select="reference" />
                </xsl:attribute>
              </xsl:if>
              <xsl:value-of select="value" />
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:if>

      <!-- Adding subject for place with topic relations. -->
      <xsl:if test="hasTopic/type='agent/person' or hasTopic/type='agent/organization'">
        <xsl:element name="mods:subject">
          <xsl:for-each select="hasTopic[type='agent/person']">
            <xsl:element name="mods:name">
              <xsl:attribute name="type">
                <xsl:value-of select="'personal'" />
              </xsl:attribute>
              <xsl:if test="reference">
                <xsl:attribute name="authorityURI">
                  <xsl:value-of select="reference" />
                </xsl:attribute>
              </xsl:if>
              <xsl:element name="mods:namePart">
                <xsl:value-of select="value" />
              </xsl:element>
            </xsl:element>
          </xsl:for-each>

          <xsl:for-each select="hasTopic[type='agent/organization']">
            <xsl:element name="mods:name">
              <xsl:attribute name="type">
                <xsl:value-of select="'corporate'" />
              </xsl:attribute>
              <xsl:if test="reference">
                <xsl:attribute name="authorityURI">
                  <xsl:value-of select="reference" />
                </xsl:attribute>
              </xsl:if>
              <xsl:element name="mods:namePart">
                <xsl:value-of select="value" />
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:if>

      <!-- Adding subject for concept with relation topic -->
      <xsl:if test="hasTopic/type='concept'">
        <xsl:element name="mods:subject">
          <xsl:attribute name="displayLabel">
            <xsl:value-of select="'concept'" />
          </xsl:attribute>
          <xsl:for-each select="hasTopic[type='concept']">
            <xsl:element name="mods:topic">
              <xsl:if test="reference">
                <xsl:attribute name="authorityURI">
                  <xsl:value-of select="reference" />
                </xsl:attribute>
              </xsl:if>
              <xsl:value-of select="value" />
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:if>

      <!-- Adding subject for event with relation topic -->
      <xsl:if test="hasTopic/type='event'">
        <xsl:element name="mods:subject">
          <xsl:attribute name="displayLabel">
            <xsl:value-of select="'event'" />
          </xsl:attribute>
          <xsl:for-each select="hasTopic[type='event']">
            <xsl:element name="mods:topic">
              <xsl:if test="reference">
                <xsl:attribute name="authorityURI">
                  <xsl:value-of select="reference" />
                </xsl:attribute>
              </xsl:if>
              <xsl:value-of select="value" />
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:if>

      <!-- Adding subject for physicalThing with relation topic -->
      <xsl:if test="hasTopic/type='physicalThing'">
        <xsl:element name="mods:subject">
          <xsl:attribute name="displayLabel">
            <xsl:value-of select="'physicalThing'" />
          </xsl:attribute>
          <xsl:for-each select="hasTopic[type='physicalThing']">
            <xsl:element name="mods:topic">
              <xsl:if test="reference">
                <xsl:attribute name="authorityURI">
                  <xsl:value-of select="reference" />
                </xsl:attribute>
              </xsl:if>
              <xsl:value-of select="value" />
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:if>

      <!-- Adding subject for field 'topic' -->
      <xsl:if test="fields/topic">
        <xsl:element name="mods:subject">
          <xsl:for-each select="fields/topic">
            <xsl:element name="mods:topic">
              <xsl:value-of select="." />
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:if>

      <xsl:element name="mods:titleInfo">
        <xsl:element name="mods:title">
          <xsl:value-of select="fields/title" />
        </xsl:element>
        <xsl:for-each select="fields/subTitle">
          <xsl:element name="mods:subTitle">
            <xsl:value-of select="." />
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
      
      <xsl:for-each select="fields/alternativeTitle">
        <xsl:element name="mods:titleInfo">
          <xsl:choose>
            <xsl:when test="type='other'">
              <xsl:attribute name="otherType">
                <xsl:value-of select="'other'" />
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="type">
                <xsl:value-of select="type" />
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="lang">
            <xsl:attribute name="lang">
              <xsl:value-of select="lang" />
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="displayLabel">
            <xsl:attribute name="displayLabel">
              <xsl:value-of select="displayLabel" />
            </xsl:attribute>
          </xsl:if>
          <xsl:element name="mods:title">
            <xsl:value-of select="title" />
          </xsl:element>
          <xsl:for-each select="subTitle">
            <xsl:element name="mods:subTitle">
              <xsl:value-of select="." />
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:for-each>
      
      <xsl:if test="fields/typeOfResource">
        <xsl:element name="mods:typeOfResource">
          <xsl:if test="fields/typeOfResourceLabel">
            <xsl:attribute name="displayLabel">
              <xsl:value-of select="fields/typeOfResourceLabel" />
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="fields/typeOfResource" />
        </xsl:element>
      </xsl:if>
      
    </mods:mods>

  </xsl:template>
</xsl:transform> 