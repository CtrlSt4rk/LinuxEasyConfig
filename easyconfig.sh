function mainMenu(){
	clear
	echo "Welcome, choose the utility or press Q to quit"
	echo "[0] AutoMount"
	echo "[1] Utilities Download"

	read -s -n 1 input
	if [[ $input = "0" ]]
	then
    	automountboot 
    fi
    if [[ $input = "1" ]]
	then
    	downloadUtilities 
    fi
    if [[ $input = "q" ]] || [[ $input = "Q" ]]
	then
    	exit
    fi
}

function automountboot(){
	#mounting on standard points (/mnt/partitionName)
	clear
	printf '%s\n' "AutoMount utility, made for 1 time use only!! Use it at your own risk"
	printf '%s\n' "Press A to AutoMount, press R to revert it or press Q to quit"
	read -s -n 1 inputAutoMount
	if [[ $inputAutoMount = "q" ]] || [[ $inputAutoMount = "Q" ]]
	then
    	mainMenu 
    fi
	if [ $inputAutoMount == "a" ] || [ $inputAutoMount == "A" ]
	then
		clear
		printf '%s\n' "These are the found partitions in your system"
		printf '%s\n' "If you can't identify, please go to your file manager and add check the mount name"
		printf '%s\n\n' "Only non mounted partitions can be used! If you can't identify reboot the system before"
		printf '\n%s' "How many new partitions should be mounted on boot: "
		read partitionNumber
		cp /etc/fstab /etc/fstab.backup
		for ((i=1;i<=$partitionNumber;i++))
		do
			clear
			lsblk -f
			printf '\n%s' "Type or paste here the UUID of the partition $i: "  
			read uuid
			printf '\n%s' "Type the name of the directory to mount in (lowercase and letters only is recommended): "
			read partitionName
			printf '\n%s' "Type or paste the filesystem used (FSTYPE): "  
			read fstype
			mkdir /media/$partitionName
			echo "UUID=$uuid	/media/$partitionName 	$fstype 	defaults	0	0" | sudo tee -a /etc/fstab
		done
		if [ mount -a &> /dev/null ]
		then
		       echo "Mounting was successful!"
		else
		       echo "Mounting failed!"
		fi 
	fi
	if [ $inputAutoMount == "r" ] || [ $inputAutoMount == "R" ]
	then
		cp /etc/fstab.backup /etc/fstab
		if [  $? -eq 0 ]
		then
		       echo "Restore was successful!"
		else
		       echo "Restore failed!"
		fi
	fi

	echo "Press Q to quit and go back to the main menu"
	read -s -n 1 inputAutoMountEnd
	if [[ $inputAutoMountEnd = "q" ]] || [[ $inputAutoMountEnd = "Q" ]]
	then
    	mainMenu
    fi

}

function downloadUtilities(){
	apt update
	while true
	do
		clear
		printf '%s\n' "Utilities Installer using apt"
		printf '%s\n\n' "Press Q to quit"
		echo "[0] hwloc (lstopo)"
		echo "[1] Htop"
		echo "[2] VIM"
		echo ""
		echo "[U] Update via terminal"

		read -s -n 1 inputUtil

		if [[ $inputUtil = "0" ]]
		then
        	apt install hwloc
        fi
        if [[ $inputUtil = "1" ]]
		then
	        apt install htop
        fi
        if [[ $inputUtil = "2" ]]
		then
        	apt install vim
        fi
        if [[ $inputUtil = "u" ]] || [[ $inputUtil = "U" ]]
		then
       		sudo apt update && sudo apt upgrade
        fi

		if [[ $inputUtil = "q" ]] || [[ $inputUtil = "Q" ]]
		then
        	mainMenu 
        fi
    done
}

mainMenu