#!/bin/bash

clear

# Verify the openai api key is available in environment
if [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: OPENAI_API_KEY is not in environment"
    echo "Set the variable to continue with this program"
    exit 1
fi


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
