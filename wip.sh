#!/bin/bash

# define tasks
tasks=("Task 1" "Task 2" "Task 3" "Task 4" "Task 5")
status=("Not selected" "Not selected" "Not selected" "Not selected" "Not selected")

function show_menu {
    command=$(dialog --clear \
                --backtitle "Task Selection" \
                --title "Select a Task" \
                --menu "Choose one of the following options:" \
                15 40 5 \
                "1" "${tasks[0]} : ${status[0]}" \
                "2" "${tasks[1]} : ${status[1]}" \
                "3" "${tasks[2]} : ${status[2]}" \
                "4" "${tasks[3]} : ${status[3]}" \
                "5" "${tasks[4]} : ${status[4]}" \
                2>&1 >/dev/tty)

    clear
    return $command
}

function execute_task {
    task_num=$1
    status[$task_num]="In progress"
    show_menu

    # Insert your task here. Make sure to redirect all output to /dev/null
    # Example: 
    # command > /dev/null 2>&1
    sleep 3  # Emulate long task. Replace with actual task command.

    if [ $? -eq 0 ]; then
        status[$task_num]="Done"
    else
        status[$task_num]="Failed"
    fi
}

# Initial menu
echo "Welcome to Task Manager"
show_menu

# Loop until user exits
while [ $? -eq 0 ]; do
    task_num=$?

    if [ $task_num -ge 1 -a $task_num -le 5 ]; then
        execute_task $((task_num-1))
    fi

    show_menu
done
