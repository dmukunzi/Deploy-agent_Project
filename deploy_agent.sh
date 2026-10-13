#!/bin/bash 

set -u 

#Pre-flight checks

 if command -v python3; then 
    echo "Success: python3 is installed."
 else
    echo "Error: python3 is not installed."
    exit 1

 fi 

 if command -v zip; then 
    echo "Success: zip is installed."
 else 
    echo "Error: zip is not installed."
    exit 1
 fi 

 echo "Pre-flight checks passed: python3 and zip are installed."


#Ask for project name and create folders

 read -r -p "Enter a project name: " project_name 
 project_dir="attendance_tracker_${project_name}"

 if [ -d "$project_dir" ]; then 
    read -r -p "Folder exists already. Overwrite it? (No/Yes):" answer
 
   if [ "$answer" = "Yes" ]; then
     rm -rf "$project_dir"

   else 
    echo "Overwrite cancelled."
    exit 1
 fi

fi

 mkdir -p "$project_dir/Helpers"
 mkdir -p "$project_dir/reports"

 cp templates/attendance_checker.py "$project_dir/"
 cp templates/config.json "$project_dir/Helpers/"


# Create the student roster 

 echo "Select how to create the student roster:"
 echo "1) Copy students roster from the template"
 echo "2) Genereta a new student roster"

 read -r -p "Choose 1 or 2: " roster_choice

if [ "$roster_choice" = "1" ]; then 
 read -r -p "How many students do you wish to copy?" student_number

 head -n $((student_number + 1)) templates/assets.csv > "$project_dir/Helpers/assets.csv"

elif [ "$roster_choice"  = "2" ]; then 

 read -r -p "How many students do you want to create" student_number

 names=("Mugisha Ambrose" "Rukiza Cedric" "Ndamukunda Hubert" "Guta Deborrah" "Akeza Ruth" "Mariza Sereine")

 emails=("ambrosem@gmail.com" "cedricr@gmail.com" "hubertn@gmail.com" "deborrahg@gmail.com" "rutha@gmail.com" "sereinem@gmail.com")

 echo "Email,Names,Attendance Count,Absence Count" > "$project_dir/Helpers/assets.csv"
 
 for ((i=0; i<student_number; i++)); do
     echo "${emails[i]},${names[i]},0,0" >> "$project_dir/Helpers/assets.csv"
 done

     sed -i.bak 's/"total_sessions": 5/"total_sessions": 1/' "$project_dir/Helpers/config.json"
     rm "$project_dir/Helpers/config.json.bak"

else
    echo "Invalid choice. Deployment cancelled."
    exit 1

fi 

# Setting the required permissions 

chmod +x "$project_dir/attendance_checker.py"
chmod 600 "$project_dir/Helpers/config.json"

echo " attendance_checker.py is now executable"
echo " config.json is now owner read and write only"

# Updating threshold values

read -r -p " Do you want to update attendance alert thresholds? (yes/no): " new_alert_thresholds

if [ "$new_alert_thresholds" = "yes" ]; then

 read -r -p "Enter warning threshold (press Enter for 75): " warning 
 read -r -p "Enter failure threshold (press enter for 50): " failure 

 warning=${warning:-75}
 failure=${failure:-50}

 sed -i.bak \
    -e "s/\"warning\": [0-9][0-9]*/\"warning\": $warning/" \
    -e "s/\"failure\": [0-9][0-9]*/\"failure\": $failure/" \
    "$project_dir/Helpers/config.json"

 rm "$project_dir/Helpers/config.json.bak"

 echo "Attendance alert thresholds updated successfully."

fi

#Creating the Run Feature 

read -r -p "Enter the deployed project name: " project_name
project_dir="attendance_tracker_${project_name}"

if [ ! -d "$project_dir" ]; then
   echo "Failure: the deployed project folder does not exists."
   exit 1
fi 

cd "$projecr_dir" || exit 1
python3 attendance_checker.py

#Archive log files feature 
 
read -r -p "Enter the name of the deployed project: " project_name
project_dir="attendance_tracker_${project_name}"

if [ ! -d "$project_dir" ]; then 
   echo "Error: the deployed project folder was not found."
   exit 1
fi 

timestamp=$(date +"%Y%m%d_%H%M%S")

mkdir -p "$project_dir/archives/attendance"
mkdir -p "$project_dir/archives/absent"

if [ -f "$project_dir/reports/attendance.log" ]; then
   archived_attendance_log="$project_dir/archives/attendance/attendance_${timestamp}.log"
   cp "$project_dir/reports/attendance.log" "$archived_attendance_log"
   echo" Attendance logs archived: $archived_attendance_log"

else 
   echo "No attendance log found, archive cancelled"
fi 

if [ -f "$project_dir/reports/absent.log"]; then 
   archived_absent_log="$project_dir/archives/absent/absent_${timestamp}.log"
   cp "$project_dir/reports/absent.log" "$archived_absent_log"
   echo "Absent logs archived : $archived_absent_log"
else
   echo "No absent log found, archive cancelled"
fi 


