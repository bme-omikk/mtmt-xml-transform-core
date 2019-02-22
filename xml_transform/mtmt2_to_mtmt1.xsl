<?xml version="1.0" encoding='UTF-8' standalone='yes'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- for XSLT 1.0 lowercase transformation using fn:translate -->
  <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyzáéíóöőúüű'" />
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÉÍÓÖŐÚÜŰ'" />

  <xsl:param name="source_name" />

  <xsl:template match="/">
    <xsl:variable name="technical_lang" select="(myciteResult|myciteResultList)/labelLang" />

    <records xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="mycite.xsd">
      <xsd_version>2.4.</xsd_version>
      <xsl:for-each select="(myciteResult|myciteResultList)/content/publication">
        <record>
          <technical_data>
            <filesource>
              <xsl:attribute name="identifier">
                <xsl:value-of select="./mtid"/>
              </xsl:attribute>
              <xsl:attribute name="name">
                <xsl:value-of select="$source_name" />
              </xsl:attribute>
              <xsl:attribute name="status">
                <xsl:call-template name="process-status" />
              </xsl:attribute>
              <!--<xsl:attribute name="accepted-by"> </xsl:attribute> TODO -->
              <!-- <xsl:attribute name="acceptance-date">1970-01-01</xsl:attribute> TODO -->
              <!-- <xsl:attribute name="error"></xsl:attribute> TODO -->
            </filesource>
            <language>
              <xsl:choose>
                <xsl:when test="$technical_lang = 'hun'">magyar</xsl:when>
                <!-- TODO: other cases -->
                <xsl:otherwise><xsl:value-of select="$technical_lang"/></xsl:otherwise>
              </xsl:choose>
            </language>
            <owner>
              <xsl:apply-templates select="creator" />
            </owner>
            <source identifier="" name="" date="1970-01-01"  time="00:00:00" year="2010" /><!-- TODO -->
            <xsl:call-template name="edited" />
            <xsl:if test="./adminApproved">
              <admin_seen>
                <xsl:attribute name="timestamp">
                  <xsl:value-of select="substring-before(./adminApproved, '.000')" />
                </xsl:attribute>
                <name>
                  <xsl:attribute name="first">
                    <xsl:value-of select="./adminApprover/familyName" />
                  </xsl:attribute>
                  <xsl:attribute name="last">
                    <xsl:value-of select="./adminApprover/givenName" />
                  </xsl:attribute>
                  <xsl:attribute name="suffix">
                    <!-- TODO -->
                  </xsl:attribute>
                </name>
                <identifiers>
                  <identifier><xsl:value-of select="./adminApprover/mtid" /></identifier>
                </identifiers>
                <institutes><!-- TODO --></institutes>
              </admin_seen>
            </xsl:if>
          </technical_data>
          <publication>

            <!-- process basic document metadata -->
            <xsl:apply-templates select="." />

            <container>
              <xsl:apply-templates select="book|journal" />
            </container>
            <!-- TODO -->
          </publication>
          <citations>
            <xsl:apply-templates select="citations/citation" />
          </citations>
        </record>
      </xsl:for-each>
    </records>
  </xsl:template>

  <xsl:template match="identifier">
    <identifier>
      <xsl:attribute name="name"><xsl:value-of select="./source/name" /></xsl:attribute>
      <xsl:attribute name="identifier"><xsl:value-of select="./idValue" /></xsl:attribute>
    </identifier>
  </xsl:template>

  <!-- process basic document metadata -->
  <xsl:template match="citation/related|publication|publication/book">
    <authors>
      <xsl:for-each select="authorships/authorship[./type/otype='AuthorshipType' and ./type/mtid='1']"> <!-- AuthorshipType/mtid=1 is author -->
        <author>
          <xsl:apply-templates select="./author" />
        </author>
      </xsl:for-each>
    </authors>
    <editors>
      <xsl:for-each select="authorships/authorship[./type/otype='AuthorshipType' and ./type/mtid='2']"> <!-- AuthorshipType/mtid=2 is editor -->
        <editor>
          <xsl:choose>
            <xsl:when test="./author">
              <xsl:apply-templates select="./author" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="." />
            </xsl:otherwise>
          </xsl:choose>
        </editor>
      </xsl:for-each>
    </editors>

    <xsl:copy-of select="title" />
    <xsl:if test="subTitle">
      <subtitle><xsl:value-of select="subTitle" /></subtitle>
    </xsl:if>
    <xsl:if test="./volumeNumber">
      <volume>
        <xsl:value-of select="./volumeNumber" />
      </volume>
    </xsl:if>
    <xsl:apply-templates select="publishedYear" />
    <identifiers>
      <xsl:apply-templates select="identifiers/identifier" />
    </identifiers>

    <xsl:apply-templates select="languages" />
    <xsl:apply-templates select="publishers/publisher" />
    <xsl:apply-templates select="publishedAt" />
    <xsl:call-template name="process-classifications" />
    <length>
      <entry>
        <xsl:attribute name="page_number">
          <xsl:value-of select="./pageLength" />
        </xsl:attribute>
      </entry>
    </length>

    <!-- TODO -->
  </xsl:template>

  <xsl:template match="journal">
    <!-- weak TODO: journal title -->
    <peerreviewed>
      <xsl:choose>
        <xsl:when test="reviewType = 'REVIEWED'">true</xsl:when>
        <xsl:when test="reviewType = 'UNKNOWN'">not given</xsl:when>
        <!-- TODO: other cases -->
      </xsl:choose>
    </peerreviewed>
    <published_abroad>
      <xsl:choose>
        <xsl:when test="hungarian = 'false'">true</xsl:when>
        <xsl:when test="hungarian = 'true'">false</xsl:when>
        <xsl:otherwise>not given</xsl:otherwise>
      </xsl:choose>
    </published_abroad>
    <!-- TODO: process Impact Factor (noIF tag) -->
    <identifiers>
      <xsl:if test="pIssn">
        <identifier type="issn"><xsl:value-of select="pIssn" /></identifier>
      </xsl:if>
      <xsl:if test="eIssn">
        <identifier type="eissn"><xsl:value-of select="eIssn" /></identifier>
      </xsl:if>
    </identifiers>
  </xsl:template>

  <xsl:template match="citation">
    <citation>
      <xsl:attribute name="status">
        <xsl:call-template name="process-status" />
      </xsl:attribute>
      <source>
        <xsl:if test="source">
          <xsl:attribute name="name"><xsl:value-of select="source" /></xsl:attribute>
        </xsl:if>
        <xsl:attribute name="year">
          <xsl:value-of select="substring-before(./created, '-')" />
        </xsl:attribute>
      </source>

      <!-- process basic document metadata -->
      <xsl:apply-templates select="related" />
      <owner>
        <xsl:apply-templates select="adminApprover" />
      </owner>

      <xsl:call-template name="edited" />

      <independent>
        <xsl:if test="externalCitationOK">
          <xsl:attribute name="independent-ok"><xsl:value-of select="externalCitationOK" /></xsl:attribute>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="externalCitation">
            <xsl:value-of select="externalCitation" />
          </xsl:when>
          <xsl:otherwise>not given</xsl:otherwise>
        </xsl:choose>
      </independent>
      <!-- TODO -->
    </citation>
  </xsl:template>

  <xsl:template match="publishedYear">
    <date year="{.}" />
  </xsl:template>

  <xsl:template match="languages">
    <!-- MTMT1 XML has a single language element with a (mostly comma-)separated values list -->
    <xsl:if test="./language">
      <language>
        <xsl:for-each select="language">
          <xsl:choose>
            <xsl:when test="position() = 1">
              <xsl:value-of select="name" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(', ', name)" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </language>
    </xsl:if>
  </xsl:template>

  <xsl:template name="process-status">
    <xsl:choose>
      <xsl:when test="./status = 'APPROVED'">jóváhagyva</xsl:when><!-- publication/technical-data -->
      <xsl:when test="./status = 'VALIDATED'">érvényesítve</xsl:when><!-- publication/technical-data -->
      <xsl:when test="./status = 'ADMIN_APPROVED'">jóváhagyva</xsl:when><!-- citation -->
      <!-- TODO: other cases -->
      <xsl:otherwise><xsl:value-of select="./status"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="process-classifications">
    <classifications>
      <classification>
        <xsl:apply-templates select="type|subType|category" />
      </classification>
    </classifications>
  </xsl:template>

  <xsl:template match="publication/type|citation/related/type|publication/book/type">
    <type identifier="{mtid}"><xsl:value-of select="translate(label, $uppercase, $lowercase)" /></type>
  </xsl:template>
  <!-- we intentionally use name here as the label has also type information, which is poisonous for us -->
  <xsl:template match="publication/subType|citation/related/subType|publication/book/subType">
    <subtype identifier="{mtid}"><xsl:value-of select="translate(name, $uppercase, $lowercase)" /></subtype>
  </xsl:template>
  <xsl:template match="publication/category|citation/related/category|publication/book/category">
    <character identifier="{mtid}"><xsl:value-of select="translate(label, $uppercase, $lowercase)" /></character>
  </xsl:template>

  <xsl:template name="process-name-w-share">
    <xsl:param name="share" />
    <name first="{./givenName}" last="{./familyName}">
      <xsl:if test="$share">
        <xsl:attribute name="share">
          <xsl:value-of select="$share" />
        </xsl:attribute>
      </xsl:if>
      <xsl:value-of select="./label" />
    </name>
  </xsl:template>

  <!-- used for identified authorships/admins etc -->
  <xsl:template match="creator|author|adminApprover">
    <xsl:call-template name="process-name-w-share">
      <xsl:with-param name="share" select="../share" />
    </xsl:call-template>

    <identifiers>
      <identifier type="{$source_name}"><xsl:value-of select="./mtid" /></identifier>
      <xsl:apply-templates select="./identifiers/identifier" />
    </identifiers>
    <institutes>
      <xsl:apply-templates select="./affiliations/affiliation" />
    </institutes>
  </xsl:template>
  <!-- used for unidentified authorships -->
  <xsl:template match="authorship">
    <xsl:call-template name="process-name-w-share">
      <xsl:with-param name="share" select="./share" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="publisher">
    <publisher country="{.//partOf/label[../otype = 'Country']}" city="{./cities/city/name}" publisher-country="{//partOf/label[../otype = 'Country']}">
      <xsl:value-of select="./name" />
    </publisher>
  </xsl:template>

  <xsl:template match="publishedAt">
    <published country="{.//partOf/label[../otype = 'Country']}" city="{substring-before(//city/label[../otype = 'City'], ',')}" />
  </xsl:template>

  <xsl:template name="edited">
    <edited>
      <entry event="created">
        <xsl:attribute name="date">
          <xsl:value-of select="substring-before(./created, 'T')"/>
        </xsl:attribute>
        <xsl:attribute name="time">
          <xsl:value-of select="substring-after(substring-before(./created, '.'), 'T')"/>
        </xsl:attribute>
      </entry>
      <entry event="last-modified">
        <xsl:attribute name="date">
          <xsl:value-of select="substring-before(./lastModified, 'T')"/>
        </xsl:attribute>
        <xsl:attribute name="time">
          <xsl:value-of select="substring-after(substring-before(./lastModified, '.'), 'T')"/>
        </xsl:attribute>
      </entry>
    </edited>
  </xsl:template>

  <xsl:template match="affiliation">
    <institute identifier="{./worksFor/mtid}">
      <xsl:value-of select="./worksFor/name" />
    </institute>
  </xsl:template>

</xsl:stylesheet>
