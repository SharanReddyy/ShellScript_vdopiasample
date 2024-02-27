# ShellScript_vdopiasample

The following script takes input for the variables and checks the view type. If the view type is bid, it shows in bid mode and auction mode for auction.



# Function to update the sig.conf file


#!/bin/bash
update_sig_conf() {
    local component="$1"
    local scale="$2"
    local view="$3"
    local count="$4"

    # Determine the value for vdopia based on the view input
    local vdopia_value="vdopiasample"
    [[ "${view,,}" == "bid" ]] && vdopia_value="vdopiasample-bid"

    # Format the line for sig.conf
    local line="${vdopia_value} ; ${scale^^} ; ${component^^} ; ETL ; vdopia-etl= ${count}"

     
        echo "$line" > sig.conf
    

    echo "File updated successfully!"
}

# Get input from the user
read -p "Enter Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]: " component
[[ "${component^^}" =~ ^(INGESTOR|JOINER|WRANGLER|VALIDATOR)$ ]] || { echo "Invalid Component Name"; exit 1; }

read -p "Enter Scale [MID/HIGH/LOW]: " scale
[[ "${scale^^}" =~ ^(MID|HIGH|LOW)$ ]] || { echo "Invalid Scale"; exit 1; }

read -p "Enter View [Auction/Bid]: " view
[[ "${view,,}" =~ ^(auction|bid)$ ]] || { echo "Invalid View"; exit 1; }

read -p "Enter Count [single digit number]: " count
[[ "$count" =~ ^[0-9]$ ]] || { echo "Invalid Count (should be a single digit number)"; exit 1; }

# Update the sig.conf file
update_sig_conf "$component" "$scale" "$view" "$count"

