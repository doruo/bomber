#!/bin/bash

# Display help information
show_help() {
    cat << EOF

▀██▀▀█▄                      ▀██                      
 ██   ██    ▄▄▄   ▄▄ ▄▄ ▄▄    ██ ▄▄▄    ▄▄▄▄  ▄▄▄ ▄▄  
 ██▀▀▀█▄  ▄█  ▀█▄  ██ ██ ██   ██▀  ██ ▄█▄▄▄██  ██▀ ▀▀ 
 ██    ██ ██   ██  ██ ██ ██   ██    █ ██       ██     
▄██▄▄▄█▀   ▀█▄▄█▀ ▄██ ██ ██▄  ▀█▄▄▄▀   ▀█▄▄▄▀ ▄██▄    
                                                
Usage: $0 [OPTIONS] [SUBDIRECTORY]

OPTIONS:
    -h, --help         Show this help message

EOF
}

bombard() {

	# Total number of steps
	total_steps=20
	# Initial progress
	progress=0
	# Delay between each process
	delay=0.1

	# Display initial state
	echo -n "[--------------------] 0% "

	# Progress loop
	while [ $progress -le $total_steps ]; do

	    # Calculate the number of '#' to display
	    let filled_slots=progress*20/total_steps

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
    	let percentage=progress*100/total_steps

        # Print progress bar
        echo -ne "\r[${bar}] ${percentage}% "

        # Process
        bomb $1;

        # Update progress
        let progress++
	    sleep $delay
	    clear
	done
}

bomb() {
	echo "Bombarding: $1...";
	echo "Press [CTRL+C] to stop.";
	curl -S -s -o /dev/null $1;
}

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
			ADRESS="$1"
			shift
            ;;	
	esac	
done

bombard $ADRESS