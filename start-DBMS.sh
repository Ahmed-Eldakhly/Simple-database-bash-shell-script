#!/bin/bash
#------------------------------------------------------------------------------------
#import files to use their functions
. database_logic.sh
clear
#check if it is the first run to create Database schema that will have all the data.
if [ ! -d Database-schema ]
then
	mkdir Database-schema
fi
#go inside Database schame to access all databases.
cd Database-schema
echo "                            Welcome to OurSQL"
echo ------------------------------------------------------------------------
#the main menu for Database operations.
PS3="please enter your choice: "
select userChoice in $'Create Database.\n2) List Database.\n3) Connect to Databases.\n4) Drop Database.\n5) Exit.'
do case $REPLY in
    1) createNewDatabase ;;
    2) listDatabases ;;
    3) connectDb ;;
    4) dropDb ;;
    5) break ;;
    *) echo -e "\e[31mWrong choice! please choose from the above choices.\e[0m"
        echo ------------------------------------------------------------------------ ;;
	esac
	echo $'1) Create Database.\n2) List Database.\n3) Connect to Databases.\n4) Drop Database.\n5) Exit.'
done
echo -e "\e[32mThank you for using our application.\e[0m"
echo -e "\e[32mBye\e[0m"




