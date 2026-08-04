#!/bin/bash

clear

source "./scripts/functions.sh"

ERROR_FOUND=""

if [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: OPENAI_API_KEY is not in environment"
    ERROR_FOUND="1"
fi

if [ -z "$OPENAI_MODEL" ]; then
    echo "Error: OPENAI_MODEL is not in the environment"
    ERROR_FOUND="1"
fi

if [ -n "${ERROR_FOUND}" ]; then
    echo "Please, solve the error previously mentioned to execute the program"
    exit 1
fi

json_file="./artifacts/model_list.json"

if validate_model  "${OPENAI_MODEL}"  "${json_file}"; then
    bash ./scripts/execute_api_v1_responses.sh
else
    echo "Initialization Failed..."
    exit 1
fi

 

echo "######################################## Ending BashGPT ######################################## "
