# rhel7-docker-ansibleci
RHEL 7 base image + ansible, ansible-review &amp; ansible-lint
.kitchen.yml - the test kitchen yml file we use.  driver is docker, provisioner ansible_playbook and verifier is serverspec
.gitlab-ci.yml - gitlab ci configuration for above
