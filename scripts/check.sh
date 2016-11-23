#!/bin/bash
# ----------------------------------------------------
# The MIT License (MIT)
#
# Copyright (c) 2016 copyright pamtrak06@gmail.com
# ----------------------------------------------------
# SCRIPT           : check.sh
# ALIAS            : edjangercheck
# DESCRIPTION      : check missing parameters in edjanger.properties
# CREATOR          : pamtrak06@gmail.com
# --------------------------------
# VERSION          : 1.0
# DATE             : 2016-03-02
# COMMENT          : creation
# --------------------------------
# USAGE            : edjangercheck
# ----------------------------------------------------
source {edjangerpath}/_common.sh

if [[ "$1" =~ ^[-]*h[a-z]* ]] || [ "$1" = "-h" ]; then
  usage $0 check
else
  if [ -f "edjanger.${config_extension}" ] && [ "{edjangerpath}" != "$PWD" ]; then
    echo -e "Check edjanger.${config_extension}..."
    checkconfig
    if [ "$?" != "255" ]; then
      echo -e "  => STATUS of configuration is: OK"
    else
      echo -e "  => STATUS of configuration is: some parameters are undefined"
    fi
  fi
fi