#!/usr/bin/env bash

# Synopsis:
# Run the lines of code counter on a solution.

# Arguments:
# $1: track slug
# $2: exercise slug
# $3: absolute path to solution folder
# $4: absolute path to output directory

# Output:
# Count the lines of code of the solution in the passed-in output directory.
# The test results are formatted according to the specifications at TODO

# Example:
# ./bin/run.sh ruby two-fer /absolute/path/to/two-fer/solution/folder/ /absolute/path/to/output/directory/

# If any required arguments is missing, print the usage and exit
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
    echo "usage: ./bin/run.sh track-slug exercise-slug /absolute/path/to/two-fer/solution/folder/ /absolute/path/to/output/directory/"
    exit 1
fi

track_slug="${1}"
exercise_slug="${2}"
solution_dir="${3%/}"
output_dir="${4%/}"
results_file="${output_dir}/counts.json"
script_file="script.rb"

# Create the output directory if it doesn't exist
mkdir -p "${output_dir}"

echo "${track_slug}/${exercise_slug}: counting lines of code..."

# Simulate JSON event payload
body_json=$(jq -n --arg t "${track_slug}" --arg e "${exercise_slug}" --arg s "${solution_dir}" --arg o "${output_dir}" '{track: $t, exercise: $e, solution: $s, output: $o}')
event_json=$(jq -n --arg b "${body_json}" '{body: $b}')

# Call the handler processor
echo $'require("./app.rb")\nExercism::CountLinesOfCode.process(event: JSON.parse(ARGV[0]), context: {})' > "${script_file}"
ruby "${script_file}" "${event_json}"

rm "${script_file}"

echo "${track_slug}/${exercise_slug}: done"
