# Copyright (c) ENKI Development Team.
# Distributed under the terms of the Affero General Public License

FROM scratch

# compilers required for ENKI libgnustep-base-dev --no-install-recommends
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y dist-upgrade
RUN apt-get -y autoremove
RUN apt-get install -y  \
    gfortran \
    gcc \
    cmake \
    clang-10 \
    libgsl-dev \
    liblapack-dev \
    zip
RUN rm -rf /var/lib/apt/lists/*

# install additional package...
RUN pip install --no-cache-dir nbgitpuller
RUN pip install --no-cache-dir deprecation
RUN pip install --no-cache-dir numdifftools
RUN pip install --no-cache-dir VESIcal
RUN pip install --no-cache-dir -r requirements.txt

ENV LD_LIBRARY /usr/local/lib

RUN git clone https://gitlab.com/ENKI-portal/rubiconobjc.git
RUN cd ./rubiconobjc && \
    pip install --no-cache-dir --use-feature=in-tree-build . && \
    cd .. && \
    rm -rf ./rubiconobjc

# Install GNUstep components from sources (requires Python 2.7, hence the path change)
ARG SAVE_PATH=$PATH
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN git clone https://github.com/plaurent/gnustep-build && \
    cd gnustep-build/ubuntu-20.04-clang-10.0-runtime-2.0/ && \
    bash GNUstep-buildon-ubuntu2004.sh && \
    cd ../.. && \
    rm -rf ./gnustep-build

ENV PATH $SAVE_PATH

# Install ThermoEngine repository (note && \ missing from first line)
ENV RUNTIME_VERSION gnustep-2.0
COPY / /thermoengine/
RUN cd /thermoengine/Cluster && \
    make && \
    /usr/bin/install -c -p  ./obj/libswimdew.so.0.0.1 /usr/local/lib && \
    ln -s /usr/local/lib/libswimdew.so.0.0.1 /usr/local/lib/libswimdew.so.0 && \
    ln -s /usr/local/lib/libswimdew.so.0 /usr/local/lib/libswimdew.so && \
    /usr/bin/install -c -p  ./obj/libphaseobjc.so.0.0.1 /usr/local/lib && \
    ln -s /usr/local/lib/libphaseobjc.so.0.0.1 /usr/local/lib/libphaseobjc.so.0 && \
    ln -s /usr/local/lib/libphaseobjc.so.0 /usr/local/lib/libphaseobjc.so && \
    cd .. && \
    make pyinstall && \
    cd .. && \
    rm -rf ./thermoengine
