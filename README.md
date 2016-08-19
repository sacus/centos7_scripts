#centos7上的lnmp编译安装的一些启动脚本，
***
centos7采用的是system来启动和管理服务的，但chkconfig还是保留了，   
像编译安装的nginx和php启动都没有脚本，所以我手动增加了一些脚本，   
在/etc/init.d/下增加了脚本，然后/usr/lib/systemd/system/下来引用，  
这样两种管理方式都保留了。
