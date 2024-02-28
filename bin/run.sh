#!/usr/bin/env bash

# Synopsis:
# Run the lines of code counter on a submission.

# Arguments:
# $1: track slug
# $2: path to submission directory
# $3: path to output directory (optional)

# Output:
# Count the lines of code of the submission in the passed-in submission directory.
# If the output directory is specified, also write the response to that directory.

# Example:
# ./bin/run.sh ruby path/to/submission/directory/

# Stop executing when a command returns a non-zero return code
set -e

# If any required arguments is missing, print the usage and exit
if [[ $# -lt 2 ]]; then
    echo "usage: ./bin/run.sh track-slug path/to/submission/directory/ [path/to/output/directory/]"
    exit 1
fi

track_slug="${1}"
submission_dir=$(realpath "${2%/}")
submission_uuid=$(basename "${submission_dir}")
submission_filepaths=$(find ${submission_dir} -type f ! -name *response.json -printf "%P\n" | xargs)
submission_parent_dir=$(realpath ${submission_dir}/..)

if [ ! -z "${3}" ]; then
    output_dir=$(realpath "${3%/}")
fi

echo "${track_slug}/${submission_uuid}: counting lines of code..."

# Call the function with the correct JSON event payload
body_json=$(jq -n --arg t "${track_slug}" --arg u "${submission_uuid}" --arg f "${submission_filepaths}" --arg o "${output_dir}" '{track_slug: $t, submission_uuid: $u, submission_filepaths: ($f | split(" ")), output_dir: (if $o == "" then null else $o end)}')
event_json=$(jq -n --arg b "${body_json}" '{body: $b}')
EFS_DIR="${submission_parent_dir}" ruby "./bin/run.rb" "${event_json}"

echo "${track_slug}/${submission_uuid}: done"
