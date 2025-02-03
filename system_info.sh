#!/bin/bash
#move file to /usr/local/bin and chmod +x system_info.sh
#This is a script that will capture the various details about this server
#Hostname info
echo -e "Server Details"
echo -e "\e[31;43m***** HOSTNAME INFORMATION *****\e[0m"
hostnamectl
echo ""
# File System Disk Space Usage
echo -e "\e[31;43m***** FILE SYSTEM DISK SPACE USAGE *****\e[0m"
df -h
echo ""
# Memory Information
echo -e "\e[31;43m***** FREE AND USED MEMORY *****\e[0m"
free
echo ""
#System uptime
echo -e "\e[31;43m***** SYSTEM UPTIME *****\e[0m"
uptime
echo ""
#Logged-in Users
echo -e "\e[31;43m***** LOGGED-IN USERS *****\e[0m"
who
echo ""
#Memory consumption
echo -e "\e[31;43m***** TOP 5 PROCESSES *****\e[0m"
ps -eo %mem,%cpu,comm --sort=-%mem | head -n 6
echo ""
echo -e "\e[1;32mDone.\e[0m"
