#!/bin/bash
set -exuo pipefail

cmake -B build -GNinja ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DCMAKE_CXX_SCAN_FOR_MODULES=OFF \
    -DSLANG_INCLUDE_TOOLS=ON \
    -DSLANG_INCLUDE_TESTS=OFF \
    -DSLANG_INCLUDE_DOCS=OFF \
    -DSLANG_INCLUDE_PYLIB=OFF \
    -DSLANG_INCLUDE_INSTALL=ON \
    -DSLANG_USE_MIMALLOC=ON \
    -DBUILD_SHARED_LIBS=ON \
    -DSLANG_USE_SYSTEM_FMT=ON \
    -DSLANG_USE_SYSTEM_BOOST=ON \
    -DFETCHCONTENT_FULLY_DISCONNECTED=ON \
    -DFETCHCONTENT_SOURCE_DIR_TOMLPLUSPLUS="${SRC_DIR}/tomlplusplus" \
    -DFETCHCONTENT_SOURCE_DIR_MIMALLOC="${SRC_DIR}/mimalloc" \
    .

cmake --build build -j${CPU_COUNT}
cmake --install build

# mimalloc is linked statically; drop the files its install rules add
rm -rf "${PREFIX}"/include/mimalloc-* "${PREFIX}"/lib/mimalloc-* "${PREFIX}"/lib/cmake/mimalloc-* "${PREFIX}"/lib/pkgconfig/mimalloc.pc
