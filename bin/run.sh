#!/usr/bin/env bash

# Synopsis:
# Run the lines of code counter on a solution.

# Arguments:
# $1: track slug
# $2: exercise slug
# $3: path to solution folder

# Output:
# Count the lines of code of the solution in the passed-in solution directory.

# Example:
# ./bin/run.sh ruby two-fer path/to/solution/folder/

# If any required arguments is missing, print the usage and exit
if [[ $# -lt 3 ]]; then
    echo "usage: ./bin/run.sh track-slug exercise-slug path/to/solution/folder/"
    exit 1
fi

track_slug="${1}"
exercise_slug="${2}"
solution_dir=$(realpath "${3%/}")
response_file="${solution_dir}/response.json"

echo "${track_slug}/${exercise_slug}: counting lines of code..."

# Call the function with the correct JSON event payload
ruby "./bin/run.rb" "${track_slug}" "${exercise_slug}" "${solution_dir}" > "${response_file}"

echo "${track_slug}/${exercise_slug}: done"
