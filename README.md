# RHEL 7 image + Ansible CI/CD tooling
This repository provides a Docker container based upon RedHat Enterprise Linux 7 images.

## Pre-req
You need to make sure you have the following:
* Locally hosted [GitLab instance](https://about.gitlab.com/installation/)
* GitLab [container registry](https://docs.gitlab.com/ee/administration/container_registry.html) enabled
* [GitLab runner](https://docs.gitlab.com/runner/) that has access to a Docker executor in [privileged mode](https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runners-docker-section) tagged as "docker".
* Accessible Docker daemon via TCP for the DIND to access privlieged containers for Test-Kitchen.
* GitLab hosted Ansible code repositories following [best practices directory layout](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#directory-layout)

## Container Installation
To use this container you can perform the following steps
* Clone this project to your GitLab instance.
* Edit the .gitlab-cli.yml and replace
```
  NAME_SPACE: "INTERNAL_GITLAB_GROUP"
  DOCKER_REGISTRY: "INTERNAL_GITLAB_INSTANCE"
  DOCKER_HOST: "tcp://INTERNAL_DOCKER_NODE:4243"
```
With your local information eg:
```
  NAME_SPACE: "devops"
  DOCKER_REGISTRY: "gitlab-registry.mydomain.com"
  DOCKER_HOST: "tcp://docker-a1.mydomain.com:4243"
```
* Confirm the Pipeline builds the container and press the play button to tag it as "latest"
* Confirm you can access and run the container with docker commands eg: `docker run -it gitlab-registry.mydomain.com/devops/rhel7-docker-ansibleci ansible --version`

## CI/CD Setup
Now that you have a pre-baked locally hosted container with ansible tooling you can use it for testing an ansible repository

The **examples** folder has sample example files you can copy to your local project for CI/CD testing.

* Edit the .gitlab-ci.yml and replace
```
image: INTERNAL_REGISTRY_TLD/NAMESPACE/rhel7-docker-ansibleci:latest
```
With your local information eg:
```
image: gitlab-registry.mydomain.com/devops/rhel7-docker-ansibleci:latest
```

## CI/CD usage
Once set the CI/CD runner should execute the container and run the basic "ansible-playbook --syntax-check" on the first level playbooks in the directory.

The next stage in "Review" will execute [ansible-lint](https://github.com/willthames/ansible-lint) and [ansible-review](https://github.com/willthames/ansible-review).
* Ansible-Lint will give you most of the best practices and things to improve.
* Ansible-Review will give you a framework to test standards Ansible should be written to. Note this is totally customizable and the .ansible-review folder holds the configuration with the option to point to custom rules.

The final stage "Integration" is using [test-kitchen](https://kitchen.ci/) to test your playbooks or roles on a Docker container to validate the changes with [InSpec](https://www.inspec.io/)

**TODO**
