## build-pyarrow
Bastille template to generate Python 3.x wheels for pyarrow on FreeBSD.

Once the template is completed the built wheel can be found in /usr/local/bastille/jails/<jail_name>/root/root/wheels.

## Bootstrap

```shell
bastille bootstrap https://gitlab.com/rebost/build-pyarrow
```

## Usage

Create the jail

```shell
# bastille create build_pyarrow 12.1-RELEASE 192.168.1.128 igb0
bastille create <jail_name> <freesd_release> <jail_ip> <interface>

```

Start the jail and apply the template

```shell
bastille start <jail_name>
bastille template <jail_name> rebost/build-pyarrow

```

Log into the jail

```shell
bastille console <jail_name>

```

Once inside the jail, parametrize and launch the build

```shell
ARROW_VERSION=1.0.1
PYTHON_VERSION=3.8
CPATH=/usr/local/include \
  LIBRARY_PATH=/usr/local/lib \
  LD_LIBRARY_PATH=/usr/local/lib \
  CMAKE_REQUIRED_INCLUDES=/usr/local/include \
  AWSSDK_PREFIX=/usr/local \
  AWSSDK_INCLUDE_DIR=/usr/local/include/aws \
  MAKE=/usr/local/bin/gmake \
/usr/local/bin/build_pyarrow.sh ${ARROW_VERSION} ${PYTHON_VERSION}

```

After the wheel has been built you can find it from the host

```shell
ARROW_VERSION=1.0.1
PYTHON_VERSION=3.8
ls /usr/local/bastille/jails/<jail_name>/root/root/wheels/pyarrow-${ARROW_VERSION}*-cp${PYTHON_VERSION/./}-cp${PYTHON_VERSION/./}*-freebsd_*_amd64.whl

```
