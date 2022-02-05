#! /bin/bash
# Return a version string for this image.
# The version string is formatted:
#        OpenSimVersion-OpenSimGitCommit-OpenSimDockerVersion-BuildDate-OpenSimDockerCommit
# An example is:
#       0.9.2.1-17b5123-2.1.3-20220202-4b994b5
# Verbose but it has all the version information.

export OPENSIMHOME=/home/opensim
export VERSIONDIR=$OPENSIMHOME/VERSION

echo "$(cat $VERSIONDIR/OS_VERSION)-$(cat $VERSIONDIR/OS_GIT_COMMIT_SHORT)-$(cat $VERSIONDIR/OS_DOCKER_IMAGE_VERSION)"
