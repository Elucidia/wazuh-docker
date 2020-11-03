#!/bin/bash

# Files name
alertsJsonFile='alerts.json'
alertsLogFile='alerts.log'
archivesLogFile='archives.log'

# Paths
alertsPath='../../../var/ossec/logs/alerts'
archivesPath='../../../var/ossec/logs/archives'

# Remove every file and directory except the ones specified in the current location
find $alertsPath -type f ! -name $alertsJsonFile ! -name $alertsLogFile -delete
find $alertsPath -mindepth 1 -type d -delete

# Remove every file and directory except the ones specified in the current location
find $archivesPath -type f ! -name $archivesLogFile -delete
find $archivesPath -mindepth 1 -type d -delete

declare -a filesToWatch=("$alertsPath/$alertsJsonFile" "$alertsPath/$alertsLogFile" "$archivesPath/$archivesLogFile")

for i in "${filesToWatch[@]}"; do 
# Check files size in Mb
fileSizeInMo=$(($(stat --format=%s $i) / (1024 * 1024)))

# When file reach more than 4mb, remove 10000 lines from the top file
if [[ $fileSizeInMo > 4 ]]; then
    sed -i '1,10000d' $i
fi

done