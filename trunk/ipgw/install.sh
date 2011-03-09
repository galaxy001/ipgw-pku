#!/bin/bash
### BEGIN INIT INFO
# Provides:          boot_facility_1 [ boot_facility_2 ...]
# Required-Start:    boot_facility_1 [ boot_facility_2 ...]
# Required-Stop:     boot_facility_1 [ boot_facility_2 ...]
# Should-Start:      boot_facility_1 [ boot_facility_2 ...]
# Should-Stop:       boot_facility_1 [ boot_facility_2 ...]
# X-Start-Before:    boot_facility_1 [ boot_facility_2 ...]
# X-Stop-After:      boot_facility_1 [ boot_facility_2 ...]
# Default-Start:     run_level_1 [ run_level_2 ...]
# Default-Stop:      run_level_1 [ run_level_2 ...]
# Short-Description: single_line_description
# Description:       multiline_description
### END INIT INFO

# IPGW Installer
#   AUTHOR: Chen Xing(  cxcxcxcx@gmail.com )
#  WEBSITE: http://www.linux-wiki.cn/
#  Created: 2007/09/27
# Modified: 2008/02/28
# Modified: 2009/02/15
# Modified: 2009/03/30

if [ "$(id -u)" != "0" ]; then
	echo "You must be root to do this."
	exit 1
fi


echo "Please contact Chen Xing ( cxcxcxcx@gmail.com ) to report bugs."

echo "Uninstalling..."
./uninstall.sh

install -m 755 -o root -g root ipgw /bin/ipgw
echo -ne "\033[0;35mSave password\033[0m (or ipgw can't run automatically)? [Y/n]"
read ans
if [ "$ans" == "y" ] || [ "$ans" == "Y" ] || [ "$ans" == "" ]; then
	# ∂¡»Î√‹¬Î
	echo "Please input your ipgw username and password."
	read -p "Username: " USERNAME
	read -r -s -p "Password: " PASSWORD
	echo

	PASSWORD=`python ./ipgw mkPwdStr <<< "$PASSWORD"`
	sed -i "s/YourUserName/$USERNAME/" /bin/ipgw
	sed -i "s/YourPassword/$PASSWORD/" /bin/ipgw

	echo -ne "\033[0;35mRun ipgw automatically whenever network is ready?\033[0m  [Y/n]"
	read ans
	if [ "$ans" == "y" ] || [ "$ans" == "Y" ] || [ "$ans" == "" ]; then
		echo "If you are using NetworkManager with the dispatcher enabled (Ubuntu do this by default, for example), please choose the first one."

		PS3="Please select your distribution: "
		select DISTR in NetworkManager-with-Dispatcher Debian/Ubuntu Gentoo openSUSE Archlinux Other
		do
			case $DISTR in
				NetworkManager-with-Dispatcher )
					DISTR="nm"
					break
					;;
				Debian/Ubuntu )
					DISTR="DEBLIKE"
					break
					;;
				Gentoo )
					DISTR="GENTOO"
					break
					;;
				openSUSE )
					DISTR="SUSE"
					break
					;;
				Archlinux )
					DISTR="ARCH"
					break
					;;
				Other )
					DISTR="FEDORA"
					break
					;;
				*)
					echo "Please give a correct choice!"
					;;
			esac
		done
		if [ $DISTR = "DEBLIKE" ]; then
			install -m 755 -o root -g root ipgws /etc/init.d/ipgw
			echo -ne '#!/bin/bash\nipgw connect\n' > /etc/network/if-up.d/ipgw
			echo -ne '#!/bin/bash\nipgw disconnect\n' > /etc/network/if-down.d/ipgw
			chmod +x /etc/network/if-up.d/ipgw
			chmod +x /etc/network/if-down.d/ipgw
			#ln -fs /etc/init.d/ipgw /etc/rc2.d/S90ipgw
		elif [ $DISTR = "nm" ]; then
			install -m 755 -o root -g root ipgw_nm /etc/NetworkManager/dispatcher.d/99_ipgw
		elif [ $DISTR = "FEDORA" ]; then
			install -m 755 -o root -g root ipgws /etc/init.d/ipgw
			ln -fs /etc/init.d/ipgw /etc/rc5.d/S90ipgw
			ln -fs /etc/init.d/ipgw /etc/rc6.d/K13ipgw
			ln -fs /etc/init.d/ipgw /etc/rc0.d/K13ipgw
		elif [ $DISTR = "GENTOO" ]; then
			install -m 755 -o root -g root ipgws_gen /etc/init.d/ipgw
			rc-update add ipgw default
		elif [ $DISTR = "SUSE" ]; then
			install -m 755 -o root -g root ipgws /etc/init.d/ipgw
			ln -fs /etc/init.d/ipgw /etc/init.d/rc5.d/S90ipgw
			ln -fs /etc/init.d/ipgw /etc/init.d/rc6.d/K13ipgw
			ln -fs /etc/init.d/ipgw /etc/init.d/rc0.d/K13ipgw
		elif [ $DISTR = "ARCH" ]; then
			install -m 755 -o root -g root ipgws_arch /etc/rc.d/ipgw
		else
			install -m 755 -o root -g root ipgws /etc/init.d/ipgw
			ln -fs /etc/init.d/ipgw /etc/rc5.d/S90ipgw
			ln -fs /etc/init.d/ipgw /etc/rc6.d/K13ipgw
			ln -fs /etc/init.d/ipgw /etc/rc0.d/K13ipgw
		fi
	fi
fi



echo
echo "OK."

echo "TIPS: Go to http://www.linux-wiki.cn/ to read/write solutions to daily Linux problems."
