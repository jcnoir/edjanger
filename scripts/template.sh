#!/bin/bash
# ----------------------------------------------------
# The MIT License (MIT)
#
# Copyright (c) 2016 copyright pamtrak06@gmail.com
# ----------------------------------------------------
# SCRIPT           : template.sh
# ALIAS            : edjangertemplate
# DESCRIPTION      : generate edjanger.poperties from edjanger.template
# CREATOR          : pamtrak06@gmail.com
# --------------------------------
# VERSION          : 1.0.3
# DATE             : 2016-11-08
# COMMENT          : creation of edjangertemplate.sh
# --------------------------------
# USAGE            : edjangertemplate
# ----------------------------------------------------
source {edjangerpath}/_common.sh

function check_export_presence_from_properties()
{
  prop_file=$1

  nbvar=$(cat $prop_file |grep "="| wc -l)
  nbexp=$(cat $prop_file |grep "export"| wc -l)

  if [ "$nbvar" = "$nbexp" ]; then
    check_export_presence_from_properties=true;
  else
    echo -e "edjanger:ERROR one or several \"export\" command are absent(s) in the previous properties, please fix it"
    echo -e "\tvariable declaration must have this form: \"export <variable name>=<value>\""
    echo -e "\tcontent of the previous properties:"
    while read line; do echo -e "\t\t$line"; done < $prop_file
    check_export_presence_from_properties=false;
  fi
}

function create_edjanger_properties()
{
  command=$1

  if [[ ! "$command" == *"properties="* ]]; then
    echo -e "edjanger:ERROR argument must be set with following form: properties=\"<basename or properties name>\"."
    return -1
  else
    configuration=${command##properties=}
  fi

  if [ ! "${configuration##*.}" = "properties" ]; then
    configuration=$configuration.properties
  fi

  if [ "${configuration}" = "edjanger" ]; then
    echo -e "edjanger:ERROR this name could not be used for this purpose. Please choose another one."
    return -1
  fi

  # Retrieve all edjanger configuration files from current directory
  listconf=$(find $PWD -name "edjanger.template")
  if [ -z "$listconf" ]; then
    echo -e "edjanger:ERROR No edjanger.template available recursively in this directory"
    return -1
  fi

  for template in ${listconf[@]}
  do

    echo -e "edjanger:INFO Process informations of template: \"${template}\"  ..."

    continue=true

    # one main configuration file
    if [ -n "${configuration}" ] && [ -f "${configuration}" ]; then

      prop_file=${configuration}
      echo -e "edjanger:INFO Use main configuration file: \"${prop_file}\"  ..."
      check_export_presence_from_properties "$prop_file"
      continue=$?

    # one configuration file by edjanger.template
    elif [ -n "${configuration}" ]; then

      working_directory=$(dirname ${template})
      prop_file=${working_directory}/${configuration}
      echo -e "edjanger:INFO Use local configuration file: \"${prop_file}\"  ..."
      check_export_presence_from_properties "$prop_file"
      continue=$?

    else

      continue=false
      echo -e "edjanger:ERROR File configuration name must exist and be set as argument"

    fi

    if [ ${continue} ]; then

      # replace variable from configuration file in template
      # if configuration file exist (global or local)
      if [ -f "${prop_file}" ]; then

        edjangerproperties=${template%.template}.properties

        # check if edjanger.properties exist
        if [ -f "${edjangerproperties}" ]; then

          echo -e "edjanger:WARNING edjanger properties file \"${edjangerproperties}\" already exist, do you want to replace it (y/n) ?"
          read response

          if [ "y" = "${response}" ]; then
            date_time=$(date +"%Y%m%d_%H%M%S")
            cp ${edjangerproperties} ${template%.template}_${date_time}.bak
            echo -e "edjanger:INFO create \"${edjangerproperties}\" file from template \"${template}\" and configuration file \"${prop_file}\""
            . ${prop_file} && envsubst < "${template}" | tee "${edjangerproperties}" > /dev/null
          fi

        # else create edjanger.properties
        else

          echo -e "edjanger:INFO create \"${edjangerproperties}\" file from template \"${template}\" and configuration file \"${prop_file}\""
          . ${prop_file} && envsubst < "${template}" | tee "${edjangerproperties}" > /dev/null

        fi
      # else configuration file doe not exist
      else
        echo -e "edjanger:ERROR properties file (${prop_file}) does not exist for template ${template}, edjanger.properties could not be created"
      fi

    else
      echo -e "edjanger:ERROR templating aborted, see previous reported errors"
    fi

  done
}

if [[ "$1" =~ ^[-]*h[a-z]* ]] || [ "$1" = "-h" ]; then
  usage $0 template
else
  create_edjanger_properties $1
fi