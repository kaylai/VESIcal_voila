FROM ubuntu:14.04

USER root

# install basic stuff like wget, gcc, and git
RUN apt-get update \
	&& apt-get install -y wget \
	&& apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get dist-upgrade -y \
	&& apt-get install build-essential software-properties-common -y \
	&& add-apt-repository ppa:ubuntu-toolchain-r/test -y \
	&& apt-get update -y \
	&& apt-get install gcc-7 g++-7 -y \
	&& update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-7 \
	&& update-alternatives --config gcc \
	&& apt-get update -y \
	&& apt-get install clang-9 --install-suggests -y \
	&& apt-get install git -y \
	&& rm -rf /var/lib/apt/lists/*

# download and install gcc
RUN wget https://mirror.ibcp.fr/pub/gnu/gsl/gsl-latest.tar.gz \
	&& tar -xzf gsl-latest.tar.gz \
	&& rm gsl-latest.tar.gz
RUN cd gsl-2.7.1 \
	&& ./configure \
	&& make \
	&& make install

# download and install thermoengine
RUN git clone https://gitlab.com/ENKI-portal/ThermoEngine.git
RUN cd ThermoEngine \
	&& make \
	&& make install \
	&& make pyinstall

# download other dependencies
RUN pip install VESIcal
RUN pip install jupyter
RUN pip install voila
