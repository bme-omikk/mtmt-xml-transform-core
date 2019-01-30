import lxml.etree as ET


def transform(original_xml_path):
    xsl_path = 'mtmt2_to_mtmt1.xsl'

    xml = ET.parse(original_xml_path)
    xslt = ET.parse(xsl_path)
    transformer = ET.XSLT(xslt)
    return transformer(xml)
