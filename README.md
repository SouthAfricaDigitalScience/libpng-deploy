[![Build Status](https://ci.sagrid.ac.za/buildStatus/icon?job=libpng-deploy)](https://ci.sagrid.ac.za/job/libpng-deploy/) [![DOI](https://zenodo.org/badge/43883381.svg)](https://zenodo.org/badge/latestdoi/43883381)


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

Bruce Becker, & Sakhile Masoka. (2017). SouthAfricaDigitalScience/libpng-deploy: CODE-RADE Foundation Release 3 - libpng [Data set]. Zenodo. http://doi.org/10.5281/zenodo.571464
