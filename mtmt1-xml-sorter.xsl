<!--
mycite XML format sorter stylesheet.
For XSD version: 2.4-rev008

Usage: java -cp saxon7.jar net.sf.saxon.Transform mycite.xml output-sorter.xsl >sorted-mycite.xml

By Jozsef Marton, 2014, jmarton@omikk.bme.hu.
Based on http://stackoverflow.com/questions/4091085/xslt-to-sort-nodes-by-name
(Retrieved: 2014-02-07; Question by Stefan Kendall, Answer by Dimitre Novatchev, 2010-11-03).

Convention used here is always include possible future elements.
It is much better when it breaks validity against XSD than silently suppressing some future modification.

Lines like the following serve for this purpose (see template match="/records", the root element):
   <xsl:apply-templates select="node()[name()!= 'xsd_version' and name()!='record']" />
/records element have technical_data and record* inside.
 They are explicitly outputted in this order, but the mentioned line
 serves for including possible future additions in the sorted output.
-->
<xsl:stylesheet version="2.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:saxon="http://saxon.sf.net/"
 xmlns:fn="http://www.w3.org/2005/xpath-functions"
>
 <xsl:output omit-xml-declaration="no" indent="yes" saxon:indent-spaces="1"/>
 <xsl:strip-space elements="*"/>

 <xsl:template match="node()|@*">
  <xsl:copy>
   <xsl:apply-templates select="@*">
    <xsl:sort select="name()"/>
   </xsl:apply-templates>

   <xsl:apply-templates select="node()">
    <xsl:sort select="name()"/>
   </xsl:apply-templates>
  </xsl:copy>
 </xsl:template>

 <xsl:template match="/records">
  <xsl:copy>
   <xsl:apply-templates select="@*">
    <xsl:sort select="name()"/>
   </xsl:apply-templates>

   <xsl:apply-templates select="xsd_version"/>
   <xsl:apply-templates select="record" />

   <xsl:apply-templates select="node()[name()!= 'xsd_version' and name()!='record']" />
  </xsl:copy>
 </xsl:template>

 <xsl:template match="record">
  <xsl:copy>
   <xsl:apply-templates select="@*">
    <xsl:sort select="name()"/>
   </xsl:apply-templates>

   <xsl:apply-templates select="technical_data" />
   <xsl:apply-templates select="publication" />
   <xsl:apply-templates select="citations" />

   <xsl:apply-templates select="node()[name()!= 'technical_data' and name()!='publication' and name()!='citations']" />
  </xsl:copy>
 </xsl:template>

 <xsl:template match="identifiers">
  <xsl:copy>
   <xsl:apply-templates select="@*">
    <xsl:sort select="name()" />
   </xsl:apply-templates>

   <xsl:apply-templates select="identifier">
    <xsl:sort select="@type"/>
    <xsl:sort select="@name"/>
   </xsl:apply-templates>
  </xsl:copy>
 </xsl:template>

 <xsl:template match="identifier">
  <xsl:copy>
   <xsl:apply-templates select="@*" />

   <xsl:apply-templates select="node()" />
  </xsl:copy>
 </xsl:template>

 <xsl:template match="author|editor|owner|admin_seen"><!-- type_person -->
  <xsl:copy>
   <xsl:apply-templates select="@*" />

   <xsl:apply-templates select="name" />
   <xsl:apply-templates select="comment" />
   <xsl:apply-templates select="identifiers" />
   <xsl:apply-templates select="institutes">
    <xsl:sort select="@for" />
   </xsl:apply-templates>

   <xsl:apply-templates select="node()[name()!= 'name' and name()!='comment' and name()!='identifiers' and name()!='institutes']" />
  </xsl:copy>
 </xsl:template>

 <xsl:template match="technical_data">
  <xsl:copy>
   <xsl:apply-templates select="@*" />

   <xsl:apply-templates select="filesource" />
   <xsl:apply-templates select="source" />

   <xsl:apply-templates select="node()[name()!= 'filesource' and name()!='source']" />
  </xsl:copy>
 </xsl:template>

 <xsl:template match="publication|container|citation">
  <xsl:copy>
   <xsl:apply-templates select="@*" />

   <xsl:apply-templates select="source" />
   <xsl:apply-templates select="date" />

   <xsl:apply-templates select="title" />
   <xsl:apply-templates select="subtitle" />
   <xsl:apply-templates select="classifications" />

   <xsl:apply-templates select="authors" />
   <xsl:apply-templates select="editors" />

   <xsl:apply-templates select="node()[name()!= 'source' and name()!='date' and name()!='title' and name()!='subtitle' and name()!='classifications' and name()!='authors' and name()!='editors' and name()!='container']" />

   <xsl:apply-templates select="container" />
  </xsl:copy>
 </xsl:template>

 <xsl:template match="classification">
  <xsl:copy>
   <xsl:apply-templates select="@*" />

   <xsl:apply-templates select="type" />
   <xsl:apply-templates select="subtype" />
   <xsl:apply-templates select="character" />

   <xsl:apply-templates select="node()[name()!= 'type' and name()!='subtype' and name()!='character']" />
  </xsl:copy>
 </xsl:template>

</xsl:stylesheet>
