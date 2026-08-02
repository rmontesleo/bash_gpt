#!/bin/bash

# Clean terminal
clear

#build docker image
image_name="bashgpt"

# Show current images
docker images --filter reference="${image_name}"
echo ""

# Prompt to type the new version to be generated
echo "Type the version to assign to the image ${image_name}, if not value is enter, lates will be assigned"
read -p "Enter version: " image_version

# If not value was assigened, latest and a random version will be generated
if [ -z "${image_version}" ]; then
    image_version="latest"
    random_version="v${RANDOM}_$( date +%Y%m%d%H%M%S )"
fi

full_image_name="${image_name}:${image_version}"
echo "The ${full_image_name} image will be generated"

if [ -n "${random_version}" ]; then
    full_random_name="${image_name}:${random_version}"
    echo "Also the ${full_random_name} image will be generated"
fi

# A little pause before build the image
read -p "Press enter to continue or Ctrl + C to abort the building process ... "


docker build --file ../Dockerfile  -t "$full_image_name" ..

if [ -n  "${random_version}" ]; then
    docker build --file ../Dockerfile  -t "$full_random_name" ..
fi


echo "Showing docker images related with"
docker images --filter reference="${image_name}"

