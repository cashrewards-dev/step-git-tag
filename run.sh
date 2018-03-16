#!/bin/bash
set +e
set -o noglob

echo "----------------------------------------"
echo "$(head -n 2 $WERCKER_STEP_ROOT/wercker-step.yml)"
echo "----------------------------------------"

source $WERCKER_STEP_ROOT/src/helper.sh

STEP_PREFIX="WERCKER_GIT_TAG"
step_var() {
  echo $(tmp=${STEP_PREFIX}_$1 && echo ${!tmp}) 
}

# Check required packages
if type_exists 'git'
	then
	echo 'Git installed'
else
  error "Please install git"
  exit 1
fi

if [ ! -d ".git" ]; then
    fail "no git repository found"
fi

# Check variables
if [ -z "$(step_var 'TAG')" ]; then
  error "Please set the 'tag' variable"
  exit 1
fi

# Configure Git.
git config --global user.email pleasemailus@wercker.com
git config --global user.name "$WERCKER_STARTED_BY"
debug 'configured git'

# Get tags.
git fetch --tags origin
debug 'fetched git tags'

# Create the name of the tag
TAG_ANNOTATION="$(step_var 'TAG')"

# Delete the tag if it exists, otherwise just skip
if (git tag -l | grep "$TAG_ANNOTATION" &> /dev/null);
then
  git tag -d "$TAG_ANNOTATION"
  git push origin ":refs/tags/$TAG_ANNOTATION"  
  debug "Deleted existing $TAG_ANNOTATION"
fi

# Tag your commit.
git tag -a "$tagname" $WERCKER_GIT_COMMIT -m "Wercker deploy TAG:${TAG_ANNOTATION} by $WERCKER_STARTED_BY"
git push origin --tags 
	  