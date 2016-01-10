#!/bin/bash -e
. /etc/profile.d/modules.sh
module load ci
module add zlib
echo "About to make the modules"
cd $WORKSPACE/${NAME}-${VERSION}/build-${BUILD_NUMBER}
ls
echo $?

echo "Run Make Check - This is the Test"
make check

echo "Run make Install"
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
setenv       LIBPNG_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION

prepend-path 	PATH            $::env(LIBPNG_DIR)/bin
prepend-path    PATH            $::env(LIBPNG_DIR)/include
prepend-path    PATH            $::env(LIBPNG_DIR)/bin
prepend-path    MANPATH         $::env(LIBPNG_DIR)/man
prepend-path    LD_LIBRARY_PATH $::env(LIBPNG_DIR)/lib
MODULE_FILE
) > modules/$VERSION
mkdir -p $LIBRARIES_MODULES/$NAME
cp modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}/${VERSION}

# Testing module
module avail
module list
module add ${NAME}/${VERSION}
