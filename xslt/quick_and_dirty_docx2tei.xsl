<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	       xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
	       xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
	       xmlns:o="urn:schemas-microsoft-com:office:office"
	       xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
	       xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
	       xmlns:v="urn:schemas-microsoft-com:vml"
	       xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
	       xmlns:w10="urn:schemas-microsoft-com:office:word"
	       xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
	       xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
	       xmlns:exsl="http://exslt.org/common"
	       xmlns:t="http://www.tei-c.org/ns/1.0"
	       xmlns="http://www.tei-c.org/ns/1.0"
	       exclude-result-prefixes="xsl exsl t pkg ve o r m v wp w10 w wne"
	       version="1.0">
  
  <xsl:output encoding="UTF-8"
	      indent="yes" />

    <!-- ="da-DK" -->

  <xsl:param name="default_lang">
    <xsl:value-of 
	select="pkg:package/pkg:part/pkg:xmlData/w:styles/w:docDefaults/w:rPrDefault/w:rPr/w:lang/@w:val"/>
  </xsl:param>

<!--
   1. Start
   2. Brevskrivningsdato
   3. Afsender
   4. Afsendelsessted
   5. Modtager
   6. Modtagelsessted
   7. Sprog – er angivet i selve softwaren og derfor ikke opmærket på samme
   måde som resten. Kan findes i tagget <w:lang> under attribute
   w:val=””. Følger iso-forkortelser, så vidt jeg kan regne ud.
   8. Proveniens
   9. Note
  10. Slut
-->  

  <xsl:template match="/">

    <!-- We build the tei document in two passes. In the first we collect TEI text
         into a document stored in the rtei (raw tei) variable -->

    <xsl:variable name="rtei">
    <TEI>
      <teiHeader>
	<fileDesc>
	  <titleStmt>
	    <title/>
	  </titleStmt>
	  <publicationStmt>
	    <p/>
	  </publicationStmt>
	  <sourceDesc>
	    <bibl/>
	  </sourceDesc>
	</fileDesc>
      </teiHeader>
      <text>
	<body>
	  <xsl:apply-templates select="pkg:package"/>
	</body>
      </text>
    </TEI>
    </xsl:variable>

    <!-- Here we transform the raw tei -->
    <xsl:choose>
      <xsl:when test="1">
	<xsl:apply-templates  select="exsl:node-set($rtei)/*"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy-of select="$rtei"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


<!-- More or less empty templates for going into the guts of the word document -->

  <xsl:template match="pkg:package">
    <xsl:apply-templates select="pkg:part"/>
  </xsl:template>

  <xsl:template match="pkg:part">
    <xsl:apply-templates select="pkg:xmlData"/>
  </xsl:template>

  <xsl:template match="pkg:xmlData">
    <xsl:apply-templates select="w:document"/>
  </xsl:template>

  <xsl:template match="w:document">
    <xsl:apply-templates select="w:body"/>
  </xsl:template>

  <xsl:template match="w:body">
    <xsl:apply-templates mode="letterstart" select="w:p[w:r/w:rPr/w:rStyle/@w:val='Start']"/>
  </xsl:template>

<!-- These are for the second pass -->

  <xsl:template  match="t:milestone[@type='Brevskrivningsdato']">
    <date>
      <xsl:call-template name="get_span">
	<xsl:with-param name="milestone">Brevskrivningsdato</xsl:with-param>
      </xsl:call-template>
    </date>
  </xsl:template>

  <xsl:template  match="t:milestone[@type='Modtager']">
    <address>
      <name>
	<xsl:call-template name="get_span">
	  <xsl:with-param name="milestone">Modtager</xsl:with-param>
	</xsl:call-template>
      </name>
    </address>
  </xsl:template>

  <xsl:template  match="t:milestone[@type='Modtagelsessted']">
    <placeName type="sender">
      <xsl:call-template name="get_span">
	<xsl:with-param name="milestone">Modtagelsessted</xsl:with-param>
      </xsl:call-template>
    </placeName>
  </xsl:template>

  <xsl:template  match="t:milestone[@type='Afsender']">
    <persName type="sender">
      <xsl:call-template name="get_span">
	<xsl:with-param name="milestone">Afsender</xsl:with-param>
      </xsl:call-template>
    </persName>
  </xsl:template>

  <xsl:template  match="t:milestone[@type='Afsendelsessted']">
    <placeName type="recipient">
      <xsl:call-template name="get_span">
	<xsl:with-param name="milestone">Afsendelsessted</xsl:with-param>
      </xsl:call-template>
    </placeName>
  </xsl:template>

  <xsl:template  match="t:milestone[@type='Note']">
    <note>
      <xsl:call-template name="get_span">
	<xsl:with-param name="milestone">Note</xsl:with-param>
      </xsl:call-template>
    </note>
  </xsl:template>

  <xsl:template  match="t:milestone[@type='Proveniens']">
    <xsl:comment>
      <xsl:call-template name="get_span">
	<xsl:with-param name="milestone">Proveniens</xsl:with-param>
      </xsl:call-template>
    </xsl:comment>
  </xsl:template>

  <!-- Here we have the plain (untyped) text stuff -->

  <xsl:template  match="t:milestone[@type='Text']">
    <xsl:call-template name="get_span">
      <xsl:with-param name="milestone">Text</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- In the second pass we go into the document by going recursively into
       the content following Start milestones -->

  <xsl:template  match="t:body">
    <body>
      <xsl:apply-templates select="t:milestone[@type='Start']"/>
    </body>
  </xsl:template>

  <!-- The material between two Start milestones are aggregated into a div,
       i.e. a letter -->

  <xsl:template match="t:milestone[@type='Start']">
    <xsl:variable name="letter_id">
      <xsl:value-of select="generate-id(.)"/>
    </xsl:variable>
    <xsl:element name="div">
      <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
      <xsl:attribute name="xml:id">div<xsl:value-of select="$letter_id"/></xsl:attribute>
      <xsl:attribute name="xml:lang"><xsl:value-of select="$default_lang"/></xsl:attribute>
      <xsl:apply-templates select="following-sibling::t:p[generate-id(preceding-sibling::t:milestone[1]) = $letter_id]"/>
    </xsl:element>
  </xsl:template>

  <!-- this is a function collecting text in the spans into whatever element
       they belongs to as implied by the milestone -->

  <xsl:template name="get_span">
    <xsl:param name="milestone" select="''"/>
    <xsl:variable name="mid">
      <xsl:value-of select="generate-id(.)"/>
    </xsl:variable>
    <xsl:for-each 
	select="following-sibling::t:span[$mid=generate-id(preceding-sibling::t:milestone[1])]">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="t:p">
    <xsl:if test="t:pb">
      <xsl:element name="pb"/>
    </xsl:if>
    <p>
      <xsl:apply-templates select="t:milestone"/> 
    </p>
  </xsl:template>

  <xsl:template match="t:span">
    <xsl:choose>
      <xsl:when test="@xml:lang">
	<span>
	  <xsl:copy-of select="@xml:lang"/>
	  <xsl:apply-templates/>
	</span>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template  match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates  select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="make_milestones">
    <xsl:variable name="milestone_id" select="generate-id(.)"/>
    <xsl:choose>
      <xsl:when test="w:rPr/w:rStyle/@w:val='Brevskrivningsdato' or
		      w:rPr/w:rStyle/@w:val='Afsender' or
		      w:rPr/w:rStyle/@w:val='Avsendelsessted' or
		      w:rPr/w:rStyle/@w:val='Modtager' or
		      w:rPr/w:rStyle/@w:val='Modtagelsessted' or
		      w:rPr/w:rStyle/@w:val='Proveniens' or
		      w:rPr/w:rStyle/@w:val='Note'">
	<xsl:element name="milestone">
	  <xsl:attribute name="type">
	    <xsl:choose>
	      <xsl:when test="w:rPr/w:rStyle/@w:val='Brevskrivningsdato'">Brevskrivningsdato</xsl:when>
	      <xsl:when test="w:rPr/w:rStyle/@w:val='Afsender'">Afsender</xsl:when>
	      <xsl:when test="w:rPr/w:rStyle/@w:val='Avsendelsessted'">Avsendelsessted</xsl:when>
	      <xsl:when test="w:rPr/w:rStyle/@w:val='Modtager'">Modtager</xsl:when>
	      <xsl:when test="w:rPr/w:rStyle/@w:val='Modtagelsessted'">Modtagelsessted</xsl:when>
	      <xsl:when test="w:rPr/w:rStyle/@w:val='Proveniens'">Proveniens</xsl:when>
	      <xsl:when test="w:rPr/w:rStyle/@w:val='Note'">Note</xsl:when>
	    </xsl:choose>
	  </xsl:attribute>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:if test="w:rPr/w:rStyle/@w:val">
	  <xsl:element name="milestone">
	    <xsl:attribute name="type">Text</xsl:attribute>
	  </xsl:element>
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="letterstart"  match="w:p">
    <xsl:variable name="milestone_id" select="generate-id(.)"/>    
    <milestone type="Start" />
    <xsl:for-each 
	select=".|following-sibling::w:p[generate-id(preceding-sibling::w:p[w:r/w:rPr/w:rStyle/@w:val='Start'][1])=$milestone_id]">
      <xsl:apply-templates mode="raw" select="."/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template mode="raw" match="w:p">
    <p>
      <xsl:apply-templates mode="raw" select="w:r"/>
    </p>
  </xsl:template>

  <xsl:template mode="raw" match="w:r">
    <xsl:if test="w:lastRenderedPageBreak">
      <pb/>
    </xsl:if>
    <xsl:call-template name="make_milestones"/>
    <span>
      <xsl:if test="w:rPr/w:lang/@w:val and not(w:rPr/w:lang/@w:val = $default_lang)">
	<xsl:attribute name="xml:lang"><xsl:value-of select="w:rPr/w:lang/@w:val"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="w:t"/>
    </span>
  </xsl:template>

  <xsl:template match="w:t">
    <xsl:choose>
      <xsl:when test="@xml:space='preserve'">
	<xsl:apply-templates mode="preserve"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="preserve" match="text()">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>


</xsl:transform>

