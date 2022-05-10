FROM ubuntu:14.04

USER root

RUN apt-get update \
	&& apt-get install -y wget \
	&& rm -rf /var/lib/apt/lists/*

# download and install gcc
RUN wget https://mirror.ibcp.fr/pub/gnu/gsl/gsl-latest.tar.gz
RUN tar xf gsl-latest.tar.gz -C /gsl-latest/
RUN cd gsl-latest
RUN ./configure \
	&& make \
	&& make install

# download and install thermoengine
RUN git clone https://gitlab.com/ENKI-portal/ThermoEngine.git
RUN cd ThermoEngine
RUN make \
	&& make install \
	&& make pyinstall

# download other dependencies
RUN pip install VESIcal
RUN pip install jupyter
RUN pip install voila
