#!/bin/bash
#this scripts is created by clc at 20160414
#this scripts is monitor the user's passwd change or not and moinitor the important file
a_shadow_md5=`/usr/bin/md5sum /etc/shadow|awk '{print $1}'`
b_passwd_md5=`/usr/bin/md5sum /etc/passwd|awk '{print $1}'`
c_gshadow_md5=`/usr/bin/md5sum /etc/gshadow|awk '{print $1}'`
d_group_md5=`/usr/bin/md5sum /etc/group|awk '{print $1}'`
e_inittab_md5=`/usr/bin/md5sum /etc/inittab|awk '{print $1}'`

if [ $a_shadow_md5 == $1 -a $b_passwd_md5 == $2 -a $c_gshadow_md5 == $3 -a $d_group_md5 == $4   -a  $e_inittab_md5 == $5 ]
	then
	echo "shadow passwd gshadow group inittab is normal,not changed!"
	exit 0
elif [ $a_shadow_md5 != $1 -a $b_passwd_md5 == $2 -a $c_gshadow_md5 == $3 -a $d_group_md5 == $4  -a  $e_inittab_md5 == $5 ]
	then
	echo  "passwd gshadow group inittab is normal,the shadow is not normal!!!"
	exit 2
elif [ $a_shadow_md5 == $1 -a $b_passwd_md5 != $2 -a $c_gshadow_md5 == $3 -a $d_group_md5 == $4  -a  $e_inittab_md5 == $5 ]
	then
        echo  "shadow  gshadow group inittab is normal,the passwd is not normal!!!"
        exit 1
elif [ $a_shadow_md5 == $1 -a $b_passwd_md5 == $2 -a $c_gshadow_md5 != $3 -a $d_group_md5 == $4  -a  $e_inittab_md5 == $5 ]
        then
        echo  "shadow  passwd group inittab is normal,the gshadow is not normal!!!"
        exit 1

elif [ $a_shadow_md5 == $1 -a $b_passwd_md5 == $2 -a $c_gshadow_md5 == $3 -a $d_group_md5 != $4  -a  $e_inittab_md5 == $5 ]
        then
        echo  "shadow  passwd gshadow inittab is normal,the group is not normal!!!"
        exit 1

elif [ $a_shadow_md5 == $1 -a $b_passwd_md5 == $2 -a $c_gshadow_md5 == $3 -a $d_group_md5 == $4  -a  $e_inittab_md5 != $5 ]
        then
        echo  "shadow  passwd group gshadow is normal,the inittab is not normal!!!"
        exit 1
else
	echo "the all files (shadow passwd group gshadow inittab) is not normal !!!!,now check it!"
	exit 2
fi

