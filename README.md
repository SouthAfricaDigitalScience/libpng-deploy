[![Build Status](https://ci.sagrid.ac.za/buildStatus/icon?job=libpng-deploy)](https://ci.sagrid.ac.za/job/libpng-deploy/)
# libpng-deploy

Build, test and deploy scripts for [libpng](http://www.libpng.org/pub/png/libpng.html)

# Versions

Versions built are  :

  1. 1.6.27

In order to use it :

```
module  add libpng/1.6.27
```

# Dependencies

The dependency graph can be seen at https://ci.sagrid.ac.za/job/libpng-deploy/depgraph-view/

This project depends on :

  * [zlib-deploy](https://ci.sagrid.ac.za/job/zlib-deploy)

# Configuration

The builds are configured with the following flags :

```
--with-zlib-prefix=${ZLIB_DIR} \
--enable-unversioned-links \
--prefix=${SOFT_DIR}
```

# Citing

Cite as :

<!-- waiting for DOI --> 
