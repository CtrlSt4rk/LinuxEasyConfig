function automountboot(){
	#mounting on standard points (/mnt/partitionName)
	clear
	printf '%s\n' "AutoMount utility, made for 1 time use only!! Use it at your own risk"
	printf '%s\n' "Press A to AutoMount and press R to revert it"
	read -s -n 1 optionAutoMount

	if [ $optionAutoMount == "a" ] || [ $optionAutoMount == "A" ]
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
	if [ $optionAutoMount == "r" ] || [ $optionAutoMount == "R" ]
	then
		cp /etc/fstab.backup /etc/fstab
		if [  $? -eq 0 ]
		then
		       echo "Restore was successful!"
		else
		       echo "Restore failed!"
		fi
	fi
}



automountboot