#!/usr/bin/env zsh

# Usage:
#
#   publish.sh [file_to_publish.html ...]
#
# All *.nb.html files are published automatically.

read -q "YN?Have you run *Session → Restart R and Run All Chunks* in the menu and *Preview Notebook* in the toolbar? (y/n) "
yesno=$?
echo >&2

if (( $yesno == 0 )); then
  echo >&2 "Publishing the changes to GitHub Pages..."
else
  echo >& 2 "Use RStudio to generate an up-to-date version of the documents first, then re-run this script."
  exit 1
fi

# swith to new gh-pages branch
git stash
git branch -D gh-pages
git checkout -b gh-pages

# stage, commit and push
git rm --ignore-unmatch -r * .*
if (( $# > 0 )); then
  git add $@
fi
git add *.nb.html
git commit -m "Render GitHub Pages"
git push -f -u origin gh-pages

# go back to master
git checkout master
git stash pop

