#!/bin/bash
#------------------------------------------------------------------------------------
#import files to use their functions
. ./globals.sh
#------------------------------------------------------------------------------------
#add new records to the tables in the current database.
function insertIntoTable(){
	# takes table name and that's it
	# get number of columns
	# get the types
	# check primary key
	echo ----------------------------------------------------------------------------
	#check if the table exists in the current Database.
	read -p "Table name to insert into> " name
	until [ -f $name ] 
	do
	    echo -e "\e[31mNo such table name in this database.\e[0m"
	    read -p "Table name to insert into> " name
	done
	#get Meta data from metadata file of the table (columns name - datatype - primary key).
	local length=$(head -n 1 .$name | tr $DELIMITER ' ' | wc -w)
	local columns_names=($(head -n 1 .$name | tr $DELIMITER ' '))
	local columns_types=($(head -n 2 .$name | tail -n 1 | tr $DELIMITER ' '))
	local pkColNum=$(tail -n 1 .$name )
	local new_record=()
	printTableColums=`head -n 1 .$name`
	#show columns to the user with their datatypes.
	tableView $printTableColums $DELIMITER
	#get the new record values
	for (( i=0; $i < $length; i++ ))
	do
		read -p "Input your ${columns_names[$i]}> " cellValue
		#check if user use spaces in his value insertion.
		while [[ `echo $cellValue | wc -w` > 1 ]]
		do
			echo -e "\e[31mSorry, You cant use Spaces in this field.\e[0m"
			read -p "Input your ${columns_names[$i]}> " cellValue
		done
		#validation on the colums datatype.
		if [[ ( ${columns_types[$i]} == INT && $cellValue =~ ^[0-9]+$ )|| ( ${columns_types[$i]} == STRING )|| ( ${columns_types[$i]} == "DATE" && $cellValue ==  $(date -d $cellValue '+%Y-%m-%d') ) ]]
		then 
			#check on the primary key column
			if [ $i -eq `expr $pkColNum - 1` ]
			then
				#check on duplicated primary key.
				if (( `cut -d$DELIMITER -f $pkColNum $name | grep $cellValue | wc -l` > 0 ))
				then
					echo -e "\e[31mEnter another primary key please.\e[0m"
					i=$i-1
					continue
				else
					new_record+=($cellValue)
				fi
			else
				new_record+=($cellValue)
			fi
		else
			i=$i-1
			continue
		fi	
	done
	#add the new record to the table
	echo ${new_record[@]}$EOF | tr " " $DELIMITER >> $name
	echo ----------------------------------------------------------------------------
}
#------------------------------------------------------------------------------------
#display all tables in the current Database.
function listTables(){
	echo -e "\e[32m`ls -1 .`\e[0m"
	echo ----------------------------------------------------------------------------
}
#------------------------------------------------------------------------------------
#drop table from current database
function dropTable(){
	#get table name from the user.
	read -p "Table name to drop> " table_name
	#check if the table name exists
	if [[ -f $table_name && `echo $table_name | wc -w` == 1 ]] 
	then
		mv $table_name .$table_name .trash
		echo -e "\e[32mDONE\e[0m"
	else 
		echo -e "\e[31mTable is not found\e[0m"
	fi
	echo ----------------------------------------------------------------------------
}

