#!/bin/bash -e
# Copyright 2016 C.S.I.R. Meraka Institute
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

. /etc/profile.d/modules.sh
# We will build the code from the github repo, but if we want specific versions,
# a new Jenkins job will be created for the version number and we'll provide
# the URL to the tarball in the configuration.
SOURCE_REPO="http://download.sourceforge.net/libpng/"
# We pretend that the $SOURCE_FILE is there, even though it's actually a dir.
SOURCE_FILE="${NAME}-${VERSION}.tar.gz"

module add ci
module add zlib

echo "REPO_DIR is "
echo $REPO_DIR
echo "SRC_DIR is "
echo $SRC_DIR
echo "WORKSPACE is "
echo $WORKSPACE
echo "SOFT_DIR is"
echo $SOFT_DIR

mkdir -p $WORKSPACE
mkdir -p $SRC_DIR
mkdir -p $SOFT_DIR

#  Download the source file

if [ ! -e ${SRC_DIR}/${SOURCE_FILE}.lock ] && [ ! -s ${SRC_DIR}/${SOURCE_FILE} ] ; then
  touch  ${SRC_DIR}/${SOURCE_FILE}.lock
  echo "seems like this is the first build - let's get the source"
  wget ${SOURCE_REPO}/${SOURCE_FILE} -O ${SRC_DIR}/${SOURCE_FILE}
elif [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; then
  # Someone else has the file, wait till it's released
  while [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; do
    echo " There seems to be a download currently under way, will check again in 5 sec"
    sleep 5
  done
else
  echo "continuing from previous builds, using source at " ${SRC_DIR}/${SOURCE_FILE}
fi

tar -xvzf ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE} --skip-old-files
mkdir -p ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
cd  ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
echo "Configuring the build"
export LD_LIBRARY_PATH="/lib64:lib/:$LD_LIBRARY_PATH"
# export CPPFLAGS="-I${ZLIB_DIR}/include"
# export CFLAGS="-I${ZLIB_DIR}/include"
# export LDFLAGS="-L${ZLIB_DIR}/lib"
../configure \
--with-zlib-prefix=${ZLIB_DIR} \
--enable-unversioned-links \
--prefix=${SOFT_DIR}
echo "Running the build"
make -j2
