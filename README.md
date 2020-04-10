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
