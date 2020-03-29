#!/bin/bash

if [[ $# != 3 ]]
then
	echo "Syntax: ./shadow_cracker <shadow_file_path> <user_to_crack> <wordlist_path>"
	exit 0
fi
user=$(whoami)
if [[ "$user" == "root" ]]
then
	echo "Cracking Password.......Wait"
	shadow_path=$1
	shadow_user=$2
	wordlist=$3
	shadow_line=$(cat ${shadow_path} | grep ${shadow_user})
	shadow_pass=$(echo ${shadow_line}|cut -d ':' -f2)
	pass_algo=$(echo ${shadow_pass}|cut -d '$' -f2)
	salt=$(echo ${shadow_pass}|cut -d '$' -f3)
	while read -r line; do
		if [[ ${line} ]] 
		then
			crypt_line=$(openssl passwd -${pass_algo} -salt ${salt} ${line})
			if [[ "$crypt_line" == "$shadow_pass" ]]
			then
				echo "Password Cracked:$line"
				exit 0	
			fi 
		fi
	done < "$wordlist"
	echo "No cracked password was found"
else
	echo "You need to be root to read shadow file"
fi