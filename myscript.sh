#!/bin/bash

# Function to update the sig.conf file
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

# Parse command-line options
while getopts ":c:s:v:n:" opt; do
    case $opt in
        c)
            component="$OPTARG"
            ;;
        s)
            scale="$OPTARG"
            ;;
        v)
            view="$OPTARG"
            ;;
        n)
            count="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

# Validate input
[[ "${component^^}" =~ ^(INGESTOR|JOINER|WRANGLER|VALIDATOR)$ ]] || { echo "Invalid Component Name"; exit 1; }
[[ "${scale^^}" =~ ^(MID|HIGH|LOW)$ ]] || { echo "Invalid Scale"; exit 1; }
[[ "${view,,}" =~ ^(auction|bid)$ ]] || { echo "Invalid View"; exit 1; }
[[ "$count" =~ ^[0-9]$ ]] || { echo "Invalid Count (should be a single-digit number)"; exit 1; }

# Update the sig.conf file
update_sig_conf "$component" "$scale" "$view" "$count"
