#!/bin/bash
#this scripts is created by clc at 20160414
#this scripts is monitor the user's passwd change or not and moinitor the important file
a_shadow_md5=`/usr/bin/md5sum /etc/shadow|awk '{print $1}'`
b_passwd_md5=`/usr/bin/md5sum /etc/passwd|awk '{print $1}'`
#c_gshadow_md5=`/usr/bin/md5sum /etc/gshadow|awk '{print $1}'`
#d_group_md5=`/usr/bin/md5sum /etc/group|awk '{print $1}'`
#e_inittab_md5=`/usr/bin/md5sum /etc/inittab|awk '{print $1}'`

if [ $a_shadow_md5 == $1 -a $b_passwd_md5 == $2 ]
	then
	echo "shadow and passwd file  is normal,not changed!"
	exit 0
elif [ $a_shadow_md5 != $1 -a $b_passwd_md5 == $2 ]
	then
	echo  "the passwd fiel is normal,the shadow is not normal,secret is changed by someone!!!"
	exit 2
elif [ $a_shadow_md5 == $1 -a $b_passwd_md5 != $2  ]
	then
        echo  "the shadow is normal,the passwd file is not normal!!!"
        exit 1
else
	echo "the shadow and passwd file is not normal !!!!,now check it!"
	exit 2
fi

