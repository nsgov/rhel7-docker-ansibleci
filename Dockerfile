FROM rhel7/rhel
MAINTAINER Paul Badcock <paul.badcock@novascotia.ca>
LABEL Description="Container for for Ansible CI/CD" Vendor="ICT Services"

ENV PATH=/opt/rh/python27/root/usr/bin/${PATH:+:${PATH}}

RUN yum --enablerepo=* install -y \
    ca-certificates openssh-clients curl sqlite-devel \
    wget vim hostname rubygems ruby ruby-libs ruby-devel \
    git-core zlib zlib-devel gcc-c++ patch readline \
    readline-devel libffi-devel openssl-devel libyaml-devel \
    make bzip2 autoconf automake libtool bison \
    docker-client sudo \
    python27-python-devel python27-python-pip \
    && yum clean all && rm -rf /var/cache/yum

RUN gem install --no-rdoc --no-ri bundle
ADD Gemfile .
RUN bundle

RUN scl enable python27 'pip2 install ansible-lint ansible-review'

ADD ansible /etc/ansible
