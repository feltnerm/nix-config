#!/usr/bin/env bash

function _yearPercent() {
    local currentDayNumber
    local totalDayNumber
    local progressPercent

    currentDayNumber=$(date +%j)
    totalDayNumber=365
    progressPercent=$(echo "scale=2; ($currentDayNumber / $totalDayNumber)" | bc)

    echo "$progressPercent"
}

function _progressBar() {
    local front
    local back
    front="["
    back="]"

    local loading
    local loaded
    loading="-"
    loaded="="

    local progressPercent
    progressPercent=${1:-"0"}

    local total
    total=${2:-"10"}

    local normalizedProgress
    normalizedProgress=$(echo "($progressPercent * $total)" | bc)

    local formattedNormalizedProgress
    formattedNormalizedProgress=$(printf %.0f "$normalizedProgress")

    local normalizedUnloaded
    normalizedUnloaded=$(echo "($total - $normalizedProgress)" | bc)

    local formattedNormalizedUnloaded
    formattedNormalizedUnloaded=$(printf %.0f "$normalizedUnloaded")

    # echo -e "$normalizedProgress"
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

function _main() {
    local width
    width=${1:-"80"}

    local progressBar
    progressBar=$(_progressBar "$(_yearPercent)" "$width")

    echo -e "$progressBar"
}

_main "$@"

# divide by 10 to make it easy
# multiply by width in characters - 2 (for the )
# [----------]
# result=$(expr $(date +%j) / 365); echo $result
