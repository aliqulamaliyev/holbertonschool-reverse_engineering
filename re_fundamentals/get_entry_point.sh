#!/bin/bash

if [ "$#" -ne 1 ]; then
   echo "file adin girin" >&2
   exit 1
fi

file_name="$1"

if [! -f "$file_name" ]; then
   echo "Error: File '$file_name' does not exist in this directory! " >&2
   exit 1
fi

if [ -f "./messages.sh" ]; then
    # shellcheck source=/dev/null
    source ./messages.sh
fi

if ! readelf -h "$file_name" > /dev/null 2>&1; then
    echo "Error: '$file_name' is not a valid ELF file." >&2
    exit 1
fi

# Extract ELF header details using readelf
header_info=$(readelf -h "$file_name")


magic_number=$(echo "$header_info" | grep -i "Magic:" | sed -E 's/^[[:space:]]*Magic:[[:space:]]*//' | sed 's/[[:space:]]*$//')


class=$(echo "$header_info" | grep -i "Class:" | awk -F: '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')


byte_order=$(echo "$header_info" | grep -i "Data:" | sed -E 's/.*, ([^,]+)/\1/' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

entry_point_address=$(echo "$header_info" | grep -i "Entry point address:" | awk -F: '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

# Call the function defined in messages.sh without adding extra echoes
display_elf_header_info
