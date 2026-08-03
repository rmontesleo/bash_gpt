#!/bin/bash


# Get all models, the endpoint: https://api.openai.com/v1/models
# Get specific model, the endpoint: https://api.openai.com/v1/models/${model}
fetch_model_data(){
    # If any system out (echo ) is required,
    # Redirect logs to stderr (>&2) so they don't pollute the JSON response
    
    local api_key="$1"
    local endpont="$2"    
    local response_temp_file=$(mktemp)

    local http_code=$( curl --silent --show-error \
        --output "$response_temp_file" \
        --write-out "%{http_code}" \
        "${endpont}" \
        --header "Authorization: Bearer ${api_key}" )

    local response_body=$(cat $response_temp_file)
    rm -f "$response_temp_file"

    if [ "${http_code}" -eq 200  ]; then
        # 2. ONLY the raw JSON goes to stdout
        echo  "${response_body}"
        return 0
    else
        # 3. Redirect all error messages to stderr (>&2)
        echo "Something wrong fetching information" >&2
        echo "Status Code: ${http_code}" >&2
        echo "Response: ${response_body}" >&2
        return 1
    fi
}


build_local_file(){
    local file_content="$1"
    local target_folder="$2"
    local file_name="$3"

    if [ ! -d "${target_folder}" ]; then
        echo "${target_folder} folder do not exist" >&2 
        return 1
    fi

    local full_path="${target_folder}/${file_name}"
    echo "${file_content}" > "${full_path}"

    return 0
}


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