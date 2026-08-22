#!/bin/bash

exists_openai_api_key(){

    if [ -z "$OPENAI_API_KEY" ]; then
        echo "Error: OPENAI_API_KEY is not in environment" >&2
        echo "Set the variable to continue with this program" >&2
        return 1
    fi

    return 0
}


check_required_envs(){
    local error_found=0

    # Iterate over every argument passed to the function ("$@")
    for var_name in "$@"; do
        # ${!var_name} get the VALUE of the variable whose name is store in $var_name
        if [ -z "${!var_name}" ]; then
            echo "❌ Error: Required environment variable '${var_name}' is not set or empty." >&2
            error_found=1
        fi
    done

    # If any variable was missing, return 1 to indicate failure
    if [ "${error_found}" -ne 0 ]; then
        echo "Please, set the missing variables and try again." >&2
        return 1
    fi

    return 0
}


# Get all models, the endpoint: https://api.openai.com/v1/models
# Get specific model, the endpoint: https://api.openai.com/v1/models/${model}
# If any system out (echo ) is required,
# Redirect logs to stderr (>&2) so they don't pollute the JSON response
fetch_model_data(){
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

# 1. Create the folder tree
# 2. Write safely using printf (creates new file automatically)
build_local_file(){
    local file_content="$1"
    local target_folder="$2"
    local file_name="$3"
    
    if  ! mkdir -p "${target_folder}"; then
        echo "Error: Could not create directory ${target_folder}" >&2 
        return 1
    fi

    local full_path="${target_folder}/${file_name}"
    
    if ! printf '%s\n' "${file_content}" >  "${full_path}"; then
        echo "Error: File to write to ${full_path} ."  >&2
        return 1
    fi

    return 0
}


exists_model(){

    local target_model="$1"
    local json_file="$2"

    # 1. Safety check the file exists
    if [ ! -f "$json_file"  ]; then
        echo "Error: JSON file ${json_file} not found" >&2 
        return 1
    fi
    
    # 2. Use jq to check if the model exists
    #   --arg model "$target_model" securely passes the bash variable into jq
    #   .data | any(.id == $model) returns true or false
    #   -e makes jq exit with 0 (true) or 1 (false)
    #   > /dev/null suppresses the actual text output so your script stays quiet
    jq -e --arg model "${target_model}" '.data | any(.id == $model)' "${json_file}" > /dev/null 2>&1
    
    # 3. Explicitly return the exit status of the jq command ($?)
    return $?

}

validate_model(){

    local model="$1"
    local models_file="$2"
    
    exists_model "${model}" "${models_file}"
    status_code=$?

    if [ "${status_code}"  -ne 0 ]; then
        echo "❌ Error: Failed to find model with code ${status_code}" >&2
        echo "Verify the model ${model} your try to get or the file exist ${models_file}" >&2
        return "${status_code}"
    fi

    return 0
}