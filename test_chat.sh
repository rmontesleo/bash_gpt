#!/bin/bash

clear

source './scripts/functions.sh'

exists_openai_api_key || exit 1


# Initial values
image_name="bashgpt"
registry_name="rmontesleo"
default_model="gpt-4.1"


echo "If no model is enter, ${default_model} will be used."
read -p "Type the openai model you want to use and press enter: " openai_model

if [ -z "${openai_model}" ]; then
    openai_model=$default_model
fi

export OPENAI_MODEL="${openai_model}"

bash ./start_chat.bash

unset OPENAI_MODEL
