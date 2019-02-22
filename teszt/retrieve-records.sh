#!/bin/bash

FIELDS='citations:1,publishers.cities.partOf:1,book.publishers.cities.partOf:1,journal.publishers.cities.partOf:1,creator.identifiers:1'

MYDIR=$(readlink $(dirname $0))

for dir in $(find $MYDIR -maxdepth 1 -mindepth 1 -type d) ; do
  if [ -f "$dir/documents.lst" ]; then
    for d in $(cat $dir/documents.lst) ; do
      wget -O - 'https://m2.mtmt.hu/api/publication/'${d}'?&fields='$FIELDS'&format=xml' | grep -v '^<?xml-stylesheet .*?>$' >$dir/doc_${d}_mtmt2.xml
      wget -O $dir/doc_${d}_mtmt1.xml 'https://vm.mtmt.hu/www/index.php?mode=xml&DocumentID='${d}'&Full=1'
    done
  fi

  if [ -f "$dir/authors.lst" ]; then
    for a in $(cat $dir/authors.lst) ; do
      wget -O - 'https://m2.mtmt.hu/api/publication?&cond=authors;eq;'${a}'&fields='$FIELDS'&format=xml' | grep -v '^<?xml-stylesheet .*?>$' >$dir/author_${a}_mtmt2.xml
      wget -O $dir/author_${a}_mtmt1.xml 'https://vm.mtmt.hu/www/index.php?AuthorID='${a}'&mode=xml&Full=1'
    done
  fi
done
