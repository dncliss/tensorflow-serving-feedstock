#!/bin/bash
# *****************************************************************
# (C) Copyright IBM Corp. 2020, 2021. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# *****************************************************************
set -ex
# Set python path variables from conda build environment
BAZEL_RC_DIR=$1
cat > $BAZEL_RC_DIR/python_configure.bazelrc << EOF
build --incompatible_use_python_toolchains=false
build --action_env PYTHON_BIN_PATH="$PYTHON"
build --action_env PYTHON_LIB_PATH="$SP_DIR"
build --action_env PATH="$PREFIX/bin:$PATH"
build --python_path="$PYTHON"
EOF

ARCH=`uname -p`
if [[ "${ARCH}" == 's390x' ]]; then
cat > $BAZEL_RC_DIR/python_configure.bazelrc << EOF
build --action_env CC="$PREFIX/gcc"
build --action_env CXX="$PREFIX/g++"
EOF
fi
