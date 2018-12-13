if [ -z $SIABPWD ]
then
	echo "***WARNING!***"
	echo "Please create a secret (SIABPWD) to change the default password before using"
	export SIABPWD=developer
fi

if [ -z $SIABNORMAL ]
then
	export SIABNORMAL=white-on-black
fi

if [ -z $SIABREVERSE ]
then
	export SIABREVERSE=black-on-white
fi

echo "Using secret to update password"
/usr/bin/expect << EOD

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

shellinaboxd -t -p 8080 --disable-peer-check -d \
	--user-css Reverse:-/usr/share/shellinabox/$SIABREVERSE.css,Normal:+/usr/share/shellinabox/$SIABNORMAL.css \
	-s "/:developer:developer:/home/developer:/usr/bin/su developer" -u developer -g developer 2>&1

echo "----------should not get here----------"

