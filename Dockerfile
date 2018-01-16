FROM fredhutch/ls2_ubuntu:16.04_20180116

ENV DEBIAN_FRONTEND noninteractive

# OS Packages
#   EasyBuild needs Python, and an Environment Modules implementation
#   Our Environment Modules implementation, Lmod, needs lua
#   Apparently with EasyBuild using https urls for download, it needs ssl
RUN apt-get update && apt-get install -y \
    python \
    python-setuptools \
    lua5.2 \
    lua-posix \
    lua-filesystem \
    lua-term \
    ssl-cert

# Install directory
RUN mkdir /app && chown 500.500 /app

# User
#   EasyBuild does not build as root, so we make a user
RUN groupadd -g 500 neo && useradd -u 500 -g neo -ms /bin/bash neo

# use bash
SHELL ["/bin/bash", "-c"]

# install and uninstall build-essential in one step to reduce layer size
# while installing Lmod and EasyBuild
ENV LMOD_VER=7.7.3
ENV EB_VER=3.5.0
ENV EASYBUILD_PREFIX=/app
ENV EASYBUILD_MODULES_TOOL=Lmod
ENV EASYBUILD_MODULE_SYNTAX=Lua
RUN apt-get install -y build-essential && \
    curl -L -o /tmp/Lmod-${LMOD_VER}.tar.gz https://github.com/TACC/Lmod/archive/${LMOD_VER}.tar.gz && \
    su -c "tar -xzf /tmp/Lmod-${LMOD_VER}.tar.gz && \
           cd Lmod-${LMOD_VER} && \
           ./configure --prefix=/app --with-tcl=no && \
           make install && \
           cd .. && \
           rm -r Lmod-${LMOD_VER}" - neo && \
    rm /tmp/Lmod-${LMOD_VER}.tar.gz && \
    curl -L -o /tmp/bootstrap_eb.py https://github.com/easybuilders/easybuild-framework/raw/easybuild-framework-v${EB_VER}/easybuild/scripts/bootstrap_eb.py && \
    su -c "source /app/lmod/lmod/init/bash && \
           python /tmp/bootstrap_eb.py ${EASYBUILD_PREFIX}" - neo && \
    rm /tmp/bootstrap_eb.py && \
    apt-get remove -y --purge build-essential && \
    apt-get autoremove -y --purge

# switch to neo user for future actions
USER neo
WORKDIR /home/neo
SHELL ["/bin/bash", "-c"]
