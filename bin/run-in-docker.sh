#!/usr/bin/env bash

# Synopsis:
# Run the lines of code counter on a submission using the Docker image.

# Arguments:
# $1: track slug
# $2: submission uuid
# $3: path to submission directory

# Output:
# Count the lines of code of the submission in the passed-in submission directory.

# Example:
# ./bin/run-in-docker.sh ruby aaaa-bbbb-cccc path/to/submission/directory/

# If any required arguments is missing, print the usage and exit
if [[ $# -lt 3 ]]; then
    echo "usage: ./bin/run-in-docker.sh track-slug submission-uuid path/to/submission/directory/"
    exit 1
fi

track_slug="${1}"
submission_uuid="${2}"
submission_dir=$(realpath "${3%/}")
submission_files=$(find ${submission_dir} -type f ! -name *response.json -printf "%P\n" | xargs)
response_file="${submission_dir}/response.json"
container_port=9876

# Build the Docker image
docker build --rm -t exercism/lines-of-code-counter .

# Run the Docker image using the settings mimicking the production environment
container_id=$(docker run \
    --detach \
    --publish ${container_port}:8080 \
    --mount type=bind,src="${submission_dir}",dst=/mnt/submissions/${submission_uuid} \
    exercism/lines-of-code-counter)

echo "${track_slug}/${exercise_slug}: counting lines of code..."

# Call the function with the correct JSON event payload
event_json=$(jq -n --arg t "${track_slug}" --arg u "${submission_uuid}" --arg f "${submission_files}" '{track_slug: $t, submission_uuid: $u, submission_files: ($f | split(" "))}')
curl --silent --output "${response_file}" -XPOST http://localhost:${container_port}/2015-03-31/functions/function/invocations -d "${event_json}"

echo "${track_slug}/${exercise_slug}: done"

docker stop $container_id > /dev/null
