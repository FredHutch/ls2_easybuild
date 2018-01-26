# ls2_easybuild

Ubuntu container with easybuild and Lmod

Please look at [ls2](https://github.com/FredHutch/ls2) for details on how to build these Dockerfiles and how to use them to deploy the same software to a local archive.


* Docker build command should include: `--build-arg my_prefix=/app --build-arg LMOD_VER=7.7.14 --build-arg EB_VER=3.5.0`
  * my_prefix is where EasyBuild will be installed. In our case, this is /app in a standard LS2 container and in our NFS software package archive, but you can leverage this build time argument to make a test location as well
  * LMOD_VER is the specific version of LMOD to install - use this to match LMOD version inside and outside a container
  * EB_VER is the specific version of EasyBuild to install - note that bootstrap_eb.py does not support this yet, thus we use our own patched bootstrap_eb.py

This container adds:

* EasyBuild itself

## Building this container

Build this container with:

`docker build . --tag fredhutch/ls2_easybuild:3.5.0 --build-arg EB_VER=3.5.0`

Note that `EB_VER` has no default value and not setting it will cause the build to fail.

## Deploying outside the contianer

We do not do this at this time.
