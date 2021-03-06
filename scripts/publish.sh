#!/bin/bash
#
# Author:: Lance Albertson <lance@osuosl.org>
# Copyright:: Copyright 2020, Cinc Project
# License:: Apache License, Version 2.0
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
source scripts/common.sh
arch="$(uname -m)"
cat << EOF > /tmp/docker-token
$DOCKER_TOKEN
EOF
cat /tmp/docker-token | docker login --username $DOCKER_USERNAME --password-stdin
rm -rf /tmp/docker-token
set -ex

for version in ${VERSIONS} ; do
  for arch in ${ARCHS} ; do
    supported_platform $CINC_IMAGE $version $arch || continue
    test_image="${CI_REGISTRY_IMAGE}/${CINC_IMAGE}:${version}-${arch}-${CI_COMMIT_SHORT_SHA}"
    prod_image="cincproject/${CINC_IMAGE}:${version}-${arch}"
    docker pull ${test_image}
    docker tag ${test_image} ${prod_image}
    docker push ${prod_image}
  done
done
