#!/bin/bash

clear

source '../scripts/utils.sh'

# In this project, by default the images will be push to:
# restry url : "docker.io"  Docker hub
# namespace:   rmontesleo

registry_url="docker.io"

# Run teh verfication
verify_registry_login "${registry_url}"
echo "✅ Authentication verified. Procced to select and push an image."
echo ""

# Display all available images
display_images_by_name

# Select the image to Push
read -p "Select the image to push [rmontesleo/name:tag] : " -r target_image

if [ -z "${target_image}" ]; then
    echo "An image must be choosen to be push, please try again."
    exit 1
fi

image_count=$(count_images_by_name "${target_image}")

echo "image_count ${image_count}"

if [ "${image_count}" -lt 1  ]; then
    echo "A typo with image name, ${image_count} not found.    Please start again and type a proper image name"
    exit 1
fi


full_image_path="${registry_url}/${target_image}"
echo "Pushing ${full_image_path}..."

docker push "${full_image_path}"

echo "🎉 Push completed successfully!"

docker images --digests "${full_image_path}"

echo "---------------------------------------------------------------"
