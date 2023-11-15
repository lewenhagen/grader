#!/usr/bin/env awk

BEGIN {
  FS="\n"
  total = 0
  #split(ENVIRON["TEACHERS"], teachers,",\n")
  
  while ((getline temp < "teachers.data") > 0) {
    kmoms[temp][0] = 0
    kmoms[temp][1] = 0
    kmoms[temp][2] = 0
    kmoms[temp][3] = 0
    kmoms[temp][4] = 0
    kmoms[temp][5] = 0
  }
}

{
  
  if (NR%2==0) {
    gsub(/"/, "", $1)
    gsub(/"/, "", prev)
    
    if (prev == "Kmom01") {
      kmoms[$1][0]++
    } else if (prev == "Kmom02") {
      kmoms[$1][1]++
    } else if (prev == "Kmom03") {
      kmoms[$1][2]++
    }
    
    
  }
  prev=$0
  
}

END {

  total=0
  printf ("%-25s%s%-8s%-8s%-8s%-8s%-8s%-8s%s%-8s\n", "Name", "|", "Kmom01", "Kmom02", "Kmom03", "Kmom04", "Kmom05", "Kmom06", "|", "Totalt")
  printf ("%s\n", "---------------------------------------------------------------------------------")
  for (name in kmoms) {
    total=kmoms[name][0]+kmoms[name][1]+kmoms[name][2]+kmoms[name][3]+kmoms[name][4]+kmoms[name][5]
    printf ("%-25s%s%-8s%-8s%-8s%-8s%-8s%-8s%s%-8s\n", name, "|", kmoms[name][0], kmoms[name][1], kmoms[name][2], kmoms[name][3], kmoms[name][4], kmoms[name][5], "|", total)
  
  } 
}