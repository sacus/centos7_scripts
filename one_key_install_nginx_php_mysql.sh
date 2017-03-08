#!/bin/bash
#安装路径：/application下面，软件目录：/home/clc/tools下面，没有定义，到时候如果要更改可以替换一下就可以了
function nginx_install(){
#no.1环境安装
/usr/bin/yum install pcre pcre-devel openssl openssl-devel -y

#no2. 建立用户，对用户进行判断
num1=`cat /etc/passwd |grep nginx |wc -l`
if [ $num1 -ne 1 ]
then
        useradd nginx -s /sbin/nologin -M
fi

#no3.安装nginx
if [ ! -f /application/nginx-1.8.0/sbin/nginx ]
        then 
  [ ! -d /application/nginx-1.8.0 ]&&mkdir -p /application/nginx-1.8.0
  [ ! -d /home/clc/tools  ] && mkdir /home/clc/tools -p 
  cd /home/clc/tools &&[ ! -f nginx-1.8.0.tar.gz ]&& wget  http://nginx.org/download/nginx-1.8.0.tar.gz

 cd /home/clc/tools && [ ! -d nginx-1.8.0 ]&&tar -zvxf nginx-1.8.0.tar.gz 
 cd nginx-1.8.0 && \
./configure --prefix=/application/nginx-1.8.0  \
--user=nginx --group=nginx --with-http_ssl_module  \
--with-http_stub_status_module && make && make install \
&& ln -s /application/nginx-1.8.0  /application/nginx

	else
	echo "nginx is installed in this machine !!!"
fi
}

#install apache
function apache_install(){
if [ ! -f /application/apache ]
	then	
	[ ! -d /home/clc/tools  ] && mkdir /home/clc/tools -p 
	cd /home/clc/tools &&[ ! -f httpd-2.2.31.tar.gz ]&&  \
	wget http://mirrors.cnnic.cn/apache/httpd/httpd-2.2.31.tar.gz
	cd /home/clc/tools && [ ! -d httpd-2.2.31 ]&&tar -zvxf httpd-2.2.31.tar.gz
	cd httpd-2.2.31 && \
./configure  \
--prefix=/application/apache-2.2.31 \
--enable-defate \
--enable-expires \
--enable-headers \
--enable-modules=most \
--enable-so \
--with-mpm=worker \
--enable-rewrite  && make && make install \
&& ln -s /application/apache-2.2.31 /application/apache
/application/apache/bin/apachectl  start && echo -e "\n \n apache install successful"

	else
	echo "apache is installed in this machine!!!"
fi
}




function mysql_install(){
#no.1

yum install ncurses-devel libaio-devel -y

#no.2

cd /home/clc/tools 
if [ ! -f  /usr/local/bin/cmake ]
then
	if [ -f cmake-2.8.8.tar.gz  ]
	then
        tar xf cmake-2.8.8.tar.gz
        cd cmake-2.8.8
        ./configure
        gmake
        gmake install
	else
	echo -e "\n \n cmake software is not exist  \n pls download it and mv it to the document"
	exit 2
	fi
fi

#no.3 create user
num2=`cat /etc/passwd |grep mysql |wc -l`
if [ $num2 -ne 1 ]
then
  useradd mysql -s /sbin/nologin -M
fi

#no.4 install mysql
[ ! -d /home/clc/tools  ] &&mkdir /home/clc/tools -p 
cd /home/clc/tools/ 

#下载安装文件

if [ ! -f /home/clc/tools/mysql-5.5.45.tar.gz  ]
	then
	wget http://ftp.ntu.edu.tw/pub/MySQL/Downloads/MySQL-5.5/mysql-5.5.45.tar.gz
	#http://mirrors.sohu.com/mysql/MySQL-5.5/mysql-5.5.44.tar.gz
	#http://mirror.yandex.ru/mirrors/ftp.mysql.com/Downloads/MySQL-5.5/mysql-5.5.44.tar.gz
	#http://files.directadmin.com/services/all/mysql/mysql-5.5.44.tar.gz
	#https://downloads.mariadb.com/archives/mysql-5.5/mysql-5.5.44-linux2.6-x86_64.tar.gz
fi

#if语句是判断没有装和安装文件存在
if [ -f mysql-5.5.45.tar.gz -a ! -f /application/mysql-5.5.45/bin/mysql ] 
then
if [ -d /home/clc/tools/mysql-5.5.45 ]
	then
	rm -rf /home/clc/tools/mysql-5.5.45
fi
tar -zxvf mysql-5.5.45.tar.gz && cd mysql-5.5.45
cmake . -DCMAKE_INSTALL_PREFIX=/application/mysql-5.5.45 \
-DMYSQL_DATADIR=/application/mysql-5.5.45/data \
-DMYSQL_UNIX_ADDR=/application/mysql-5.5.45/tmp/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DEXTRA_CHARSETS=gbk,gb2312,utf8,ascii \
-DENABLED_LOCAL_INFILE=ON \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
-DWITHOUT_PARTITION_STORAGE_ENGINE=1 \
-DWITH_FAST_MUTEXES=1 \
-DWITH_ZLIB=bundled \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_READLINE=1 \
-DWITH_EMBEDDED_SERVER=1 \
-DWITH_DEBUG=0

make && make install
ln -s /application/mysql-5.5.45/ /application/mysql

	else
	echo "mysql is installed in this machine!!!"
fi

}

#初始化数据和配置传统启动及环境变量的添加
function db_install_data () {

if [ -f /application/mysql-5.5.45/bin/mysql -a -d  /application/mysql/data ] 
	then
	/bin/mv /etc/my.cnf  /etc/my.`date +%F`.cnf && \
	/bin/cp /home/clc/tools/mysql-5.5.45/support-files/my-small.cnf   /etc/my.cnf && \
	chown -R 1777 /tmp && \
	chown -R mysql:mysql /application/mysql/data && \
	echo "PATH="/application/mysql/bin/:$PATH"" >>/etc/profile && \
	source /etc/profile && \
	/application/mysql/scripts/mysql_install_db  --basedir=/application/mysql  --datadir=/application/mysql/data --user=mysql  && \
	\cp /application/mysql/support-files/mysql.server /etc/init.d/mysqld && \
	/etc/init.d/mysqld start
fi	
}


function php_install(){
#no.1 环境准备    
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
yum install  zlib-devel  libxml2-devel  libjpeg-devel  libiconv-devel freetype-devel \
libpng-devel  gd-devel curl-devel libmcrypt-devel   mhash mhash-devel libxslt-devel mcrypt -y

[ ! -d /home/clc/tools ] && mkdir -p /home/clc/tools
cd /home/clc/tools

#判断以下软件有没有安装，有的话，直接不运行，判断不是很精确
if [ ! -d /usr/local/libiconv/ ]
then
wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz&& \
tar zvxf libiconv-1.14.tar.gz && \
cd libiconv-1.14 && \
./configure --prefix=/usr/local/libiconv \
make && make install
cd ../
fi

#no.2  install php without local mysql
if [ ! -d /application/php/bin ]
then

#下载软件
	cd /home/clc/tools
	if [ ! -f php-5.5.26.tar.gz ]
		then
		wget http://mirrors.sohu.com/php/php-5.5.26.tar.gz
	fi
	
cd /home/clc/tools/ && tar -zxvf php-5.5.26.tar.gz \
&& cd php-5.5.26 


#if语句的作用是判断本机有没有安装mysql，装与没有装编译参数有点差别。
if [ -f /application/mysql/bin/mysql ]
then
#在已经安装了nginx和mysql环境中安装php的参数
if [ -f /application/nginx/sbin/nginx ]
 then
./configure \
--prefix=/application/php-5.5.26 \
--with-mysql=/application/mysql \
--with-iconv-dir=/usr/local/libiconv \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib \
--with-libxml-dir=/usr \
--enable-xml \
--disable-rpath \
--enable-safe-mode \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--with-curl \
--with-curlwrappers \
--enable-mbregex \
--enable-fpm \
--enable-mbstring \
--with-mcrypt \
--with-gd \
--enable-gd-native-ttf \
--with-openssl \
--with-mhash \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--enable-zip \
--enable-soap \
--enable-short-tags \
--enable-zend-multibyte \
--enable-static \
--with-xsl \
--with-fpm-user=nginx \
--with-fpm-group=nginx \
--enable-ftp && \
ln -s /application/mysql/lib/libmysqlclient.so.18  /usr/lib64/ 
touch ext/phar/phar.phar&& \
echo "/application/mysql/lib">>/etc/ld.so.conf && \
echo "/application/mysql/lib">>/etc/ld.so.conf.d/mysql-x86_64.conf && ldconfig && \
make &&make install && \
ln -s /application/php-5.5.26/ /application/php && \
cp /home/clc/tools/php-5.5.26/php.ini-production /application/php/lib/php.ini && \
cp /application/php/etc/php-fpm.conf.default  /application/php/etc/php-fpm.conf

#在已经安装了apache和mysql环境中安装php的参数
elif [ -f /application/apache/bin/apachectl ]
then
./configure \
--prefix=/application/php-5.5.26 \
--with-apxs2=/application/apache/bin/apxs \
--with-mysql=/application/mysql \
--with-xmlrpc \
--with-openssl \
--with-zlib \
--with-freetype-dir \
--with-gd \
--with-jpeg-dir \
--with-png-dir \
--with-iconv=/usr/local/libiconv \
--enable-short-tags \
--enable-sockets \
--enable-zend-multibyte \
--enable-soap \
--enable-mbstring \
--enable-static \
--enable-gd-native-ttf \
--with-curl \
--with-xsl \
--enable-ftp \
--with-libxml-dir &&
make && make install && \
ln -s /application/php-5.5.26/ /application/php && \
cp /home/clc/tools/php-5.5.26/php.ini-production /application/php/lib/php.ini
fi

else 
#没有安装mysql的编译参数，好像不可以用。
./configure \
--prefix=/application/php-5.6.22 \
--with-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-iconv-dir=/usr/local/libiconv \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib \
--with-libxml-dir=/usr \
--enable-xml \
--disable-rpath \
--enable-safe-mode \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--with-curl \
--with-curlwrappers \
--enable-mbregex \
--enable-fpm \
--enable-mbstring \
--with-mcrypt \
--with-gd \
--enable-gd-native-ttf \
--with-openssl \
--with-mhash \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--enable-zip \
--enable-soap \
--enable-short-tags \
--enable-zend-multibyte \
--enable-static \
--with-xsl \
--with-fpm-user=nginx \
--with-fpm-group=nginx \
--enable-ftp && \
ln -s /application/mysql/lib/libmysqlclient.so.18  /usr/lib64/ 
touch ext/phar/phar.phar&&make &&make install && \
ln -s /application/php-5.5.26/ /application/php && \
cp /home/clc/tools/php-5.5.26/php.ini-production /application/php/lib/php.ini && \
cp /application/php/etc/php-fpm.conf.default  /application/php/etc/php-fpm.conf
fi


#echo "/application/mysql/lib" >>/etc/ld.so.conf.d/mysql-x86_64.conf  && idconfig \
#make &&make install && \
#ln -s /application/php-5.5.26/ /application/php

else
echo "php is installed in this machine!!!!"
fi
}


menu(){
cat<<EOF
#######################
# 1.[INSTALL NGINX ]  #
# 2.[INSTALL APACHE]  #
# 3.[INSTALL MYSQL ]  #
# 4.[INSTALL PHP   ]  #
# 5.[mysql_ins_db  ]  #
# 6.[EXIT]            #
#######################
EOF
read -t 20 -p "pls input the num you want:" a
}

read1(){
        if [ "$a" == "1" ]
			then
                echo "start installing nginx...."
                nginx_install
                menu
                read1
		elif [ "$a"  ==  "2" ]
			then
                echo "start installing apache...."
                apache_install
                menu
                read1
        elif [ "$a"  ==  "3" ]
			then
                echo "start installing mysql...."
                mysql_install
                menu
                read1
        elif [ "$a" == "4" ]
			then
                echo "start installing php...."
                php_install
                menu
                read1
		elif [ "$a" == "5" ]
			then
				echo "mysql_install_db is doing...."
				db_install_data
				menu
				read1
        elif [ "$a" == "6" ]
			then
                echo "exiting...."
                exit
        else 
                echo "input error ,pls input num!!!"
                exit 3
        fi


}
main(){
menu
read1
}
main
