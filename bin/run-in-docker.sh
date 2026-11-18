#!/usr/bin/env bash

# Synopsis:
# Run the lines of code counter on a request using the Docker image.

# Arguments:
# $1: track slug
# $2: path to a directory containing a request.json file
# $3: path to output directory (optional)

# Output:
# Count the lines of code of the files in the request.json file.
# If the output directory is specified, also write the response to that directory.

# Example:
# ./bin/run-in-docker.sh ruby path/to/directory/with/request/json/

# Stop executing when a command returns a non-zero return code
set -e

# If any required arguments is missing, print the usage and exit
if [[ $# -lt 2 ]]; then
    echo "usage: ./bin/run-in-docker.sh track-slug path/to/directory/with/request/json/ [path/to/output/directory/]"
    exit 1
fi

track_slug="${1}"
job_dir=$(realpath "${2%/}")
job_id=$(basename "${job_dir}")

if [ ! -f "${job_dir}/request.json" ]; then
    echo "${job_dir}/request.json does not exist"
    exit 1
fi

if [ ! -z "${3}" ]; then
    output_dir=$(realpath "${3%/}")
    output_dir_mount="--mount type=bind,src="${output_dir}",dst=/mnt/output"
fi

container_port=9876

# Build the Docker image, unless SKIP_BUILD is set
if [[ -z "${SKIP_BUILD}" ]]; then
    if [ -z "${LATEST_TOKEI_SHA}" ]; then
        source ./bin/fetch-latest-tokei-sha.sh
    fi

    docker build --rm -t exercism/lines-of-code-counter --build-arg "TOKEI_SHA=${LATEST_TOKEI_SHA}" .
fi

# Run the Docker image using the settings mimicking the production environment
container_id=$(docker run \
    --detach \
    --publish ${container_port}:8080 \
    ${output_dir_mount} \
    exercism/lines-of-code-counter)

echo "${track_slug}/${job_id}/${container_id}: counting lines of code..."

# Call the function with the correct JSON event payload
# The request.json file is the request body.
body_json=$(jq -c --arg o "${output_dir}" '. + {output_dir: (if $o == "" then null else "/mnt/output" end)}' "${job_dir}/request.json")
event_json=$(jq -n --arg b "${body_json}" '{body: $b}')
curl -XPOST http://localhost:${container_port}/2015-03-31/functions/function/invocations -d "${event_json}"

echo "${track_slug}/${job_id}: done"

docker stop $container_id > /dev/null