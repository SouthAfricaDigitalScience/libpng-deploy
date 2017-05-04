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

# png deploy script
. /etc/profile.d/modules.sh
export LD_LIBRARY_PATH="/lib64:$LD_LIBRARY_PATH"
module add deploy
module add zlib
echo "SOFT_DIR is"
echo $SOFT_DIR
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
export CFLAGS="-I${ZLIB_DIR}/include"
export LDFLAGS="-L${ZLIB_DIR}/lib"
export CPPFLAGS="-I${ZLIB_DIR}/include"
rm -rf *
../configure  \
--with-zlib-prefix=${ZLIB_DIR} \
--enable-unversioned-links \
--prefix=${SOFT_DIR}
echo "Running the build"
make -j2
make install

mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
   puts stderr "\tAdds $NAME $VERSION to your environment"
}

module-whatis   "$NAME $VERSION."
setenv       LIBPNG_VERSION       $VERSION
setenv       LIBPNG_DIR           $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION

prepend-path 	PATH            $::env(LIBPNG_DIR)/bin
prepend-path    MANPATH         $::env(LIBPNG_DIR)/man
prepend-path    LD_LIBRARY_PATH $::env(LIBPNG_DIR)/lib
MODULE_FILE
) > modules/${VERSION}
mkdir -p ${LIBRARIES}/${NAME}
cp modules/${VERSION} ${LIBRARIES}/${NAME}/${VERSION}

# Testing module
module avail
module list
module add ${NAME}/${VERSION}
which libpng16-config
libpng16-config --version
