# Use Debian Buster base image
FROM debian:10 as build

# Install prerequisites
# http://wiki.synchro.net/install:nix:prerequisites
ARG DEBIAN_FRONTEND=noninteractive
RUN set -eux; \
  apt-get update; apt-get upgrade; \
  apt-get install -y \
    bash \
    bats \
    g++ \
    git \
    gkermit \
    libncursesw5-dev \
    libnspr4-dev \
    linux-libc-dev \
    lrzsz \
    make \
    perl \
    pkgconf \
    python \
    unzip \
    wget \
    zip; \
  rm -rf /var/lib/apt/lists/*;

# Create base directory, pull Makefile, compile source code
ARG SBBS_GITTAG=sbbs318b
ARG SBBSDIR=/sbbs
ARG SBBS_SYMLINK=1
RUN set -eux; \
  mkdir -p $SBBSDIR; cd $SBBSDIR; \
  wget -nv https://gitlab.synchro.net/main/sbbs/-/raw/master/install/GNUmakefile; \
  make install NOCAP=1 NO_X=1 NO_GTK=1 SYMLINK=$SBBS_SYMLINK TAG=$SBBS_GITTAG

# Add tests and execute them
COPY tests /tests
RUN bats /tests

#
# Final image
#
FROM debian:10

ENV DEBIAN_FRONTEND=noninteractive
ENV SBBSDIR=/sbbs
ENV SBBSCTRL=$SBBSDIR/ctrl

RUN set -eux; \
  apt-get update; apt-get upgrade; \
  apt-get install -y \
    bash \
    libnspr4 \
    net-tools \
    procps \
    tini \
    wget; \
  rm -rf /var/lib/apt/lists/*; \
  groupadd --gid 10000 nonroot; \
  useradd --uid 10000 --gid 10000 --shell /bin/bash --create-home nonroot; \
  wget -nv -O /etc/termcap https://gitlab.synchro.net/main/sbbs/-/raw/master/install/termcap

# Add application
COPY --from=build --chown=10000:10000 $SBBSDIR $SBBSDIR

USER nonroot
WORKDIR $SBBSDIR
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/sbbs/exec/sbbs"]
