#Deploy-agent Project

This is project is about a developing a deployment tool for a student attedance tracker app.

## Purpose

the designed deploy agent is Bash tool that sets up and looks after a small Student Attendance Tracker app written in Python. Instead of copying files and creating folders by
hand every time a new class or week starts, you run one script, deploy_agent.sh, and it does the setup for you. It can also run the app once it is deployed,
archive the attendance logs when a session is over, and protect you from a messy half-finished deployment if you interrupt it with 
Ctrl+C or Ctrl+Z. 

## Contents of the repository: 

the repository will contain 

-deploy_agent.sh
-templates/
-README.md

## Contents of Template folder 

the templates folder contains the source code files for the student attendance tracker app, the files include 

- attendance_checker.py
- assets.csv
- config.json

the deploy_agent.sh script will copy these templates files into a newly created project folder with the
 `Helpers` and `reports` direcotries to as the required project structure to enable the app the run smoothly 

## Pre-flight checks

Before, doing anything the following pre-requisites must be met: you must have python 3 and zip tools intalled. Therefore, the script will check for the presence
of each of these tools itself at the start of every deployment and will stop with a clear message of "success, pre_flight checks passed" if tools are available or
an error message to let the user know the tools that need installing

#Starting the script and using the menu

The script should be run  in the repository folder containing deploy_agent.sh and templates/ ; because it 
looks for the templates folder next to itself to access the source code files 

Once the script is run it will present the owner with an interactive menu with four choices:
 1. Deploy the application
 2. Run the deployed application
 3. Archive logs
 4. Exit

You type the number of the feature you want to use and press enter, after that feature has been performed the
menu will come back to the user giving them the ability to deploy, run, then archive or exit in one sitting.
typing anything that is not 1 to 4 will print and invalid choice message and the menu will be returned back

#Feature 1: Deploy 

After choosing option 1 in the menu, deploy builds a fresh, ready-to-use copy of the tracker. The script goes through these stages

1. Pre-flight checks 

2. Project name: You are asked for a name, and the project folder is called attendance_tracker_ followed by that name.
                 If a folder with that name already exists, you are asked whether to overwrite it. Answering Yes removes,
                 the old one and starts clean. Any other answer cancels the deployment and leaves the old folder alone.

3.Folder structure: The script creates the project folder with two subfolders, Helpers and reports, then copies the app(attendance_checker.py) 
                    into the project and the alert threshold files(config.json) into Helpers.

4. Student roster: The script will prompt you to choose how the class list(assets.csv in Helpers) is created; option 1 copies the first N students 
                    from the template roster, keeping its header line. Option 2 generates a new roster of N students from a built-in list of
                    six names and emails, with attendance and absence counts starting at zero. Because a newly generated roster is a brand-new class,
                    this option also sets total_sessions in the project's config.json to 1.

5. Permissions: The script also sets the app file permissions making it executable and config.json is set to only read or write by owner

6. Thresholds: During deployment the script will ask whether you want to change the attendance alert thresholds; if you answer no: the script 
               keeps the template thresholds in config.json, if you press enter: it sets the thresholds to default value, and if you press yes,
               it will ask you to enter the new alert thresholds.

7. Once all these stages are succesful, The script will show a message telling the user that deployment is complete, and the main menu is brought back again

##Feature 2: Run the app
 
- This asks for the project name and checks that the project exists. If it does not, you get an error message and nothing runs.
- If it does, the script enters that project folder, starts attendance_checker.py, and returns to where it started when the app closes.
- When Running the app, it will display a live marking session where it goes through the roster and asks, for each student, whether they are present or absent.
- It then shows their attendance percentage, flags students who are below the thresholds, and writes the results into two log files in the project's reports folder:
   attendance.log and absent.log.

##Feature 3: Archive logs

-Once a session is finished, archiving keeps a timestamped copy of the logs so that they are not lost when a new session is being recorded.
-The script will prompt the user to give the project name and and will save each log into it's own archive folder.
-as mentioned earlier, the copy of the logs are stamped with current date and time written as "Year_Month_date_Hour_Minutes_Seconds"

## Signal Handling

- During deployment,due to several asks for input along the way, it becomes easier to press Ctrl+C or Ctrl+Z halfway through, 
- without protection this kills or freezes the script messily and leaves a half-built folder that looks like a real deployment but is not
- Hence this script listens for both signals(SIGINT AND SIGTSTP) from the moment it starts creating project folders until deployment is finished ensuring
  that when interrupted it does not crash the whole script but instead stops gracefully.
- Furthemore, the interrupted partial folder project will packed into _archive.zip folder and will contain the information it had at the moment of interruption during deployment

## Project Demo
https://youtu.be/sS3RGxVFpOY?si=RyiFUXplc_9uIBp7

