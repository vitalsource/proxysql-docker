#!/bin/bash

# Copyright 2014 The Kubernetes Authors.
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

# Encodes the environment variables into a Kubernetes secret.

show_usage() {
  echo ""
  echo -e "Usage: $0 <filename>"
  echo "Where <filename> is the proxysql config you'd like to encode."
  echo ""
}

if [ $# -lt 1 ]
then
 show_usage
 exit 1
fi

BASE64_ENC=$(cat $1 | base64 | tr -d '\n')
sed -e "s#{{config_data}}#${BASE64_ENC}#g" ./proxysql-config-secret-tmpl.yaml > proxysql-config-secret.yaml
