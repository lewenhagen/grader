#!/usr/bin/env awk

BEGIN {
  FS=","
  total = 0
  line = "------------------------------------------------------------------------------------------------------------------------"
}

{
    gsub(/"/, "", $1)
    gsub(/"/, "", $2)
    gsub(/"/, "", $3)

    #print $1, $2, $3

    result[$2][$1][$3]++
}

END {
    for (name in result) {
        for (kmom in result[name]) {
            # Add to total row
            total_row[kmom]["total_sum"] = 0
            total_row[kmom]["G"] += result[name][kmom]["G"]
            total_row[kmom]["Ux"] += result[name][kmom]["Ux"]
            total_row[kmom]["U"] += result[name][kmom]["U"]
            total_row[kmom]["total_sum"] += (total_row[kmom]["G"] + total_row[kmom]["Ux"])
            

            # Add to teacher row, sums of (total, G, Ux)
            result[name][kmom]["total"] += (result[name][kmom]["G"] + result[name][kmom]["Ux"])  
            result[name][kmom]["total_g"] += result[name][kmom]["G"]
            result[name][kmom]["total_ux"] += result[name][kmom]["Ux"] 
            result[name]["total"] += result[name][kmom]["total"]
            result[name]["all_total_g"] += result[name][kmom]["total_g"]           
        }

        # Add to total_row
        total_row["total_sum"] += result[name]["total"]
        total_row["total_g"] += result[name]["all_total_g"]

        # Calculate percentage per teacher
        if (result[name]["all_total_g"] > 0)
            result[name]["all_total_g_percent"] += result[name]["all_total_g"] / result[name]["total"] * 100

    }

    # Calculate total_row G percentage
    total_row["total_g_percent"] = total_row["total_g"] / total_row["total_sum"] * 100

    # Print header row
    printf ("%-20s%s%10s%10s%10s%10s%10s%10s%10s%s%8s%7s%6s%7s\n", "Name", "|", "Kmom01", "Kmom02", "Kmom03", "Kmom04", "Kmom05", "Kmom06", "Kmom10", "|", "Totalt", "%", "G", "%G")
    printf ("%s\n", line)
    
    # Print main info
    for (name in result) {

        # Calculate teacher total percentage 
        result[name]["all_percent"] = result[name]["total"] / total_row["total_sum"] * 100

        printf ("%-20s%s%10s%10s%10s%10s%10s%10s%10s%s%8s%6.0f%%%6s%6.0f%%\n", 
            name, 
            "|", 
            result[name]["Kmom01"]["total"], 
            result[name]["Kmom02"]["total"], 
            result[name]["Kmom03"]["total"], 
            result[name]["Kmom04"]["total"], 
            result[name]["Kmom05"]["total"], 
            result[name]["Kmom06"]["total"], 
            result[name]["Kmom07"]["total"], 
            "|", 
            result[name]["total"], 
            result[name]["all_percent"], 
            result[name]["all_total_g"], 
            result[name]["all_total_g_percent"])
    }

    # Print Total row
    printf ("%s\n", line)
    printf ("%-20s%s%10s%10s%10s%10s%10s%10s%10s%s%8s%6.0f%%%6s%6.0f%%\n", 
        "Total (Not U)", 
        "|", 
        total_row["Kmom01"]["total_sum"], 
        total_row["Kmom02"]["total_sum"], 
        total_row["Kmom03"]["total_sum"], 
        total_row["Kmom04"]["total_sum"], 
        total_row["Kmom05"]["total_sum"], 
        total_row["Kmom06"]["total_sum"], 
        total_row["Kmom07"]["total_sum"], 
        "|", 
        total_row["total_sum"], 
        "100", 
        total_row["total_g"], 
        total_row["total_g_percent"])

        # Print specific data
        printf ("%-20s%s%10s%10s%10s%10s%10s%10s\n", 
        "G|Ux|U", 
        "|", 
        total_row["Kmom01"]["G"] "|" total_row["Kmom01"]["Ux"] "|" total_row["Kmom01"]["U"], 
        total_row["Kmom02"]["G"] "|" total_row["Kmom02"]["Ux"] "|" total_row["Kmom02"]["U"], 
        total_row["Kmom03"]["G"] "|" total_row["Kmom03"]["Ux"] "|" total_row["Kmom03"]["U"], 
        total_row["Kmom04"]["G"] "|" total_row["Kmom04"]["Ux"] "|" total_row["Kmom04"]["U"], 
        total_row["Kmom05"]["G"] "|" total_row["Kmom05"]["Ux"] "|" total_row["Kmom05"]["U"], 
        total_row["Kmom06"]["G"] "|" total_row["Kmom06"]["Ux"] "|" total_row["Kmom06"]["U"])

        # Print genomströmning
        printf ("%s\n", line)
        printf ("%-20s%s%7.0f%%%7.0f%%%7.0f%%%7.0f%%%7.0f%%%7.0f%%%7.0f%%\n", 
        "Genomströmning", 
        "|", 
        total_row["Kmom01"]["G"] / total_row["Kmom01"]["G"] * 100, 
        total_row["Kmom02"]["G"] / total_row["Kmom01"]["G"] * 100,
        total_row["Kmom03"]["G"] / total_row["Kmom01"]["G"] * 100,
        total_row["Kmom04"]["G"] / total_row["Kmom01"]["G"] * 100,
        total_row["Kmom05"]["G"] / total_row["Kmom01"]["G"] * 100,
        total_row["Kmom06"]["G"] / total_row["Kmom01"]["G"] * 100,
        total_row["Kmom07"]["G"] / total_row["Kmom01"]["G"] * 100)  
}