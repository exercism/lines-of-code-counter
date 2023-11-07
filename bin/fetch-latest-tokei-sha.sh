#!/usr/bin/env bash

# Synopsis:
# Fetch the latest commit SHA of the exercism/tokei repository

# Output:
# Sets the LATEST_TOKEI_SHA environment variable

# Example:
# ./bin/fetch-latest-tokei-sha

if ! command -v gh &> /dev/null
then
    echo $'The `gh` command could not be found.\nPlease install the CLI from https://cli.github.com/'
    exit 1
fi

LATEST_TOKEI_SHA=$(gh api /repos/exercism/tokei/commits/master --jq '.sha')
