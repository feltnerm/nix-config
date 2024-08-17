#!/usr/bin/env bash

function _yearPercent() {
    local currentDayNumber
    local totalDayNumber
    local progressPercent

    currentDayNumber=$(date +%j)
    totalDayNumber=365
    progressPercent=$(echo "scale=2; ($currentDayNumber / $totalDayNumber)" | bc)

    echo -n "$progressPercent"
}

function _drawProgressBar() {
    local progressPercent
    progressPercent="$1"

    local width
    width="$2"

    # set some drawing characters
    local loading
    local loaded
    loading="${3:--}"
    loaded="${4:-=}"

    local front
    local back
    front="${5:-[}"
    back="${6:-]}"

    # subtract 2 since the front and back characters are part of the
    # width
    local total
    total=$(echo "($width - 2)" | bc)

    # use the provided percent to draw a progress bar at the provided
    # width
    local normalizedProgress
    normalizedProgress=$(echo "($progressPercent * $total)" | bc)

    local formattedNormalizedProgress
    formattedNormalizedProgress=$(printf %.0f "$normalizedProgress")

    local normalizedUnloaded
    normalizedUnloaded=$(echo "($total - $normalizedProgress)" | bc)

    local formattedNormalizedUnloaded
    formattedNormalizedUnloaded=$(printf %.0f "$normalizedUnloaded")

    echo -n "$front"
    for ((i=0; i<formattedNormalizedProgress; i++))
    do
        echo -n "$loaded"
    done
    for ((j=0; j<formattedNormalizedUnloaded; j++))
    do
        echo -n "$loading"
    done
    echo -n "$back"
}

function _progressBar() {

    local progressPercent
    progressPercent=${1:-"0"}

    local width
    width=${2:-"10"}
    # TODO if $width < 3, just make it 3

    _drawProgressBar "$progressPercent" "$width"
}

function _main() {
    local width
    width=${1:-"80"}

    local progressBar
    progressBar=$(_progressBar "$(_yearPercent)" "$width")

    echo -e "$progressBar"
}

_main "$@"
