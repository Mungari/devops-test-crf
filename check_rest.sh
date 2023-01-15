#!/bin/bash
Help()
{
   # Display Help
   echo "This script checks for a rest endpoint and reloads a service on this server if the responses are 4xx or 5xx."
   echo
   echo "Syntax: checkservice [-p|-s|-h]"
   echo "options:"
   echo "-p    Endpoint to check."
   echo "-s    Service to reload."
   echo "-h    Print help."
   echo
}

process_arguments() {
    if [[ -z "$1" ]];
    then
    Help
    exit 1
    fi

    while [ -n "$1" ]
    do
        case $1 in
            -h|--help) Help; exit 1;;
            -p) export endpoint=$2; shift; shift; ;;
            -s) export service=$2; shift; shift; ;;
            *) Help; exit 1;;
        esac
    done
}

################################################################################
################################################################################
# Main program                                                                 #
################################################################################
################################################################################

process_arguments "$@"
status_codes=(200 302 301)

response=$(curl --write-out '%{http_code}' --silent --output /dev/null $endpoint)
retries=5
if [[ ! " ${status_codes[*]} " =~ " ${response} " ]]; then
    while [[ max_retries -ne 0 ]];
    do
    response=$(curl --write-out '%{http_code}' --silent --output /dev/null $endpoint)
    if [[ ! " ${status_codes[*]} " =~ " ${response} " ]]; then
        echo "response is $response, polling... $retries left"
        sleep 2
        ((max_retries=max_retries-1))
    else
        echo "response is $response, service reachable, exiting..."
        max_retries=0
        exit 0
    fi
    done
    echo "response is $response, service unavailable, restarting service $service"
    systemctl restart $service
else
    echo "service is reachable at $endpoint status is $response , exiting.."
    exit 0
fi