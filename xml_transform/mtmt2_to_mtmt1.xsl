<?xml version="1.0" encoding='UTF-8' standalone='yes'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
                <xsl:choose>
                  <xsl:when test="status = 'APPROVED'">jóváhagyva</xsl:when>
                  <!-- TODO: other cases -->
                  <xsl:otherwise><xsl:value-of select="./status"/></xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="accepted-by"><!-- TODO --></xsl:attribute>
              <xsl:attribute name="acceptance-date">1970-01-01<!-- TODO --></xsl:attribute>
              <xsl:attribute name="error"><!-- TODO --></xsl:attribute>
            </filesource>
            <language>
              <xsl:choose>
                <xsl:when test="technical_lang = 'hun'">magyar</xsl:when>
                <!-- TODO: other cases -->
                <xsl:otherwise><xsl:value-of select="$technical_lang"/></xsl:otherwise>
              </xsl:choose>
            </language>
            <owner>
              <name>
                <xsl:attribute name="first">
                  <xsl:value-of select="./creator/familyName" />
                </xsl:attribute>
                <xsl:attribute name="last">
                  <xsl:value-of select="./creator/givenName" />
                </xsl:attribute>
              </name>
              <comment><xsl:value-of select="./creator/label" /></comment><!-- SKIP-TODO(jmarton): TODO: this contains the name as well. -->
              <identifiers>
                <identifier type="Éles MTMT felület."><xsl:value-of select="./creator/oldId" /></identifier>
                <!-- TODO: other ids? -->
              </identifiers>
              <institutes><!-- TODO --></institutes>
            </owner>
            <source identifier="" name="" date="1970-01-01"  time="00:00:00" year="2010" /><!-- TODO -->
            <edited>
              <entry event="created">
                <xsl:attribute name="date">
                  <xsl:value-of select="substring-before(./created, 'T')" />
                </xsl:attribute>
                <xsl:attribute name="time">
                  <xsl:value-of select="substring-after(substring-before(./created, '.'), 'T')" />
                </xsl:attribute>
                <xsl:attribute name="login">
                  <!-- SKIP-ATTR(jmarton): TODO : login? -->
                </xsl:attribute>
              </entry>
            </edited>
            <xsl:if test="./adminApproved">
              <admin_seen>
                <xsl:attribute name="timestamp">
                  <xsl:value-of select="./adminApproved" /> <!-- TODO invalid -->
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
                  <xsl:attribute name="share">
                    <!-- SKIP-ATTR(for admin_seen; jmarton) TODO -->
                  </xsl:attribute>
                </name>
                <comment><xsl:value-of select="./adminApprover/label" /></comment><!-- SKIP-TODO(jmarton): TODO contains name -->
                <identifiers>
                  <identifier><xsl:value-of select="./adminApprover/mtid" /></identifier>
                </identifiers>
                <institutes><!-- TODO --></institutes>
              </admin_seen>
            </xsl:if>
          </technical_data>
          <publication>
            <title><xsl:value-of select="title" /></title>
            <subtitle><xsl:value-of select="subTitle" /></subtitle>
            <xsl:apply-templates select="publishedYear" />
            <xsl:call-template name="process-classifications" />
            <!-- TODO -->
            <identifiers>
              <xsl:apply-templates select="identifiers/identifier" />
            </identifiers>
          </publication>
          <citations>
            <xsl:apply-templates select="citations/citation/related" />
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

  <xsl:template match="citation/related">
    <citation>
      <xsl:copy-of select="title" />
      <xsl:apply-templates select="publishedYear" />
      <xsl:call-template name="process-classifications" />
      <identifiers>
        <xsl:apply-templates select="identifiers/identifier" />
      </identifiers>
      <!-- TODO -->
    </citation>
  </xsl:template>

  <xsl:template match="publishedYear">
    <date year="{.}" />
  </xsl:template>

  <xsl:template name="process-classifications">
    <classifications>
      <classification>
        <xsl:apply-templates select="type|subType|category" />
      </classification>
    </classifications>
  </xsl:template>

  <xsl:template match="publication/type|citation/related/type">
    <type identifier="{mtid}"><xsl:value-of select="label" /></type>
  </xsl:template>
  <xsl:template match="publication/subType|citation/related/subType">
    <subtype identifier="{mtid}"><xsl:value-of select="label" /></subtype>
  </xsl:template>
  <xsl:template match="publication/category|citation/related/category">
    <character identifier="{mtid}"><xsl:value-of select="label" /></character>
  </xsl:template>
</xsl:stylesheet>
