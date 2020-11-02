count=1
	cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
	totalaccounts=`cat /tmp/expirelist.txt | wc -l`
	for((i=1; i<=$totalaccounts; i++ )); do
	tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
		username=`echo $tuserval | cut -f1 -d:`
		userexp=`echo $tuserval | cut -f2 -d:`
		userexpireinseconds=$(( $userexp * 86400 ))
		todaystime=`date +%s`
		expired="$(chage -l $username | grep "Account expires" | awk -F": " '{print $2}')"
		if [ $userexpireinseconds -lt $todaystime ] ; then
			passwd -l $username
			egrep "^$username" /etc/passwd >/dev/null
			count=$((count+1))
		fi
	done
rm -r /tmp/*.txt