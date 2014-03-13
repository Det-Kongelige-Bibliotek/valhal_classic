<?xml version="1.0" encoding="UTF-8" ?>

<xsl:transform version="1.0"
	       xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	       xmlns:marc="http://www.loc.gov/MARC21/slim" 
	       xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:param name="pdfUri"  select="'http://example.com/mock-file.pdf'" />

  <xsl:output method="xml"
	      indent="yes"
	      encoding="UTF-8" />

  <xsl:template match="/">
    <marc:record>
      <xsl:apply-templates/>

      <xsl:element name="marc:datafield">
	<xsl:attribute name="ind1">#</xsl:attribute>
	<xsl:attribute name="ind2">1</xsl:attribute>
	<xsl:attribute name="tag">856</xsl:attribute>
	<xsl:element name="marc:subfield">
	  <xsl:attribute name="code">u</xsl:attribute>
	  <xsl:value-of select="$pdfUri"/>
	</xsl:element>
      </xsl:element>
    </marc:record>
  </xsl:template>
  
  <xsl:template match="present">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="record">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="oai_marc">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="varfield[@id='096']">

    <xsl:element name="marc:datafield">
      <xsl:attribute name="ind1">
	<xsl:value-of select="@i1"/>
      </xsl:attribute>
      <xsl:attribute name="ind2">
	<xsl:value-of select="@i1"/>
      </xsl:attribute>
      <xsl:attribute name="tag">852</xsl:attribute>
      <xsl:element name="marc:subfield">
	<xsl:attribute name="code">a</xsl:attribute>
	<xsl:value-of select="subfield[@label='a']"/>
      </xsl:element>
    </xsl:element>

  </xsl:template>

  <xsl:template match="varfield[@id='100']">

    <xsl:element name="marc:datafield">

      <xsl:attribute name="ind1">
	<xsl:value-of select="@i1"/>
      </xsl:attribute>
      <xsl:attribute name="ind2">
	<xsl:value-of select="@i1"/>
      </xsl:attribute>
      <xsl:attribute name="tag">
	<xsl:value-of select="@id"/>
      </xsl:attribute>
      
      <xsl:if test="subfield[@label = 'a']">
	<xsl:element name="marc:subfield">
	  <xsl:attribute name="code">a</xsl:attribute>
	  <xsl:for-each select="subfield[@label = 'a'] | subfield[@label = 'h']">
	    <xsl:if test="position() &gt; 1"><xsl:text>, </xsl:text></xsl:if><xsl:apply-templates/>
	  </xsl:for-each>
	</xsl:element>
      </xsl:if>

      <xsl:if test="subfield[@label='k']">  
	<xsl:element name="marc:subfield">
	  <xsl:attribute name="code">q</xsl:attribute>
	  <xsl:for-each select="subfield[@label = 'a'] | subfield[@label = 'k']">
	    <xsl:if test="position() &gt; 1"><xsl:text>, </xsl:text></xsl:if><xsl:apply-templates/>
	  </xsl:for-each>
	</xsl:element>
      </xsl:if>
      
    </xsl:element>

  </xsl:template>


  <xsl:template match="varfield[@id='245']">

    <xsl:variable name="ind2">
      <xsl:choose>
	<xsl:when test="starts-with(subfield[@label = 'a'],'&lt;&lt;') and 
			not(contains(substring-before(subfield[@label = 'a'],'&gt;&gt;'),'='))">
	  <xsl:value-of 
	      select="string-length(substring-after(substring-before(subfield[@label = 'a'][1],'&gt;&gt;'),'&lt;&lt;'))"/>
	</xsl:when>
	<xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="subfieldA">
      <xsl:choose>
	<xsl:when test="$ind2 &gt; 0">
	  <xsl:value-of 
	      select="substring-after(substring-before(subfield[@label = 'a'][1],'&gt;&gt;'),'&lt;&lt;')"/>
	  <xsl:text> </xsl:text>
	  <xsl:value-of 
	      select="substring-after(subfield[@label = 'a'][1],'&gt;&gt;')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="subfield[@label = 'a'][1]"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:element name="marc:datafield">
      <xsl:attribute name="ind1">
	<xsl:value-of select="@i1"/>
      </xsl:attribute>
      <xsl:attribute name="ind2">
	<xsl:value-of select="$ind2"/>
      </xsl:attribute>
      <xsl:attribute name="tag">
	<xsl:value-of select="@id"/>
      </xsl:attribute>

      <xsl:element name="marc:subfield">
	<xsl:attribute name="code">a</xsl:attribute>
	<xsl:value-of select="$subfieldA"/> 
	<xsl:if test="subfield[@label = 'b']">
	  <xsl:text> </xsl:text><xsl:apply-templates select="subfield[@label = 'b']"/>
	</xsl:if>
      </xsl:element>

      <xsl:element name="marc:subfield">
	<xsl:attribute name="code">b</xsl:attribute>

	<xsl:for-each select="subfield[@label = 'a'][position() &gt; 1]">
	  <xsl:text>; </xsl:text><xsl:value-of select="."/>
	</xsl:for-each>

	<xsl:for-each select="subfield[@label = 'c'] | subfield[@label = 'u']">
	  <xsl:text>: </xsl:text><xsl:value-of select="."/>
	  <xsl:if test="following-sibling::subfield[@label = 'p']">
	    <xsl:text>=</xsl:text><xsl:value-of select="following-sibling::subfield[@label = 'p']"/>
	  </xsl:if>
	</xsl:for-each>
      </xsl:element>

      <xsl:element name="marc:subfield">
	<xsl:attribute name="code">c</xsl:attribute>

	<xsl:for-each select="subfield[@label = 'e'] | 
			      subfield[@label = 'f'] |
			      subfield[@label = 'i'] |
			      subfield[@label = 'j'] |
			      subfield[@label = 'æ'] |
			      subfield[@label = 't']">

	  <xsl:choose>
	    <xsl:when test="contains('efij',@label)"><xsl:text>/ </xsl:text><xsl:value-of select="."/></xsl:when>
	    <xsl:otherwise><xsl:text>=</xsl:text><xsl:value-of select="."/></xsl:otherwise>
	  </xsl:choose>
	</xsl:for-each>
      </xsl:element>

    </xsl:element>
  </xsl:template>


  <xsl:template match="varfield[@id='260']">
    <xsl:element name="marc:datafield">
      <xsl:attribute name="ind1">
	<xsl:value-of select="@i1"/>
      </xsl:attribute>
      <xsl:attribute name="ind2">
	<xsl:value-of select="@i1"/>
      </xsl:attribute>
      <xsl:attribute name="tag">
	<xsl:value-of select="@id"/>
      </xsl:attribute>

      <xsl:if test="subfield[@label='a']">
	<xsl:for-each select="subfield[@label='a']">
	  <xsl:element name="marc:subfield">
	    <xsl:attribute name="code">a</xsl:attribute>
	    <xsl:if test="position() &gt; 1"><xsl:text>; </xsl:text></xsl:if>
	    <xsl:value-of select="translate(.,'[].:;','')"/>
	  </xsl:element>
	</xsl:for-each>
      </xsl:if>


      <xsl:for-each select="subfield[@label='b'] |
	                    subfield[@label='c'] |
	                    subfield[@label='f'] |
	                    subfield[@label='g']">
	<xsl:element name="marc:subfield">
	  <xsl:attribute name="code">
	    <xsl:choose>
	      <xsl:when test="@label='b'">b</xsl:when>
	      <xsl:when test="@label='c'">c</xsl:when>
	      <xsl:when test="@label='f'">a</xsl:when>
	      <xsl:when test="@label='g'">b</xsl:when>
	    </xsl:choose>
	  </xsl:attribute>
	  <xsl:if test="position()&gt;1">
	    <xsl:choose>
	      <xsl:when test="contains('bg',@label)"><xsl:text>: </xsl:text></xsl:when>
	      <xsl:when test="@label = 'c'">,</xsl:when>
	      <xsl:when test="@label = 'g'"><xsl:text>; </xsl:text></xsl:when>
	    </xsl:choose>
	  </xsl:if><xsl:value-of select="."/>
	</xsl:element>
      </xsl:for-each>

      <xsl:for-each select="subfield[@label='r'] |
	                    subfield[@label='t'] |
	                    subfield[@label='j']">
	<xsl:element name="marc:subfield">
	  <xsl:attribute name="code">
	    <xsl:choose>
	      <xsl:when test="@label='r'">e</xsl:when>
	      <xsl:when test="@label='t'">f</xsl:when>
	      <xsl:when test="@label='j'">g</xsl:when>
	    </xsl:choose>
	  </xsl:attribute>
	  <xsl:if test="position()=1">(</xsl:if>
	  <xsl:if test="@label='t' and position()=2"> :</xsl:if>
	  <xsl:if test="@label='g' and position()&gt;=2">,</xsl:if>
	  <xsl:value-of select="."/>
	  <xsl:if test="position()=last()">)</xsl:if>
	</xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>



  <xsl:template match="varfield">
    <xsl:element name="marc:datafield">
      <xsl:attribute name="ind1">
	<xsl:value-of select="@i1"/>
      </xsl:attribute>
      <xsl:attribute name="ind2">
	<xsl:value-of select="@i1"/>
      </xsl:attribute>
      <xsl:attribute name="tag">
	<xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="subfield">
    <xsl:element name="marc:subfield">
      <xsl:attribute name="code">
	<xsl:value-of select="@label"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="session-id"/>

</xsl:transform>
