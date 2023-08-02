tmstatus-v3 () 
{    
    while true; do
        eval $(tmutil status | grep -E '[^}];$' | perl -p -e 's/^\s+[\"]*//g;' -e 's/[\"]*\s+\=\s+/=/g') || (echo "Something went wrong..." && return 1)
        if [[ $Running -eq 1 ]]
            then export LC_NUMERIC="en_US.UTF-8"
            ETAint=$(echo $TimeRemaining | awk '{printf "%d\n",$1 + 0.5}')
            ETAfloat=$(echo "scale=2; $ETAint/60" | bc)
            if [[ $BackupPhase == "Copying" ]]
            then
                Percent=$(printf '%0.2f %%' `bc <<< $Percent*100`)
                clear
                printf "%-42s\n" "$(printf '%.0s#' {1..54})"
                printf "%-33s %20s" "TimeMachine Status" "$(date '+%Y-%m-%d %H:%M:%S')"
                printf "\n%-42s\n" "$(printf '%.0s#' {1..54})"
                printf "%-40s %7d Files\n%-40s %7d Files" \
                "Files actually backed up:" "$files" \
                "Total files in backup:" "$totalFiles"
                printf "\n%-42s\n" "$(printf '%.0s#' {1..54})"
                printf "%-40s %7.2f GB\n%-40s %7.2f GB" \
                "Actually backed up:" "$(echo "scale=2; ${bytes:-0}/1000000000" | bc)" \
                "Total backup size:" "$(echo "scale=2; ${totalBytes:-0}/1000000000" | bc)"
                printf "\n%-42s\n" "$(printf '%.0s#' {1..54})"
                printf "%-41s %8s\n%-41s ~%s min" \
                "Progress: " "${Percent}" \
                "ETA:" "$ETAfloat"
                printf "\n%-42s\n" "$(printf '%.0s#' {1..54})"
            else
                clear
                echo "${DateOfStateChange} ${BackupPhase}"                                
            fi
        else 
            clear
            echo "TimeMachine backup is not running."
            break
        fi
        sleep 1
    done
}
