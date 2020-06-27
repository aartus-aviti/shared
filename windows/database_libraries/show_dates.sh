#!/bin/sh
# Show libraries ordered by date
# Filter-out reproducible builds, as they do not provide a reliable timestamp

cat "$(dirname -- "$0")"/*.db/*_versions.db.json | \
    jq 'to_entries |
        map(.key as $k | .value.versions | map(.name_arch = $k) | .[]) |
        .[] |
        .peh_ts = (select(.debug_reproducible|not) | .pe_header.timestamp) |
        .peh_ts_iso = (select(.debug_reproducible|not) | .pe_header.timestamp_iso) |
        .timestamp = (.authenticode[0].timestamp_counter_sign.timestamp // .peh_ts) |
        select(.timestamp) |
        .ts_iso = (.authenticode[0].timestamp_counter_sign.timestamp_iso // .peh_ts_iso)' |
    jq --raw-output --null-input 'reduce inputs as $in ([]; . + [$in]) |
        sort_by(.timestamp) |
        .[] |
        [.ts_iso, .name_arch, .string_info.FileVersion] |
        join(" ")' | \
    column -t | \
    sed 's/ \+$//'
