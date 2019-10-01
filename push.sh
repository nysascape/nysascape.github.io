#!/bin/bash

# Sorry @baalajimaestro for kanging <3

git submodule add https://github.com/rhazdon/hugo-theme-hello-friend-ng.git themes/hello-friend-ng
curl -sLo hugo_0.58.1_Linux-64bit.deb https://github.com/gohugoio/hugo/releases/download/v0.58.3/hugo_extended_0.58.3_Linux-64bit.deb
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
msg="[nysaCI] // Push website #${SEMAPHORE_BUILD_NUMBER}"
if [ $# -eq 1 ]
  then msg="$1"
fi

git commit -m "$msg"

# Push source and build repos.
git remote rm origin
git remote add origin https://nysascape:${GITHUB_SECRET}@github.com/nysascape/nysascape.github.io.git
git push origin master

# Come Back up to the Project Root
cd ..
