#!/bin/bash


validate_model(){
    local api_key=$1
    local model=$2

    curl --silent --show-error \
        "https://api.openai.com/v1/models/${model}" \
        --header "Authorization: Bearer ${api_key}" \
  

}