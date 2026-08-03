#!/bin/bash


validate_model(){
    echo "Validating Model model before start"
    
    local api_key=$1
    local model=$2

    local response_file=$(mktemp)
    local http_code=$( curl --silent --show-error \
        --output "$response_file" \
        --write-out "%{http_code}" \
        "https://api.openai.com/v1/models/${model}" \
        --header "Authorization: Bearer ${api_key}"  )

    local response_body=$(cat $response_file)

    rm -f "$response_file"

    if [ "${http_code}" -ne 200  ]; then
        echo "❌ Error, API call failed with HTTP status code ${http_code}"
        echo "Response: ${response_body}"
        echo "Verify your OPENAI_API_KEY is still valid or the model you try to use"
        return 1
    fi

    echo "✅ Success: Model '${model}' is valid and ready."
    return 0  

}