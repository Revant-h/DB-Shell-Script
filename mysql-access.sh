#!/bin/bash -xv
_DEBUG="on"
DEBUG set -x  
clear
source ./DB.txt
function dates_ ()
{
	case "$1" in
	"1")date=`date -d"+2 days" +%Y-%m-%d`
	;;
	"2")date=`date -d"+3 days" +%Y-%m-%d`
	;;
	"3")date=`date -d"+4 days" +%Y-%m-%d`
	;;
	"4")date=`date -d"+5 days" +%Y-%m-%d`
        ;;
	"5")date=`date -d"+6 days" +%Y-%m-%d`
        ;;
	 "6")date=`date -d"+7 days" +%Y-%m-%d`
        ;;
	 "7")date=`date -d"+8 days" +%Y-%m-%d`
        ;;
	 "8")date=`date -d"+9 days" +%Y-%m-%d`
        ;;
	 "9")date=`date -d"+10 days" +%Y-%m-%d`
        ;;
	 "10")date=`date -d"+11 days" +%Y-%m-%d`
        ;;
	 "11")date=`date -d"+12 days" +%Y-%m-%d`
        ;;
	 "12")date=`date -d"+13 days" +%Y-%m-%d`
        ;;
	 "13")date=`date -d"+14 days" +%Y-%m-%d`
        ;;
	 "14")date=`date -d"+15 days" +%Y-%m-%d`
        ;;
	 "15")date=`date -d"+16 days" +%Y-%m-%d`
        ;;
esac
}
function DB_Privileges_temp ()
{
         case "$1" in
		"1") mysql -B -N -h$4 -u$dbuser -p$password -e "GRANT SELECT, INSERT, UPDATE ON "$2".* TO '"$3"'@'%' ;"
			 mysql -B -N -h$4 -u$dbuser -p$password -e "flush privileges;"
		;;
		"2")  mysql -B -N -h$4 -u$dbuser -p$password -e "GRANT SELECT, INSERT, UPDATE, CREATE, REFERENCES, ALTER ON "$2".* TO '"$3"'@'%' ;"
			 mysql -B -N -h$4 -u$dbuser -p$password -e "flush privileges;"
		;;
                "3") mysql -B -N -h$4 -u$dbuser -p$password -e "GRANT SELECT, INSERT, UPDATE, CREATE, REFERENCES, ALTER, EXECUTE, CREATE ROUTINE, ALTER ROUTINE  ON "$2".* TO '"$3"'@'%' ;"
                         mysql -B -N -h$4 -u$dbuser -p$password -e "flush privileges;"
                ;; 
		"4") mysql -B -N -h$4 -u$dbuser -p$password -e "GRANT SELECT, INSERT, UPDATE, CREATE, REFERENCES, ALTER, EXECUTE, CREATE ROUTINE, ALTER ROUTINE,DELETE  ON "$2".* TO '"$3"'@'%' ;"
                         mysql -B -N -h$4 -u$dbuser -p$password -e "flush privileges;"
		;;
		"5")  mysql -B -N -h$4 -u$dbuser -p$password -e "GRANT SELECT, INSERT, UPDATE, CREATE, REFERENCES, ALTER, EXECUTE, CREATE ROUTINE, ALTER ROUTINE, DELETE, DROP  ON "$2".* TO '"$3"'@'%' ;"
                         mysql -B -N -h$4 -u$dbuser -p$password -e "flush privileges;"
                ;;
esac
}
function temp_access ()
{
	`touch rev `
        converting_users_tmp
        echo -e "Choose which to give access to \n1.Staging\n2.Demo\n3.Sandbox\n4.Prod\n"
        read uuu
        numb="$1"
        shift
        lsw=("$@")
        for ((f=0;f<${numb};f++))
do
        count=0
        echo -e "${lsw[$f]}"
        grep -i "${lsw[$f]}" users_1 > rev
        x=rev
        i=0
        three=3
        echo -e "Searching All the  users according to the name given ................ \n"
        while read -r line; do
         ab[i]="$line"
        echo -e "$i $line \n"
        ((i=i+1))
        ((count=count+1))
        done < "$x"
        t=0
        tttt=-1
	echo -e "Enter a new user_name  \n"
        read a
	a="$a@tmp"
                echo -e "\n"
                echo "Choose the privelege type for the given instance for all the users "
                echo -e "\n 1.Write \n 2.Limited \n 3.Limited+SP \n 4.Limited+SP+Delete \n 5.Limited+SP+Delete+Drop"
                read b
		echo -e "Chose the time interval between 0-15 days \n"
		read time_interval
		pass_list=$(tr -dc 'A-Za-z0-9!#%&\''*+@`|' </dev/urandom | head -c 16)
		dates_ "$time_interval"
        i=0
                echo -e "1.for giving accesss to all the databases. \n 2. For creating users in all the hosts and giving privileges \n "
                read zx
                case "$zx" in
                "1")echo -e "Choose : \n 1.Non-prod hosts \n 2.Prod hosts"
        read xoxo
        one=1
        two=2
        if ((xoxo == one))
        then
                hosts=hostname.txt
        elif ((xoxo == two))
        then
                 hosts=hostname-prod.txt
        fi
                echo -e "Choose the host \n"
         while read -r line; do
          ast[i]="$line"
          echo -e "$i. ${ast[$i]}\n"
         ((i=i+1))
         done < "$hosts"
         read d
	 bl="${ast[$d]}"
		instance_type_temp "$uuu" "$a" "$b" "$pass_list" "$date" "$bl"
                  mysql -B -N -h$bl -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$a"'@'%' IDENTIFIED BY '"$pass_list"' PASSWORD EXPIRE INTERVAL "$time_interval" DAY;"
                alldb "$bl"
                dbase=databases
        echo "Giving priveleges"
                while read -r line;do
                c="$line"
                 DB_Privileges_temp "$b" "$c" "$a" "$bl"
                done < "$dbase"
                ;;
                "2")`touch users`
        echo -e "Choose 1 for all the hosts or 2 for selected hosts \n"
        read w
        `touch databases`
         case "$w" in
        "1")echo -e "Choose : \n 1.Non-prod hosts \n 2.Prod hosts"
        read xoxo
        one=1
        two=2
        if ((xoxo == one))
        then
                hosts=hostname.txt
        elif ((xoxo == two))
        then
                 hosts=hostname-prod.txt
        fi
         while read -r line; do
                 asd="$line"
	instance_type_temp "$uuu" "$a" "$b" "$pass_list" "$date" "$asd"
                mysql -B -N -h$asd -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$a"'@'%' IDENTIFIED BY '"$pass_list"' PASSWORD EXPIRE INTERVAL "$time_interval" DAY;"
        alldb "$asd"
        dbase=databases
         while read -r line; do
	 c="$line"
                DB_Privileges "$b" "$c" "$a" "$asd"
        done < "$dbase"
        done < "$hosts"
        ;;
         "2")
                 echo -e "Choose : \n 1.Non-prod hosts \n 2.Prod hosts"
        read xoxo
        one=1
        two=2
        if ((xoxo == one))
        then
                hots=hostname.txt
                 echo -e "All the hosts \n"
                echo -e "$(cat hostname.txt)\n"
        elif ((xoxo ==two))
        then
                 hots=hostname-prod.txt
                 echo -e "All the hosts \n"
                echo -e "$(cat hostname-prod.txt)\n"
        fi
        i=0
                while read -r line; do
                ab[i]="$line"
                ((i=i+1))
        done < "$hots"
        echo -e "Choose the number of hosts \n"
        read uv
        echo -e " Pick hosts from the above list. Please write full name \n "
        `touch host`
	 for ((i=0;i<${uv};i++))
        do
                read d[i]
                echo "${d[$i]}" >> host
        done
        hosts=host
        echo -e "Creating all the users and granting the privileges in hosts"
         while read -r line; do
                 asd="$line"
		instance_type_temp "$uuu" "$a" "$b" "$pass_list" "$date" "$asd"
		mysql -B -N -h$asd -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$a"'@'%' IDENTIFIED BY '"$pass_list"' PASSWORD EXPIRE INTERVAL "$time_interval" DAY;"
        alldb "$asd"
        dbase=databases
         while read -r line; do
                c="$line"
                DB_Privileges_temp "$b" "$c" "$a" "$asd"
        done < "$dbase"
        done < "$hosts"
                 `rm -f host`
        ;;
        esac
		;;
		esac
  done
echo -e "User-name = $a \n Password = $pass_list \n Date it will expire = $date \n "
}
function Deleting_users ()
{
        converting_users
         numb="$1"
        shift
        lsw=("$@")
          for((f=0;f<${numb};f++))
do
        count=0
        echo -e "${lsw[$f]}"
        grep -i "${lsw[$f]}" users > rev
        x=rev
        i=0
        echo -e "Searching users according to the name given ................ \n"
        while read -r line; do
         ab[i]="$line"
        echo -e "$i $line \n"
        ((i=i+1))
        ((count=count+1))
        done < "$x"
         echo -e "Choose the given user_name or the user does not exist\n"
          read a
         s="${ab[$a]}"
        one=1
        two=2
	echo -e "1.For Non-Prod hosts \n2.Prod Hosts\n"
	read xoxo
        if ((xoxo == one))
        then
                hosts=hostname.txt
        elif ((xoxo == two))
        then
                 hosts=hostname-prod.txt
        fi
                echo -e "Choose the hosts \n"
        i=0
         while read -r line; do
	mysql -B -N -h$line -u$dbuser -p$password -e "DROP USER '"$s"';"
        done < "$hosts"
        awk '{print $1" "$2"    "$3"    "$4"    "$5"    "$6}' ./user.txt > user_2.txt
        sed "/"${ab[$a]}"/d" user_2.txt > user_1.txt && mv user_1.txt user.txt
done
}
function DB_Privileges ()
        {
         case "$1" in
                "1") mysql -B -N -h$4 -u$dbuser -p$password -e "GRANT SELECT ON "$2".* TO '"$3"'@'%' ;"
                         mysql -B -N -h$4 -u$dbuser -p$password -e "flush privileges;"
                ;;
                "2") mysql -B -N -h$4 -u$dbuser -p$password -e "GRANT SELECT, INSERT, UPDATE ON "$2".* TO '"$3"'@'%';"
                         mysql -B -N -h$4 -u$dbuser -p$password -e "flush privileges;"
                 ;;
                "3")mysql -B -N -h$4 -u$dbuser -p$password -e "GRANT SELECT, INSERT, UPDATE, CREATE, REFERENCES, ALTER ON "$2".* TO '"$3"'@'%';"
                         mysql -B -N -h$4 -u$dbuser -p$password -e "flush privileges;"
                ;;
                "4") mysql -B -N -h$4 -u$dbuser -p$password -e "GRANT SELECT, INSERT, UPDATE, CREATE, REFERENCES, EXECUTE, CREATE ROUTINE, ALTER ROUTINE  ON "$2".* TO '"$3"'@'%' ;"
                         mysql -B -N -h$4 -u$dbuser -p$password -e "flush privileges;"
                ;;
                "5") mysql -B -N -h$4 -u$dbuser -p$password -e "GRANT SELECT, INSERT, UPDATE ON "$2".* TO '"$3"'@'%' ;"
                        mysql -B -N -h$4 -u$dbuser -p$password -e "flush privileges;"
                ;;
                "6") mysql -B -N -h$4 -u$dbuser -p$password -e "GRANT SELECT, INSERT, UPDATE ON "$2".* TO '"$3"'@'%' ;"
                         mysql -B -N -h$4 -u$dbuser -p$password -e "flush privileges;"
                ;;
		"7") mysql -B -N -h$4 -u$dbuser -p$password -e "GRANT ALL ON "$2".* TO '"$3"'@'%' ;"
                         mysql -B -N -h$4 -u$dbuser -p$password -e "flush privileges;"
                ;;
                esac
          }
function alldb ()
{
mysql -B -N -h$1 -u$dbuser -p$password -e "Show databases like 'issue%';" > databases
mysql -B -N -h$1 -u$dbuser -p$password -e "Show databases like 'elastic%';" >> databases
mysql -B -N -h$1 -u$dbuser -p$password -e "Show databases like 'cmdb%';" >> databases
mysql -B -N -h$1 -u$dbuser -p$password -e "Show databases like 'ivr%';" >> databases
mysql -B -N -h$1 -u$dbuser -p$password -e "Show databases like 'brcm_%';" >> databases
mysql -B -N -h$1 -u$dbuser -p$password -e "Show databases like 'signup_%';" >> databases
}
function instance_type ()
{
	case "$1" in
		"1")echo -en "$2\t$4\t$3\t0\t0\t0\n  " >> user.txt
		;;
		"2")echo -en "$2\t$4\t0\t$3\t0\t0\n  " >> user.txt
                ;;
		"3")echo -en "$2\t$4\t0\t0\t$3\t0\n  " >> user.txt
                ;;
		"4")echo -en "$2\t$4\t0\t0\t0\t$3\n  " >> user.txt
              ;;
	esac
}
function instance_type_temp ()
{
        case "$1" in
                "1")echo -en "$2\t$4\t$3\t0\t0\t0\t`date -d "+0 days" +%Y-%m-%d`\t$5\t$6\n  " >> user_temp.txt
                ;;
                "2")echo -en "$2\t$4\t0\t$3\t0\t0\t`date -d "+0 days" +%Y-%m-%d`\t$5\t$6\n  " >> user_temp.txt
                ;;
                "3")echo -en "$2\t$4\t0\t0\t$3\t0\t`date -d "+0 days" +%Y-%m-%d`\t$5\t$6\n  " >> user_temp.txt
                ;;
                "4")echo -en "$2\t$4\t0\t0\t0\t$3\t`date -d "+0 days" +%Y-%m-%d`\t$5\t$6\n  " >> user_temp.txt
              ;;
        esac
}
function converting_users_tmp ()
{
`touch users_1`
awk '{print $1}' ./user_temp.txt > users_1
}
function converting_users ()
{
		`touch users privilege passwords`
			awk '{print $1}' ./user.txt > users
}
function bcd ()
{
case "$3" in
	"1")	 awk '{print $1}' ./user.txt > revanth
                usr=revanth
                name="$1"
                i=0
                j=0
                count=0
                x=0
                zero=0
                awk '{print $1"        "$2}' ./user.txt > user_2.txt
		awk '{print $4"	"$5"	"$6}' ./user.txt > user_7.txt
                awk '{print $3}' ./user.txt > user_6.txt
		user_56=user_7.txt
                while read -r line; do
                bxxx[j]="$line"
                ((j=j+1))
                done < "$user_56"
                j=0
                user_name=user_2.txt
                while read -r line; do
                ab[j]="$line"
                ((j=j+1))
                done < "$user_name"
                demo_privilege=user_6.txt
                aa=0
                demo_db=0
                while read -r line; do
                xx[aa]="$line"
                ((aa=aa+1))
                done < "$demo_privilege"
		aa=0
		user=user.txt
		while read -r line; do
                rx[aa]="$line"
		((aa=aa+1))
                done < "$user"
		i=0
		 while read -r line; do
                if [[ "$line" = "$name" ]]
                then
                        demo_db="${xx[$i]}"
                        break
                fi
		((i=i+1))
                done < "$usr"
                while read -r line; do
                if [[ "$line" = "$name" ]] && [[ "${xx[$x]}" = "$zero" ]] 
                then
                        echo -n -e "${ab[$x]}\t"
                         sed "/${rx[$x]}/d" user.txt >  user_4.txt && mv user_4.txt user.txt
                         echo -n -e "${ab[$x]}\t$2\t${bxxx[$x]}\n"   >> user.txt
			demo_db=0
			demo_db=$2
			break
                fi
                        ((x=x+1))
                   done < "$usr"
                        two=2
		;;
                "2")     awk '{print $1}' ./user.txt > revanth
		usr=revanth
                name="$1"
                i=0
                j=0
                count=0
                x=0
		zero=0
		awk '{print $1"        "$2"	"$3}' ./user.txt > user_2.txt
		awk '{print $4}' ./user.txt > user_7.txt
		awk '{print $5"	"$6}' ./user.txt > user_6.txt
		 user_56=user_6.txt
                while read -r line; do
                bxxx[j]="$line"
                ((j=j+1))
                done < "$user_56"
                j=0
                user_name=user_2.txt
                while read -r line; do
                ab[j]="$line"
                ((j=j+1))
                done < "$user_name"
		demo_privilege=user_7.txt
		aa=0
		demo_db=0
		while read -r line; do
                xx[aa]="$line"
                ((aa=aa+1))
                done < "$demo_privilege"
		aa=0
		user=user.txt
		while read -r line; do
                rx[aa]="$line"
		((aa=aa+1))
                done < "$user"
		i=0
		 while read -r line; do
                if [[ "$line" = "$name" ]]
                then
                        demo_db="${xx[$i]}"
                        break
                fi
		((i=i+1))
                done < "$usr"
                while read -r line; do
                if [[ "$line" = "$name" ]] && [[ "${xx[$x]}" = "$zero" ]] 
                then
                        echo -n -e "${ab[$x]}\t"
                         sed "/${rx[$x]}/d" user.txt >  user_4.txt && mv user_4.txt user.txt
                         echo -n -e "${ab[$x]}\t$2\t${bxxx[$x]}\n"   >> user.txt
			demo_db=0
			demo_db=$2
			break
                fi
                        ((x=x+1))
                   done < "$usr"
			two=2
		;;
	"3")  awk '{print $1}' ./user.txt > revanth
                usr=revanth
                name="$1"
                i=0
                j=0
                count=0
                x=0
                zero=0
		awk '{print $1"        "$2"    "$3"    "$4}' ./user.txt > user_2.txt
                awk '{print $5}' ./user.txt > user_6.txt
		awk '{print $6}' ./user.txt > user_7.txt
		user_56=user_7.txt
		while read -r line; do
                bxxx[j]="$line"
                ((j=j+1))
                done < "$user_56"
		j=0
                user_name=user_2.txt
                while read -r line; do
                ab[j]="$line"
                ((j=j+1))
                done < "$user_name"
                demo_privilege=user_6.txt
                aa=0
                demo_db=0
                while read -r line; do
                xx[aa]="$line"
                ((aa=aa+1))
                done < "$demo_privilege"
		user=user.txt
                aa=0
                while read -r line; do
                rx[aa]="$line"
		((aa=aa+1))
		done < "$user"
		i=0
		while read -r line; do
                if [[ "$line" = "$name" ]]
                then
                        demo_db="${xx[$i]}"
			break
                fi
		((i=i+1))
                done < "$usr"
                while read -r line; do
                if [[ "$line" = "$name" ]] && [[ "${xx[$x]}" = "$zero" ]] 
                then
                        echo -n -e "${ab[$x]}\t"
                         sed "/${rx[$x]}/d" user.txt >  user_4.txt && mv user_4.txt user.txt
			echo -n -e "${ab[$x]}\t$2\t${bxxx[$x]}\n"   >> user.txt
			demo_db=0
			demo_db=$2
			break
                fi
                        ((x=x+1))
                   done < "$usr"
                        two=2
                ;;
	"4")  awk '{print $1}' ./user.txt > revanth
                usr=revanth
                name="$1"
                i=0
                j=0
                count=0
                x=0
                zero=0
		awk '{print $1" "$2"    "$3"    "$4"    "$5}' ./user.txt > user_2.txt
                awk '{print $6}' ./user.txt > user_6.txt
                user_name=user_2.txt
                while read -r line; do
                ab[j]="$line"
                ((j=j+1))
                done < "$user_name"
                demo_privilege=user_6.txt
                aa=0
                demo_db=0
                while read -r line; do
                xx[aa]="$line"
                ((aa=aa+1))
                done < "$demo_privilege"
		user=user.txt	
		aa=0
		while read -r line; do
                rx[aa]="$line"
                ((aa=aa+1))
                done < "$user"
		i=0
		while read -r line; do
                if [[ "$line" = "$name" ]]
		then
			demo_db="${xx[$i]}"
			break
		fi
		((i=i+1))
		done < "$usr"
                while read -r line; do
                if [[ "$line" = "$name" ]] && [[ "${xx[$x]}" = "$zero" ]] 
                then
                        echo -n -e "${ab[$x]}\t"
                         sed "/${rx[$x]}/d" user.txt >  user_4.txt && mv user_4.txt user.txt
                         echo -n -e "${ab[$x]}\t$2\n"   >> user.txt
			demo_db=0
			demo_db=$2
			break
                fi
                        ((x=x+1))
                   done < "$usr"
                        two=2
		;;
esac
}
function update_access ()
{ 
	case "$3" in
		"1")awk '{print $1}' ./user.txt > revanth
			usr=revanth
                name="$1"
                i=0
                j=0
                count=0
                x=0
                zero=0
                awk '{print $1"        "$2}' ./user.txt > user_2.txt
                awk '{print $4" "$5"    "$6}' ./user.txt > user_7.txt
                awk '{print $3}' ./user.txt > user_6.txt
                user_56=user_7.txt
                while read -r line; do
                bxxx[j]="$line"
                ((j=j+1))
                done < "$user_56"
                j=0
                user_name=user_2.txt
                while read -r line; do
                ab[j]="$line"
                ((j=j+1))
                done < "$user_name"
                demo_privilege=user_6.txt
                aa=0
                while read -r line; do
                xx[aa]="$line"
                ((aa=aa+1))
                done < "$demo_privilege"
		aa=0
                while read -r line; do
                rx[aa]="$line"
		((aa=aa+1))
                done < "$user"
                while read -r line; do
		if [[ "$line" = "$name" ]]
                then
                        echo -n -e "${ab[$x]}\t"
                         sed "/$line/d" user.txt >  user_4.txt && mv user_4.txt user.txt
                         echo -n -e "${ab[$x]}\t$2\t${bxxx[$x]}\n"   >> user.txt
                 fi
                        ((x=x+1))
                   done < "$usr"
		;;
		"2")awk '{print $1}' ./user.txt > revanth
			 usr=revanth
                name="$1"
                i=0
                j=0
                count=0
                x=0
                zero=0
                awk '{print $1"        "$2"     "$3}' ./user.txt > user_2.txt
                awk '{print $4}' ./user.txt > user_7.txt
                awk '{print $5" "$6}' ./user.txt > user_6.txt
                 user_56=user_7.txt
                while read -r line; do
                bxxx[j]="$line"
                ((j=j+1))
                done < "$user_56"
                j=0
                user_name=user_2.txt
                while read -r line; do
                ab[j]="$line"
                ((j=j+1))
                done < "$user_name"
                demo_privilege=user_6.txt
                aa=0
                while read -r line; do
                xx[aa]="$line"
                ((aa=aa+1))
                done < "$demo_privilege"
                aa=0
                while read -r line; do
                rx[aa]="$line"
		((aa=aa+1))
                done < "$user"
                while read -r line; do
                if [[ "$line" = "$name" ]] 
                then
                        echo -n -e "${ab[$x]}\t"
                         sed "/$line/d" user.txt >  user_4.txt && mv user_4.txt user.txt
                         echo -n -e "${ab[$x]}\t$2\t${bxxx[$x]}\n"   >> user.txt
                fi
			((x=x+1))
		done < "$usr"
                ;;
		"3")awk '{print $1}' ./user.txt > revanth
			 usr=revanth
                name="$1"
                i=0
                j=0
                count=0
                x=0
                zero=0
                awk '{print $1"        "$2"    "$3"    "$4}' ./user.txt > user_2.txt
                awk '{print $5}' ./user.txt > user_6.txt
                awk '{print $6}' ./user.txt > user_7.txt
                user_56=user_7.txt
                while read -r line; do
                bxxx[j]="$line"
                ((j=j+1))
                done < "$user_56"
                j=0
                user_name=user_2.txt
                while read -r line; do
                ab[j]="$line"
                ((j=j+1))
                done < "$user_name"
                demo_privilege=user_6.txt
                aa=0
                while read -r line; do
                xx[aa]="$line"
                ((aa=aa+1))
                done < "$demo_privilege"
                user=user.txt
                aa=0
                while read -r line; do
                rx[aa]="$line"
		((aa=aa+1))
                done < "$user"
                while read -r line; do
                if [[ "$line" = "$name" ]] 
                then
                        echo -n -e "${ab[$x]}\t"
                         sed "/$line/d" user.txt >  user_4.txt && mv user_4.txt user.txt
                        echo -n -e "${ab[$x]}\t$2\t${bxxx[$x]}\n"   >> user.txt
                fi
		((x=x+1))
		done < "$usr"
                ;;
		"4")  awk '{print $1}' ./user.txt > revanth
                usr=revanth
                name="$1"
                i=0
                j=0
                count=0
                x=0
                zero=0
                awk '{print $1" "$2"    "$3"    "$4"    "$5}' ./user.txt > user_2.txt
                awk '{print $6}' ./user.txt > user_6.txt
                user_name=user_2.txt
                while read -r line; do
                ab[j]="$line"
                ((j=j+1))
                done < "$user_name"
                demo_privilege=user_6.txt
                aa=0
                while read -r line; do
                xx[aa]="$line"
                ((aa=aa+1))
                done < "$demo_privilege"
                user=user.txt
                aa=0
                while read -r line; do
                rx[aa]="$line"
                ((aa=aa+1))
                done < "$user"
                while read -r line; do
                if [[ "$line" = "$name" ]] 
                then
                        echo -n -e "${ab[$x]}\t"
			sed "/$line/d" user.txt >  user_4.txt && mv user_4.txt user.txt
                         echo -n -e "${ab[$x]}\t$2\n"   >> user.txt
                fi
			((x=x+1))
		done < "$usr"
                ;;
	esac
}
function abcd ()
{
	zero=0
	`touch rev `
	converting_users 
	echo -e "Choose which to give access to \n1.Staging\n2.Demo\n3.Sandbox\n4.Prod\n"
	read uuu
	numb="$1"
	shift
	lsw=("$@")
	for ((f=0;f<${numb};f++))
do
	count=0
	echo -e "${lsw[$f]}"
	grep -i "${lsw[$f]}" users > rev
	x=rev
	i=0
	three=3
	echo -e "Searching users according to the name given ................ \n"
	while read -r line; do
         ab[i]="$line"
	echo -e "$i $line \n"
        ((i=i+1))
	((count=count+1))
	done < "$x" 
	t=0
	tttt=-1
	if((count > t))
then
		echo -e "Choose the given user_name or -1 to enter a new name\n"
          read a
	if((a != tttt))
	then 
          s="${ab[$a]}"
                echo "Choose the privelege type for the given instance for all the users "
                echo -e "\n 1.Read \n 2.Write \n 3.Limited \n 4.SP \n 5.Prod-Limited \n 6.QA-Limited "
                read b
	i=0
		echo -e "Choose option \n 1. For giving priveleges for 1 database .\n 2.For giving accesss to all the databases. \n 3. For creating users in all the hosts or some hosts \n "
		read zx
		case "$zx" in 
		"1") echo -e "Choose : \n 1.Non-prod hosts \n 2.Prod hosts"
        read xoxo
        one=1
        two=2
        if ((xoxo == one))
        then
                hosts=hostname.txt
	elif ((xoxo == two))
	then
		 hosts=hostname-prod.txt
	fi
		echo -e "Choose the number associated with the hostname \n"
         while read -r line; do
          ast[i]="$line"
         echo -e "$i. ${ast[$i]}\n"
         ((i=i+1))
        done < "$hosts"
         read d
         bl="${ast[$d]}"
		alldb "$bl"
        echo "$(cat databases)"
	 echo -n "Choose the database on which you have to give access to .Please write full name = "
                read c
		if ((re == three))
        then
		update_access "$s" "$b" "$uuu"
                mysql -B -N -h$bl -u$dbuser -p$password -e "DROP USER '"$s"';"
                 awk '{print $2}' ./user.txt > user_12.txt
                passwords__=user_12.txt
                awk '{print $1}' ./user.txt > user_13.txt
                usernames__=user_13.txt
                i=0
                 while read -r line; do
                pass_word[i]="$line"
                ((i=i+1))
                done < "$passwords__"
		i=0
                while read -r line; do
                user_name[i]="$line"
                if [[ "${user_name[$i]}" = "$s" ]]
                then
                        result="${pass_word[$i]}"
                        break
                fi
                ((i=i+1))
                done < "$usernames__"
         mysql -B -N -h$bl -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$s"'@'%' IDENTIFIED BY '"$result"';"
        else
               awk '{print $2}' ./user.txt > user_12.txt
                passwords__=user_12.txt
                awk '{print $1}' ./user.txt > user_13.txt
                usernames__=user_13.txt
                i=0
                 while read -r line; do
                pass_word[i]="$line"
                ((i=i+1))
                done < "$passwords__"
		i=0
                while read -r line; do
                user_name[i]="$line"
                if [[ "${user_name[$i]}" = "$s" ]]
                then
                        result="${pass_word[$i]}"
                        break
                fi
                ((i=i+1))
                done < "$usernames__"
		 bcd "$s" "$b" "$uuu"
                mysql -B -N -h$bl -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$s"'@'%' IDENTIFIED BY '"$result"';"
        fi
		if ((demo_db == zero )) || ((demo_db == b))
                then
                DB_Privileges "$b" "$c" "$s" "$bl"
                else
                DB_Privileges "$demo_db" "$c" "$s" "$bl"
                fi
		;;
		"2")
		echo -e "Choose : \n 1.Non-prod hosts \n 2.Prod hosts"
        read xoxo
        one=1
        two=2
        if (( xoxo == one))
        then
                hosts=hostname.txt
        elif (( xoxo == two))
        then
                 hosts=hostname-prod.txt
        fi
		echo -e "Choose the number associated with the host name \n"
         while read -r line; do
          ast[i]="$line"
         echo -e "$i. ${ast[$i]}\n"
         ((i=i+1))
         done < "$hosts"
         read d
         bl="${ast[$d]}"
		three=3
		if ((re == three))
	then
		update_access "$s" "$b" "$uuu"
		mysql -B -N -h$bl -u$dbuser -p$password -e "DROP USER '"$s"';" 
		 awk '{print $2}' ./user.txt > user_12.txt
                passwords__=user_12.txt
                awk '{print $1}' ./user.txt > user_13.txt
                usernames__=user_13.txt
                i=0
                 while read -r line; do
                pass_word[i]="$line"
                ((i=i+1))
                done < "$passwords__"
		i=0
                while read -r line; do
                user_name[i]="$line"
                if [[ "${user_name[$i]}" = "$s" ]]
                then
                        result="${pass_word[$i]}"
                        break
                fi
                ((i=i+1))
                done < "$usernames__"
         mysql -B -N -h$bl -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$s"'@'%' IDENTIFIED BY '"$result"';"
	else
		awk '{print $2}' ./user.txt > user_12.txt
                passwords__=user_12.txt
                awk '{print $1}' ./user.txt > user_13.txt
                usernames__=user_13.txt
                i=0
                 while read -r line; do
                pass_word[i]="$line"
                ((i=i+1))
                done < "$passwords__"
		i=0
                while read -r line; do
                user_name[i]="$line"
                if [[ "${user_name[$i]}" = "$s" ]]
                then
                        result="${pass_word[$i]}"
                        break
                fi
                ((i=i+1))
                done < "$usernames__"
		bcd "$s" "$b" "$uuu"
		mysql -B -N -h$bl -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$s"'@'%' IDENTIFIED BY '"$result"';"
	fi
		alldb "$bl"
		dbase=databases
		echo -e "Giving privileges"
                while read -r line;do
                c="$line"
		if ((demo_db == zero )) || ((demo_db == b))
                then
                DB_Privileges "$b" "$c" "$s" "$bl"
                else
                DB_Privileges "$demo_db" "$c" "$s" "$bl"
                fi
                done < "$dbase"
		;;
		"3")`touch users`
        echo -e "Choose 1 for all the hosts or 2 for selected hosts \n"
        read w
        `touch databases`
         case "$w" in
        "1")echo -e "Choose : \n 1.Non-prod hosts \n 2.Prod hosts"
        read xoxo
        one=1
        two=2
        if ((xoxo == one))
        then
                hosts=hostname.txt
        elif ((xoxo == two))
        then
                 hosts=hostname-prod.txt
        fi
	three=3
	if ((re == three))
        then
		 update_access "$s" "$b" "$uuu"
                while read -r line; do
		ht="$line"
                mysql -B -N -h$ht -u$dbuser -p$password -e "DROP USER '"$s"';"
                 awk '{print $2}' ./user.txt > user_12.txt
                passwords__=user_12.txt
                awk '{print $1}' ./user.txt > user_13.txt
                usernames__=user_13.txt
                i=0
                 while read -r line; do
                pass_word[i]="$line"
                ((i=i+1))
                done < "$passwords__"
		i=0
                while read -r line; do
                user_name[i]="$line"
                if [[ "${user_name[$i]}" = "$s" ]]
		then
                        result="${pass_word[$i]}"
                        break
                fi
                ((i=i+1))
                done < "$usernames__"
         mysql -B -N -h$ht -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$s"'@'%' IDENTIFIED BY '"$result"';"
		done < "$hosts"
        else
                bcd "$s" "$b" "$uuu"
        fi
         while read -r line; do
                 asd="$line"
		awk '{print $2}' ./user.txt > user_12.txt
                passwords__=user_12.txt
                awk '{print $1}' ./user.txt > user_13.txt
                usernames__=user_13.txt
                i=0
                 while read -r line; do
                pass_word[i]="$line"
                ((i=i+1))
                done < "$passwords__"
		i=0
                while read -r line; do
                user_name[i]="$line"
                if [[ "${user_name[$i]}" = "$s" ]]
                then
                        result="${pass_word[$i]}"
                        break
                fi
                ((i=i+1))
                done < "$usernames__"
		 mysql -B -N -h$asd -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$s"'@'%' IDENTIFIED BY '"$result"';"
        alldb "$asd"
        dbase=databases
         while read -r line; do
                c="$line"
		if ((demo_db == zero )) || ((demo_db == b))
                then
                DB_Privileges "$b" "$c" "$s" "$asd"
                else
                DB_Privileges "$demo_db" "$c" "$s" "$asd"
                fi
        done < "$dbase"
        done < "$hosts"
        ;;
        "2")three=3
		 echo -e "Choose : \n 1.Non-prod hosts \n 2.Prod hosts"
        read xoxo
        one=1
        two=2
        if ((xoxo == one))
        then
                hots=hostname.txt
		 echo -e "All the hosts \n"
                echo -e "$(cat hostname.txt)\n"
        elif ((xoxo == two))
        then
                 hots=hostname-prod.txt
		 echo -e "All the hosts \n"
                echo -e "$(cat hostname-prod.txt)\n"
        fi
        i=0
        while read -r line; do
                 ab[i]="$line"
                ((i=i+1))
        done < "$hots"
        echo -e "Choose the number of hosts \n"
        read uv
        echo -e " Pick hosts from the above list. Please write full name \n "
        `touch host`
        for ((i=0;i<${uv};i++))
        do
                read d[i]
                echo "${d[$i]}" >> host
        done
        hosts=host
	if ((re == three))
        then
		update_access "$s" "$b" "$uuu"
                while read -r line; do
                ht="$line"
                mysql -B -N -h$ht -u$dbuser -p$password -e "DROP USER '"$s"';"
                 awk '{print $2}' ./user.txt > user_12.txt
                passwords__=user_12.txt
                awk '{print $1}' ./user.txt > user_13.txt
                usernames__=user_13.txt
                i=0
                 while read -r line; do
                pass_word[i]="$line"
                ((i=i+1))
                done < "$passwords__"
		i=0
                while read -r line; do
                user_name[i]="$line"
                if [[ "${user_name[$i]}" = "$s" ]]
                then
                        result="${pass_word[$i]}"
                        break
                fi
                ((i=i+1))
                done < "$usernames__"
         mysql -B -N -h$ht -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$s"'@'%' IDENTIFIED BY '"$result"';"
                done < "$hosts"
        else
                bcd "$s" "$b" "$uuu"
        fi
        echo -e "Creating all the users and granting the privileges in hosts"
         while read -r line; do
                 asd="$line"
		awk '{print $2}' ./user.txt > user_12.txt
                passwords__=user_12.txt
                awk '{print $1}' ./user.txt > user_13.txt
                usernames__=user_13.txt
                i=0
                 while read -r line; do
                pass_word[i]="$line"
                ((i=i+1))
                done < "$passwords__"
		i=0
                while read -r line; do
                user_name[i]="$line"
                if [[ "${user_name[$i]}" = "$s" ]]
                then
                        result="${pass_word[$i]}"
                        break
                fi
                ((i=i+1))
                done < "$usernames__"
		mysql -B -N -h$asd -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$s"'@'%' IDENTIFIED BY '"$result"';"
        alldb "$asd"
        dbase=databases
         while read -r line; do
                c="$line"
		if ((demo_db == zero )) || ((demo_db == b))
                then
                DB_Privileges "$b" "$c" "$s" "$asd"
                else
                DB_Privileges "$demo_db" "$c" "$s" "$asd"
                fi
        done < "$dbase"
        done < "$hosts"
		 `rm -f host`
        ;;
        esac
		;;
		esac
	else
		 echo -e "Enter the user_name because the pattern did not match \n"
        read a
                passwd=$(tr -dc 'A-Za-z0-9!#%&\''*+@`|' </dev/urandom | head -c 16)
                echo -e "\n"
                echo "Choose the privelege type for the given instance for all the users "
                echo -e "\n 1.Read \n 2.Write \n 3.Limited \n 4.SP \n 5.Prod-Limited \n 6.QA-Limited \n 7.All"
                read b
                instance_type "$uuu" "$a" "$b" "$passwd"
        i=0
                echo -e "Choose option \n1. for giving priveleges for 1 database .\n2.for giving accesss to all the databases. \n3. For creating users in all the hosts and giving privileges \n "
                read zx
                case "$zx" in
                "1") echo -e "Choose : \n 1.Non-prod hosts \n 2.Prod hosts"
        read xoxo
        one=1
        two=2
        if ((xoxo  == one))
        then
                hosts=hostname.txt
        elif ((xoxo == two))
        then
                 hosts=hostname-prod.txt
        fi
		echo -e "Choose the number associated with the  host name \n"
         while read -r line; do
          ast[i]="$line"
          echo -e "$i. ${ast[$i]}\n"
         ((i=i+1))
         done < "$hosts"
         read d
        bl="${ast[$d]}"
		mysql -B -N -h$bl -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$a"'@'%' IDENTIFIED BY '"$passwd"';"
		alldb "$bl"
        echo "$(cat databases)"
        echo -n "Choose the database on which you have to give access to .Please write full name = "
                read c
		echo "Giving priveleges"
                                DB_Privileges "$b" "$c" "$a" "$bl"
		echo -e "Username : $a \nPassword : $passwd\n"
                ;;
                "2") echo -e "Choose : \n 1.Non-prod hosts \n 2.Prod hosts"
        read xoxo
        one=1
        two=2
        if ((xoxo == one))
        then
                hosts=hostname.txt
        elif ((xoxo == two))
        then
                 hosts=hostname-prod.txt
        fi
		echo -e "Choose the number assaciated with the host name \n"
         while read -r line; do
          ast[i]="$line"
          echo -e "$i. ${ast[$i]}\n"
         ((i=i+1))
         done < "$hosts"
	        read d
         bl="${ast[$d]}"
		mysql -B -N -h$bl -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$a"'@'%' IDENTIFIED BY '"$passwd"';"
		alldb "$bl"
                dbase=databases
        echo "Giving priveleges"
                while read -r line;do
                c="$line"
                 DB_Privileges "$b" "$c" "$a" "$bl"
                done < "$dbase"
echo -e "Username : $a \nPassword : $passwd\n"
                ;;
                "3")`touch users`
        echo -e "Choose the hosts \n"
        read w
        `touch databases`
         case "$w" in
        "1")echo -e "Choose : \n 1.Non-prod hosts \n 2.Prod hosts"
        read xoxo
        one=1
        two=2
        if ((xoxo == one))
        then
                hosts=hostname.txt
        elif ((xoxo == two))
        then
                 hosts=hostname-prod.txt
        fi
         while read -r line; do
                 asd="$line"
	 mysql -B -N -h$asd -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$a"'@'%' IDENTIFIED BY '"$passwd"';"
        alldb "$asd"
        dbase=databases
         while read -r line; do
                c="$line"
                DB_Privileges "$b" "$c" "$a" "$asd"
        done < "$dbase"
        done < "$hosts"
	echo -e "Username : $a \nPassword : $passwd\n"
        ;;
        "2")	 echo -e "Choose : \n 1.Non-prod hosts \n 2.Prod hosts"
        read xoxo
        one=1
        two=2
        if ((xoxo == one))
        then
                hots=hostname.txt
        elif ((xoxo == two))
        then
                 hots=hostname-prod.txt
        fi
        i=0
                hots=hostname.txt
        echo -e "Choose the hosts \n"
		i=0
        while read -r line; do
                 ab[i]="$line"
		 echo -e "$i. ${ast[$i]}\n"
                ((i=i+1))
        done < "$hots"
        echo -e "Choose the number of hosts \n"
        read uv
        echo -e " Pick hosts from the above list. Please write full name \n "
        `touch host`
        for ((i=0;i<${uv};i++))
        do
                read d[i]
                echo "${d[$i]}" >> host
        done
        hosts=host
        echo -e "Creating all the users and granting the privileges in hosts"
         while read -r line; do
                 asd="$line"
	mysql -B -N -h$asd -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$a"'@'%' IDENTIFIED BY '"$passwd"';"
        alldb "$asd"
        dbase=databases
         while read -r line; do
                c="$line"
                DB_Privileges "$b" "$c" "$a" "$asd"
        done < "$dbase"
        done < "$hosts"
                 `rm -f host`
	echo -e "Username : $a \nPassword : $passwd\n"
        ;;
        esac
                ;;
                esac

fi
else
		 echo -e "Enter the user_name because the pattern did not match \n"
        read a
                 passwd=$(tr -dc 'A-Za-z0-9!#%&\''*+@`|' </dev/urandom | head -c 16)
                echo -e "\n"
                echo "Choose the privelege type for the given instance for all the users "
                echo -e "\n 1.Read \n 2.Write \n 3.Limited \n 4.SP \n 5.Prod-Limited \n 6.QA-Limited \n 7.All "
                read b
                echo -e "All the hosts \n"
		instance_type "$uuu" "$a" "$b" "$passwd" 
        i=0
                echo -e "1. For giving priveleges for 1 database .\n 2.For giving accesss to all the databases. \n 3. For creating users in all the hosts and giving privileges \n "
                read zx
                case "$zx" in
                "1")echo -e "Choose : \n 1.Non-prod hosts \n 2.Prod hosts"
        read xoxo
        one=1
        two=2
        if ((xoxo == one))
        then
                hosts=hostname.txt
        elif ((xoxo == two))
        then
                 hosts=hostname-prod.txt
        fi
		echo -e "Choose the number associated with the  host name \n"
         while read -r line; do
          ast[i]="$line"
          echo -e "$i. ${ast[$i]}\n"
         ((i=i+1))
         done < "$hosts"
         read d
         bl="${ast[$d]}"
                  mysql -B -N -h$bl -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$a"'@'%' IDENTIFIED BY '"$passwd"';"
		alldb "$bl"
        echo "$(cat databases)"
        echo -n "Choose the database on which you have to give access to .Please write full name = "
                read c
                        echo "Giving priveleges"
                                DB_Privileges "$b" "$c" "$a" "$bl"
		echo -e "Username : $a \nPassword : $passwd\n"
                ;;
                "2")echo -e "Choose : \n 1.Non-prod hosts \n 2.Prod hosts"
        read xoxo
        one=1
        two=2
        if ((xoxo == one))
        then
                hosts=hostname.txt
        elif ((xoxo == two))
        then
                 hosts=hostname-prod.txt
        fi
		echo -e "Choose the number associated with the host name \n"
         while read -r line; do
          ast[i]="$line"
          echo -e "$i. ${ast[$i]}\n"
         ((i=i+1))
         done < "$hosts"
         read d
         bl="${ast[$d]}"
                  mysql -B -N -h$bl -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$a"'@'%' IDENTIFIED BY '"$passwd"';"
		alldb "$bl"
                dbase=databases
        echo "Giving priveleges"
                while read -r line;do
                c="$line"
                 DB_Privileges "$b" "$c" "$a" "$bl"
                done < "$dbase"
		echo -e "Username : $a \nPassword : $passwd\n"
                ;;
                "3")`touch users`
        echo -e "Choose 1 for all the hosts or 2 for selected hosts \n"
        read w
        `touch databases`
         case "$w" in
        "1")echo -e "Choose : \n 1.Non-prod hosts \n 2.Prod hosts"
        read xoxo
        one=1
        two=2
        if ((xoxo == one))
        then
                hosts=hostname.txt
        elif ((xoxo == two))
        then
                 hosts=hostname-prod.txt
        fi
         while read -r line; do
                 asd="$line"
	mysql -B -N -h$asd -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$a"'@'%' IDENTIFIED BY '"$passwd"';"
        alldb "$asd"
        dbase=databases
         while read -r line; do
                c="$line"
                DB_Privileges "$b" "$c" "$a" "$asd"
        done < "$dbase"
        done < "$hosts"
	echo -e "Username : $a \nPassword : $passwd\n"
        ;;
         "2")
                 echo -e "Choose : \n 1.Non-prod hosts \n 2.Prod hosts"
        read xoxo
        one=1
        two=2
        if ((xoxo == one))
        then
                hots=hostname.txt
                 echo -e "All the hosts \n"
                echo -e "$(cat hostname.txt)\n"
        elif ((xoxo ==two))
        then
                 hots=hostname-prod.txt
                 echo -e "All the hosts \n"
                echo -e "$(cat hostname-prod.txt)\n"
        fi
        i=0
		while read -r line; do
		ab[i]="$line"
                ((i=i+1))
        done < "$hots"
        echo -e "Choose the number of hosts \n"
        read uv
        echo -e " Pick hosts from the above list. Please write full name \n "
        `touch host`
        for ((i=0;i<${uv};i++))
        do
                read d[i]
                echo "${d[$i]}" >> host
        done
        hosts=host
        echo -e "Creating all the users and granting the privileges in hosts"
         while read -r line; do
                 asd="$line"
	 mysql -B -N -h$asd -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$a"'@'%' IDENTIFIED BY '"$passwd"';"
        alldb "$asd"
        dbase=databases
         while read -r line; do
                c="$line"
                DB_Privileges "$b" "$c" "$a" "$asd"
        done < "$dbase"
        done < "$hosts"
                 `rm -f host`
	echo -e "Username : $a \nPassword : $passwd\n"
        ;;
        esac
                ;;
                esac

fi
done
}
echo -e "1. Create users and giving them privileges to certain databases or all databases\n2. Migrating all the users from different host. \n3. Update user privileges in user file \n4. Delete user from all the host \n5. Provide temporary access on a host\n"
read re
if ((re == 1));
then
echo -e "Enter the number of users you want to give access to \n"
echo -n "Number="
read numb
echo "Enter their names/name"
hosts=hostname.txt
for ((i=0;i<${numb};i++))
        do
                echo -n "Name="
                read names[i]
        done
	abcd "$numb" "${names[@]}" 
i=0
`touch databases`	
echo "Users created and given access "
`rm -f revanth user_1.txt user_2.txt user_3.txt databases users privilege passwords rev passwords privilege user_6.txt user_5.txt user_7.txt`
elif ((re == 3));
then
echo -e "Enter the number of users you want to update the access to \n"
echo -n "Number="
read numb
echo "Enter their names/name"
hosts=hostname.txt
for ((i=0;i<${numb};i++))
        do
                echo -n "Name="
                read names[i]
        done
        abcd "$numb" "${names[@]}" "$re"
i=0
`touch databases`
echo "Users created and given access "
`rm -f revanth user_1.txt user_2.txt user_3.txt databases users privilege passwords rev passwords privilege user_6.txt user_5.txt user_7.txt`
elif ((re == 2));
then 
	username=user.txt
	passwrd=password.txt
	echo -e "Choose : \n 1.Non-prod hosts \n 2.Prod hosts"
	read xoxo
	one=1
	two=2
	if ((xoxo == one))
	then
		hosts=hostname.txt
		echo -e "List of all the hosts"
        echo "$(cat hostname.txt)"
        echo -e "Please add the new host - name"
        read ew
        echo "$ew" >> hostname.txt
	elif ((xoxo == two))
	then
		 hosts=hostname-prod.txt
		echo -e "List of all the hosts"
        echo "$(cat hostname-prod.txt)"
        echo -e "Please add the new host - name"
        read ew
        echo "$ew" >> hostname-prod.txt
	fi 
	echo -e "creating all users"
	i=0
	echo -e "Choose option \n 1. for Staging \n 2. for Demo \n 3.for Sandbox \n 4. for Production \n "
	read ty
	case "$ty" in 
		"1")awk '{print $1}' ./user.txt > users
			awk '{print $2}' ./user.txt > passwords 	
			awk '{print $3}' ./user.txt > privilege
		;;
		"2")awk '{print $1}' ./user.txt > users
                        awk '{print $2}' ./user.txt > passwords
                        awk '{print $4}' ./user.txt > privilege
		;;
		"3")awk '{print $1}' ./user.txt > users
                        awk '{print $2}' ./user.txt > passwords
                        awk '{print $5}' ./user.txt > privilege
                ;;
		"4")awk '{print $1}' ./user.txt > users
                        awk '{print $2}' ./user.txt > passwords
                        awk '{print $6}' ./user.txt > privilege
                ;;
	esac
	x=users
	y=privilege
	z=passwords
	 while read -r line ;do
		ab[i]="$line"
        	((i=i+1))
	done < "$x"
	j=0
	 while read -r line; do
                 bc[j]="$line"
                ((j=j+1))
        done < "$z"	
#	for ((i=0;i<2;i++))
 #       do
  #              mysql -B -N -h$ew -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"${ab[$i]}"'@'%' IDENTIFIED BY '"{$bc[$i]}"';"
#	 done
	echo -e "Granting the same privileges "
        i=0
	alldb "$ew"
	datbase=databases
	while read -r line ;do
	mysql -B -N -h$ew -u$dbuser -p$password -e "CREATE USER IF NOT EXISTS '"$line"'@'%' IDENTIFIED BY '"{$bc[$i]}"';"
	while read -r line ;do
	c="$line"
	i=0
  while read -r line ;do
	l="$line"
	echo "$c"
	echo -e "${ab[$i]}"
	DB_Privileges "$l" "$c" "${ab[$i]}" "$ew"
	((i=i+1))
	done < "$y"
	done < "$datbase"
	done < "$x"
	`rm -f users privilege databases passwords`
	echo -e "It is done "
`rm -f databases users privilege passwords`
elif ((re == 4));
then
echo -e "Please select the number of users"
        echo -n "Number="
        read numb
        echo "Enter their names/name"
        for ((i=0;i<${numb};i++))
                do
                        echo -n "Name="
                        read names[i]
                done
        Deleting_users "$numb" "${names[@]}"
        echo "Deleted users"
`rm -f revanth user_1.txt user_2.txt user_3.txt databases users privilege passwords rev passwords privilege user_6.txt user_5.txt user_7.txt grants grants.txt`
elif ((re == 5));
then
echo -e "Enter the number of users you want to update the access to \n"
echo -n "Number="
read numb
echo "Enter their names/name"
hosts=hostname.txt
for ((i=0;i<${numb};i++))
        do
                echo -n "Name="
                read names[i]
        done
        temp_access "$numb" "${names[@]}" "$re"
i=0
`rm -f revanth user_1.txt user_2.txt user_3.txt databases users privilege passwords rev passwords privilege user_6.txt user_5.txt user_7.txt grants grants.txt`
fi
`rm -f users_1 user_11.txt user_10.txt user_12.txt user_13.txt grants grants.txt`
DEBUG set +x
