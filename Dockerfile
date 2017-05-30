#FROM rhel7.3:latest
FROM centos7:latest
MAINTAINER Steven Zinck <steven.zinck@novascotia.ca>
LABEL Description="This image is the base for GitLab CI for Ansible" Vendor="ICT Services" 

ENV PATH=/opt/rh/rh-python35/root/usr/bin${PATH:+:${PATH}}
ENV LD_LIBRARY_PATH=/opt/rh/rh-python35/root/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
ENV MANPATH=/opt/rh/rh-python35/root/usr/share/man:${MANPATH}
ENV PKG_CONFIG_PATH=/opt/rh/rh-python35/root/usr/lib64/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}
ENV XDG_DATA_DIRS=/opt/rh/rh-python35/root/usr/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}

RUN yum --enablerepo=* install -y rubygems git createrepo ruby-devel docker docker-client sudo openssl-devel libffi-devel gcc rh-python35-python-devel rh-python35-python rh-python35-pip 

RUN gem install --no-rdoc --no-ri \
 	bundle \
	test-kitchen \
	kitchen-verifier-serverspec \
	kitchen-docker \
	kitchen-ansible \
	serverspec 

RUN pip3 install ansible-lint && pip3 install --upgrade setuptools && pip3 install ansible-review
RUN mkdir /etc/ansible
ADD ansible.cfg /etc/ansible/ansible.cfg
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts
