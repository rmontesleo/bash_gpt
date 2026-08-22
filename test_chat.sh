#!/bin/bash

source './scripts/functions.sh'

clear

exists_openai_api_key || exit 1

# Initial values
default_model="gpt-5.6-luna"

echo "If no model is enter, ${default_model} will be used."
read -p "Type the openai model you want to use and press enter: " -r openai_model

export OPENAI_MODEL="${openai_model:-$default_model}"

bash ./start_chat.sh

unset OPENAI_MODEL
