#!/bin/bash

# Clean terminal
clear

source '../scripts/functions.sh'

exists_openai_api_key || exit 1

# Initial values
image_name="bashgpt"
registry_name="rmontesleo"
default_model="gpt-5.6-luna"

# Show current images
docker images --filter reference="${image_name}"
echo ""

# Prompt for the version to run
echo "Choose a version to run or empty value to use latest"
read -p "Enter the version to run: "  -r image_version

if [ -z "${image_version}" ]; then
    image_version="latest"
fi


full_image_name="${image_name}:${image_version}"
registry_full_name="${registry_name}/${full_image_name}"
final_image_name=""

echo "Verifying the ${full_image_name} image exists"

if docker image inspect "${full_image_name}" >/dev/null 2>&1; then
    echo "✅ Image found locally. Ready to run."
    final_image_name=${full_image_name}

elif docker manifest inspect "${registry_full_name}" >/dev/null 2>&1; then
    echo "☁️ Image found in remote repository. It will be pulled when you run it."
    final_image_name=${registry_full_name}
else
    echo "❌ Error: Image '$full_image_name' does not exist locally or in the repository."
    echo "Please build or push the image first"
    exit 1
fi


echo "If no model is enter, ${default_model} will be used."
read -p "Type the openai model you want to use and press enter: " -r openai_model

if [ -z "${openai_model}" ]; then
    openai_model=$default_model
fi


echo "Ready to run ${final_image_name} using the model ${openai_model}"
read -p "Press enter to continue... " -r

docker run -it --rm   \
-e OPENAI_API_KEY="${OPENAI_API_KEY}" \
-e OPENAI_MODEL="${openai_model}" \
--name bashgpt \
"$final_image_name"


echo ""
echo "### Ending Container Execution ###"
