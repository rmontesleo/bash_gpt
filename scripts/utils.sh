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

verify_registry_login(){    
    
    if [ -z "${1}" ]; then
        echo "Error: A registry must be provided to verify" >&2
    fi

    local registry="$1"
    local search_string="${registry}"
    local config_file="${HOME}/.docker/config.json"

    if [[ "${registry}" == "docker.io" || "${registry}" == "registry-1.docker.io" ]];then
        search_string="index.docker.io"
    fi

    # Check if config exists AND if the registry string is inside it
    if [! -f "${config_file}" ] || ! grep -q "${search_string}" "${config_file}"; then
        
        echo "❌ Error: You are not logged into the registry '${registry}' ." >&2

        if [[ "${registry}" == "docker.io" ]]; then
            echo "👉 Please log in by running: docker login" >&2 
        else
            echo "👉 Please log in by running: docker login ${registry}" >&2
        fi

        echo "After successfully loggin in, execute this script again. " >&2

        exit 1
    fi

}
