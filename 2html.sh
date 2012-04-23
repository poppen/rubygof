#!/bin/bash

echo 'translating'
for file in *.rb; do
 code2html --template=html.tmpl "$file" > "$file".html
 ruby "$file" > output

 #escaping html
 sed -i 's/</\&lt;/g' output
 sed -i 's/>/\&gt;/g' output

 cat output >> "$file".html
 echo "</pre>" >> "$file".html
done

echo 'removing watermarks'
sed -i 's/<hr>//' *rb.html
sed -i 's/syntax highlighted by.*$//' *rb.html
