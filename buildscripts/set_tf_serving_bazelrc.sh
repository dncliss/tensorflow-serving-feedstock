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
BAZEL_RC_DIR=$1

#Determine architecture for specific options
ARCH=`uname -p`

## ARCHITECTURE SPECIFIC OPTIMIZATIONS
## These are settings and arguments to pass to GCC for
## optimization settings specific to the target architecture
##
OPTION_1=''
OPTION_2=''
if [[ "${ARCH}" == 'x86_64' ]]; then
    OPTION_1='-march=nocona'
    OPTION_2='-mtune=haswell'
fi
if [[ "${ARCH}" == 'ppc64le' ]]; then
    OPTION_1='-mcpu=power8'
    OPTION_2='-mtune=power8'
fi

SYSTEM_LIBS_PREFIX=$PREFIX
cat >> $BAZEL_RC_DIR/tensorflow-serving.bazelrc << EOF
import %workspace%/tensorflow_serving/python_configure.bazelrc
build:opt --copt="${OPTION_1}"
build:opt --copt="${OPTION_2}"
build:opt --host_copt="${OPTION_1}"
build:opt --host_copt="${OPTION_2}"
build --strip=always
build --color=yes
build --verbose_failures
build --spawn_strategy=standalone
EOF
