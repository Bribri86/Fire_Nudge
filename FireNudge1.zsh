#!/bin/zsh --no-rcs

# Jamf Variables

counter_1="$4" # ${counter_1}
startinterval_1="$5" # ${startinterval_1}
counter_2="$6" # ${counter_2}
startinterval_2="$7" # ${startinterval_2}
counter_3="$8" # ${counter_3}
startinterval_3="$9" # ${startinterval_3}
Timer="$10" # ${Timer}

# Define Custom Variables for Scripts

jamf="/usr/local/bin/jamf"
loggedInUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ {print $3}')
loggedInUserID=$(id -u "$loggedInUser" 2>/dev/null)

runAsUser() {  
# Run commands as the logged in user
if [[ "$loggedInUser" == "" ]]; then
    echo "No user logged in, unable to run commands as a user"
else
    launchctl asuser "$loggedInUserID" sudo -u "$loggedInUser" "$@"
fi
}

log_file=/usr/local/.FireNudge/LogFile.log


# Check if swiftDialog installed and install!
# Requires policy with "InstallSwiftDialog" as trigger. 

if [ -x "/usr/local/bin/dialog" ]; then
echo "Swift Dialog already installed."
else
echo "Installing Swift Dialog"
jamf policy -event InstallSwiftDialog
sleep 8
echo "Installed dialog"
fi

# make Nudge directory and create it as hidden (.) within the skygroup folder 

mkdir /usr/local/.FireNudge/

# Create Log File

touch /usr/local/.FireNudge/LogFile.log

# Counter File (create as hidden too). Initial Value for "Count" set to 0

cat <<"EOF"> /usr/local/.FireNudge/.counter.plist

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Count</key>
    <integer>0</integer>
</dict>
</plist>

EOF

# Create Bootout files 

# Bootout Daemon 1

cat <<"EOF"> /usr/local/.FireNudge/Bootout1.zsh
#!/bin/zsh --no-rcs

bootlog_file=/usr/local/.FireNudge/BootoutLogFile.log
exec >> $bootlog_file 2>&1

/usr/local/bin/jamf recon

Counter2=0

while launchctl list | grep -q "com.FireNudge" && [ $Counter2 -lt 5 ]; do
(( Counter2 ++ ))
echo "Attempt $Counter2 to bootout com.FireNudge Daemon"

/bin/launchctl bootout system /Library/LaunchDaemons/com.FireNudge.plist
sleep 2
done

EOF

# Bootout Daemon 2

cat <<"EOF"> /usr/local/.FireNudge/Bootout2.zsh
#!/bin/zsh --no-rcs

bootlog_file2=/usr/local/.FireNudge/BootoutLogFile2.log
exec >> $bootlog_file2 2>&1

/usr/local/bin/jamf recon

Counter2=0

while launchctl list | grep -q "com.FireNudge2" && [ $Counter2 -lt 5 ]; do
(( Counter2 ++ ))
echo "Attempt $Counter2 to bootout com.FireNudge2 Daemon"

/bin/launchctl bootout system /Library/LaunchDaemons/com.FireNudge2.plist
sleep 2
done

EOF


# Bootout Daemon 3

cat <<"EOF"> /usr/local/.FireNudge/Bootout3.zsh
#!/bin/zsh --no-rcs

bootlog_file3=/usr/local/.FireNudge/BootoutLogFile3.log
exec >> $bootlog_file3 2>&1

/usr/local/bin/jamf recon

Counter2=0

while launchctl list | grep -q "com.FireNudge3" && [ $Counter2 -lt 5 ]; do
(( Counter2 ++ ))
echo "Attempt $Counter2 to bootout com.FireNudge3 Daemon"

/bin/launchctl bootout system /Library/LaunchDaemons/com.FireNudge3.plist
sleep 2
done

EOF

# Permissions for Bootout files 

chmod 755 /usr/local/.FireNudge/Bootout1.zsh
chown root:wheel /usr/local/.FireNudge/Bootout1.zsh
chmod 755 /usr/local/.FireNudge/Bootout2.zsh
chown root:wheel /usr/local/.FireNudge/Bootout2.zsh
chmod 755 /usr/local/.FireNudge/Bootout3.zsh
chown root:wheel /usr/local/.FireNudge/Bootout3.zsh

# Create Scripts & Daemons 

# SCRIPT 1 

cat <<EOF> /usr/local/.FireNudge/Script1.zsh
#!/bin/zsh --no-rcs

exec >> $log_file 2>&1 

counter=\$(defaults read /usr/local/.FireNudge/.counter.plist Count)

if [ ! -d "/Applications/Firefox.app" ] && [ \$counter -lt ${counter_1} ]; then

  echo "Firefox is not installed and counter is below ${counter_1}. Counter is \$counter"
  ((counter++))

    # swiftDialog Message
 	$runAsUser /usr/local/bin/dialog -i /usr/local/graphics/firefox.png --overlayicon "SF=exclamationmark.circle.fill" -t "Firefox Missing" -m "Your Mac does not have Firefox installed." --button1text "Install Now" --button1action "INSERT_EXECUTE_POLICY_HERE(COPY FROM JAMF PRO)" --button2text "Defer" --button2action 'echo "Deferred"' --timer ${Timer}


elif [ -d "/Applications/Firefox.app" ]; then
echo "Firefox is installed. Counter was \$counter"

$jamf recon
$jamf policy -event 'Fire_Nudge'

else

echo "Firefox is not installed. Counter is \$counter"
echo "Counter is ${counter_1} or more. Run bootout file"

/usr/local/.FireNudge/Bootout1.zsh

fi

defaults write /usr/local/.FireNudge.counter.plist Count \$counter
echo "New Count is \$counter"

EOF


# DAEMON 1

cat <<EOF > /Library/LaunchDaemons/com.FireNudge.plist

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>

    <key>Label</key>
    <string>com.FireNudge</string>

    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/.FireNudge/Script1.zsh</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>KeepAlive</key>
    <false/>

    <key>StartInterval</key>
    <integer>${startinterval_1}</integer>
    
</dict>
</plist>

EOF


# SCRIPT 2

cat <<EOF> /usr/local/.FireNudge/Script2.zsh
#!/bin/zsh --no-rcs

exec >> $log_file 2>&1 

counter=\$(defaults read /usr/local/.FireNudge/.counter.plist Count)

if [ ! -d "/Applications/Firefox.app" ] && [ \$counter -lt ${counter_2} ]; then

  echo "Firefox is not installed and counter is below ${counter_2}. Counter is \$counter"
  ((counter++))

    # swiftDialog Message
 	$runAsUser /usr/local/bin/dialog -i /usr/local/graphics/firefox.png --overlayicon "SF=exclamationmark.circle.fill" -t "Firefox Missing" -m "Your Mac does not have Firefox installed." --button1text "Install Now" --button1action "INSERT_EXECUTE_POLICY_HERE(COPY FROM JAMF PRO)" --button2text "Defer" --button2action 'echo "Deferred"' --timer ${Timer}


elif [ -d "/Applications/Firefox.app" ]; then
echo "Firefox is installed. Counter was \$counter"

$jamf recon
$jamf policy -event 'Fire_Nudge'

else

echo "Firefox is not installed. Counter is \$counter"
echo "Counter is ${counter_2} or more. Run bootout file"

/usr/local/.FireNudge/Bootout2.zsh

fi

defaults write /usr/local/.FireNudge/.counter.plist Count \$counter
echo "New Count is \$counter"

EOF


#  SCRIPT 3

cat <<EOF> /usr/local/.FireNudge/Script3.zsh
#!/bin/zsh --no-rcs

exec >> $log_file 2>&1 

counter=\$(defaults read /usr/local/.FireNudge/.counter.plist Count)

if [ ! -d "/Applications/Firefox.app" ] && [ \$counter -lt ${counter_3} ]; then

  echo "Firefox is not installed and counter is below ${counter_3}. Counter is \$counter"
  ((counter++))

    # swiftDialog Message
 	$runAsUser /usr/local/bin/dialog -i /usr/local/graphics/firefox.png --overlayicon "SF=exclamationmark.circle.fill" -t "Firefox Missing" -m "Your Mac does not have Firefox installed." --button1text "Install Now" --button1action "INSERT_EXECUTE_POLICY_HERE(COPY FROM JAMF PRO)" --button2text "Defer" --button2action 'echo "Deferred"' --timer ${Timer}


elif [ -d "/Applications/Firefox.app" ]; then
echo "Firefox is installed. Counter was \$counter"

$jamf recon
$jamf policy -event 'Fire_Nudge'

else

echo "Firefox is not installed. Counter is \$counter"
echo "Counter is ${counter_3} or more. Run bootout file"

/usr/local/.FireNudge/Bootout3.zsh

fi

defaults write /usr/local/.FireNudge/.Brian/.counter.plist Count \$counter
echo "New Count is \$counter"

EOF



# Set Permissions - Daemons

chmod 644 /Library/LaunchDaemons/com.FireNudge.plist
chown root:wheel /Library/LaunchDaemons/com.FireNudge.plist

# Set Permissions - Scripts 

chmod 755 /usr/local/.FireNudge/Script1.zsh
chown root:wheel /usr/local/.FireNudge/Script1.zsh
chmod 755 /usr/local/.FireNudge/Script2.zsh
chown root:wheel /usr/local/.FireNudge/Script2.zsh
chmod 755 /usr/local/.FireNudge/Script3.zsh
chown root:wheel /usr/local/.FireNudge/Script3.zsh

# Counter 

counter=$(defaults read /usr/local/.FireNudge/.counter.plist Count)
echo "Starting counter is $counter"

# Bootstrap Daemon 1 and update Jamf logs to check Daemon is loaded

/bin/launchctl bootstrap system /Library/LaunchDaemons/com.FireNudge.plist
CheckLoaded=$(launchctl list | grep 'com.Fire')
echo "Loaded:- $CheckLoaded"