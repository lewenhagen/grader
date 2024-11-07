#!/usr/bin/env bash

AUTH="Authorization: Bearer $CANVAS_TOKEN"

BASE_URL="https://bth.instructure.com"
COURSEID=""

# if [[ -f "course.data" ]]; then
#   COURSEID=$(< "course.data")
# else
#   echo "No course added yet"
# fi

LENGTH=1
PAGE=1
GRADEBOOK="result.data"
COUNTER=0

function present
{
  awk -f fix.awk $GRADEBOOK
  exit 0
}

function presentTable
{
  node print.js
  exit 0
}

function getnew
{
  if [[ -f "course.data" ]]; then
    COURSEID=$(< "course.data")
  else
    echo "No course added yet."
    init
    getnew
    exit 0
  fi

  echo "Getting new data..."
  > $GRADEBOOK

  while [[ true ]]
  do
    GRADEBOOK_URL="$BASE_URL/api/v1/courses/$COURSEID/gradebook_history/feed?page=$PAGE&per_page=100"
    GRADEBOOK_HOLDER=$(curl -H "$AUTH" -s "$GRADEBOOK_URL")
    LENGTH=$(echo $GRADEBOOK_HOLDER | jq length)
    [[ $LENGTH == 0 ]] && exit 0
    (( COUNTER+=$LENGTH ))
    echo "Total gradings: $COUNTER"
    echo "$GRADEBOOK_HOLDER" | jq '.[] | select(.grader != "Bedömd vid inlämning" and (.assignment_name | contains("quiz") | not)) | "\(.assignment_name),\(.grader),\(.grade)"' >> $GRADEBOOK

    ((PAGE++))
  done

  exit 0
}

function save {
    local course
    if [[ -f "course.data" ]]; then
        course=$(< "course.data")
        if [[ -f "result.data" ]]; then
            present > $course"_save"
        fi
    fi

    exit 0
}

function init {
    read -p "course code? " temp
    echo $temp > "course.data"

    printf "%s\n" "New course code added: $temp"
    exit 0
}


[[ "$1" = "fetch" ]] && getnew
[[ "$1" = "print" ]] && present
[[ "$1" = "table" ]] && presentTable
[[ "$1" = "save" ]] && save
[[ "$1" = "init" ]] && init


printf "%s\n%s\n%s\n%s\n%s\n%s\n" "Commands:" "'fetch' (Fetches new data from Canvas)" "'save' (Saves the current result)" "'print' (Prints current result with AWK)" "'table' (Prints current result with js)"

exit 1
