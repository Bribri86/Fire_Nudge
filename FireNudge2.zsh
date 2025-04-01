#!/bin/zsh --no-rcs

# Jamf Variables

counter_1="$4" # ${counter_1}
startinterval_1="$5" # ${startinterval_1}
counter_2="$6" # ${counter_2}
startinterval_2="$7" # ${startinterval_2}
counter_3="$8" # ${counter_3}
startinterval_3="$9" # ${startinterval_3}
Timer="$10" # ${Timer}

# UPDATE VARIABLES WITH SAME VALUES AS SCRIPT IN POLICY 1
# REMEMBER TO UPDATE THE SMART GROUP TOO! 

# Jamf binary
jamf="/usr/local/bin/jamf"

# Allow short delay incase Daemon being booted out
sleep 3

# Current counter is
counter=$(defaults read /usr/local/.FireNudge/.counter.plist Count)
echo "Counter when policy run is $counter"

# Bootout and cleanup task

boot_and_cleanup() {
# Check if Daemon is loaded and boot it out. 

Counter2=0
Counter3=0
Counter4=0

while launchctl list | grep -q "com.FireNudge" && [ $Counter2 -lt 6 ]; do
(( Counter2 ++ ))
echo "Attempt $Counter2 to bootout com.FireNudge Daemon"

/bin/launchctl bootout system /Library/LaunchDaemons/com.FireNudge.plist
sleep 2
done

while launchctl list | grep -q "com.FireNudge2" && [ $Counter3 -lt 6 ]; do
(( Counter2 ++ ))
echo "Attempt $Counter3 to bootout com.FireNudge2 Daemon"

/bin/launchctl bootout system /Library/LaunchDaemons/com.FireNudge2.plist
sleep 2
done

while launchctl list | grep -q "com.FireNudge3" && [ $Counter4 -lt 6 ]; do
(( Counter2 ++ ))
echo "Attempt $Counter4 to bootout com.FireNudge3 Daemon"

/bin/launchctl bootout system /Library/LaunchDaemons/com.FireNudge3.plist
sleep 2
done

if [ $Counter2 -eq 5 ]; then
        echo "Bootout Daemon 1 Failed"
        echo "Removing Daemon instead..."
    launchctl remove com.FireNudge

elif [ $Counter2 -eq 0 ]; then
echo "Counter was 0 for Daemon 1. Daemon already booted out"

else 
echo "Counter was not 0 or 5. Bootout Daemon 1 worked"

fi

if [ $Counter3 -eq 5 ]; then
        echo "Bootout Daemon 2 Failed"
        echo "Removing Daemon 2 instead..."
    launchctl remove com.FireNudge2

elif [ $Counter3 -eq 0 ]; then
echo "Counter was 0 for Daemon 2. Daemon already booted out"

else 
echo "Counter was not 0 or 5. Bootout Daemon 2 worked"

fi

if [ $Counter4 -eq 5 ]; then
        echo "Bootout Daemon 3 Failed"
        echo "Removing Daemon 3 instead..."
    launchctl remove com.FireNudge3

elif [ $Counter4 -eq 0 ]; then
echo "Counter was 0 for Daemon 4. Daemon already booted out"

else 
echo "Counter was not 0 or 5. Bootout Daemon 4 worked"

fi

# Remove all files after bootout sequence. Check successfully booted out and check Daemons removed. 

echo "Remove all ./Fire Folder and files"
rm -rf /usr/local/.FireNudge/

echo "Remove Daemon files if they still exist"
if [ -f "/Library/LaunchDaemons/com.FireNudge.plist" ]; then
    rm /Library/LaunchDaemons/com.FireNudge.plist
    echo "Daemon 1 file removed"
else
    echo "Daemon 1 file not found"
fi

if [ -f "/Library/LaunchDaemons/com.FireNudge2.plist" ]; then
    rm /Library/LaunchDaemons/com.FireNudge2.plist
    echo "Daemon 2 file removed"
else
    echo "Daemon 2 file not found"
fi

if [ -f "/Library/LaunchDaemons/com.FireNudge3.plist" ]; then
    rm /Library/LaunchDaemons/com.FireNudge3.plist
    echo "Daemon 3 file removed"
else
    echo "Daemon 3 file not found"
fi

CheckLoaded=$(launchctl list | grep 'com.Fire')
echo "Loaded:- $CheckLoaded"

echo "List LaunchDaemons in /Library/LaunchDaemons:-"
ls /Library/LaunchDaemons
$jamf recon
}


# If Firefox is installed bootout and cleanup

if [ -d "/Applications/Firefox.app" ]; then

    echo "Firefox is installed. Bootout, cleanup then exit with code 102."

boot_and_cleanup
exit 102

fi


# Launch Daemon 2 

if [ $counter -eq $counter_1 ]; then

# Check if previous Daemon still loaded and if so remove it. 

if launchctl list | grep -q "com.FireNudge"; then
    echo "Remove loaded daemon"
    launchctl remove com.FireNudge
else
    echo " 1st daemon is not loaded."
fi

echo "Remove Daemon 1 and Script 1"
sudo rm -f /Library/LaunchDaemons/com.FireNudge.plist
sudo rm -f /usr/local/.FireNudge/Script1.zsh

cat <<EOF > /Library/LaunchDaemons/com.FireNudge2.plist

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>

    <key>Label</key>
    <string>com.FireNudge2</string>

    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/.FireNudge/Script2.zsh</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>KeepAlive</key>
    <false/>

    <key>StartInterval</key>
    <integer>${startinterval_2}</integer>
    
</dict>
</plist>

EOF

chmod 644 /Library/LaunchDaemons/com.FireNudge2.plist
chown root:wheel /Library/LaunchDaemons/com.FireNudge2.plist
/bin/launchctl bootstrap system /Library/LaunchDaemons/com.FireNudge2.plist

CheckLoaded=$(launchctl list | grep 'com.Fire')
echo "Loaded:- $CheckLoaded"

fi

if [ $counter -eq $counter_2 ]; then

# Check if previous Daemon still loaded and if so remove it. 

if launchctl list | grep -q "com.FireNudge2"; then
    echo "Remove loaded daemon 2"
    launchctl remove com.FireNudge2
else
    echo "2nd daemon is not loaded."
fi

echo "Remove Daemon 2 and Script 2"
sudo rm -f /Library/LaunchDaemons/com.FireNudge2.plist
sudo rm -f /usr/local/.FireNudge/Script2.zsh

cat <<EOF > /Library/LaunchDaemons/com.FireNudge3.plist

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>

    <key>Label</key>
    <string>com.FireNudge3</string>

    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/.FireNudge/Script3.zsh</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>KeepAlive</key>
    <false/>

    <key>StartInterval</key>
    <integer>${startinterval_3}</integer>
    
</dict>
</plist>

EOF

chmod 644 /Library/LaunchDaemons/com.FireNudge3.plist
chown root:wheel /Library/LaunchDaemons/com.FireNudge3.plist
/bin/launchctl bootstrap system /Library/LaunchDaemons/com.FireNudge3.plist

CheckLoaded=$(launchctl list | grep 'com.Fire')
echo "Loaded:- $CheckLoaded"

fi

# Reset counter, recon & bootout if Max Counter reached. To restart; flush policy 1! 

if [ $counter -ge $counter_3 ]; then

echo "Reset Counter and recon" 
defaults write /usr/local/.FireNudge/.counter.plist Count 0
defaults read /usr/local/.FireNudge/.counter.plist Count
$jamf recon
boot_and_cleanup

fi