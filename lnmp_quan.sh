#!/bin/bash
#auth: ccc
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

function basic_install(){
    yum update -y && \
    yum install epel-release -y && \
    yum groupinstall "Compatibility libraries" "Base" "Development tools"  "debugging Tools" -y && \
    yum install iftop iotop tree lrzsz nmap sysstat telnet -y
    if [ $? -eq 0 ]
      then
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "basic package is installed successful"
    fi
}

#install nginx
function nginx_install() {
    yum install nginx -y
    if [ $? -eq 0 ]
      then
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "nginx install is sucessful"
    fi
}

#install mysql 
function mysql_5_6_install() {
    if [ ! -d /root/tools ]
      then
	mkdir /root/tools
    fi
    cd /root/tools && \
    cd /root/tools && \
    wget https://repo.mysql.com//mysql80-community-release-el7-1.noarch.rpm && \
    yum  localinstall mysql80-community-release-el7-1.noarch.rpm -y && \
    yum-config-manager --disable mysql57-community  && \
    yum-config-manager --disable mysql80-community  && \
    yum-config-manager --enable mysql56-community  && \
    yum install mysql-community-server -y 
    if [ $? -eq 0 ]
      then 
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "mysql install is successful"
    fi
}


function mysql_5_7_install() {
    if [ ! -d /root/tools ]
      then
	mkdir /root/tools
    fi
    cd /root/tools && \
    cd /root/tools && \
    wget https://repo.mysql.com//mysql80-community-release-el7-1.noarch.rpm && \
    yum  localinstall mysql80-community-release-el7-1.noarch.rpm -y && \
    yum-config-manager --disable mysql56-community  && \
    yum-config-manager --disable mysql80-community  && \
    yum-config-manager --enable mysql57-community  && \
    yum install mysql-community-server -y 
    if [ $? -eq 0 ]
      then 
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "mysql install is successful"
    fi
}


#install php 
function php_5_6_install() {
    yum install epel-release -y && \
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && \
    yum install php56w  php56w-bcmath php56w-cli php56w-common php56w-fpm php56w-gd \
    php56w-mysqlnd php56w-pdo php56w-mbstring php56w-mcrypt php56w-devel php56w-xml -y 
    if [ $? -eq 0 ]
      then
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "php install is successful"    
    fi   

#
    num1=`grep -c  "nginx" /etc/passwd`
    if [ $num1 -eq 1 ]
      then
	chown -R nginx /var/lib/php
        chown -R nginx /var/log/php-fpm
    fi
}

function php_7_2_install() {
    yum install epel-release -y && \
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && \
    yum install php72w  php72w-bcmath php72w-cli php72w-common php72w-fpm php72w-gd  php72w-mysqlnd php72w-pdo php72w-mbstring php72w-mcrypt php72w-devel php72w-xml php72w-opcache -y  && \
    if [ $? -eq 0 ]
      then
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "php install is successful"    
    fi   

#
    num1=`grep -c  "nginx" /etc/passwd`
    if [ $num1 -eq 1 ]
      then
	chown -R nginx /var/lib/php
        chown -R nginx /var/log/php-fpm
    fi
}

function php_7_3_install() {
    yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum -y install epel-release yum-utils && \
    yum install epel-release -y && \
    yum-config-manager --disable remi-php54 && \
    yum-config-manager --enable remi-php73  && \
    yum install php  php-bcmath php-cli php-common php-fpm php-gd  php-mysqlnd php-pdo php-mbstring php-mcrypt php-devel php-xml php-opcache php-zip  php-curl  php-pear  php-json  -y
    if [ $? -eq 0 ]
      then
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "php install is successful"    
    fi   

#
    num1=`grep -c  "nginx" /etc/passwd`
    if [ $num1 -eq 1 ]
      then
	chown -R nginx /var/lib/php
        chown -R nginx /var/log/php-fpm
    fi
}

#install redis
function redis_install() {
    if [ ! -d /root/tools ]
      then
	mkdir /root/tools
    fi
    cd /root/tools && \
    wget http://download.redis.io/releases/redis-4.0.14.tar.gz && \
    tar -zxf redis-4.0.14.tar.gz && \
    cd redis-4.0.14 && \
    make && make install && \
    mkdir /etc/redis && \
    cp redis.conf /etc/redis/6379.conf && \
    cp utils/redis_init_script /etc/init.d/redis 
    if [ $? -eq 0 ]
      then
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo " redis install is successful"
    fi
}

function php_5_6_redis_install () {
    if [ ! -d /root/tools ]
      then
	mkdir /root/tools
    fi
    cd /root/tools  && \
    wget http://pecl.php.net/get/redis-2.2.8.tgz && \
    tar -zxf redis-2.2.8.tgz && \
    cd redis-2.2.8 && \
    phpize &&  ./configure --enable-redis && \
    make && make install 
    if [ $? -eq 0 ]
      then
  	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "php redis so install is successful"
    fi
    if [ -f /usr/lib64/php/modules/redis.so ]
      then
        echo "extension=redis.so" >>/etc/php.d/redis.ini && \
        echo " redis.ini is created success"
    fi
}

function php_7_redis_install () {
    if [ ! -d /root/tools ]
      then
	mkdir /root/tools
    fi
    cd /root/tools  && \
    wget https://pecl.php.net/get/redis-4.0.2.tgz && \
    tar -zxf redis-4.0.2.tgz && \
    cd redis-4.0.2 && \
    phpize &&  ./configure --enable-redis && \
    make && make install 
    if [ $? -eq 0 ]
      then
  	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "php redis so install is successful"
    fi
    if [ -f /usr/lib64/php/modules/redis.so ]
      then
        echo "extension=redis.so" >>/etc/php.d/redis.ini && \
        echo " redis.ini is created success"
    fi
}

function php_5_phalcon_install() {
    if [ ! -d /root/tools ]
      then
	mkdir /root/tools
    fi
    cd /root/tools && \
    git clone -b 3.4.x git://github.com/phalcon/cphalcon.git && \
    cd cphalcon/build && \
    ./install
    if [ $? -eq 0 ];then
     	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo " php phalcon so install is successful"
    fi
    if [ -f /usr/lib64/php/modules/phalcon.so ]
      then
        echo "extension=phalcon.so" >>/etc/php.d/phalcon.ini && \
        echo " phalcon.ini is created success"
    fi
}

function php_7_phalcon_install() {
    if [ ! -d /root/tools ]
      then
	mkdir /root/tools
    fi
    cd /root/tools && \
    git clone -b 4.0.x git://github.com/phalcon/cphalcon.git && \
    cd cphalcon/build && \
    ./install
    if [ $? -eq 0 ];then
     	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo " php phalcon so install is successful"
    fi
    if [ -f /usr/lib64/php/modules/phalcon.so ]
      then
        echo "extension=phalcon.so" >>/etc/php.d/phalcon.ini && \
        echo " phalcon.ini is created success"
    fi
}

function nsq_1_2_install() {
    if [ ! -d /root/tools ]
      then
	mkdir /root/tools
    fi
    mkdir /usr/local/nsq/{data,log,config} -p
    cd /root/tools && \
    wget https://s3.amazonaws.com/bitly-downloads/nsq/nsq-1.2.0.linux-amd64.go1.12.9.tar.gz && \
    tar -zxvf nsq-1.2.0.linux-amd64.go1.12.9.tar.gz && \
    mv nsq-1.2.0.linux-amd64.go1.12.9/bin /usr/local/nsq/ && \
    echo "## log verbosity level: debug, info, warn, error, or fatal
log-level = \"warn\"

## <addr>:<port> to listen on for HTTP clients
http_address = \"0.0.0.0:4171\"

## graphite HTTP address
graphite_url = \"10.35.158.145:4171\"

## proxy HTTP requests to graphite
proxy_graphite = false

## prefix used for keys sent to statsd (%s for host replacement, must match nsqd)
statsd_prefix = \"nsq.%s\"

## format of statsd counter stats
statsd_counter_format = \"stats.counters.%s.count\"

## format of statsd gauge stats
statsd_gauge_format = \"stats.gauges.%s\"

## time interval nsqd is configured to push to statsd (must match nsqd)
statsd_interval = \"60s\"

## HTTP endpoint (fully qualified) to which POST notifications of admin actions will be sent
notification_http_endpoint = \"\"


## nsqlookupd HTTP addresses
nsqlookupd_http_addresses = [
    \"127.0.0.1:4161\"
]

## nsqd HTTP addresses (optional)
#nsqd_http_addresses = [
#    \"127.0.0.1:4151\"
#]" >/usr/local/nsq/config/nsqadmin.cfg

  echo "## log verbosity level: debug, info, warn, error, or fatal
log-level = \"warn\"

## <addr>:<port> to listen on for TCP clients
tcp_address = \"0.0.0.0:4160\"

## <addr>:<port> to listen on for HTTP clients
http_address = \"0.0.0.0:4161\"

## address that will be registered with lookupd (defaults to the OS hostname)
# broadcast_address = \"\"


## duration of time a producer will remain in the active list since its last ping
inactive_producer_timeout = \"300s\"

## duration of time a producer will remain tombstoned if registration remains
tombstone_lifetime = \"45s\"
" >/usr/local/nsq/config/nsqlookupd.cfg

  echo "## log verbosity level: debug, info, warn, error, or fatal
log-level = \"warn\"

## unique identifier (int) for this worker (will default to a hash of hostname)
# id = 5150

## <addr>:<port> to listen on for TCP clients
tcp_address = \"0.0.0.0:4150\"

## <addr>:<port> to listen on for HTTP clients
http_address = \"0.0.0.0:4151\"

## <addr>:<port> to listen on for HTTPS clients
# https_address = \"0.0.0.0:4152\"

## address that will be registered with lookupd (defaults to the OS hostname)
# broadcast_address = \"\"

## cluster of nsqlookupd TCP addresses
nsqlookupd_tcp_addresses = [
    \"127.0.0.1:4160\"
]

## duration to wait before HTTP client connection timeout
http_client_connect_timeout = \"2s\"

## duration to wait before HTTP client request timeout
http_client_request_timeout = \"5s\"

## path to store disk-backed messages
data_path = \"/usr/local/nsq/data\"

## number of messages to keep in memory (per topic/channel)
mem_queue_size = 10000

## number of bytes per diskqueue file before rolling
max_bytes_per_file = 104857600

## number of messages per diskqueue fsync
sync_every = 2500

## duration of time per diskqueue fsync (time.Duration)
sync_timeout = \"2s\"


## duration to wait before auto-requeing a message
msg_timeout = \"60s\"

## maximum duration before a message will timeout
max_msg_timeout = \"15m\"

## maximum size of a single message in bytes
max_msg_size = 1024768

## maximum requeuing timeout for a message
max_req_timeout = \"1h\"

## maximum size of a single command body
max_body_size = 5123840


## maximum client configurable duration of time between client heartbeats
max_heartbeat_interval = \"60s\"

## maximum RDY count for a client
max_rdy_count = 2500

## maximum client configurable size (in bytes) for a client output buffer
max_output_buffer_size = 65536

## maximum client configurable duration of time between flushing to a client (time.Duration)
max_output_buffer_timeout = \"1s\"


## UDP <addr>:<port> of a statsd daemon for pushing stats
# statsd_address = \"127.0.0.1:8125\"

## prefix used for keys sent to statsd (%s for host replacement)
statsd_prefix = \"nsq.%s\"

## duration between pushing to statsd (time.Duration)
statsd_interval = \"60s\"

## toggle sending memory and GC stats to statsd
statsd_mem_stats = true

## the size in bytes of statsd UDP packets
# statsd_udp_packet_size = 508


## message processing time percentiles to keep track of (float)
e2e_processing_latency_percentiles = [
    1.0,
    0.99,
    0.95
]

## calculate end to end latency quantiles for this duration of time (time.Duration)
e2e_processing_latency_window_time = \"10m\"


## path to certificate file
tls_cert = \"\"

## path to private key file
tls_key = \"\"

## set policy on client certificate (require - client must provide certificate,
##  require-verify - client must provide verifiable signed certificate)
# tls_client_auth_policy = \"require-verify\"

## set custom root Certificate Authority
# tls_root_ca_file = \"\"

## require client TLS upgrades
tls_required = false

## minimum TLS version (\"ssl3.0\", \"tls1.0,\" \"tls1.1\", \"tls1.2\")
tls_min_version = \"\"

## enable deflate feature negotiation (client compression)
deflate = true

## max deflate compression level a client can negotiate (> values == > nsqd CPU usage)
max_deflate_level = 6

## enable snappy feature negotiation (client compression)
snappy = true
" >/usr/local/nsq/config/nsqd.cfg

echo "[Unit]
Description=NSQAdmin
After=network.target

[Service]
LimitCORE=infinity
LimitNOFILE=100000
LimitNPROC=100000
WorkingDirectory=/usr/local/nsq
ExecStart=/usr/local/nsq/bin/nsqadmin -config=/usr/local/nsq/config/nsqadmin.cfg
ExecReload=/bin/kill -HUP $MAINPID
Type=simple
KillMode=process
Restart=on-failure
RestartSec=10s
User=root

[Install]
WantedBy=multi-user.target" >/usr/lib/systemd/system/nsqadmin.service 

echo "[Unit]
Description=NSQD
After=network.target

[Service]
LimitCORE=infinity
LimitNOFILE=100000
LimitNPROC=100000
WorkingDirectory=/usr/local/nsq
ExecStart=/usr/local/nsq/bin/nsqd -config=/usr/local/nsq/config/nsqd.cfg
#ExecStart=/bin/bash -c '/usr/local/nsq/bin/nsqd -config /usr/local/nsq/config/nsqd.cfg 2>&1|egrep -v \"sending heartbeat|200 GET\"'
ExecReload=/bin/kill -HUP $MAINPID
Type=simple
KillMode=process
Restart=on-failure
RestartSec=10s
User=root

[Install]
WantedBy=multi-user.target" >/usr/lib/systemd/system/nsqd.service
echo "[Unit]
Description=NSQLookupD
After=network.target

[Service]
LimitCORE=infinity
LimitNOFILE=100000
LimitNPROC=100000
WorkingDirectory=/usr/local/nsq
ExecStart=/usr/local/nsq/bin/nsqlookupd -config=/usr/local/nsq/config/nsqlookupd.cfg
#ExecStart=/bin/bash -c '/usr/local/nsq/bin/nsqlookupd -config  /usr/local/nsq/config/nsqlookupd.cfg 2>&1| egrep -v \"sending heartbeat|200 GET\"'
ExecReload=/bin/kill -HUP $MAINPID
Type=simple
KillMode=process
Restart=on-failure
RestartSec=10s
User=root

[Install]
WantedBy=multi-user.target" >/usr/lib/systemd/system/nsqlookupd.service

systemctl daemon-reload
systemctl enable nsqd nsqlookupd nsqadmin
systemctl start nsqd nsqlookupd nsqadmin
}

function supervisor_install() {
	yum install python-pip -y && \
	pip install supervisor && \
	b_supervisor=`which supervisord`
	mkdir /var/log/supervisor -p
	source /etc/profile
	echo_supervisord_conf > /etc/supervisord.conf
	sed -i 's#/tmp/supervisor.sock#/var/run/supervisor.sock#g' /etc/supervisord.conf 
	sed -i 's#/tmp/supervisord.pid#/var/run/supervisord.pid#g' /etc/supervisord.conf 
	sed -i 's#/tmp/supervisord.log#/var/log/supervisor/supervisord.log#g' /etc/supervisord.conf 
	echo -e "\n\n
;[program:down]
;directory=/data/www
;command=/data/www/down
;numprocs=1                   
;umask=022                    
;autostart=true               
;minfds=1024000
;startsecs=10                  
;startretries=10              
;autorestart=true
;user=c-node
;redirect_stderr=true         
;stdout_logfile=/var/log/supervisor/down.log
;stdout_logfile_maxbytes=10MB  
;stdout_logfile_backups=30    
;stdout_capture_maxbytes=10MB  
;stdout_events_enabled=false  
;stderr_logfile=/var/log/supervisor/error_down.log
;stderr_logfile_maxbytes=10MB  
;stderr_logfile_backups=90    
;stderr_capture_maxbytes=10MB  
;stderr_events_enabled=false" >>/etc/supervisord.conf

	echo "
[Unit]
Description=Process Monitoring and Control Daemon
After=rc-local.service nss-user-lookup.target

[Service]
Type=forking
ExecStart=$b_supervisor -c /etc/supervisord.conf

[Install]
WantedBy=multi-user.target
" >/usr/lib/systemd/system/supervisord.service

systemctl daemon-reload
systemctl enable supervisord
systemctl start supervisord

}

function go_13_install() {
    if [ ! -d /root/tools ]
      then
	mkdir /root/tools
    fi
    cd /root/tools && \
    wget https://dl.google.com/go/go1.13.9.linux-amd64.tar.gz && \
    tar -zxf go1.13.9.linux-amd64.tar.gz && \
    mv go /usr/local/ 
    echo "export GOROOT=/usr/local/go
export GOPATH=/root/go_work
export PATH=\$PATH:\$GOROOT/bin
export GO111MODULE=on" >>/etc/profile
   mkdir -p /root/go_work/{pkg,bin,src} 
}

function go_14_install() {
    if [ ! -d /root/tools ]
      then
	mkdir /root/tools
    fi
    cd /root/tools && \
    wget https://dl.google.com/go/go1.14.1.linux-amd64.tar.gz && \
    tar -zxf go1.14.1.linux-amd64.tar.gz && \
    mv go /usr/local/ 
    echo "export GOROOT=/usr/local/go
export GOPATH=/root/go_work
export PATH=\$PATH:\$GOROOT/bin
export GO111MODULE=on" >>/etc/profile
   mkdir -p /root/go_work/{pkg,bin,src} 
}

function nodejs_v12_16_3_install () {
    if [ ! -d /root/tools ]
      then
		mkdir /root/tools
    fi
	cd /root/tools && \
    wget https://nodejs.org/dist/v12.16.3/node-v12.16.3-linux-x64.tar.gz && \
    tar -zxf node-v12.16.3-linux-x64.tar.gz && \
	mv node-v12.16.3-linux-x64 /usr/local/ 
	echo "export NODE_HOME=/usr/local/node-v12.16.3-linux-x64
export PATH=$NODE_HOME/bin:$PATH" >>/etc/profile
	source /etc/profile
}

function nodejs_v10_20_1_install () {
    if [ ! -d /root/tools ]
      then
		mkdir /root/tools
    fi
	cd /root/tools && \
    wget https://nodejs.org/dist/v10.20.1/node-v10.20.1-linux-x64.tar.gz && \
    tar -zxf node-v10.20.1-linux-x64.tar.gz && \
	mv node-v10.20.1-linux-x64 /usr/local/ 
	echo "export NODE_HOME=/usr/local/node-v10.20.1-linux-x64
export PATH=$NODE_HOME/bin:$PATH" >>/etc/profile
	source /etc/profile
}

function nginx_conf () {
    cd /etc/nginx  && \
    cp nginx.conf nginx.conf_$(date +$F).bak && \
    echo "user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

worker_rlimit_nofile 65535;

include /usr/share/nginx/modules/*.conf;

events {
    use epoll;
    worker_connections  20480;
}


http {
    server_tokens off;
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

  log_format  main  '\$remote_addr \$remote_user [\$time_local] \$http_host \"\$request\" \"\$request_body\" '
                               '\$status　\$body_bytes_sent　\"\$http_referer\" '
                               '\"\$http_user_agent\" \$request_time  \$upstream_response_time \$upstream_status';

    access_log  /var/log/nginx/access.log  main;

    charset	utf-8;
    server_names_hash_bucket_size 128;
    client_header_buffer_size 32k;
    large_client_header_buffers 4 64k;
    client_max_body_size 8m;
    sendfile on;
    tcp_nopush     on;
    tcp_nodelay on;
    keepalive_timeout 60;
    fastcgi_intercept_errors on;
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 128k;
    
    open_file_cache max=65535 inactive=10s;
    open_file_cache_valid 30s;
    open_file_cache_min_uses 1;
    
    gzip on;
    gzip_min_length  1k;
    gzip_buffers     4 16k;
    gzip_http_version 1.0;
    gzip_comp_level 2;
    gzip_types       text/plain application/javascript text/css application/xml  text/xml image/jpeg ;
    gzip_vary on;
    
	server {
	  	listen 80 default_server;
		server_name _;
		return 501;
	}
    include /etc/nginx/conf.d/*.conf;
}" >nginx.conf
    if [ $? -eq 0 ];then
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "nginx.conf is configure successful"
    fi
}

function php_conf(){
    echo "expose_php = Off
register_globals = Off
allow_url_fopen = Off
disable_functions =  system,passthru,exec,shell_exec,popen,phpinfo
display_errors = Off
error_log=/var/log/php-fpm/php_error.log;
date.timezone = Asia/Shanghai" >>/etc/php.ini && \
    cp /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf_$(date +%F).bak && \
    echo "; Start a new pool named 'www'.
[www]

; The address on which to accept FastCGI requests.
; Valid syntaxes are:
;   'ip.add.re.ss:port'    - to listen on a TCP socket to a specific address on
;                            a specific port;
;   'port'                 - to listen on a TCP socket to all addresses on a
;                            specific port;
;   '/path/to/unix/socket' - to listen on a unix socket.
; Note: This value is mandatory.
listen = 127.0.0.1:9000

; Set listen(2) backlog. A value of '-1' means unlimited.
; Default Value: -1
;listen.backlog = -1
 
; List of ipv4 addresses of FastCGI clients which are allowed to connect.
; Equivalent to the FCGI_WEB_SERVER_ADDRS environment variable in the original
; PHP FCGI (5.2.2+). Makes sense only with a tcp listening socket. Each address
; must be separated by a comma. If this value is left blank, connections will be
; accepted from any ip address.
; Default Value: any
listen.allowed_clients = 127.0.0.1

; Set permissions for unix socket, if one is used. In Linux, read/write
; permissions must be set in order to allow connections from a web server. Many
; BSD-derived systems allow connections regardless of permissions. 
; Default Values: user and group are set as the running user
;                 mode is set to 0666
;listen.owner = nobody
;listen.group = nobody
;listen.mode = 0666

; Unix user/group of processes
; Note: The user is mandatory. If the group is not set, the default user's group
;       will be used.
; RPM: apache Choosed to be able to access some dir as httpd
user = nginx
; RPM: Keep a group allowed to write in log dir.
group = nginx

; Choose how the process manager will control the number of child processes.
; Possible Values:
;   static  - a fixed number (pm.max_children) of child processes;
;   dynamic - the number of child processes are set dynamically based on the
;             following directives:
;             pm.max_children      - the maximum number of children that can
;                                    be alive at the same time.
;             pm.start_servers     - the number of children created on startup.
;             pm.min_spare_servers - the minimum number of children in 'idle'
;                                    state (waiting to process). If the number
;                                    of 'idle' processes is less than this
;                                    number then some children will be created.
;             pm.max_spare_servers - the maximum number of children in 'idle'
;                                    state (waiting to process). If the number
;                                    of 'idle' processes is greater than this
;                                    number then some children will be killed.
; Note: This value is mandatory.
pm = dynamic

; The number of child processes to be created when pm is set to 'static' and the
; maximum number of child processes to be created when pm is set to 'dynamic'.
; This value sets the limit on the number of simultaneous requests that will be
; served. Equivalent to the ApacheMaxClients directive with mpm_prefork.
; Equivalent to the PHP_FCGI_CHILDREN environment variable in the original PHP
; CGI.
; Note: Used when pm is set to either 'static' or 'dynamic'
; Note: This value is mandatory.
pm.max_children = 300

; The number of child processes created on startup.
; Note: Used only when pm is set to 'dynamic'
; Default Value: min_spare_servers + (max_spare_servers - min_spare_servers) / 2
pm.start_servers = 6

; The desired minimum number of idle server processes.
; Note: Used only when pm is set to 'dynamic'
; Note: Mandatory when pm is set to 'dynamic'
pm.min_spare_servers = 4

; The desired maximum number of idle server processes.
; Note: Used only when pm is set to 'dynamic'
; Note: Mandatory when pm is set to 'dynamic'
pm.max_spare_servers = 35
 
; The number of requests each child process should execute before respawning.
; This can be useful to work around memory leaks in 3rd party libraries. For
; endless request processing specify '0'. Equivalent to PHP_FCGI_MAX_REQUESTS.
; Default Value: 0
;pm.max_requests = 500
pm.max_requests = 300

; The URI to view the FPM status page. If this value is not set, no URI will be
; recognized as a status page. By default, the status page shows the following
; information:
;   accepted conn    - the number of request accepted by the pool;
;   pool             - the name of the pool;
;   process manager  - static or dynamic;
;   idle processes   - the number of idle processes;
;   active processes - the number of active processes;
;   total processes  - the number of idle + active processes.
; The values of 'idle processes', 'active processes' and 'total processes' are
; updated each second. The value of 'accepted conn' is updated in real time.
; Example output:
;   accepted conn:   12073
;   pool:             www
;   process manager:  static
;   idle processes:   35
;   active processes: 65
;   total processes:  100
; By default the status page output is formatted as text/plain. Passing either
; 'html' or 'json' as a query string will return the corresponding output
; syntax. Example:
;   http://www.foo.bar/status
;   http://www.foo.bar/status?json
;   http://www.foo.bar/status?html
; Note: The value must start with a leading slash (/). The value can be
;       anything, but it may not be a good idea to use the .php extension or it
;       may conflict with a real PHP file.
; Default Value: not set 
;pm.status_path = /status
 
; The ping URI to call the monitoring page of FPM. If this value is not set, no
; URI will be recognized as a ping page. This could be used to test from outside
; that FPM is alive and responding, or to
; - create a graph of FPM availability (rrd or such);
; - remove a server from a group if it is not responding (load balancing);
; - trigger alerts for the operating team (24/7).
; Note: The value must start with a leading slash (/). The value can be
;       anything, but it may not be a good idea to use the .php extension or it
;       may conflict with a real PHP file.
; Default Value: not set
;ping.path = /ping

; This directive may be used to customize the response of a ping request. The
; response is formatted as text/plain with a 200 response code.
; Default Value: pong
;ping.response = pong
 
; The timeout for serving a single request after which the worker process will
; be killed. This option should be used when the 'max_execution_time' ini option
; does not stop script execution for some reason. A value of '0' means 'off'.
; Available units: s(econds)(default), m(inutes), h(ours), or d(ays)
; Default Value: 0
;request_terminate_timeout = 0
 
; The timeout for serving a single request after which a PHP backtrace will be
; dumped to the 'slowlog' file. A value of '0s' means 'off'.
; Available units: s(econds)(default), m(inutes), h(ours), or d(ays)
; Default Value: 0
request_slowlog_timeout = 5 
 
; The log file for slow requests
; Default Value: not set
; Note: slowlog is mandatory if request_slowlog_timeout is set
slowlog = /var/log/php-fpm/www-slow.log
 
; Set open file descriptor rlimit.
; Default Value: system defined value
;rlimit_files = 1024
rlimit_files = 20480
 
; Set max core size rlimit.
; Possible Values: 'unlimited' or an integer greater or equal to 0
; Default Value: system defined value
;rlimit_core = 0
 
; Chroot to this directory at the start. This value must be defined as an
; absolute path. When this value is not set, chroot is not used.
; Note: chrooting is a great security feature and should be used whenever 
;       possible. However, all PHP paths will be relative to the chroot
;       (error_log, sessions.save_path, ...).
; Default Value: not set
;chroot = 
 
; Chdir to this directory at the start. This value must be an absolute path.
; Default Value: current directory or / when chroot
;chdir = /var/www
 
; Redirect worker stdout and stderr into main error log. If not set, stdout and
; stderr will be redirected to /dev/null according to FastCGI specs.
; Default Value: no
;catch_workers_output = yes
 
; Limits the extensions of the main script FPM will allow to parse. This can
; prevent configuration mistakes on the web server side. You should only limit
; FPM to .php extensions to prevent malicious users to use other extensions to
; exectute php code.
; Note: set an empty value to allow all extensions.
; Default Value: .php
;security.limit_extensions = .php .php3 .php4 .php5

; Pass environment variables like LD_LIBRARY_PATH. All $VARIABLEs are taken from
; the current environment.
; Default Value: clean env
;env[HOSTNAME] = $HOSTNAME
;env[PATH] = /usr/local/bin:/usr/bin:/bin
;env[TMP] = /tmp
;env[TMPDIR] = /tmp
;env[TEMP] = /tmp

; Additional php.ini defines, specific to this pool of workers. These settings
; overwrite the values previously defined in the php.ini. The directives are the
; same as the PHP SAPI:
;   php_value/php_flag             - you can set classic ini defines which can
;                                    be overwritten from PHP call 'ini_set'. 
;   php_admin_value/php_admin_flag - these directives won't be overwritten by
;                                     PHP call 'ini_set'
; For php_*flag, valid values are on, off, 1, 0, true, false, yes or no.

; Defining 'extension' will load the corresponding shared extension from
; extension_dir. Defining 'disable_functions' or 'disable_classes' will not
; overwrite previously defined php.ini values, but will append the new value
; instead.

; Default Value: nothing is defined by default except the values in php.ini and
;                specified at startup with the -d argument
;php_admin_value[sendmail_path] = /usr/sbin/sendmail -t -i -f www@my.domain.com
php_flag[display_errors] = off
php_admin_value[error_log] = /var/log/php-fpm/www-error.log
php_admin_flag[log_errors] = on
;php_admin_value[memory_limit] = 128M

; Set session path to a directory owned by process user
php_value[session.save_handler] = files
php_value[session.save_path]    = /var/lib/php/session
php_value[soap.wsdl_cache_dir]  = /var/lib/php/wsdlcache " >/etc/php-fpm.d/www.conf 
    if [ $? -eq 0 ];then
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "php configure is successful"
    fi
}

function mysql_conf () {
    cp /etc/my.cnf /etc/my.cnf_$(date +$F).bak && \
    echo "LimitNOFILE=65535
LimitNPROC=65535" >>/usr/lib/systemd/system/mysqld.service  && \
    systemctl daemon-reload && \
    mkdir /var/log/mysql && \
    chown -R mysql:mysql /var/log/mysql && \
    echo "# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/5.6/en/server-configuration-defaults.html
[client]
default-character-set = utf8

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

server-id=3

datadir=/data/mysql_data
socket=/var/lib/mysql/mysql.sock

#long_query_time=2
#slow-query-log =1
#slow-query-log-file=/var/log/mysql/mysql_slow.log
#log-queries-not-using-indexes=0
#expire_logs_days = 99
#log_bin = /data/mysql_data/mysql-bin

innodb_file_per_table=1
innodb_buffer_pool_size = 2G
query_cache_size = 0
query_cache_type = 0
innodb_log_file_size = 512M
innodb_log_files_in_group = 2

#below 3 rows had add by command,2017-10-19
max_connections = 2000
max_connect_errors = 6000
thread_cache_size = 512

open_files_limit  = 65535
innodb_open_files = 65535

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

# Recommended in standard MySQL setup
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES 
#sql_mode=

character-set-server = utf8
collation-server = utf8_general_ci
default-time-zone='+8:00'

[mysqld_safe]
log-error=/var/log/mysql/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid" >/etc/my.cnf

    if [ $? -eq 0 ];then
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "mysql configure is successful"
    fi
}

function redis_conf (){
    sed -i 's#daemonize no#daemonize yes#g' /etc/redis/6379.conf && \
    sed -i 's#timeout 0#timeout 300#g' /etc/redis/6379.conf && \
    sed -i 's#loglevel notice#loglevel warning#g' /etc/redis/6379.conf && \
    sed -i 's#logfile ""#logfile "/var/log/redis.log"#g' /etc/redis/6379.conf && \
    sed -i 's#dir ./#dir /data/redis_data#g' /etc/redis/6379.conf && \
    echo "maxclients 20000"   >>/etc/redis/6379.conf && \
    echo "maxmemory 1024MB" >>/etc/redis/6379.conf 
    if [ $? -eq 0 ];then
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "redis configure is successful"
    fi
}

function firewalld_conf () {
    firewall-offline-cmd  --zone=public --add-interface=eth0 && \
    firewall-offline-cmd  --zone=public --add-port=22/tcp && \
    firewall-offline-cmd  --zone=public --add-service=http && \
    firewall-offline-cmd  --zone=public --add-service=https && \
    firewall-offline-cmd  --add-rich-rule="rule family="ipv4" source address="8.8.8.8/32" port port="10050" protocol="tcp" accept "
   if [ $? -eq 0 ];then
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "firewalld configure is successful"
   fi
}

function autostart_all () {
    systemctl enable nginx php-fpm mysqld && \
    chkconfig --add redis && chkconfig redis on && \
    if [ $? -eq 0 ];then
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "nginx php-fpm mysqld redis will autostart for system start"
    fi
}
function menu(){
cat<<EOF
###########################################
# 1. [INSTALL BASIC_PACKAGE            ]  #
# 2. [INSTALL NGINX                    ]  #
# 3. [INSTALL MYSQL 5.6                ]  #
# 4. [INSTALL PHP5.6                   ]  #
# 5. [INSTALL REDIS4                   ]  #
# 6. [INSTALL REDIS_5.6_EXTENSION      ]  #
# 7. [INSTALL PHALCON_5.6_EXTENSION    ]  #
# 8. [INSTALL NGINX_CONF               ]  #
# 9. [INSTALL PHP_CONF                 ]  #
# 10.[INSTALL MYSQL_CONF               ]  #
# 11.[INSTALL REDIS_CONF               ]  #
# 12.[INSTALL 1-10                     ]  #
# 13.[FIREWALLD OFFLINE CONF           ]  #
# 14.[INSTALL  AUTOSTART               ]  #
# 15.[INSTALL  MYSQL 5.7               ]  #
# 16.[INSTALL  PHP_7_2_INSTALL         ]  #
# 17.[INSTALL  PHP_7_3_INSTALL         ]  #
# 18.[INSTALL  REDIS_7.x_EXTENSION     ]  #
# 19.[INSTALL  PHALCON_7.x_EXTENSION   ]  #
# 20.[INSTALL  NSQ_1_2_INSTALL         ]  #
# 21.[INSTALL  SUPERVISOR_INSTALL      ]  #
# 22.[INSTALL  GO_13_INSTALL           ]  #
# 23.[INSTALL  GO_14_INSTALL           ]  #
# 24.[INSTALL  nodejs12.16.3 INSTALL   ]  #
# 25.[INSTALL  nodejs10.20.1 INSTALL   ]  #
# 25.[EXIT                             ]  #                     
###########################################
EOF
read -t 20 -p "pls input the num you want to install :" a
}

function read1(){
        if [ "$a" == "1" ];then
                echo "start installing basic package....."
		basic_install
                menu
                read1
	elif [ "$a"  ==  "2" ];then
		echo "start installing nginx ...."
		nginx_install
                menu
                read1
        elif [ "$a"  ==  "3" ];then
                echo "start installing mysql...."
                mysql_5_6_install
                menu
                read1
        elif [ "$a" == "4" ];then
                echo "start installing php5.6...."
		php_5_6_install
                menu
                read1
        elif [ "$a" == "5" ];then
                echo "start installing redis4...."
                redis_install
                menu
                read1
        elif [ "$a" == "6" ];then
                echo "start installing php redis expand...."
		php_5_6_redis_install
                menu
                read1
        elif [ "$a" == "7" ];then
                echo "start installing php phalcon expand...."
		php_5_phalcon_install
                menu
                read1
        elif [ "$a" == "8" ];then
                echo "start configure nginx conf ...."
		nginx_conf
                menu
                read1
        elif [ "$a" == "9" ];then
                echo "start configure php ...."
                php_conf
                menu
                read1
        elif [ "$a" == "10" ];then
                echo "start configure mysql ...."
                mysql_conf
                menu
                read1
        elif [ "$a" == "11" ];then
                echo "start configure redis conf"
                redis_conf
                menu
                read1
        elif [ "$a" == "12" ];then
                echo "start install lnmp and basic package instll and configure and php expand with redis and phalcon...."
		basic_install && \
		nginx_install && \
		mysql_install  && \
		php_install  && \
		redis_install && \
		php_redis_install && \
		php_phalcon_install && \
		nginx_conf && \
		php_conf && \
		mysql_conf && \
		redis_conf && \
                menu
                read1
        elif [ "$a" == "13" ];then
                echo "firewalld offline configure for eth0....."
		firewalld_conf	
		menu
		read1
        elif [ "$a" == "14" ];then
                echo "nginx,php,mysql,redis autostart set ....."
		autostart_all
		menu
		read1
        elif [ "$a" == "15" ];then
                echo "start install mysql 5.7 version ....."
		mysql_5_7_install
		menu
		read1
        elif [ "$a" == "16" ];then
                echo "start install php 7.2.x version  ....."
		php_7_2_install
		menu
		read1
        elif [ "$a" == "17" ];then
                echo "start install php 7.3.x version ...."
		php_7_3_install
		menu
		read1
        elif [ "$a" == "18" ];then
                echo "install php 7 redis extension ....."
		php_7_redis_install
		menu
		read1
        elif [ "$a" == "19" ];then
                echo "install php 7 phalcon extension ......"
		php_7_phalcon_install
		menu
		read1
        elif [ "$a" == "20" ];then
                echo "install nsq 1.2 version ......"
		nsq_1_2_install
		menu
		read1
        elif [ "$a" == "21" ];then
                echo "install supervisor ......"
		supervisor_install
		menu
		read1
        elif [ "$a" == "22" ];then
                echo "install go 13 version ......."
		go_13_install
		menu
		read1
        elif [ "$a" == "23" ];then
                echo "install go 14 version ......."
		go_14_install
		menu
		read1
		elif [ "$a" == "24" ];then
                echo "install nodejs_v12.16.3  version ......."
		nodejs_v12_16_3_install
		menu
		read1
		elif [ "$a" == "25" ];then
                echo "install nodejs_v12.16.3  version ......."
		nodejs_v10_20_1_install
		menu
		read1	
        elif [ "$a" == "26" ];then
                echo "exiting........."
                exit

        else 
                echo "input error ,pls input num!!!"
                exit 3
        fi
}
function main(){
   	menu
  	read1
}
main


