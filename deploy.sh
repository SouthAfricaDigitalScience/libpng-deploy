#!/bin/bash -e
# png deploy script
. /etc/profile.d/modules
module add deploy
module add zlib
echo "SOFT_DIR is"
echo $SOFT_DIR
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
rm -rf *
../configure  \
--with-zlib-prefix=${ZLIB_DIR} \
--enable-unversioned-links \
--prefix=${SOFT_DIR} \
echo "Running the build"
make all -j2

make check

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
prepend-path    PATH            $::env(LIBPNG_DIR)/include
prepend-path    PATH            $::env(LIBPNG_DIR)/bin
prepend-path    MANPATH         $::env(LIBPNG_DIR)/man
prepend-path    LD_LIBRARY_PATH $::env(LIBPNG_DIR)/lib
MODULE_FILE
) > modules/$VERSION
mkdir -p $LIBRARIES_MODULES/$NAME
cp modules/$VERSION $LIBRARIES_MODULES/$NAME/$VERSION

# Testing module
module avail
module list
module add $NAME/${VERSION}
which libpng16-config
libpng16-config 
