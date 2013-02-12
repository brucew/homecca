#!/bin/sh
rm -rf .git
git init
echo .svn > .gitignore
git add .
git commit -m "reinitialized git repo"
git remote add heroku git@heroku.com:skillz.git
git remote add staging git@heroku.com:homecca-staging.git
git push -f staging
