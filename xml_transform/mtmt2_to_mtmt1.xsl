<?xml version="1.0" encoding='UTF-8' standalone='yes'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <records xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="mycite.xsd">
            <xsd_version>2.4.</xsd_version>

            <xsl:for-each select="(myciteResult|myciteResultList)/content/publication">
                <record>
                    <technical_data>
                        <filesource>
                            <xsl:attribute name="identifier"><xsl:value-of select="./mtid" /></xsl:attribute>
                            <xsl:attribute name="status">
                                <xsl:choose>
                                    <xsl:when test="status = 'APPROVED'">jóváhagyva</xsl:when>
                                    <xsl:otherwise>??</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </filesource>
                    </technical_data>
                </record>
            </xsl:for-each>
        </records>
    </xsl:template>
</xsl:stylesheet>