from difflib import SequenceMatcher
import lxml.etree as ET
from os import listdir, path
from xmldiff import main, formatting

from transform import transform

xml_declaration_props = dict(xml_declaration=True, encoding='UTF-8', standalone=True)

def run_all(data_path='../teszt/szintetikus-rekordok'):
    if not path.exists(data_path):
        raise ValueError('%s path does not exists.')

    files = map(lambda x: path.abspath(path.join(data_path, x)), listdir(data_path))

    for file1 in files:
        if 'mtmt1' in file1:
            file2 = file1.replace('mtmt1', 'mtmt2')
            if path.exists(file2):
                run_one(file2, file1)
            else:
                raise ValueError('No mtmt2 file for %s' % file1)


def run_one(original_xml_path, expected_xml_path):
    transformed_xml = transform(original_xml_path)
    transformed_xml_str = ET.tostring(transformed_xml, pretty_print=True, **xml_declaration_props)
    with open(original_xml_path.replace('.xml', '_converted.xml'), 'wb') as f:
        f.write(transformed_xml_str)

    expected_xml = ET.parse(expected_xml_path)
    expected_xml_str = ET.tostring(expected_xml, pretty_print=True)

    text_diff_ratio = SequenceMatcher(None, expected_xml_str, transformed_xml_str).ratio()
    #diff = main.diff_trees(transformed_xml, expected_xml, formatter=formatting.XMLFormatter())
    #print(diff)
    print(transformed_xml_str)
    print(original_xml_path, text_diff_ratio)


if __name__ == '__main__':
    run_all()
