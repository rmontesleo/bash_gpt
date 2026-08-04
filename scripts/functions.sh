#!/bin/bash


exists_openai_api_key(){

    if [ -z "$OPENAI_API_KEY" ]; then
        echo "Error: OPENAI_API_KEY is not in environment" >&2
        echo "Set the variable to continue with this program" >&2
        return 1
    fi

    return 0
}


exist_specific_env_var(){
    local env_variable="$1"
    local error_message="$2"

    if [ -z "$env_variable" ]; then
        echo "$error_message" >&2
        return 1
    fi

    return 0
}


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

    # 1. Create the folder tree
    if  ! mkdir -p "${target_folder}"; then
        echo "Error: Could not create directory ${target_folder}" >&2 
        return 1
    fi

    local full_path="${target_folder}/${file_name}"

    #2. Write safely using printf (creates new file automatically)
    if ! printf '%s\n' "${file_content}" >  "${full_path}"; then
        echo "Error: File to write to ${full_path} ."  >&2
        return 1
    fi

    return 0
}


validate_model(){

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
        echo "❌ Error, API call failed with HTTP status code ${http_code}" >&2
        echo "Response: ${response_body}" >&2
        echo "Verify your OPENAI_API_KEY is still valid or the model you try to use" >&2
        return 1
    fi

    echo "✅ Success: Model '${model}' is valid and ready."
    return 0  

}