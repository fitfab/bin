#!/bin/bash

#################################################################################
# Generates a list of PRs for the current `repo`  with the given `tag`          #
# - if tag is not passed, it will grab the latest tag from the current repo     #
# CMD                                                                           #
# ~/bin/change-log.sh <tag-name>                                                #
# Author: Miguel Julio                                                          #
#################################################################################

# get organization name: https://github.com/org-name/repo-name/
#                       f1    f2    f3      f4          f5
ORG=$(git remote get-url origin | cut -d'/' -f4)

# get repo url: https://github.com/org-name/repo-name/
#               f1    f2    f3      f4          f5
REPO=$(git remote get-url origin | cut -d'/' -f5 | cut -d'.' -f1)

# If tag was not passed, get the latest tag from the repo
if [ "$1" == '' ]
then
    TAG=$(git for-each-ref --count=1 --sort=-taggerdate --format '%(tag)' refs/tags)
else 
    TAG=$1
fi

echo ""
echo " Generating list of PRs"
echo " ----------------------"
echo " REPO:    https://github.com/$ORG/$REPO"
echo " TAG:     $TAG"
echo ""

# get the list of PR since last tag
git log $TAG...HEAD --pretty=format:'%s %H %b' | grep "Merge pull" | grep "feature" |
while read ref; do
    pr=$(echo $ref | cut '-d ' -f4)
    hash=$(echo $ref | cut '-d ' -f7)
    detail=$(echo $ref | cut '-d ' -f 8-99)
    echo "- [$pr](https://github.com/$ORG/$REPO/commit/$hash) $detail"
done
