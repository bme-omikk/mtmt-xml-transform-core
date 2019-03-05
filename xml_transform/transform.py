from lxml import etree

from exceptions import InvalidResultError


def transform(original_xml_path, raise_if_invalid=True, source_name=etree.XSLT.strparam('Éles MTMT felület.')):
    xsl_path = 'mtmt2_to_mtmt1.xsl'

    xml = etree.parse(original_xml_path)
    xslt = etree.parse(xsl_path)
    transformer = etree.XSLT(xslt)

    xslt_parameters = {
        'source_name': source_name,
    }

    transformed_xml = transformer(xml, **xslt_parameters)

    if raise_if_invalid and not is_valid(transformed_xml):
        raise InvalidResultError()

    return transformed_xml


def sort_transform(original_xml):
    xsl_path = '../mtmt1-xml-sorter.xsl'
    xslt = etree.parse(xsl_path)
    transformer = etree.XSLT(xslt)
    return transformer(original_xml)


def is_valid(xml, schema_path='../util/mtmt1.xsd'):
    xml_schema = etree.XMLSchema(etree.parse(schema_path))
    valid = xml_schema.validate(xml)
    if not valid:
        print(xml_schema.error_log)
    return valid
