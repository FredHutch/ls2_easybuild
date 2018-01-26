FROM fredhutch/ls2_lmod:7.7.14

# Remember, default user will be LS2_USER, not root

# These must be specified
ARG EB_VER
ENV EB_VER=${EB_VER}

# copy in scripts and files
COPY install_easybuild.sh /ls2/
COPY deploy_easybuild.sh /ls2/
COPY bootstrap_eb.py /ls2/
COPY eb_module_footer /ls2/

# OS Packages
#   EasyBuild needs Python, and an Environment Modules implementation
USER root
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
    python \
    python-setuptools 

# install and uninstall build-essential in one step to reduce layer size
# while installing Lmod
RUN apt-get install -y build-essential \
    && su -c "/bin/bash /ls2/install_easybuild.sh" ${LS2_USERNAME} \
    && AUTO_ADDED_PKGS=$(apt-mark showauto) apt-get remove -y --purge build-essential ${AUTO_ADDED_PKGS} \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# gather pkg info
RUN dpkg -l > /ls2/installed_pkgs.easybuild

# switch to LS2 user for future actions
USER ${LS2_USERNAME}
WORKDIR /home/${LS2_USERNAME}
SHELL ["/bin/bash", "-c"]

