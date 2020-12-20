# Wordpress OKD / Openshift implementation

This project is trying to implement an easy and secure way for Wordpress on Openshift / OKD

The goals were:

- Use reliable base images (UBI8 & CentOS)
- make upgrades easy
- make it easy to understand (it's also part of an Openshift Workshop)
- make it customizable in wordpress: plug-ins, themes, ...
- updates of the core wordpress should require a container rebuild
- container builds via openshift docker builds

## Implement a secure clean wordpress installation

Always inspect all the yaml files first:

- look for object names
- ConfigMap and Secret values
- play special attention to the image paths!

## make wordpress container

First install the bitbucket pull secret for the BRZ repo: `oc apply -f Secret_bitbucket-pull-ssh.yaml`

- download wordpress `curl -L -o wordpress-container/wordpress.tar.gz https://wordpress.org/latest.tar.gz`
- run a docker build in the ./wordpress-container/ dir or
- `oc apply -f wordpress-container/BuildConfig_wordpress-container.yaml`

## get a suitable mariadb container

- The easy way: `oc import-image quay.io/centos7/mariadb-103-centos7:latest --confirm`
- The complete way:

        ```shell
        podman pull quay.io/centos7/mariadb-103-centos7:latest
        oc create imagestream mariadb-103-centos7
        podman tag quay.io/centos7/mariadb-103-centos7:latest default-route-openshift-image-registry.apps.fangorn.pfpk.pro/brz-ws-paas/mariadb-103-centos7:latest
        podman login -u $(oc whoami) -p $(oc whoami -t) default-route-openshift-image-registry.apps.fangorn.pfpk.pro 
        ```

## create Openshift / OKD objects

`oc apply -f openshift/`

## Enter your install

- Look to the Route element
- Go for http first, https and Wordpress is not so easy ;-)

---
Peter Pfläging <peter@pflaeging.net>

Public Source: <https://github.com/pflaeging/wordpress-okd.git>

<https://www.pflaeging.net>
