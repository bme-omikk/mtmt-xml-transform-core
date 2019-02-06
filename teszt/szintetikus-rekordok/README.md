# Szintetikus tesztrekordok


Az MTMT2 XML fájlokban a gyökérelem `myciteResult`, de lehet `myciteResultList` is. A lényeg, hogy a `/mycireResult|myciteResultList/content/publication` az, amit transzformálni kell.


## MTMT2 lekérdezés

 - egyes közleményekre

```
for d in $(cat documents.lst) ; do wget -O - 'https://m2.mtmt.hu/api/publication/'$d'?&fields=citations:1&format=xml' | grep -v '^<?xml-stylesheet .*?>$' >doc_${d}_mtmt2.xml ; done
```

 - szerzőkre

```
for a in $(cat authors.lst) ; do wget -O - 'https://m2.mtmt.hu/api/publication?&cond=authors;eq;'${a}'&fields=citations:1&format=xml' | grep -v '^<?xml-stylesheet .*?>$' >author_${a}_mtmt2.xml ; done
```


## MTMT1 lekérdezés

 - egy közlemény: `https://vm.mtmt.hu/www/index.php?mode=xml&DocumentID=@@0&Full=1`
 - egy szerző munkássága: `https://vm.mtmt.hu/www/index.php?AuthorID=@@@&mode=xml&Full=1`
