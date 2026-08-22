#!/bin/bash
clear

source '../scripts/utils.sh'

image_name="bashgpt"

display_images_by_name "${image_name}"
image_count=$(count_images_by_name "${image_name}")
echo "From ${image_name}, the total is: ${image_count}"

if [ "${image_count}" -gt 0 ]; then
    read -p "Type the source image name [source:tag] : " source_name
    read -p "Type the namespace or just enter: " namespace    
    read -p "Type the target image name [target:tag] : " target_name

    new_image="${namespace}/${target_name}"

    docker tag "${source_name}" "${new_image}"

    docker image inspect ${new_image}

else 
    echo "No images to tag were found"
fi



