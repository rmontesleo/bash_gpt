#!/bin/bash

clear

if [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: OPENAI_API_KEY is not in environment"
    echo "Set the variable to continue with this program"
    exit 1
fi

target_folder="../target"
models_file="model_list.md"
full_path="${target_folder}/${models_file}"

echo "##################################################################"
echo "This program shows the available OpenAI model"
echo "You can show if any previous information exist or fetch a new one"
echo "##################################################################"

if [ ! -d "${target_folder}" ]; then
  mkdir "${target_folder}"
  touch "${target_folder}/.gitkeep"
else 
  echo "target folder already exists"
fi

if [ ! -f "${full_path}" ]; then
  echo "File ${models_file} do not exist, fetch for information will be required"
else
  echo ""##################################################################""
  echo "Display current models"
  echo ""
  cat "${full_path}"
  echo "##################################################################"
fi

read -p "Press Enter to fetch model list or Ctl + C to cancel: "

response_file=$(mktemp)

http_code=$( curl --silent --show-error \
  --output "$response_file" \
  --write-out "%{http_code}" \
  "https://api.openai.com/v1/models" \
  --header "Authorization: Bearer ${OPENAI_API_KEY}" ) 


response_body=$(cat $response_file)
rm -f "$response_file"

echo "Status Code: ${http_code}"

if [ "${http_code}" -eq 200 ]; then
  echo "Building md file"
  
  # 1. Define markdown file with model list
  touch $full_path


  # 2. Write the Markdown table header to the file
  echo "|Model ID|Creation Date |" > "${full_path}" 
  echo "|---|---|" >> "${full_path}"


  # 3. Use jq to iterate and add rows
  echo "$response_body" | jq -r ' .data[] | "| \(.id)| \(.created |  strftime("%Y-%m-%d %H:%M:%S")) |" ' >> $full_path


  cat "${full_path}"

else
  echo "Something wrong fetching information"
  echo "The response is: "
  echo "${response_body}"
fi


echo "############################################################"