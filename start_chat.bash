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


echo "Validating Model model before start"

response_file=$(mktemp)

http_code=$( curl --silent --show-error \
    --output "$response_file" \
    --write-out "%{http_code}" \
    "https://api.openai.com/v1/models/${OPENAI_MODEL}" \
    --header "Authorization: Bearer ${OPENAI_API_KEY}"  )

response_body=$(cat $response_file)

rm -f "$response_file"

echo "Status Code: ${http_code}"
echo "Response: ${response_body}"

if [ "${http_code}" -ne 200  ]; then
    echo "Error, API call failed with HTTP status code ${http_code}"
    echo "Verify your OPENAI_API_KEY is still valid or the model you try to use"
    exit 1
fi

bash ./scripts/execute_api_v1_responses.sh 

echo "######################################## Ending BashGPT ######################################## "
