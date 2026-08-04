#!/bin/bash

source '../scripts/functions.sh'

clear

exists_openai_api_key || exit 1

echo "##################################################################"
echo "This program shows the available OpenAI model"
echo "You can show if any previous information exist or fetch a new one"
echo "##################################################################"

target_folder="../artifacts"
models_file="model_list.md"
json_file="model_list.json"

full_md_path="${target_folder}/${models_file}"
full_json_path="${target_folder}/${json_file}"


if [  -f "${full_md_path}" ]; then
    echo "##################################################################"
    echo "Display current models"    
    cat "${full_md_path}"
    echo "##################################################################"   
#fi
#if [ -f "${full_md_path}" ]; then
else
  echo "The models file must be created"
  read -p "Press Enter to fetch model list or Ctl + C to cancel: "
  endpoint="https://api.openai.com/v1/models"

  build_local_file "" "${target_folder}" ".gitkeep"

  # In this case, the if statement must removes the []
  if  model_list=$( fetch_model_data "${OPENAI_API_KEY}" "${endpoint}" ); then 
  
    #echo "✅ Fetch successful!, building md file"
    # 2. Write the Markdown table header to the file
    #echo "|Model ID|Creation Date |" > "${full_path}" 
    #echo "|---|---|" >> "${full_path}"
    # 3. Use jq to iterate and add rows
    #echo "$model_list" | jq -r ' .data[] | "| \(.id)| \(.created |  strftime("%Y-%m-%d %H:%M:%S")) |" ' >> $full_path
    #cat "${full_path}"


    # 1. Group all the commands inside $( ) to capture their output into a variable
    md_content=$(
        echo "|Model ID|Creation Date |"
        echo "|---|---|"
        echo "${model_list}" | jq -r ' .data[] | "| \(.id)| \(.created |  strftime("%Y-%m-%d %H:%M:%S")) |" '
    )

    if build_local_file "${md_content}" "${target_folder}" "${models_file}"; then
        echo "Markdown created successfully!"
    else
        echo "Error: Failed to save the model list" >&2
    fi

    if build_local_file "${model_list}" "${target_folder}" "${json_file}"; then
        echo "JSON created successfully!"
    else
        echo "Error: Failed to save the json list" >&2
    fi

  fi

fi

echo "############################################################"