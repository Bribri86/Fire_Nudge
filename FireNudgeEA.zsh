#!/bin/bash

# Path to the plist file
plist_path="/usr/local/.FireNudge/.counter.plist"

# Check if the plist file exists
if [[ -f "$plist_path" ]]; then
    # Retrieve the count value from the plist file
    firenudge=$(defaults read "$plist_path" Count)
else
    # Set the value if the plist file is not found
    firenudge="No plist found"
fi

# Output the result for the extension attribute
echo "<result>$firenudge</result>"