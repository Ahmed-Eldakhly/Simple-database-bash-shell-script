#!/bin/bash
#------------------------------------------------------------------------------------
#import files to use their functions
. ddl.sh
. dml.sh
. table-menu.sh
#------------------------------------------------------------------------------------
#Create function to generate new Database if it dosen't exist.
function createNewDatabase(){
	echo ------------------------------------------------------------------------
	while true
	do
		#take the database name from user and check if it exists.
		read -p "please write the name of new Databese: " newDatabaseName
		dbExist $newDatabaseName
		checkOnDatabase=$?
		if [ $checkOnDatabase -eq 1 ]
		then
			echo -e "\e[31mThis database already exist, please rewrite the name.\e[0m"
		#check if user use spaces in his value insertion.
		elif [[ `echo $newDatabaseName | wc -w` > 1 ]]
		then
			echo -e "\e[31mSorry, You cant use Spaces in this field.\e[0m"
		elif  [[ $newDatabaseName == $EOF ]]
		then
			echo " "
			break
		else
			#create Database Folder.
			mkdir $newDatabaseName
			mkdir $newDatabaseName'/.trash'
			echo -e "\e[32myour database has been created successfully.\e[0m"
			break
		fi
	done
	echo ------------------------------------------------------------------------
}
#------------------------------------------------------------------------------------
#Display all Databases to the user.
function listDatabases () {
	echo ------------------------------------------------------------------------
	#check if the database is empty.
	typeset databaseList=`ls | wc -l`
	if [ $databaseList -eq 0 ]
	then 
		echo -e "\e[31mNo Database exists yet.\e[0m"
	else
		echo List of Databases:
		echo -e "\e[32m`ls -1`\e[0m"
	fi
	echo ------------------------------------------------------------------------
}
#------------------------------------------------------------------------------------
#connect with database to go to inside the Database folder to create, delete or work on Tables that inside it.
function connectDb(){
	echo ------------------------------------------------------------------------
	#take the database name from user and check if it exists.
	read -p "DB name> " db_name
	dbExist $db_name
	dbExist=$?
	if [ $dbExist -eq 1 -a ${#db_name} -gt 0 ]
	then
	useDb $db_name
		tableMenu;
	else 
		echo -e "\033[31m[X]\e[0m Database dosen't exist!"
	fi
	echo ------------------------------------------------------------------------
}
#------------------------------------------------------------------------------------
#Drop Databases by delete their folder if it exists.
function dropDb(){
	echo ------------------------------------------------------------------------
	#take the database name from user and check if it exists.
	read -p "DB name> " db_name
	dbExist $db_name
	dbExist=$?
	if [ $dbExist -eq 1 ]
	then
		#check if the database is empty to notify the user if it has tables.
		isDbEmpty $db_name
		isEmpty=$?
		if [ $isEmpty -eq 1 ]
		then
			echo "Empty schema"
		        rm "-dr" $db_name
		        echo -e "\e[32mDatabase removed successfully.\e[0m"
		else
		        echo "Database is not empty. Do you want to remove the database with its tables? [N/y]"
		        read ch
		        if [ $ch = y ]
		            then 
		                rm "-dr" $db_name
		                echo -e "\e[32mDatabase removed successfully.\e[0m"
		        fi
		fi
	else
		echo -e "\033[31m[X]\e[0m No database with this name found."
	fi
	echo ------------------------------------------------------------------------
}






