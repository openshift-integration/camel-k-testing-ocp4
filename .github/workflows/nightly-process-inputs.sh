#!/bin/bash

# ---------------------------------------------------------------------------
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ---------------------------------------------------------------------------

set -e

#
# Used to unit testing this script
#
if [ -z "$GITHUB_ENV" ]; then
  GITHUB_ENV="/tmp/GITHUB_ENV"
  rm -f "${GITHUB_ENV}"
fi

while getopts ":i:n:s:p:t:" opt; do
  case "${opt}" in
    i)
      PRE_BUILT_IMAGE=${OPTARG}
      ;;
    n)
      SAVE_FAILED_NAMESPACES=${OPTARG}
      ;;
    s)
      SKIP_TEST_SUITES=${OPTARG}
      ;;
    p)
      SKIP_PROBLEMATIC=${OPTARG}
      ;;
    t)
      TEST_FILTERS=${OPTARG}
      ;;
    :)
      echo "ERROR: Option -$OPTARG requires an argument"
      exit 1
      ;;
    \?)
      echo "ERROR: Invalid option -$OPTARG"
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

if [ -n "${PRE_BUILT_IMAGE}" ]; then
  echo "DEBUG_USE_EXISTING_IMAGE=${PRE_BUILT_IMAGE}" >> $GITHUB_ENV
fi

#
# Save failed namespaces by default for the moment
#
if [ -z "${SAVE_FAILED_NAMESPACES}" ] || [ "${SAVE_FAILED_NAMESPACES}" == "true" ]; then
  echo "CAMEL_K_TEST_SAVE_FAILED_TEST_NAMESPACE=true" >> $GITHUB_ENV
fi

if [ -n "${SKIP_TEST_SUITES}" ]; then
  toskip=($(echo ${SKIP_TEST_SUITES} | tr "," "\n"))

  #Print the split string
  for skip in "${toskip[@]}"
  do
    echo "Skipping tests ${skip}"
    echo "SKIP_${skip}=true" >> $GITHUB_ENV
  done
fi

#
# Avoid problematic tests in scheduled executions and if parameter set to true
#
if [ -z "${SKIP_PROBLEMATIC}" ] || [ "${SKIP_PROBLEMATIC}" == "true" ]; then
  echo "CAMEL_K_TEST_SKIP_PROBLEMATIC=true" >> $GITHUB_ENV
fi

#
# Adds -run args to filter tests in test suites
#
if [ -n "${TEST_FILTERS}" ]; then
  filters=($(echo ${TEST_FILTERS} | tr "," "\n"))

  #Print the split string
  for filter in "${filters[@]}"
  do
    pair=($(echo ${filter} | tr "=" " "))
    echo "Adding run filter for ${pair[0]} tests"
    echo "${pair[0]}=-run ${pair[1]}" >> $GITHUB_ENV
  done
fi
