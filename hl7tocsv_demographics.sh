#!/bin/bash
# AUHTOR: MOHAMMAD M. GHASSEMI, MIT
# PURPOSE: PARSES THE HL7 STREAM INTO A CSV FILE WHICH CAN THEN BE USED FOR ANALYSIS...

#FOR EVERY LINE IN THE INPUT FILE '$1'
while read p; do 
  #GRAB THE LINE...
  has_PID=$(echo $p | grep PID\|)
  has_OBX=$(echo $p | grep OBX\|)
  has_OBR=$(echo $p | grep OBR\|)
  has_EVN=$(echo $p | grep EVN\|)

#If this line has a new PID...
if [ "$has_PID" != "" ]; then
    current_PID=$(echo $has_PID | cut -f 4 -d '|')  
    if [ "$current_PID" != '""' ]; then
       #GET DOB AND GENDER AND EVN TIME	
       DOB=$(echo $has_PID | cut -f 8 -d '|')
       GENDER=$(echo $has_PID | cut -f 9 -d '|')
       EVN_TIME=$(echo $has_EVN | cut -f 3 -d '|')

       #MAKE SOME ENTRIES
       echo $current_PID,DOB,$DOB,$EVN_TIME
       echo $current_PID,GENDER,$GENDER,$EVN_TIME 
    fi

fi

#If this line has a new OBR...
if [ "$has_OBR" != "" ]; then
    current_OBR=$(echo $has_OBR | cut -f 8 -d '|')  
fi

#If the line has an observation
if [ "$current_PID" != '""' ]; then
    if [ "$has_OBX" != "" ]; then
       OBX_name=$(echo $has_OBX | cut -f 4 -d '|' | cut -d '^' -f 2)
       OBX_value=$(echo $has_OBX | cut -f 6 -d '|')
       OBX_units=$(echo $has_OBX | cut -f 7 -d '|' | cut -d '^' -f 2)
       #OBX_time=$(echo $has_OBX | cut -f 15 -d '|')
       echo $current_PID,$OBX_name,$OBX_value,$OBX_units,$current_OBR 
    fi   
fi

done <$1
