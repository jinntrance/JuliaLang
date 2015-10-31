find _book | grep -v SUMMARY | sed -e 's/\.md/\.html/g' -e 's/README/index/g' -e 's/_book/http:\/\/juliabook\.josephjctang\.com\/content/g' > url.txt
curl -H 'Content-Type:text/plain' --data-binary @url.txt "http://data.zz.baidu.com/urls?site=juliabook.josephjctang.com&token=q75fN10vbLmfLVFg"
