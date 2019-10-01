#!/bin/bash

# Sorry @baalajimaestro for kanging <3

curl -sLo hugo_0.58.1_Linux-64bit.deb https://github.com/gohugoio/hugo/releases/download/v0.58.1/hugo_0.58.1_Linux-64bit.deb
sudo dpkg -i hugo_0.58.1_Linux-64bit.deb
rm -rf hugo_0.58.1_Linux-64bit.deb
echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
export BUILD_DIR=$(pwd)
cd ..
git clone https://github.com/nysascape/nysascape.github.io -b master public
cd public
export PUBLIC=$(pwd)
git checkout -b master
cd $BUILD_DIR
hugo -d ../public

# Go To Public folder
cd $PUBLIC
# Add changes to git.
git config --global user.email "nysadev@raphielgang.org"
git config --global user.name "nysascape"
git add .
# Commit changes.
msg="[nysaCI]: Push website (@${GITHUB_ACTOR})"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git remote rm origin
git remote add origin https://nysascape:${GITHUB_TOKEN}@github.com/nysascape/nysascape.github.io
git push origin master

# Come Back up to the Project Root
cd ..