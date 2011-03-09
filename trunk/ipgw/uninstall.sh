#!/bin/bash
# IPGW Installer
#   AUTHOR: Chen Xing(  cxcxcxcx@gmail.com )
#  WEBSITE: http://www.linux-wiki.cn/
#  Created: 2007/09/28
# Modified: 2008/02/28
# Modified: 2009/03/30

if [ "$(id -u)" != "0" ]; then
	echo "You must be root to do this."
	exit 1
fi

rm -f /bin/ipgw /usr/bin/ipgw /etc/init.d/ipgw
rm -f /etc/rc6.d/K*ipgw /etc/rc0.d/K*ipgw
rm -f /etc/rc2.d/S*ipgw /etc/rc5.d/S*ipgw
rm -f /etc/network/if-up.d/ipgw
rm -f /etc/network/if-down.d/ipgw
rm -f /etc/NetworkManager/dispatcher.d/99_ipgw

if which rc-update 2>&1 > /dev/null ; then
	rc-update del ipgw default 2>&1 >/dev/null
fi

echo "OK."
