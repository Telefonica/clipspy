FROM quay.io/pypa/manylinux2010_x86_64

RUN yum install -y make unzip wget
# RUN auditwheel -V
# auditwheel 3.1.1 crash, downgrade to 3.1.0 https://github.com/pypa/auditwheel/issues/247
RUN /opt/_internal/tools/bin/pip3 install auditwheel==3.1.0

COPY . /io

WORKDIR /io

# RUN make clips_source
RUN make install-clips


CMD "./manylinux/build-wheels.sh"
