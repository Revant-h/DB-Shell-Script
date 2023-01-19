#!/bin/bash
source ./DB.txt
awk '{print $8}' /home/mysql-privileges/user_temp.txt > dates_
awk '{print $1}' /home/mysql-privileges/user_temp.txt > users
awk '{print $9}' /home/mysql-privileges/user_temp.txt > hosts_
        count=0
        i=0
	x=users
        while read -r line; do
         ab[i]="$line"
        ((i=i+1))
        ((count=count+1))
        done < "$x"
	z=hosts_
	i=0
	while read -r line; do
         bx[i]="$line"
        ((i=i+1))
	done < "$z"
	y=dates_
	i=0
	date=`date +%Y-%m-%d`
	 awk '{print $1" "$2"    "$3"    "$4"    "$5"    "$6"    "$7"    "$8"	"$9}' /home/mysql-privileges/user_temp.txt > user_2.txt
        user_full=user_2.txt
        while read -r line; do
        aa[i]="$line"
        ((i=i+1))
        done < "$user_full"
	i=0
	while read -r line; do
	ba="$line"
	echo "$ba"
	if (( ba < date ))
	then
	echo "$ba"
	ht="${bx[$i]}"
        mysql -B -N -h$ht -u$dbuser -p$password -e "DROP USER '"${ab[$i]}"';"
	sed "/${ab[$i]}/d" user_temp.txt > user_1.txt && mv user_1.txt /home/mysql-privileges/user_temp.txt
	fi
	((i=i+1))
	done < "$y"
	echo -e "User has been deleted \n"
`rm -f dates_ users_ user_1.txt users rev user_2.txt`
