#!/bin/bash
gitbook build
git checkout gh-pages
cp -R _book/* ./
git add zh
git commit -m "update content"
git push 
git checkout master


