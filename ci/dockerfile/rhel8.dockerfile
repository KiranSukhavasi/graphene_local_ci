FROM redhat/ubi8:latest

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && dnf update -y

COPY redhat.repo /etc/yum.repos.d/redhat.repo

COPY redhat-uep.pem /etc/rhsm/ca/redhat-uep.pem

COPY entitlement /etc/pki/entitlement

RUN sed -i 's/enabled = 1/enabled = 0/' /etc/yum.repos.d/redhat.repo

RUN rm -rf /etc/rhsm-host

RUN subscription-manager repos --enable rhel-8-for-x86_64-appstream-rpms \
    && subscription-manager repos --enable rhel-8-for-x86_64-baseos-rpms \
    && subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms

RUN dnf update -y \
    &&  dnf install -y \
        autoconf \
        automake \
        bison \
        binutils \
        cargo \
        cmake \
        curl \
        elfutils-libelf-devel \
        epel-release \
        flex \
        gawk \
        gcc-c++ \
        git \
        glibc-static \
        glibc.i686 \
        golang \
        httpd \
        java-11-openjdk \
        java-11-openjdk-devel \
        Judy \
        jq \
        less \
        lsof \
        libaio \
        libatomic \
        libbsd \
        libevent-devel \
        libcurl-devel \
        libjpeg-turbo-devel \
        libmemcached \
        libX11-devel \
        libXxf86vm \
        libXtst \
        libXfixes \
        libXrender \
        libunwind \
        make \
        nasm \
        nc \
        net-tools \
        nodejs \
        nss_nis \
        nss-mdns \
        nss-myhostname \
        ncurses-devel \
        ninja-build \
        openssl-devel \
        patch \
        pkg-config \
        protobuf-c-compiler \
        protobuf-c-devel \
        protobuf-compiler \
        protobuf-devel \
        python3 \
        python3-cryptography \
        python3-pip \
        python3-protobuf \
        python3-click \
        python3-devel \
        python3-jinja2 \
        python3-lxml \
        python3-numpy \
        python3-setuptools \
        python3-pyelftools \
        python3-pytest \
        python3-scipy \
        R-core \
        strace \
        stress-ng \
        sqlite \
        sudo \
        vim  \
        texinfo \
        unzip \
        zip \
        zlib-devel \
        rpm-build \
        wget

RUN python3 -B -m pip install -U \
    'tomli>=1.1.0' \
    'tomli-w>=0.4.0' \
    'meson>=0.56,!=1.2.*' \
    six \
    torchvision \
    pillow

# Install wrk2 benchmark. This benchmark is used in `benchmark-http.sh`.
RUN git clone https://github.com/giltene/wrk2.git \
    && cd wrk2 \
    && git checkout 44a94c17d8e6a0bac8559b53da76848e430cb7a7 \
    && make \
    && cp wrk /usr/local/bin \
    && cd .. \
    && rm -rf wrk2

# Add the user UID:1000, GID:1000, home at /intel
RUN groupadd -r intel -g 1000 && useradd -u 1000 -r -g intel -G wheel -m -d /intel -c "intel Jenkins" intel && \
    chmod 777 /intel

# Make sure /intel can be written by intel
RUN chown 1000 /intel

RUN echo 'intel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN echo 'http_proxy="http://proxy-dmz.intel.com:911/"\nhttps_proxy="http://proxy-dmz.intel.com:912/"' >> /etc/environment

# Blow away any random state
RUN rm -f /intel/.rnd

# Make a directory for the intel driver
RUN mkdir -p /opt/intel && chown 1000 /opt/intel

# Make a directory for the Gramine installation
RUN mkdir -p /home/intel/gramine_install && chown 1000 /home/intel/gramine_install

# Set the working directory to intel home directory
WORKDIR /intel

# Specify the user to execute all commands below
USER intel

# Set environment variables.
ENV HOME /intel

# Define default command.
CMD ["bash"]
