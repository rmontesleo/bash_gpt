#!/bin/bash

clear

source "./scripts/functions.sh"

if ! check_required_envs "OPENAI_API_KEY" "OPENAI_MODEL" ; then
    exit 1
fi

json_file="./artifacts/model_list.json"

if validate_model  "${OPENAI_MODEL}" "${json_file}"; then
    bash ./scripts/execute_api_v1_responses.sh
else
    echo "Initialization Failed: Model validation did not pass." >&2
    exit 1
fi



echo "######################################## Ending BashGPT ######################################## "
