# Szintetikus tesztrekordok


Így készültek az MTMT2 XML fájlok:

```
for d in 2615009 2695803 2695805 2695806 2695810 2695811 2695812 2695818 2695819 2695820 2695821 ; do wget -O - 'https://m2.mtmt.hu/api/publication/'$d'?&fields=citations:1&format=xml' | grep -v '^<?xml-stylesheet .*?>$' >${d}_mtmt2.xml ; done
```

Ilyenkor a gyökérelem `myciteResult`, de lehet `myciteResultList` is. A lényeg, hogy a `/mycireResult|myciteResultList/content/publication` az, amit transzformálni kell.
