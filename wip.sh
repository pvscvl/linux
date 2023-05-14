#!/bin/bash

# Define an array of option names
options=("Option 1: apt-get update" "Option 2: apt-get upgrade" "Option 3: wget URL" "Option 4" "Option 5")

# Define an array to track the status of each option
status=("not selected" "not selected" "not selected" "not selected" "not selected")

# Function to display the welcome text and options
show_menu() {
  clear
  echo "Welcome! Please select an option (use arrow keys to navigate and spacebar to select):"
  echo

  # Loop through the options array and display each option with its status
  for ((i=0; i<${#options[@]}; i++)); do
    option="${options[i]}"
    current_status="${status[i]}"
    printf "%d. %s \t %s\n" "$((i+1))" "$option" "$current_status"
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

# Function to execute the command for option 3
execute_option3() {
  echo "Executing option 3: wget URL"
  # Replace "URL" with the desired URL
  wget "URL" > /dev/null 2>&1
}

# Main script logic
selected=1
show_menu

while true; do
  arrow_navigation

  case $key in
    ' ')  # Spacebar
      case $selected in
        1) update_status $selected "in progress"
           execute_option1
           update_status $selected "done"
           ;;
        2) update_status $selected "in progress"
           execute_option2
           update_status $selected "done"
           ;;
        3) update_status $selected "in progress"
           execute_option3
           update_status $selected "done"
           ;;
        4) update_status $selected "not selected"
           ;;
        5) update_status $selected "not selected"
           ;;
      esac
      show_menu
      ;;
    '')  # Enter key
      break
      ;;
  esac
done

echo "Selected options:"

# Loop through the options and print the selected options
for ((i=0; i<${#options[@]}; i++)); do
  if [[ ${status[i]} == "done" ]]; then
    echo "${options[i]} - ${status[i]}"
  fi
done