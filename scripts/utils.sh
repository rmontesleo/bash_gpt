#!/bin/bash


get_images_by_name(){
    local image_name="$1"
    local images_data=$(docker images ${image_name} --format  "{{.Repository}}:{{.Tag}} {{.ID}}")
    echo "${images_data}"
}


display_images_by_name(){
    local image_name="$1"

    # 1. Show the pretty Table to the user
    echo "Here are the ${image_name} images currently on your system: "
    docker images ${image_name} --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"    
    echo "--------------------------------------------------------"
}

count_images_by_name(){
    local image_name="$1"
    image_count=$(docker images -q "${image_name}" | wc -l )
    echo "${image_count}"
}


clean_images(){
    local image_name="$1"
    local label_name="${image_name:-All images}"
    local image_count=$(count_images_by_name "${image_name}")

    display_images_by_name "${image_name}"
    echo "From ${label_name}, the total is: ${image_count}"

    if [ -n "${image_name}" ] && [ "${image_count}" -gt 0 ]; then
       echo "Proceed to delete"
       local image_data=$( get_images_by_name "${image_name}" )

       while read -r current_name current_id; do
            read -p "Delete ${current_name}? [y/N]: " confirm </dev/tty

            if [[ "${confirm}" =~  ^[Yy]$ ]]; then
                docker rmi -f ${current_id}
                echo "✅ Deleted ${current_name}"
            else
                echo "⏭️  Skipped ${current_name}"
            fi

       done <<< "${image_data}"

    else
        echo "Image name was provider nor results get found to delete"
    fi
    
}