#!/bin/bash

set -e -x

# Compile wheels
for PYBIN in /opt/python/cp36*/bin; do
    "${PYBIN}/pip" install cffi==1.14.3 nose==1.3.7 setuptools==38.5.2
    "${PYBIN}/pip" wheel /io/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair "$whl" --plat manylinux2010_x86_64 -w /io/wheelhouse/
done

# Install packages and test
for PYBIN in /opt/python/cp36*/bin; do
    "${PYBIN}/pip" install aura_clipspy --no-index -f /io/wheelhouse
    (cd "$HOME"; "${PYBIN}/nosetests" -v /io/test)
done
