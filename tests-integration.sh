#!/bin/bash
set -e

export VERSION=`xmlstarlet sel -t -v /_:project/_:version pom.xml`

function clean_docker {
    echo "===> stop it-demo server"
    docker-compose down
    echo "===> clean maven repository"
	docker run --rm \
		-w /opt/maven \
		-v $PWD:/opt/maven \
		-v $HOME/.m2:/root/.m2 \
		maven:3.5.0-jdk-8 \
		mvn clean
}

function clean_exit {
    ARG=$?
	echo "===> Exit status = ${ARG}"
    clean_docker
    exit $ARG
}
trap clean_exit EXIT

# CLEAN
echo "===> kill/rm old containers if needed"
clean_docker

# PACKAGE
echo "===> compile it-demo"
docker run --rm \
    -w /opt/maven \
	-v $PWD:/opt/maven \
	-v $HOME/.m2:/root/.m2 \
	maven:3.5.0-jdk-8 \
	mvn clean install
echo "it-demo:${VERSION}"

# BUILD
echo "===> build it-demo docker image"
docker build --build-arg version=${VERSION} --tag=sfalquier/it-demo:${VERSION} .

echo "===> start it-demo server"
docker-compose up -d
docker network ls

echo "===> wait for it-demo up and running"
docker run --net itdemo_default --rm busybox sh -c 'i=1; until nc -w 2 it-demo 8080; do if [ $i -lt 30 ]; then sleep 1; else break; fi; i=$(($i + 1)); done'

# TEST
echo "===> run integration tests"
docker run --rm \
	-w /opt/maven \
	-v $PWD:/opt/maven \
	-v $HOME/.m2:/root/.m2 \
	-e HOST="it-demo" \
	-e PORT="8080" \
	--net itdemo_default \
	maven:3.5.0-jdk-8 \
	mvn install -DskipTests=false
