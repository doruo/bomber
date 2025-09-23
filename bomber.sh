#!/bin/bash

IP="localhost"
PORT="80"

progress_bar() {

	# Total number of steps
	total_steps=20

	# Initial progress
	progress=0

	# Display initial state
	echo -n "[--------------------] 0% "

	# Progress loop
	while [ $progress -le $total_steps ]; do

	    # Calculate the number of '#' to display
	    let filled_slots=progress*20/total_steps

	    # Create the progress bar string
	    bar=""
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
            bombard;

            # Update progress
            let progress++
	done
}

bombard() {
	echo "Bombarding: $IP:$PORT...";
	echo "Press [CTRL+C] to stop.";
	curl -S -s -o /dev/null $IP:$PORT;
}

main() {
	progress_bar;
}

main;
