#!/bin/bash
echo "--------------------------------------"
echo "Deploy New Post"
echo "--------------------------------------"
echo ""
git status
echo ""
git add --all
echo ""
git commit -m "deploy new post"
echo ""
git push origin master
