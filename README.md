## Status
[![pipeline status](https://gitlab.com/rebost/build-pyarrow/badges/master/pipeline.svg)](https://gitlab.com/rebost/build-pyarrow/commits/master)

## build-pyarrow
Bastille template to generate a Python 3.7 wheel for pyarrow on FreeBSD. Once the template is completed the built wheel can be found in /usr/local/bastille/jails/[TARGET]/root/root/wheels.

## Bootstrap

```shell
bastille bootstrap https://gitlab.com/rebost/build-pyarrow
```

## Usage

```shell
bastille template TARGET rebost/build-pyarrow

```

bastille create build_pyarrow38 12.1-RELEASE 192.168.1.128 igb0
bastille start build_pyarrow38
bastille template build_pyarrow38 rebost/build-pyarrow
bastille console build_pyarrow38
ARROW_VERSION=1.0.1
CPATH=/usr/local/include LIBRARY_PATH=/usr/local/lib LD_LIBRARY_PATH=/usr/local/lib CMAKE_REQUIRED_INCLUDES=/usr/local/include AWSSDK_PREFIX=/usr/local AWSSDK_INCLUDE_DIR=/usr/local/include/aws MAKE=/usr/local/bin/gmake /usr/local/bin/build_pyarrow.sh ${ARROW_VERSION} 3.7
CPATH=/usr/local/include LIBRARY_PATH=/usr/local/lib LD_LIBRARY_PATH=/usr/local/lib CMAKE_REQUIRED_INCLUDES=/usr/local/include AWSSDK_PREFIX=/usr/local AWSSDK_INCLUDE_DIR=/usr/local/include/aws MAKE=/usr/local/bin/gmake /usr/local/bin/build_pyarrow.sh ${ARROW_VERSION} 3.8

mkdir /home/mpizarro/devel/wheels/p8
ls /usr/local/bastille/jails/build_pyarrow38/root/root/wheels/pyarrow-${ARROW_VERSION}*-cp37-cp37m-freebsd_*_p8_amd64.whl
ls /usr/local/bastille/jails/build_pyarrow38/root/root/wheels/pyarrow-${ARROW_VERSION}*-cp38-cp38-freebsd_*_p8_amd64.whl
cp -p /usr/local/bastille/jails/build_pyarrow38/root/root/wheels/pyarrow-${ARROW_VERSION}*-cp37-cp37m-freebsd_*_p8_amd64.whl /home/mpizarro/devel/wheels/p8/
cp -p /usr/local/bastille/jails/build_pyarrow38/root/root/wheels/pyarrow-${ARROW_VERSION}*-cp38-cp38-freebsd_*_p8_amd64.whl /home/mpizarro/devel/wheels/p8/
