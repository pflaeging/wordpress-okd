# Implement a secure clean wordpress installation

## make wordpress container

- download wordpress `curl -L -o wordpress-container/wordpress.tar.gz https://wordpress.org/latest.tar.gz`
- run a docker build in the ./wordpress-container/ dir

## get a suitable mariadb container

```shell
podman pull quay.io/centos7/mariadb-103-centos7:latest
oc create imagestream mariadb-103-centos7
podman tag quay.io/centos7/mariadb-103-centos7:latest default-route-openshift-image-registry.apps.fangorn.pfpk.pro/brz-test/mariadb-103-centos7:latest
podman login -u $(oc whoami) -p $(oc whoami -t) default-route-openshift-image-registry.apps.fangorn.pfpk.pro 
```

## create Openshift / OKD objects

## Enter your install

