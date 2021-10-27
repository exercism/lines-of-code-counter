#!/usr/bin/env bash

# Synopsis:
# Run the lines of code counter on a submission.

# Arguments:
# $1: track slug
# $2: path to submission directory

# Output:
# Count the lines of code of the submission in the passed-in submission directory.

# Example:
# ./bin/run.sh ruby path/to/submission/directory/

# If any required arguments is missing, print the usage and exit
if [[ $# -lt 2 ]]; then
    echo "usage: ./bin/run.sh track-slug path/to/submission/directory/"
    exit 1
fi

track_slug="${1}"
submission_dir=$(realpath "${2%/}")
submission_uuid=$(basename "${submission_dir}")
submission_filepaths=$(find ${submission_dir} -type f ! -name *response.json -printf "%P\n" | xargs)
submission_parent_dir=$(realpath ${submission_dir}/..)
response_file="${submission_dir}/response.json"

echo "${track_slug}/${submission_uuid}: counting lines of code..."

# Call the function with the correct JSON event payload
body_json=$(jq -n --arg t "${track_slug}" --arg u "${submission_uuid}" --arg f "${submission_filepaths}" '{track_slug: $t, submission_uuid: $u, submission_filepaths: ($f | split(" "))}')
event_json=$(jq -n --arg b "${body_json}" '{body: $b}')
EFS_DIR="${submission_parent_dir}" ruby "./bin/run.rb" "${event_json}" > "${response_file}"

echo "${track_slug}/${submission_uuid}: done"
