#! /bin/bash
# Return a version string for this image.
# The version string is formatted:
#        OpenSimVersion-OpenSimBranch-OpenSimGitCommit-BuildDate/OpenSimDockerImageVersion
# An example is:
#       0.9.2.1-develop-17b5123-20240712.1234/2.1.3-20220202-4b994b5
# Verbose but it has all the version information.

export OPENSIMHOME=/home/opensim
export VERSIONDIR=$OPENSIMHOME/VERSION

part=$1

cd "$VERSIONDIR"
for valueName in * ; do
    export ${valueName}=$(cat "$valueName")
done

if [[ -z "$part" ]] ; then
    echo "${OS_VERSION}-${OS_GIT_BRANCH}-${OS_GIT_COMMIT_SHORT}-${BUILD_DATE}/${OS_DOCKER_IMAGE_VERSION}"
else
    cat ${VERSIONDIR}/$part
fi

# echo "$(cat $VERSIONDIR/OS_VERSION)-$(cat $VERSIONDIR/OS_GIT_COMMIT_SHORT)-$(cat $VERSIONDIR/OS_DOCKER_IMAGE_VERSION)-$(cat $VERSIONDIR/BUILD_DATE)-$($VERSIONDIR/OS_DOCKER_GIT_COMMIT_SHORT)"
