#!/usr/bin/env bash

AUTH="Authorization: Bearer 12133~iiDecoHsYRNR8XzVbNyYaZ1OnZFm3DkTQ2p960WbGptGIcenvBnpRfx5EFXwWyvq"

BASE_URL="https://bth.instructure.com"



LENGTH=1
PAGE=1
GRADEBOOK="result.data"
COUNTER=0

function present
{
  echo ${TEACHERS[2]}
  awk -f fix.awk $GRADEBOOK
  #sort $GRADEBOOK | uniq -c
  
}

if [[ "$1" = "new" ]]; then
  echo "Getting new data..."
  > $GRADEBOOK
  while [[ true ]]
  do
    GRADEBOOK_URL="$BASE_URL/api/v1/courses/5224/gradebook_history/feed?page=$PAGE&per_page=100"
    GRADEBOOK_HOLDER=$(curl -H "$AUTH" -s "$GRADEBOOK_URL")
    LENGTH=$(echo $GRADEBOOK_HOLDER | jq length)
    [[ $LENGTH == 0 ]] && exit 0
    (( COUNTER+=$LENGTH ))
    echo "Total gradings: $COUNTER"
    echo "$GRADEBOOK_HOLDER" | jq '.[] | select(.grader != "Bedömd vid inlämning" and (.assignment_name | contains("quiz") | not)) | .assignment_name, .grader' >> $GRADEBOOK
    ((PAGE++))
  done

elif [[ "$1" = "print" ]]; then
  present
else
  printf "%s\n%s\n%s\n" "Commands:" "'print' (Prints current stats)" "'new' (Fetches new data from Canvas)"
fi
