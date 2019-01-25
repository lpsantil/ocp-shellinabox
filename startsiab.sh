if [ -z $SIABPWD ]
then
	echo "***WARNING!***"
	echo "Please create a secret (SIABPWD) to change the default password before using"
else
	echo "Updating password"
	/usr/bin/expect << EOD
timeout 5
spawn passwd
expect "assword:"
send "developer\r"
expect "New password:"
send "$SIABPWD\r"
expect "Retype new password:"
send "$SIABPWD\r"

expect eof
EOD

	unset SIABPWD
fi

if [ -z $SIABNORMAL ]
then
	export SIABNORMAL=white-on-black
fi

if [ -z $SIABREVERSE ]
then
	export SIABREVERSE=black-on-white
fi

cat /opt/siab.logo.txt

shellinaboxd -t -p 8080 --disable-peer-check -d \
	--user-css Reverse:-/usr/share/shellinabox/$SIABREVERSE.css,Normal:+/usr/share/shellinabox/$SIABNORMAL.css \
	-s "/:developer:developer:/home/developer:/usr/bin/su developer" -u developer -g developer 2>&1

echo "---------- ERROR! ----------"
echo "---------- ERROR! ----------"
echo "---------- ERROR! ----------"
