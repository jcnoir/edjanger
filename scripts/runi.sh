#!/bin/bash
##  Run a container interactively. File edjanger.properties must be present in path.
##  By default runi last container if no index specified.
##  
##  Usage:
##     @script.name [option]
##  
##  Options:
##     -h, --help                     print this documentation.
##
##         --index=INDEX              index of the container name.
##  
##  Parameters (edjanger.properties):
##     runi_options                   other runi options.
##  
##  edjanger, The MIT License (MIT)
##  Copyright (c) 2016 copyright pamtrak06@gmail.com
##  
# ------------------------------------------------------------------------------
###
### External options:
###    -h, --help                     print this documentation.
###
###        --index=INDEX              index of the container name.
###
### Internal options:
###
###        --script=SCRIPT            name of the main script
###
###        --command=COMMAND          name of the docker command to execute
###
###        --commandcomment=COMMAND  printed comment of the command to execute
###
###        --commandoptions=OPTIONS  options read in the edjanger.properties
###
# ------------------------------------------------------------------------------
source {edjangerpath}/_common.sh

read_app_properties
[ -n "${run_other_options}" ]                  && commandoptions="${commandoptions} ${run_other_options}"
[ -n "${network_settings}" ]                   && commandoptions="${commandoptions} ${network_settings}"
[ -n "${runtime_constraints_on_resources}" ]   && commandoptions="${commandoptions} ${runtime_constraints_on_resources}"
[ -n "${exposed_ports}" ]                      && commandoptions="${commandoptions} ${exposed_ports}"
[ -n "${volumes_from}" ]                       && commandoptions="${commandoptions} ${volumes_from}"
[ -n "${shared_volumes}" ]                     && commandoptions="${commandoptions} ${shared_volumes}"
[ -n "${environment_variables}" ]              && commandoptions="${commandoptions} ${environment_variables}"
[ -n "${linked_containers}" ]                  && commandoptions="${commandoptions} ${linked_containers}"
[ -n "${image_name}" ]                         && commandoptions="${commandoptions} ${image_name}"
[ -n "${command_run}" ]                        && command_run="/bin/bash"
[ -n "${command_run}" ]                        && commandoptions="${commandoptions} ${command_run}"
[ -n "${commandoptions}" ]                     && commandoptions="--commandoptions=\"${commandoptions}\""
dockerbasiccontainer "--scriptname=\"$0\";--command=\"run -it --name {container_name}\";--commandcomment=\"Create new container and enter intercative: {container_name}...\";${commandoptions};$@"



