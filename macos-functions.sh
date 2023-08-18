get-macaddress() {
      	ip=$1
      	arp -a | grep "$ip" | grep -oE '([0-9A-Fa-f]{1,2}:){5}([0-9A-Fa-f]{1,2})' | head -n 1
}


tmstatus () {    
	printf "%-42s\n" "$(printf '%.0s#' {1..54})"
	printf "%-14s %21s\n" "" "TimeMachine Status"
	printf "%-33s %20s\n" "   $(date '+%Y-%m-%d')" "$(date '+%H:%M:%S')   "
	printf "%-42s\n" "$(printf '%.0s#' {1..54})"
	eval $(tmutil status | grep -E '[^}];$' | perl -p -e 's/^\s+[\"]*//g;' -e 's/[\"]*\s+\=\s+/=/g') || (echo "Something went wrong..." && return 1)
		if [[ $Running -eq 1 ]]; then
			export LC_NUMERIC="en_US.UTF-8"
			ETAint=$(echo $TimeRemaining | awk '{printf "%d\n",$1 + 0.5}')
			ETAfloat=$(echo "scale=2; $ETAint/60" | bc)
			ETAfloat_formatted=$(printf "%5s" "$ETAfloat")
				if [[ $BackupPhase == "Copying" ]]; then
					Percent=$(printf '%0.2f %%' `bc <<< $Percent*100`)
					printf "%-18s %7d Files   %13.2f GB\n%-18s %7d Files   %13.2f GB\n" \
					"   Backed up:" "$files" "$(echo "scale=2; ${bytes:-0}/1000000000" | bc)" \
					"   Total:" "$totalFiles" "$(echo "scale=2; ${totalBytes:-0}/1000000000" | bc)"
					printf "%-42s\n" "$(printf '%.0s#' {1..54})"
					printf "%-41s %8s\n%-41s ~%s min\n" \
					"   Progress: " "${Percent}" \
					"   ETA:" "$ETAfloat_formatted"
					printf "%-42s\n" "$(printf '%.0s#' {1..54})"
				else
					#printf "%-42s\n" "$(printf '%.0s#' {1..54})"
					#printf "%-14s %21s\n" "" "TimeMachine Status"
					#printf "%-33s %20s\n" "   $(date '+%Y-%m-%d')" "$(date '+%H:%M:%S')   "
					#printf "%-42s\n" "$(printf '%.0s#' {1..54})"
					echo "   ${DateOfStateChange} ${BackupPhase}"
					printf "%-42s\n" "$(printf '%.0s#' {1..54})"                              
				fi
		else 
			echo "   TimeMachine backup is not running."
			printf "%-42s\n" "$(printf '%.0s#' {1..54})"
	
		fi
}
  
  






tmstatus-watch (){    
	while true; do
		eval $(tmutil status | grep -E '[^}];$' | perl -p -e 's/^\s+[\"]*//g;' -e 's/[\"]*\s+\=\s+/=/g') || (echo "Something went wrong..." && return 1)
		VAR12=`eval $(tmutil status | grep -E '[^}];$' | perl -p -e 's/^\s+[\"]*//g;' -e 's/[\"]*\s+\=\s+/=/g')`
		#printf "%-42s\n" "$(printf '%.0s#' {1..54})"
      		if [[ $Running -eq 1 ]]; then 
			export LC_NUMERIC="en_US.UTF-8"
			ETAint=$(echo $TimeRemaining | awk '{printf "%d\n",$1 + 0.5}')
			ETAfloat=$(echo "scale=2; $ETAint/60" | bc)
			ETAfloat_formatted=$(printf "%5s" "$ETAfloat")
			if [[ $BackupPhase == "Copying" ]]; then
				Percent=$(printf '%0.2f %%' `bc <<< $Percent*100`)
        			clear
        			printf "%-42s\n" "$(printf '%.0s#' {1..54})"
        			printf "%-14s %21s\n" "" "TimeMachine Status"
        			printf "%-33s %20s\n" "   $(date '+%Y-%m-%d')" "$(date '+%H:%M:%S')   "
        			printf "%-42s\n" "$(printf '%.0s#' {1..54})"
        			printf "%-18s %7d Files   %13.2f GB\n%-18s %7d Files   %13.2f GB\n" \
        			"   Backed up:" "$files" "$(echo "scale=2; ${bytes:-0}/1000000000" | bc)" \
        			"   Total:" "$totalFiles" "$(echo "scale=2; ${totalBytes:-0}/1000000000" | bc)"
        			printf "%-42s\n" "$(printf '%.0s#' {1..54})"
        			printf "%-41s %8s\n%-41s ~%s min\n" \
        			"   Progress: " "${Percent}" \
        			"   ETA:" "$ETAfloat_formatted"
        			printf "%-42s\n" "$(printf '%.0s#' {1..54})"
      			else
				echo "   ${DateOfStateChange} ${BackupPhase}"
				printf "%-42s\n" "$(printf '%.0s#' {1..54})"                                
			fi
      		else 
      			echo "   TimeMachine backup is not running."
			printf "%-42s\n" "$(printf '%.0s#' {1..54})"
      			break
      		fi
      	sleep 1
    	done
}



function toggle_low_power_mode() {
	output=$(pmset -g | grep "lowpowermode")
	if [[ $output == *" 1"* ]]; then
      		sudo pmset -a lowpowermode 0
      		echo -e "Low Power Mode: \033[1;31mOFF\033[0m"
    	else
		sudo pmset -a lowpowermode 1
		echo -e "Low Power Mode: \033[1;32mON\033[0m"
	fi
}
