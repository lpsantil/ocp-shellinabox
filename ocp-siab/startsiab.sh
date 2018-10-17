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
echo "$SIABPWD" | passwd developer --stdin

echo "Randomizing root's password"
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1 | passwd root --stdin

unset SIABPWD

shellinaboxd -t -p 8080 -d \
	--user-css Reverse:-/usr/share/shellinabox/$SIABREVERSE.css,Normal:+/usr/share/shellinabox/$SIABNORMAL.css \
	-s "/:LOGIN" 2>&1

echo "----------should not get here----------"

