#!/bin/bash
# ----------------------------------------------------
# The MIT License (MIT)
#
# Copyright (c) 2016 copyright pamtrak06@gmail.com
# ----------------------------------------------------
# SCRIPT           : exec.sh
# DESCRIPTION      : docker exec script (read parameters from edocker.cfg)
# CREATOR          : pamtrak06@gmail.com
# --------------------------------
# VERSION          : 1.0
# DATE             : 2016-03-02
# COMMENT          : creation
# --------------------------------
# USAGE            : alias edockerexec
# ----------------------------------------------------

if [ ! -f edocker.cfg ]; then
  echo -e "edocker:ERROR No edocker.cfg available, use \"<edockerinit>\" command to initialize one in this directory"
else
  source edocker.cfg
  idx=$(echo "$(docker ps | grep ${image_name} | wc -l)+0" | bc)
  echo enter in container_name: ${container_name}_${idx}...
  if [ -n "$1" ]; then
    docker exec -t ${container_name}_${idx} bash -c "$1" 
  else
    docker exec -it ${container_name}_${idx} bash
  fi
fi
