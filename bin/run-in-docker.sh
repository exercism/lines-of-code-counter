#!/usr/bin/env bash

# Synopsis:
# Run the lines of code counter on a solution using the Docker image.

# Arguments:
# $1: track slug
# $2: exercise slug
# $3: path to solution folder

# Output:
# Count the lines of code of the solution in the passed-in solution directory.

# Example:
# ./bin/run-in-docker.sh ruby two-fer path/to/solution/folder/

# If any required arguments is missing, print the usage and exit
if [[ $# -lt 3 ]]; then
    echo "usage: ./bin/run-in-docker.sh track-slug exercise-slug path/to/solution/folder/"
    exit 1
fi

track_slug="${1}"
exercise_slug="${2}"
solution_dir=$(realpath "${3%/}")
response_file="${solution_dir}/response.json"
container_port=9876

# Build the Docker image
docker build --rm -t exercism/lines-of-code-counter .

# Run the Docker image using the settings mimicking the production environment
container_id=$(docker run \
    --detach \
    --publish ${container_port}:8080 \
    --mount type=bind,src="${solution_dir}",dst=/solution \
    exercism/lines-of-code-counter)

echo "${track_slug}/${exercise_slug}: counting lines of code..."

# Call the function with the correct JSON event payload
event_json=$(jq -n --arg t "${track_slug}" --arg e "${exercise_slug}" '{track: $t, exercise: $e, solution: "/solution"}')
curl --silent --output "${response_file}" -XPOST http://localhost:${container_port}/2015-03-31/functions/function/invocations -d "${event_json}"

echo "${track_slug}/${exercise_slug}: done"

docker stop $container_id > /dev/null
