
Step-by-Step how to configure your customised nudge. The purpose of this is to make the nudge as aggressive as it needs to be to get your desired effect.

Check the Fire Nudge Idea for more detailed documentation. 

Edit the scripts in FireNudge1.zsh with your condition and nudge messages:- 
============================================================================
1) Set your own condition and change scripts to suit the needs of your condition
Currently it's set to check if FireFox is installed 

2) Change the swiftDialog message to suit your needs. Keep the ${Timer}. 

3) CHANGE THE --button1action > copy to policy you want to run to remediate the condition. 


Policy 1
========

4) If deploying an icon for swiftDialog message add pkg containing icon. 

5) Set this to recurring check-in + execution frequency to "Once Per Computer"

6) Add the modified FireNudge1.zsh and set the param values to what you want. 

Extension Attribute
===================

7) Save FireNudgeEA script as an EA on Jamf Pro

This is needed for Scope. 

Smart Groups
============

8) Create a "Fire Nudge 1 SG" Smart Group For:- 

Condition not being met AND
(Fire_NudgeEA is X
OR Fire_NudgeEA is X
OR Fire_NudgeEA is X)

*SET THE COUNTER VALUES HERE THE SAME AS THE PARAM COUNTER VALUES SET ON POLICY 1. 

9) Create a "Fire Nudge 2 SG" Smart Group For:- 
Condition is met AND
Fire_NudgeEA is not "No plist found"


Policy 2
========

10) Set Scope as "Fire Nudge 1 SG" and "Fire Nudge 2 SG" Smart Groups! 

11) Set to Recurring Check-in and with Custom trigger - "Fire_Nudge". Execution Frequency - Ongoing. 

12) Add FireNudge2.zsh and set the same Parameter Values as Policy 1. 










 



 
