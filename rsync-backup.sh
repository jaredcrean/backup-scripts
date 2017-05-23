#!/bin/bash

######    VAR'S   ########
HOST=$(hostname)
REMOTEIP="192.168.1.28"
REMOTEHOST="thinkpd.jaredcrean.com"
USER="jcrean"
OPTS="--archive --delete --verbose --human-readable --dry-run"
TOBAK="/home/$USER"
BAKDIR="/ZFS_SATADATASTORE/Backups/$REMOTEHOST"   
DATE=$(date +%D@%T)
DOW=$(date +%u)  		#Day of week
DOM=$(date +%e) 	 	#Day of Month
DOMF=$(date +%B%e)  		#Day of Month Full


if [ ! -d $BAKDIR/$REMOTEHOST/ ];then
	echo "making $BAKDIR"
	mkdir -p $BAKDIR
fi

#checking if backup directorys  exsist

if [ ! -d "$BAKDIR/$USER/Daily" ];then
	echo 'creating Daily folder'
	mkdir -p "$BAKDIR/$USER/Daily"
fi

if [ ! -d "$BAKDIR/$USER/Weekly" ];then
	echo 'creating Weekly folder'
	mkdir -p "$BAKDIR/$USER/Weekly"
fi

if [ ! -d "$BAKDIR/$USER/Monthly" ];then
	echo 'creating Monthly folder'
	mkdir -p "$BAKDIR/$USER/Monthly"
fi


# Exacuting the backups

#Monthly
if [ $DOM == "01" ];then
	if [ ! -d "$BAKDIR/Monthly/$DOMF" ];then
		echo "$DOMF directory dose not exsist creating it"
		mkdir -p "$BAKDIR/$USER/Monthly/$DOMF"
	else
		rsync $OPTS $USER@$REMOTEIP:$TOBAK "$BAKDIR/$USER/Monthly/$DOMF"

	fi
fi
#Daily
for d in $(seq 1 7);do

	if [ $DOW == $d ];then
		if [ ! -d $BAKDIR/$USER/Daily/daily.$DOW ];then
			echo "daily.$DOW directory dose not exsist creating it"
			mkdir -p $BAKDIR/$USER/Daily/daily.$DOW
		else
			rsync $OPTS $USER@$REMOTEIP:$TOBAK $BAKDIR/$USER/Daily/daily.$DOW

		fi
	fi
done

#Weekly

if [ $DOW == "7"  ];then
	if [ ! -d $BAKDIR/Weekly/weekly.$DOM ];then
		echo "weekly.$DOW directory dose not exsist creating it"
		mkdir -p $BAKDIR/$USER/Weekly/weekly.$DOM
	else
		rsync $OPTS $USER@$REMOTEIP:$TOBAK $BAKDIR/$USER/Weekly/weekly.$DOM

	fi
fi

# Exacuting the backups

