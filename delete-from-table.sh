#!/bin/bash
#------------------------------------------------------------------------------------
#import files to use their functions
. globals.sh
#------------------------------------------------------------------------------------
#function to get the column that will be used to delete the record
function delSelectColumnFromTable(){
	typeset -i index=1
	echo "please select on column to search for: "
	#loop to show columns name to the user
 	for i in ${columsNameArray[@]}
	do
		echo "$index) $i"
		columnsName[$index]=$i
		let "index++"
	done
	selectColumnFromTable
}

#function to delete record from the table.
function deleteFromTable() {
	echo ------------------------------------------------------------------------ 
	#check if table exist in Database.
	checkOnTable
	columsNameArray=`sed -n '1p' .$tableName | sed "s/$DELIMITER/ /g"`
	delSelectColumnFromTable
	#get the search value from the user.
	read -p "Please enter the value to search for: " searchValue
	#check if user use spaces in his value insertion.
	while [[ `echo $searchValue | wc -w` > 1 ]]
	do
		echo -e "\e[31mSorry, You cant use Spaces in this field.\e[0m"
		read -p "Please enter the value to search for: " searchValue
	done
	#get all matched records from the table.
	replaceLocations=`awk -v searchColumn=$searchColumn -v searchValue=$searchValue -v delimiter=$DELIMITER 'BEGIN{FS=delimiter} { if($searchColumn == searchValue){ print NR," "}}' $tableName`
	typeset -i index=0
	#check if any record matched.
	if [[ ${#replaceLocations} == 0 ]]
	then
		echo -e "\e[31mNo matched record.\e[0m"
	else
		#loop to delete all records that matched with the user input.
		for i in $replaceLocations
		do
			(( deletedLine = $i - $index ))	
			sed -i "${deletedLine}d" $tableName
			echo the record has been deleted.
			let "index++"
		done 
		echo -e "\e[32mdelete record(s) has finished successfully.\e[0m"
	fi
	echo ------------------------------------------------------------------------ 
}




