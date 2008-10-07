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

if [ "$(id -u)" != "0" ]; then
	echo "You must be root to do this."
	exit 1
fi


echo "Please contact Chen Xing ( cxcxcxcx@gmail.com ) to report bugs."

PS3="Please select your distribution: "
select DISTR in Debian/Ubuntu Gentoo Other
do
	case $DISTR in
		Debian/Ubuntu )
			DISTR="DEBLIKE"
			break
			;;
		Gentoo )
			DISTR="GENTOO"
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

# ∂¡»Î√‹¬Î
echo "Please input your ipgw username and password."
read -p "Username: " USERNAME
read -r -s -p "Password: " PASSWORD

PASSWORD=`python ./ipgw mkPwdStr <<< "$PASSWORD"`


install -m 755 -o root -g root ipgw /bin/ipgw
install -m 755 -o root -g root ipgws /etc/init.d/ipgw
sed -i "s/YourUserName/$USERNAME/" /bin/ipgw
sed -i "s/YourPassword/$PASSWORD/" /bin/ipgw
if [ $DISTR = "DEBLIKE" ]; then
	echo -ne '#!/bin/bash\nipgw connect\n' > /etc/network/if-up.d/ipgw
	echo -ne '#!/bin/bash\nipgw disconnect\n' > /etc/network/if-down.d/ipgw
	chmod +x /etc/network/if-up.d/ipgw
	chmod +x /etc/network/if-down.d/ipgw
	#ln -fs /etc/init.d/ipgw /etc/rc2.d/S90ipgw
elif [ $DISTR = "FEDORA" ]; then
	ln -fs /etc/init.d/ipgw /etc/rc5.d/S90ipgw
	ln -fs /etc/init.d/ipgw /etc/rc6.d/K13ipgw
	ln -fs /etc/init.d/ipgw /etc/rc0.d/K13ipgw
elif [ $DISTR = "GENTOO" ]; then
	install -m 755 -o root -g root ipgws_gen /etc/init.d/ipgw
	rc-update add ipgw default
fi

echo
echo "OK."

echo "Go to http://www.linux-wiki.cn/ to read(write) solutions to daily Linux problems?"
