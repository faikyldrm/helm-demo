# helm-demo

You can find chart in [helm](/helm) folder. This chart use [bitnami/rabbitmq](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq) as dependecy. You can override [values.yaml](/values.yaml) file for any rabbitmq configuration.

In this repo we have two application named [producer](/producer) and [consumer](/consumer) both written in golang.
Producer application produce message and send it to rabbitmq.
Consumer application consume message wich sent by producer app.
Both application has own dockerfile and both app run in alpine image.

Prebuild images can find in here for [producer](https://hub.docker.com/r/faikyildirim/demoproducer) and [consumer](https://hub.docker.com/r/faikyildirim/democonsumer) Details can be found under the apps folder.

Shellscripts install below apps;

1- Docker

2- Minikube

3- kubectl

4- Helm

5- Poc application install with helm

Steps to execute:

clone repo

```bash
git clone https://github.com/faikyldrm/helm-demo.git 
```

file execution permission
```bash
chmod +x rootless-docker.sh
chmod +x installAllComponents.sh
```
install docker
```bash
./rootless-docker.sh
```
update bashrc profile
```bash
. ~/.bashrc
```
install other components
```bash
./installAllComponents.sh
```
installAllComponents includes

Helm cli

Kubectl

minikube

Helm chart

