ARG VERSION="2"
FROM amazonlinux:${VERSION}
LABEL MAINTAINER="Cinc Project <maintainers@cinc.sh>"

ARG TOOLCHAIN_VERSION="1.1.109"
ARG JDK_VER="11"

RUN yum -y upgrade && \
    yum -y install curl wget ca-certificates tar hostname iproute rsync openssh-clients rpm-build \
        java-${JDK_VER}-amazon-corretto-headless && \
    # Eventually, we will install cinc
    curl -L https://www.chef.io/chef/install.sh | bash -s -- -v 14 && \
    mkdir -p /var/chef/cache /var/chef/cookbooks && \
    wget -qO- https://supermarket.chef.io/cookbooks/omnibus/download | tar xzC /var/chef/cookbooks && \
    for dep in windows mingw build-essential chef-sugar chef-ingredient git homebrew remote_install seven_zip wix; do \
        wget -qO- https://supermarket.chef.io/cookbooks/${dep}/download | tar xzC /var/chef/cookbooks; done && \
    echo "{\"omnibus\":{\"toolchain_version\":\"${TOOLCHAIN_VERSION}\"}}" > /tmp/attr.json && \
    chef-solo -o 'recipe[omnibus]' -j /tmp/attr.json && \
    rm -rf /tmp/attr.json && \
    sed -i -e 's/^env.*//' /home/omnibus/load-omnibus-toolchain.sh && \
    yum -y remove chef && rm -rf /var/chef/ /opt/chef/embedded/ /etc/chef && \
    yum clean all && rm -rf /var/cache/yum
