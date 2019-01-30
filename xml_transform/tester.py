from difflib import SequenceMatcher
from os import listdir, path

from transform import transform

def run_all(data_path='../teszt/szintetikus-rekordok'):
    if not path.exists(data_path):
        raise ValueError('%s path does not exists.')

    files = map(lambda x: path.abspath(path.join(data_path, x)), listdir(data_path))

    for file1 in files:
        if 'mtmt1' in file1:
            file2 = file1.replace('mtmt1', 'mtmt2')
            if path.exists(file2):
                print(file1, run_one(file2, file1))
            else:
                raise ValueError('No mtmt2 file for %s' % file1)


def run_one(original_xml_path, expected_xml_path):
    with open(original_xml_path, 'rt', encoding='utf8') as original_file,\
            open(expected_xml_path, 'rt', encoding='utf8') as expected_file:
        expected_xml = expected_file.read()
        original_xml = original_file.read()
        converted_xml = transform(original_xml)

        return SequenceMatcher(None, expected_xml, converted_xml).ratio()


if __name__ == '__main__':
    run_all()
