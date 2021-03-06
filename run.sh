#!/bin/bash

setup_library() {
    server=$1
    key=$2
    lib_yaml=$3
    lib_id=$4

    setup-data-libraries -g "$server" -a "$key" -vvv --training --legacy -i "$lib_yaml" 2>&1 | grep --line-buffered -v DEBUG

    # Super noisy so we'll disable it.
    for dataset in $(curl --silent --show-error "${server}/api/libraries/${lib_id}/contents?key=$key" | jq '.[] | select(.type == "file") | .id' -r); do
        echo -n "$dataset "
        for _ in $(seq 1 10); do
            echo -n '.'
            output=$(curl --silent --show-error "${server}/api/libraries/datasets/${dataset}/permissions?action=set_permissions&key=$key" --data '')
            echo "$output" | grep --quiet access_dataset_roles
            ec=$?
            if (( ec == 0 )); then
                echo ''
                break
            else
                sleep 1
            fi
        done;
    done;
}

export IFS=$'\n';
for line in $(jq -c '.[]' < servers.json); do
    id=$(echo "$line" | jq -r '.id');
    key=$(jq ".$id" -r < secrets.json);
    url=$(echo "$line" | jq -r '.url');

    if [ -z "$(curl --silent --show-error "$url/api/version" | jq -r '.version_major')" ]; then
        echo "$url seems down, skipping";
        continue;
    fi

    for lib_yaml in $(echo "$line" | jq -r '.libs | keys[]'); do
        lib_id=$(echo "$line" | jq -r ".libs | .\"$lib_yaml\"");
        echo "Processing $lib_yaml for $url"
        setup_library "$url" "$key" "$lib_yaml" "$lib_id"
    done
done
