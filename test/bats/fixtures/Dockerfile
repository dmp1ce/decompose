FROM alpine
MAINTAINER David Parrish <daveparrish@tutanota.com>

ADD . /app

# Setup decompose and it's dependencies
# Install bats
RUN ln -s /app/decompose /usr/local/bin && \
apk add --update git bash perl coreutils util-linux && \
git clone --recursive https://github.com/dmp1ce/decompose.git /opt/decompose && \
rm -rf /var/cache/apk/* && \
git clone https://github.com/sstephenson/bats.git /opt/bats && \
/opt/bats/install.sh /usr/local
