#!/bin/bash
. /usr/share/modules/init/bash
module load ci
echo "About to make the modules"
cd $WORKSPACE/${NAME}-${VERSION}
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

module load gcc/${GCC_VERSION}

module-whatis   "$NAME $VERSION."
setenv       LIBPNG_VERSION       $VERSION
setenv       LIBPNG_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION

prepend-path 	PATH            $::env(LIBPNG_DIR)/bin
prepend-path    PATH            $::env(LIBPNG_DIR)/include
prepend-path    PATH            $::env(LIBPNG_DIR)/bin
prepend-path    MANPATH         $::env(LIBPNG_DIR)/man
prepend-path    LD_LIBRARY_PATH $::env(LIBPNG_DIR)/lib
MODULE_FILE
) > modules/$VERSION-gcc-${GCC_VERSION}
mkdir -p $LIBRARIES_MODULES/$NAME
cp modules/$VERSION-gcc-${GCC_VERSION} $LIBRARIES_MODULES/$NAME/$VERSION-gcc-${GCC_VERSION}

# Testing module
module avail
module list
module load $NAME/${VERSION}-gcc-${GCC_VERSION}
