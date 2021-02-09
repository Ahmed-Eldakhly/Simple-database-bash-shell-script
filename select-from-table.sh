#!/bin/bash
#------------------------------------------------------------------------------------
#import files to use their functions
. globals.sh
#global variables will be used in the file
typeset -i index=1
#------------------------------------------------------------------------------------
# function to put the column names and column datatype in array to display them to the user to select from them
function getColumnNamesAndDatatypeInArrays(){
	columnNameInFile=`sed -n '1p' .$tableName | sed "s/$DELIMITER/ /g"`
	index=1
 	for i in ${columnNameInFile[@]}
	do
		echo "$index) $i"
		columnsNameArray[$index]=$i
		let "index++"
	done
}
#------------------------------------------------------------------------------------
#take columns name from the user to diplay their data with matched records with the insertion arrangment.
function getSelectedColumnsFromUser(){
	while true
	do
		#display the head of table (columns name).
		tableView `sed -n "1p" .$tableName` $DELIMITER
		#take the columns name with space or "," separator between them.
		echo "please select columns from the table separated by ',' or space from above columns:" 
		read selectedColumns
		selectedFields=""
		local rightColumnName=0
		columnNameInSelect=`echo $selectedColumns | sed "s/,/ /g"`
		#two lops to get the insertion arrangemnt from user and match it with the columns of table (return one line consist of index numbers of column that will be displayed)
		outsideLoop=1
		#outer loop for the user insertion
	 	for i in ${columnNameInSelect[@]}
		do
			insideLoop=1
			rightColumnName=0
			#inner loop for columns in the table.
			for j in ${columnNameInFile[@]}
			do
				if [ $i = $j ]
				then
					if [[ ${#selectedFields} == 0 ]]
					then
						selectedFields+=$insideLoop
					else
						selectedFields+=$DELIMITER$insideLoop
					fi
					rightColumnName=1
					break
				fi
				let "insideLoop++"
			done
			#check if the user use valid names for columns.
			if [[ $rightColumnName == 0 ]]
			then
				echo -e "\e[31mNo such column with '$i' name.\e[0m"
				break			
			fi
			let "outsideLoop++"
		done
		if [[ $rightColumnName == 1 ]]
		then
			break			
		fi
	done	
}
#------------------------------------------------------------------------------------
#function to update old records with new records
function selectFromTable() {
	echo ----------------------------------------------------------------------------
	checkOnTable
	echo "please select on column to search for: "
	#and get the column that will be used to match with the user insertion value to get matched records.
	getColumnNamesAndDatatypeInArrays
	selectColumnFromTable
	#get the value to search for and get matched records.
	read -p "Please enter the value to search for: " searchValue
	#check if user use spaces in his value insertion.
	while [[ `echo $searchValue | wc -w` > 1 ]]
	do
		echo -e "\e[31mSorry, You cant use Spaces in this field.\e[0m"
		read -p "Please enter the value to search for: " searchValue
	done
	getSelectedColumnsFromUser
	#search for matched records.
	selectLocations=`awk -v searchColumn=$searchColumn -v searchValue=$searchValue -v delimiter=$DELIMITER -v Fields=$selectedFields 'BEGIN{FS=delimiter} { if($searchColumn == searchValue){StringLine = " "; arrayLength = split(Fields , arr , delimiter); for(i = 1; i <= arrayLength; i++){if(i != arrayLength){StringLine = StringLine$arr[i]delimiter}else{StringLine = StringLine$arr[i]}}print StringLine}}' $tableName`
	typeset -i counter=0
	#check if any record is matched.
 	for i in ${selectLocations[@]}
	do
		(( counter++ ))
	done
	if [[ $counter == 0 ]]
	then
		echo -e "\e[31mNo matched record.\e[0m"
	#display one record for one match.
	elif [[ $counter == 1 ]]
	then
		tableView $selectLocations $DELIMITER
		echo -e "\e[32mThe table has been updated.\e[0m"
	#display all records for multi records match.
	else
		echo the matched records are $counter records
	 	for j in ${selectLocations[@]}
		do
			tableView $j $DELIMITER
		done
		echo -e "\e[32mDone.\e[0m"
	fi	
	echo ----------------------------------------------------------------------------	
}

	








