#!/usr/bin/env bash

# Synopsis:
# Run the lines of code counter on a solution using the Docker image.

# Arguments:
# $1: track slug
# $2: exercise slug
# $3: path to solution folder
# $4: path to output directory

# Output:
# Count the lines of code of the solution in the passed-in output directory.

# Example:
# ./bin/run-in-docker.sh ruby two-fer path/to/solution/folder/ path/to/output/directory/

# If any required arguments is missing, print the usage and exit
if [[ $# -lt 4 ]]; then
    echo "usage: ./bin/run-in-docker.sh track-slug exercise-slug path/to/solution/folder/ path/to/output/directory/"
    exit 1
fi

track_slug="${1}"
exercise_slug="${2}"
solution_dir=$(realpath "${3%/}")
output_dir=$(realpath "${4%/}")
results_file="${output_dir}/counts.json"
container_port=9876

# Create the output directory if it doesn't exist
mkdir -p "${output_dir}"

echo "${track_slug}/${exercise_slug}: counting lines of code..."

# Build the Docker image
docker build --rm -t exercism/lines-of-code-counter .

# Run the Docker image using the settings mimicking the production environment
container_id=$(docker run \
    --detach \
    --publish ${container_port}:8080 \
    --mount type=bind,src="${solution_dir}",dst=/solution \
    --mount type=bind,src="${output_dir}",dst=/output \
    exercism/lines-of-code-counter)

# Call the function with the correct JSON event payload
event_json=$(jq -n --arg t "${track_slug}" --arg e "${exercise_slug}" '{track: $t, exercise: $e, solution: "/solution", output: "/output"}')
curl --silent --output /dev/null -XPOST http://localhost:${container_port}/2015-03-31/functions/function/invocations -d "${event_json}"

docker stop $container_id > /dev/null

echo "${track_slug}/${exercise_slug}: done"