#!/usr/bin/env bash


. $WORKSPACE/tools/build-env.sh

INAME=basebox


# Handle GIT branch: set upstream tag
case "$DOCKER_TAG" in

  dev )
      T=$DOCKER_TAG
      B=master
    ;;

  * )
      T=$DOCKER_TAG
      B=$T
    ;;

esac

X_DCKR_BASETAG=$B


docker pull phusion/baseimage:$X_DCKR_BASETAG

eval $(docker run --rm phusion/baseimage:$X_DCKR_BASETAG \
  bash -c 'cat /etc/os-release' | grep -v '^VERSION=' )

PHUSION_CODENAME=$UBUNTU_CODENAME
PHUSION_VER=$ID-$VERSION_ID


# Override tags with commit-msg tag, adding basetag from branch/tag also
echo "$COMMIT_MSG" | tr 'A-Z' 'a-z' | grep -q '\[hub:' && {

  for tag in $(echo "$COMMIT_MSG" | tr 'A-Z' 'a-z' | \
    sed -E 's/.*\[hub: ([^]]*)\].*/\1/' )
  do
    DOCKER_TAGS="$DOCKER_TAGS $tag $tag-$T $tag-$T-$PHUSION_CODENAME $tag-$T-$PHUSION_VER"
  done
} || {

  # Or start with tag from branch
  DOCKER_TAGS="$T $T-$PHUSION_VER baseimage-$B-$PHUSION_CODENAME baseimage-$B-$PHUSION_VER"

  # Handle GIT tags
  for tag in $(git_rev_tags | grep basebox- | tr '\n' ' ')
  do
    tag="$(echo "$tag"|cut -c9-)"
    DOCKER_TAGS="$DOCKER_TAGS $tag $tag-$T $tag-$T-$PHUSION_CODENAME $tag-$T-$PHUSION_VER"
  done
}
unset tag

VERSION=0.0.4 # basebox
