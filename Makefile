PYTHON			?= python3 # Note: Is needed execute with sudo, therefore default python in system will be used (root)
CLIPS_VERSION		?= 6.31
# CLIPS_SOURCE_URL	?= "https://downloads.sourceforge.net/project/clipsrules/CLIPS/6.31/clips_core_source_631.zip"
MAKEFILE_NAME		?= makefile
SHARED_INCLUDE_DIR	?= /usr/local/include
SHARED_LIBRARY_DIR	?= /usr/local/lib
USER  ?= $(shell whoami)

# platform detection
# PLATFORM = $(shell uname -s)

.PHONY: clips clipspy test install clean

all: clips_source clips clipspy

clips_source:
	# wget -O clips.zip $(CLIPS_SOURCE_URL)
	# unzip -jo clips.zip -d clips_source
	-sudo apt-get update
	apt-get download aura-libclips-dev # Download needed libraries in current directory
	apt-get download aura-libclips

#ifeq ($(PLATFORM),Darwin) # macOS
#clips: clips_source
#	$(MAKE) -f $(MAKEFILE_NAME) -C clips_source                            \
#		CFLAGS="-std=c99 -O3 -fno-strict-aliasing -fPIC"               \
#		LDLIBS="-lm"
#	ld clips_source/*.o -lm -dylib -arch x86_64                            \
#		-o clips_source/libclips.so
#else
#clips: clips_source
#	$(MAKE) -f $(MAKEFILE_NAME) -C clips_source                            \
#		CFLAGS="-std=c99 -O3 -fno-strict-aliasing -fPIC"               \
#		LDLIBS="-lm -lrt"
#	ld -G clips_source/*.o -o clips_source/libclips.so
#endif
clips: clips_source
	dpkg-deb -xv aura-libclips-dev_* clips_source # Extract data contained in debian packages downloaded previously
	dpkg-deb -xv aura-libclips_* clips_source

clipspy: clips
	$(PYTHON) setup.py build_ext

test: clipspy
	cp build/lib.*/clips/_clips*.so clips
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:clips_source/usr/lib			       \
		$(PYTHON) -m pytest -v

# install-clips: clips
install-clips:
	install -d $(SHARED_INCLUDE_DIR)/
	install -m 644 clips_source/usr/include/clips/clips.h $(SHARED_INCLUDE_DIR)/
	install -d $(SHARED_INCLUDE_DIR)/clips
	install -m 644 clips_source/usr/include/clips/*.h $(SHARED_INCLUDE_DIR)/clips/
	install -d $(SHARED_LIBRARY_DIR)/
	install -m 644 clips_source/usr/lib/libclips.so                                \
	 	$(SHARED_LIBRARY_DIR)/libclips.so.$(CLIPS_VERSION)
	ln -s $(SHARED_LIBRARY_DIR)/libclips.so.$(CLIPS_VERSION)	       \
	 	$(SHARED_LIBRARY_DIR)/libclips.so.6
	ln -s $(SHARED_LIBRARY_DIR)/libclips.so.$(CLIPS_VERSION)	       \
	 	$(SHARED_LIBRARY_DIR)/libclips.so
	-ldconfig -n -v $(SHARED_LIBRARY_DIR) # https://tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html

install: clipspy install-clips
	$(PYTHON) setup.py install

build: clips
	# sudo $(PYTHON) setup.py bdist_wheel
	# https://clipspy.readthedocs.io/en/latest/#manylinux-wheels
	# Docker in docker -> run --volume /var/run/docker.sock:/var/run/docker.sock
	sudo docker build -t aura-clipspy-build-wheels:latest -f manylinux/Dockerfile .
	sudo docker run -v `pwd`/manylinux/wheelhouse:/io/wheelhouse aura-clipspy-build-wheels:latest
	mkdir dist
	cp manylinux/wheelhouse/aura_clipspy-*manylinux2010_x86_64.whl dist
	# python -m twine check dist/aura_clipspy-1.0.0-cp36-cp36m-linux_x86_64.whl
	# python -m twine upload --repository-url https://test.pypi.org/legacy/ dist/*
	# pip install --index-url https://test.pypi.org/simple/ aura_clipspy

clean:
	# -rm clips.zip
	-rm -f aura-libclips* # Remove aura-libclips and aura-libclips-dev libraries
	-rm -fr clips_source build dist clipspy.egg-info .eggs .pytest_cache
	-rm -f /usr/local/lib/libclips.so* # Remove libclips.so libclips.so.6 libclips.so.6.31
	-rm -fr $(SHARED_INCLUDE_DIR)/clips.h $(SHARED_INCLUDE_DIR)/clips
	-rm -fr aura_clipspy.egg-info manylinux/wheelhouse
