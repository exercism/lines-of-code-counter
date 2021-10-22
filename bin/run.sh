#!/usr/bin/env bash

# Synopsis:
# Run the lines of code counter on a submission.

# Arguments:
# $1: track slug
# $2: submission uuid
# $3: path to submission directory

# Output:
# Count the lines of code of the submission in the passed-in submission directory.

# Example:
# ./bin/run.sh ruby aaaa-bbbb-cccc path/to/submission/directory/

# If any required arguments is missing, print the usage and exit
if [[ $# -lt 3 ]]; then
    echo "usage: ./bin/run.sh track-slug submission-uuid path/to/submission/directory/"
    exit 1
fi

track_slug="${1}"
submission_uuid="${2}"
submission_dir=$(realpath "${3%/}")
submission_files=$(find ${submission_dir} -type f ! -name *response.json -printf "%P\n" | xargs)
response_file="${submission_dir}/response.json"

echo "${track_slug}/${submission_uuid}: counting lines of code..."

# Call the function with the correct JSON event payload
event_json=$(jq -n --arg t "${track_slug}" --arg u "${submission_uuid}" --arg f "${submission_files}" '{track_slug: $t, submission_uuid: $u, submission_files: ($f | split(" "))}')
ruby "./bin/run.rb" "${event_json}" > "${response_file}"

echo "${track_slug}/${submission_uuid}: done"
