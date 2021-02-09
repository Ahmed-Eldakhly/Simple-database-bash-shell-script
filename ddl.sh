#!/bin/bash
#------------------------------------------------------------------------------------
# Helper Functions - Returns 1 if the directory exists and -1 if it doesn't
#check if the database exists - used in (creation - connection - drop).
function dbExist(){
    if [ -d $1 ]
    then 
        return 1
    else
        return -1
    fi
}
#------------------------------------------------------------------------------------
#used with connection database only
function useDb(){
    dbDir=$1
    inUseDbPath="$PWD/$dbDir"
    cd $dbDir
	echo $inUseDbPath
}
#------------------------------------------------------------------------------------
#use in Drop Database function to check if the database is empty or not.
function isDbEmpty(){
	#check if the trash of database is empty or not.
	contents=`ls -A $1/.trash | wc -l`
	if [[ $contents == 0 ]]
	then
		rm -d $1/.trash
		#check if the database without trash is empty or not.
		contents=`ls -A $1 | wc -l`
		if [[ $contents == 0 ]]
		then
		  	return 1
		else
			mkdir $1/.trash
		fi
	fi
	return -1
}




