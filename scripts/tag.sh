#!/bin/bash
##  Description 
##    Tag an image into a repository.
##     
##    Filtered by edjanger.properties$container_name.
##    File edjanger.properties must be present in path.
##    By default executed on last container if no index specified.
##  
##  Usage
##    @script.name[option]
##  
##  Options
##     -h, --help
##            Display help.
##  
##  Parameters (edjanger.properties):
##     container_name
##            Container name.
##  
##     tag_options
##            Options of "docker tag" for a running container.
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
[ -z "${image_name}" ]                         && echo "Image name must be filled, configure variable image_name in edjanger.${config_extension}" && exit -1

[ -n "${tag_options}" ]             && commandoptions="${commandoptions} ${tag_options}"
[[ -n "$@" ]]                       && externaloptions=$(echo $@ | sed "s|[[:space:]](.*)=(.*)|;$1=$2|g") \
                                    && externaloptions=$(echo $externaloptions | sed "s|[[:space:]]--|;--|g") \
                                    && externaloptions=$(echo $externaloptions | sed "s|[[:space:]]-|;-|g")
confirm_question="Image \"{image_name}\" will be tagged, do you want to continue (y/n) ?"
dockerbasicimage "--scriptname=\"$0\";--commandline=\"tag {image_name}\";--commandcomment=\"Tag image: {image_name}...\";${commandoptions};--confirm;--confirmquestion=\"$confirm_question\";${externaloptions}"

