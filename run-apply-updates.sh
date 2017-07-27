#!/usr/bin/env bash

# Generate an error if any variable doesn't exist
set -o nounset

# Location of the php binary
PHP_BIN=$(which php || true)
if [ -z "${PHP_BIN}" ]; then
    echo "Could not find a binary for php" 1>&2
    exit 1
fi

# Absolute path to Magento installation shell scripts
DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/shell" && pwd)
if [[ -z "${DIR}" || ! -d "${DIR}" ]]; then
    echo "Could not resolve base shell directory" 1>&2
    exit 1
fi

# The scheduler.php script
APPLY_UPDATES="magento1-apply-updates.php"
if [[ ! -e "${DIR}/${APPLY_UPDATES}" || ! -r "${DIR}/${APPLY_UPDATES}" ]]; then
    echo "Could not find ${APPLY_UPDATES} script" 1>&2
    exit 1
fi

# Needed because PHP resolves symlinks before setting __FILE__
cd "${DIR}"

# Run the job in the foreground
"${PHP_BIN}" -f "${APPLY_UPDATES}" -- run
