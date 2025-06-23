#!/usr/bin/env bash

# Synopsis:
# Run the lines of code counter on a submission using the Docker image.

# Arguments:
# $1: track slug
# $2: path to submission directory
# $3: path to output directory (optional)

# Output:
# Count the lines of code of the submission in the passed-in submission directory.
# If the output directory is specified, also write the response to that directory.

# Example:
# ./bin/run-in-docker.sh ruby path/to/submission/directory/

# Stop executing when a command returns a non-zero return code
set -e

# If any required arguments is missing, print the usage and exit
if [[ $# -lt 2 ]]; then
    echo "usage: ./bin/run-in-docker.sh track-slug path/to/submission/directory/ [path/to/output/directory/]"
    exit 1
fi

track_slug="${1}"
submission_dir=$(realpath "${2%/}")
job_id=$(basename "${submission_dir}")
submission_filepaths=$(find "${submission_dir}" -type f ! -name "*response.json" | sed "s|^${submission_dir}/||" | xargs)

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
    --mount type=bind,src="${submission_dir}",dst=${submission_dir} \
    ${output_dir_mount} \
    exercism/lines-of-code-counter)

echo "${track_slug}/${job_id}/${container_id}: counting lines of code..."

# Call the function with the correct JSON event payload
body_json=$(jq -n --arg t "${track_slug}" --arg e "${submission_dir}" --arg u "${job_id}" --arg f "${submission_filepaths}" --arg o "${output_dir}" '{track_slug: $t, efs_dir: $e, job_id: $u, submission_filepaths: ($f | split(" ")), output_dir: (if $o == "" then null else "/mnt/output" end)}')
event_json=$(jq -n --arg b "${body_json}" '{body: $b}')
curl -XPOST http://localhost:${container_port}/2015-03-31/functions/function/invocations -d "${event_json}"

echo "${track_slug}/${job_id}: done"

docker stop $container_id > /dev/null
