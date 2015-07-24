find zh | grep -v SUMMARY | sed -e 's/\.md/\.html/g' -e 's/README/index/g' -e 's/zh/http:\/\/juliabook\.josephjctang\.com\/content\/zh/g' > url.txt
curl -H 'Content-Type:text/plain' --data-binary @url.txt "http://data.zz.baidu.com/urls?site=juliabook.josephjctang.com&token=q75fN10vbLmfLVFg"
