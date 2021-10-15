#!/usr/bin/env bash

# Synopsis:
# Run the lines of code counter on a solution.

# Arguments:
# $1: track slug
# $2: exercise slug
# $3: path to solution folder
# $4: path to output directory

# Output:
# Count the lines of code of the solution in the passed-in output directory.

# Example:
# ./bin/run.sh ruby two-fer path/to/solution/folder/ path/to/output/directory/

# If any required arguments is missing, print the usage and exit
if [[ $# -lt 4 ]]; then
    echo "usage: ./bin/run.sh track-slug exercise-slug path/to/solution/folder/ path/to/output/directory/"
    exit 1
fi

track_slug="${1}"
exercise_slug="${2}"
solution_dir=$(realpath "${3%/}")
output_dir=$(realpath "${4%/}")

# Create the output directory if it doesn't exist
mkdir -p "${output_dir}"

echo "${track_slug}/${exercise_slug}: counting lines of code..."

# Call the function with the correct JSON event payload
ruby "./bin/run.rb" "${track_slug}" "${exercise_slug}" "${solution_dir}" "${output_dir}"

echo "${track_slug}/${exercise_slug}: done"
