#!/usr/bin/env bash

AUTH="Authorization: Bearer 12133~iiDecoHsYRNR8XzVbNyYaZ1OnZFm3DkTQ2p960WbGptGIcenvBnpRfx5EFXwWyvq"

BASE_URL="https://bth.instructure.com"

COURSEID="5224"

LENGTH=1
PAGE=1
GRADEBOOK="result.data"
COUNTER=0

function present
{
  awk -f fix.awk $GRADEBOOK 
  exit 0
}

function getnew
{
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
    echo "$GRADEBOOK_HOLDER" | jq '.[] | select(.grader != "Bedömd vid inlämning" and (.assignment_name | contains("quiz") | not)) | .assignment_name, .grader' >> $GRADEBOOK
    ((PAGE++))
  done

  exit 0
}

[[ "$1" = "new" ]] && getnew
[[ "$1" = "print" ]] && present
  
printf "%s\n%s\n%s\n" "Commands:" "'print' (Prints current stats)" "'new' (Fetches new data from Canvas)"

exit 1