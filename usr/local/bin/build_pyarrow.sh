#!/usr/bin/env bash

export ARROW_VERSION="${1}"
export PYTHON_VERSION="${2}"
export BASE_DIR="${HOME}/arrow_${ARROW_VERSION}"
export VENV_DIR="${BASE_DIR}/venv${PYTHON_VERSION}"
export ARROW_REPO="${BASE_DIR}/arrow-apache-arrow-${ARROW_VERSION}"
export ARROW_BUILD_TYPE=release
export LOCALBASE=/usr/local
export MAKE=/usr/local/bin/gmake
export CLANG_BIN=/usr/local/bin/clang70
export CLANG_FORMAT_BIN=/usr/local/bin/clang-format70
export CLANG_TIDY_BIN=/usr/local/bin/clang-tidy70
export ARROW_HOME=${LOCALBASE}
export PARQUET_HOME=${LOCALBASE}
export CPATH=/usr/local/include
export LIBRARY_PATH=/usr/local/lib
export LD_LIBRARY_PATH=/usr/local/lib

ln -Fhvs /usr/local/lib/aws-c-common/cmake/shared /usr/local/lib/aws-c-common/cmake/static
ln -Fhvs /usr/local/lib/aws-checksums/cmake/shared /usr/local/lib/aws-checksums/cmake/static
ln -Fhvs /usr/local/lib/aws-c-event-stream/cmake/shared /usr/local/lib/aws-c-event-stream/cmake/static
 
mkdir -p ${BASE_DIR}
pushd ${BASE_DIR}
      # fetch https://github.com/apache/arrow/archive/apache-arrow-${ARROW_VERSION}.tar.gz -o arrow.tar.gz
      # tar xzf arrow.tar.gz

      if [ ! -d "${ARROW_REPO}" ]; then
            git clone https://github.com/apache/arrow.git --branch master ${ARROW_REPO}
      fi
      pushd ${ARROW_REPO}
            git checkout apache-arrow-${ARROW_VERSION}
            git submodule init
            git submodule update
            export PARQUET_TEST_DATA="${PWD}/cpp/submodules/parquet-testing/data"
            export ARROW_TEST_DATA="${PWD}/testing/data"

            if [ ! -d "${VENV_DIR}" ]; then
                  python${PYTHON_VERSION} -m venv ${VENV_DIR}
            fi
            source "${VENV_DIR}/bin/activate"
            VIRTUAL_ENV="${VENV_DIR}" PATH="${VENV_DIR}/bin:$PATH" pip install --upgrade pip
            VIRTUAL_ENV="${VENV_DIR}" PATH="${VENV_DIR}/bin:$PATH" pip install --upgrade wheel
            VIRTUAL_ENV="${VENV_DIR}" PATH="${VENV_DIR}/bin:$PATH" pip install --upgrade Cython
            if [ "${PYTHON_VERSION}" = "3.8" ]; then
                  sed -i '' 's|Py_DEPRECATED(3.8) int (\*tp_print)|int (*tp_print)|g' /usr/local/include/python3.8/cpython/object.h
            fi
            VIRTUAL_ENV="${VENV_DIR}" PATH="${VENV_DIR}/bin:$PATH" pip install --upgrade numpy
            if [ "${PYTHON_VERSION}" = "3.8" ]; then
                  easy_install pandas
            else
                  VIRTUAL_ENV="${VENV_DIR}" PATH="${VENV_DIR}/bin:$PATH" pip install --upgrade pandas
            fi
            VIRTUAL_ENV="${VENV_DIR}" PATH="${VENV_DIR}/bin:$PATH" pip install --upgrade six pytest hypothesis

            mkdir -p ${ARROW_REPO}/cpp/build
            pushd ${ARROW_REPO}/cpp/build
                  # GANDIVA -> llvm grpc
                  cmake \
                        -I${LOCALBASE}/include -L${LOCALBASE}/lib \
                        -DCMAKE_BUILD_TYPE=${ARROW_BUILD_TYPE} \
                        -DCMAKE_INSTALL_PREFIX=${ARROW_HOME} \
                        -DCMAKE_INSTALL_LIBDIR=lib \
                        -DARROW_FLIGHT=ON \
                        -DARROW_GANDIVA=ON \
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
                        VIRTUAL_ENV="${VENV_DIR}" PATH="${VENV_DIR}/bin:$PATH" python setup.py build_ext --build-type=${ARROW_BUILD_TYPE} --bundle-arrow-cpp bdist_wheel
                        mkdir -p ${HOME}/wheels
                        cp -p ${ARROW_REPO}/python/dist/*.whl ${HOME}/wheels
                  popd
            popd
      popd
popd
