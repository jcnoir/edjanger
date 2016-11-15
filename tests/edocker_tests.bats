#!/usr/bin/env bats

@test "edocker init: presence edocker.properties" {
  shopt -s expand_aliases
  . ../edocker.alias
  TMP=tmp_edockerinit
  rm -rf $TMP &&  mkdir $TMP && cd $TMP
  . ../../scripts/init.sh
  result="$(ls edocker.properties)"
  [ -n "$result" ]
  cd ..
  rm -rf $TMP
}

@test "edocker init test: presence build/Dockerfile" {
  shopt -s expand_aliases
  . ../edocker.alias
  TMP=tmp_edockerinit
  rm -rf $TMP &&  mkdir $TMP && cd $TMP
  . ../../scripts/init.sh
  result="$(ls build/Dockerfile)"
  [ -n "$result" ]
  cd ..
  rm -rf $TMP
}

@test "edockerbuild: is image built" {
  shopt -s expand_aliases
  . ../edocker.alias
  TMP=tmp_edockerinit
  rm -rf $TMP &&  mkdir $TMP && cd $TMP
  . ../../scripts/init.sh
  echo "FROM httpd" > build/Dockerfile
  PROP=edocker.properties
  TMPP=edocker.tmp
  sed -e "s/\(docker_command=\.*\)/#\1/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep docker_command
  sed -e "s/\(image_name=\).*/\1\"pamtrak06\/webtest\"/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep image_name
  sed -e "s/\(container_name=\).*/\1\"webtest\"/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep container_name
  sed -e "s/\(exposed_ports=\.*\)/#\1/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep exposed_ports
  sed -e "s/\(shared_volumes=\.*\)/#\1/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep shared_volumes
  . ../../scripts/build.sh
  result="$(docker images | grep pamtrak06/webtest )"
  [ -n "$result" ]
  cd ..
  rm -rf $TMP
  docker rmi pamtrak06/webtest
}

@test "edocker run: is container running" {
  shopt -s expand_aliases
  . ../edocker.alias
  TMP=tmp_edockerinit
  rm -rf $TMP &&  mkdir $TMP && cd $TMP
  . ../../scripts/init.sh
  echo "FROM httpd" > build/Dockerfile
  PROP=edocker.properties
  TMPP=edocker.tmp
  sed -e "s/\(docker_command=\.*\)/#\1/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep docker_command
  sed -e "s/\(image_name=\).*/\1\"pamtrak06\/webtest\"/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep image_name
  sed -e "s/\(container_name=\).*/\1\"webtest\"/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep container_name
  sed -e "s/\(exposed_ports=\.*\)/#\1/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep exposed_ports
  sed -e "s/\(shared_volumes=\.*\)/#\1/" $PROP > $TMPP && mv $TMPP $PROP
  . ../../scripts/build.sh
  . ../../scripts/run.sh
  result="$(docker ps | grep webtest_1 )"
  [ -n "$result" ]
  cd ..
  rm -rf $TMP
  docker stop $(docker ps -q --filter="name=webtest*")
  docker rm $(docker ps -aq --filter="name=webtest*")
  docker rmi pamtrak06/webtest
}

@test "edocker exec: is exec in container ok" {
  skip
  shopt -s expand_aliases
  . ../edocker.alias
  TMP=tmp_edockerinit
  rm -rf $TMP &&  mkdir $TMP && cd $TMP
  . ../../scripts/init.sh
  echo "FROM httpd" > build/Dockerfile
  PROP=edocker.properties
  TMPP=edocker.tmp
  sed -e "s/\(docker_command=\.*\)/#\1/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep docker_command
  sed -e "s/\(image_name=\).*/\1\"pamtrak06\/webtest\"/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep image_name
  sed -e "s/\(container_name=\).*/\1\"webtest\"/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep container_name
  sed -e "s/\(exposed_ports=\.*\)/#\1/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep exposed_ports
  sed -e "s/\(shared_volumes=\.*\)/#\1/" $PROP > $TMPP && mv $TMPP $PROP
  . ../../scripts/build.sh
  . ../../scripts/run.sh
  . ../../scripts/exec.sh
  result="$(uname -r)"
  exit
  [[ "$result" == *"docker"* ]]
  cd ..
  rm -rf $TMP
  docker stop $(docker ps -q --filter="name=webtest*")
  docker rm $(docker ps -aq --filter="name=webtest*")
  docker rmi pamtrak06/webtest
}

@test "edocker start/stop: start/stop container ok" {
  shopt -s expand_aliases
  . ../edocker.alias
  TMP=tmp_edockerinit
  rm -rf $TMP &&  mkdir $TMP && cd $TMP
  . ../../scripts/init.sh
  echo "FROM httpd" > build/Dockerfile
  PROP=edocker.properties
  TMPP=edocker.tmp
  sed -e "s/\(docker_command=\.*\)/#\1/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep docker_command
  sed -e "s/\(image_name=\).*/\1\"pamtrak06\/webtest\"/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep image_name
  sed -e "s/\(container_name=\).*/\1\"webtest\"/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep container_name
  sed -e "s/\(exposed_ports=\.*\)/#\1/" $PROP > $TMPP && mv $TMPP $PROP
  cat edocker.properties | grep exposed_ports
  sed -e "s/\(shared_volumes=\.*\)/#\1/" $PROP > $TMPP && mv $TMPP $PROP
  . ../../scripts/build.sh
  . ../../scripts/run.sh
  result="$(docker ps | grep webtest_1 )"
  [ -n "$result" ]
  . ../../scripts/stop.sh
  result="$(docker ps --filter="status=exited" | grep webtest_1 )"
  [ -n "$result" ]
  . ../../scripts/start.sh
  result="$(docker ps --filter="status=running" | grep webtest_1 )"
  [ -n "$result" ]
  cd ..
  rm -rf $TMP
  docker stop $(docker ps -q --filter="name=webtest*")
  docker rm $(docker ps -aq --filter="name=webtest*")
  docker rmi pamtrak06/webtest
}
