#!/usr/bin/env bash

export ARROW_VERSION="0.16.0"
export BASE_DIR="${HOME}/arrow_${ARROW_VERSION}"
export VENV_DIR="${BASE_DIR}/venv"
export ARROW_REPO="${BASE_DIR}/arrow-apache-arrow-${ARROW_VERSION}"
export ARROW_BUILD_TYPE=release
export LOCALBASE=/usr/local
export MAKE=/usr/local/bin/gmake
export ARROW_HOME=${LOCALBASE}
export PARQUET_HOME=${LOCALBASE}

mkdir -p ${BASE_DIR}
pushd ${BASE_DIR}

# fetch https://github.com/apache/arrow/archive/apache-arrow-${ARROW_VERSION}.tar.gz -o arrow.tar.gz
# tar xzf arrow.tar.gz

git clone https://github.com/apache/arrow.git --branch master ${ARROW_REPO}
pushd ${ARROW_REPO}
git checkout 71edd30f0ce50f0a1
git submodule init
git submodule update
export PARQUET_TEST_DATA="${PWD}/cpp/submodules/parquet-testing/data"
export ARROW_TEST_DATA="${PWD}/testing/data"

python3.7 -m venv ${VENV_DIR}
source "${VENV_DIR}/bin/activate"
pip install --upgrade pip
pip install six numpy pandas cython pytest hypothesis wheel

mkdir ${ARROW_REPO}/cpp/build
pushd ${ARROW_REPO}/cpp/build

# GANDIVA -> llvm grpc
cmake \
      -I${LOCALBASE}/include -L${LOCALBASE}/lib \
      -DCMAKE_BUILD_TYPE=${ARROW_BUILD_TYPE} \
      -DCMAKE_INSTALL_PREFIX=${ARROW_HOME} \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DARROW_FLIGHT=ON \
      -DARROW_GANDIVA=OFF \
      -DARROW_ORC=OFF \
      -DARROW_S3=ON \
      -DARROW_WITH_BZ2=ON \
      -DARROW_WITH_ZLIB=ON \
      -DARROW_WITH_ZSTD=ON \
      -DARROW_WITH_LZ4=ON \
      -DARROW_WITH_SNAPPY=ON \
      -DARROW_WITH_BROTLI=ON \
      -DARROW_WITH_BACKTRACE=OFF \
      -DARROW_PARQUET=ON \
      -DARROW_PYTHON=ON \
      -DARROW_PLASMA=OFF \
      -DARROW_BUILD_TESTS=OFF \
      -DMAKE=/usr/local/bin/gmake \
      ..

gmake -j46
gmake -j46 install

pushd ${ARROW_REPO}/python
export ARROW_INCLUDE_DIR=${ARROW_HOME}/include/arrow
export ARROW_LIB_DIR=${ARROW_HOME}/lib
export ARROW_PYTHON_INCLUDE_DIR=${ARROW_HOME}/include/arrow/python
export ARROW_PYTHON_LIB_DIR=${ARROW_HOME}/lib
export PYARROW_WITH_FLIGHT=1
export PYARROW_WITH_GANDIVA=1
export PYARROW_WITH_DATASET=1
export PYARROW_WITH_HDFS=1
export PYARROW_WITH_BACKTRACE=0
export PYARROW_WITH_ORC=0
export PYARROW_WITH_HDFS=1
export PYARROW_WITH_S3=1
export PYARROW_WITH_PARQUET=1
python setup.py build_ext --build-type=${ARROW_BUILD_TYPE} --bundle-arrow-cpp bdist_wheel
mkdir -p ${HOME}/wheels
cp -p ${ARROW_REPO}/python/dist/*.whl ${HOME}/wheels
popd
popd
popd
popd
