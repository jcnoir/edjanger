#!/bin/bash
##  Description
##     Inspect changes on a container's filesystem.
##     
##     Filtered by edjanger.properties$container_name.
##     File edjanger.properties must be present in path.
##     By default executed on last container if no index specified.
##  
##  Usage
##    @script.name[option]
##  
##  Options
##     -h, --help
##            Display help.
##  
##         --index=INDEX
##            Index of the container name.
##  
##  Parameters (edjanger.properties):
##     container_name
##       Container name.
##  
##     diff_options
##       Options of "docker diff" for a running container (see docker diff --help)
##  
##     docker_command
##            Display docker command.
##  
##  Licence & authors
##     edjanger, The MIT License (MIT)
##     Copyright (c) 2016 copyright pamtrak06@gmail.com
##  
# ------------------------------------------------------------------------------
###
### External options:
##     -h, --help
##            Display help.
###
###        --index=INDEX
###            Index of the container name.
###
### Internal options:
###
###        --scriptname=SCRIPT
###            Name of the main script.
###
###        --commandline=COMMAND
###            Name of the docker command to execute.
###
###        --commandcomment=COMMAND
###            Printed comment of the command to execute.
###
###        --commandoptions=OPTIONS
###            Options read in the edjanger.properties.
###
# ------------------------------------------------------------------------------
checkinstall=$(cat $0|grep -v checkinstall|grep "edjangerpath")
[ -n "$checkinstall" ]             && echo "edjanger:ERROR: Bad edjanger configuration, please run ./edjangerinstall.sh --alias from edjanger path" && exit -1

source {edjangerpath}/_common.sh

read_app_properties

# check required configuration
[ -z "${container_name}" ]          && echo "Container name must be filled, configure variable container_name in edjanger.${config_extension}" && exit -1

[ -n "${diff_options}" ]            && commandoptions="${commandoptions} ${diff_options}"
[ -n "${container_name}" ]          && commandoptions="${commandoptions} {container_name}"
[ -n "${commandoptions}" ]          && commandoptions="--commandoptions=\"${commandoptions}\""
[[ -n "$@" ]]                       && externaloptions=$(echo $@ | sed "s|[[:space:]](.*)=(.*)|;$1=$2|g") \
                                    && externaloptions=$(echo $externaloptions | sed "s|[[:space:]]--|;--|g") \
                                    && externaloptions=$(echo $externaloptions | sed "s|[[:space:]]-|;-|g")
dockerbasiccontainer "--scriptname=\"$0\";--commandline=\"diff\";--commandcomment=\"Do a diff of container: {container_name}...\";${commandoptions};${externaloptions}"

