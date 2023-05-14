#!/bin/bash
#   bash -c "$(wget -qLO - https://raw.githubusercontent.com/pvscvl/linux/main/wip.sh)"
# Define an array of option names
options=("Option 1: apt-get update" "Option 2: apt-get upgrade" "Option 4" "Option 5")

# Define an array to track the status of each option
status=("not selected" "not selected" "not selected" "not selected")

# Define an array to track the checked status of each option
checked=("false" "false" "false" "false")

# Function to display the options
show_menu() {
  clear

  # Loop through the options array and display each option with its status and checkbox
  for ((i=0; i<${#options[@]}; i++)); do
    option="${options[i]}"
    current_status="${status[i]}"
    checkbox="[ ]"
    if [[ ${checked[i]} == "true" ]]; then
      checkbox="[x]"
    fi
    printf "%s %d. %s \t %s\n" "$checkbox" "$((i+1))" "$option" "$current_status"
  done
}

# Function to handle arrow key navigation
arrow_navigation() {
  ESC=$(printf "\033")
  read -rsn1 key

  if [[ $key == $ESC ]]; then
    read -rsn2 key
    case $key in
      '[A')  # Up arrow
        selected=$((selected - 1))
        if [[ $selected -lt 1 ]]; then
          selected=${#options[@]}
        fi
        ;;
      '[B')  # Down arrow
        selected=$((selected + 1))
        if [[ $selected -gt ${#options[@]} ]]; then
          selected=1
        fi
        ;;
    esac
  fi
}

# Function to update the status of a selected option
update_status() {
  selected=$1
  status[$((selected-1))]="$2"
}

# Function to update the checked status of a selected option
update_checked() {
  selected=$1
  if [[ ${checked[selected-1]} == "true" ]]; then
    checked[$((selected-1))]="$2"
  else
    checked[$((selected-1))]="$3"
  fi
}

# Function to execute the command for option 1
execute_option1() {
  echo "Executing option 1: apt-get update"
  sudo apt-get update > /dev/null 2>&1
}

# Function to execute the command for option 2
execute_option2() {
  echo "Executing option 2: apt-get upgrade"
  sudo apt-get upgrade -y > /dev/null 2>&1
}

# Main script logic
selected=1
show_menu

while true; do
  arrow_navigation

  case $key in
    ' ')  # Spacebar
      case $selected in
        1) if [[ ${checked[selected-1]} == "true" ]]; then
             update_checked $selected "false"
           else
             update_checked $selected "true" "false"
           fi
           ;;
        2) if [[ ${checked[selected-1]} == "true" ]]; then
             update_checked $selected "false"
           else
             update_checked $selected "true" "false"
           fi
           ;;
        3) update_checked $selected "not selected"
           ;;
        4) update_checked $selected "not selected"
           ;;
      esac
      show_menu
      ;;
    '')  # Enter key
      break
      ;;
    $'\e')  # Escape key
      exit 0
