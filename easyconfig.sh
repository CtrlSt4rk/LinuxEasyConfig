function automountboot(){
	#mounting on standard points (/mnt/partname)
	clear
	printf '%s\n' "AutoMount utility, press A to AutoMount"
	printf '%s\n' "If you want to revert it, please press R"
	read -s -n 1 optionAutoMount

	if [ $optionAutoMount == "a" ] || [ $optionAutoMount == "A" ]
	then
		clear
		printf '%s\n' "These are the found partitions in your system"
		printf '%s\n' "If you can't identify, please go to your file manager and add check the mount name"
		printf '%s\n\n' "Only non mounted partitions can be used! If you can't identify reboot the system before"
		printf '\n%s' "How many new partitions should be mounted on boot: "
		read partitionNumber
		sudo cp /etc/fstab /etc/fstab.backup
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
			sudo mkdir /media/$partitionName
			echo "UUID=$uuid	/media/$partitionName 	$fstype 	defaults	0	0" | sudo tee -a /etc/fstab
			#sudo su -c  echo "UUID=$uuid	/media/$partitionName 	$fstype 	defaults	0	0" >> /etc/fstab
		done
		sudo mount -a
		#echo "Mounting was successful!"
	fi
	if [ $optionAutoMount == "r" ] || [ $optionAutoMount == "R" ]
	then
		sudo cp /etc/fstab.backup /etc/fstab
		#echo "Restore was successful!"
	fi
}



automountboot