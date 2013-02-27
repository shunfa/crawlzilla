#!/bin/bash
SvnCrawlzilla=`dirname "$0"`
SvnCrawlzilla=`cd $SvnCrawlzilla; pwd`
SvnCrawlzillaIns=`cd "$SvnCrawlzilla/Crawlzilla_Install"; pwd`
if [ ! -f $SvnCrawlzillaIns/install ];then
  echo "$SvnCrawlzillaIns worng!"
fi

Job=$1
function su_permit ( )
{
    [ "`id -u`" != "0" ] && exec sudo su -c "$0 $Job"
}

function do_build ( ) 
{
 su_permit
 if [ ! -d "/home/crawler" ];then
   echo "build crawler"
   sudo useradd -m crawler -s /bin/bash
   sudo su crawler -c 'ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ""'
   sudo su crawler -c "cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys"
   sudo su crawler -c "ssh-add /home/crawler/.ssh/id_rsa"
 else
   echo "user \"crawler\" existing..."
 fi

 if [ ! -d "$SvnCrawlzilla/opt/tomcat" ] || [ ! -d "$SvnCrawlzilla/opt/nutch" ];then 
    echo "Fill tomcat and nutch to \"$SvnCrawlzilla/opt/\" "
    cd $SvnCrawlzilla/opt/
    mkdir backup; mv tomcat backup; mv nutch backup;
    wget "http://sourceforge.net/projects/crawlzilla/files/stable/package/crawlzilla_1.0_package.tar.gz/download" -O "crawlzilla_1.0_package.tar.gz"
    tar -zxvf ./crawlzilla_1.0_package.tar.gz
    cd $SvnCrawlzilla
 else
    echo "tomcat and nutch on \"$SvnCrawlzilla/opt/\ is detected"
 fi

 if [ ! -d "/home/crawler/crawlzilla" ];then
   echo "build /home/crawler/crawlzilla"
   sudo mkdir -p /home/crawler/crawlzilla/
   sudo mkdir -p /home/crawler/crawlzilla/user/admin/IDB/
   sudo mkdir -p /home/crawler/crawlzilla/user/admin/tmp/
   sudo mkdir -p /home/crawler/crawlzilla/user/admin/meta/
   sudo mkdir -p /home/crawler/crawlzilla/meta/tmp
   # default value
   sudo echo "localhost">> /home/crawler/crawlzilla/meta/crawl_nodes
   sudo echo "crawler">> /home/crawler/crawlzilla/user/admin/meta/.passwd
   sudo cp /etc/hosts /home/crawler/crawlzilla/meta/hosts

   sudo chown -R crawler:crawler /home/crawler/
 else
   echo "\"crawlzilla on \\home\\crawler\\ \" existing..."
 fi
 if [ ! -d "/opt/crawlzilla" ];then
   echo "build /opt/crawlzilla"
   sudo mkdir /opt/crawlzilla/slave
   sudo cp -rf $SvnCrawlzilla/opt /opt/crawlzilla
   if [ -d "/opt/crawlzilla/tomcat" || -d "/opt/crawlzilla/nutch" ];then 
      wget "http://sourceforge.net/projects/crawlzilla/files/stable/package/crawlzilla_1.0_package.tar.gz/download" -O "crawlzilla_1.0_package.tar.gz"
      tar -zxvf crawlzilla_1.0_package.tar.gz
   fi
   sudo cp $SvnCrawlzilla/conf/crawlzilla_conf/* /etc/init.d/
   sudo cp $SvnCrawlzilla/conf/tomcat_conf/* /opt/crawlzilla/tomcat/conf/
   sudo cp $SvnCrawlzilla/conf/nutch_conf/* /opt/crawlzilla/nutch/conf/
 else
   echo "\"crawlzilla on \\opt\" existing..."
 fi
 if [ ! -d "/var/log/crawlzilla/" ];then
   echo "create /var/log/crawlzilla"
   sudo mkdir /var/log/crawlzilla/
   sudo mkdir /var/log/crawlzilla/tomcat-logs
   sudo ln -sf /var/log/crawlzilla/tomcat-logs /opt/crawlzilla/tomcat/logs
   sudo chown -R crawler /var/log/crawlzilla/
   sudo chmod -R 777 /var/log/crawlzilla/
 else
   echo "\"crawlzilla on \\var\\log\\ \" existing..."
 fi
 if [ ! -d "/home/crawler/crawlzilla/workspace/" ];then
   echo "create /home/crawler/crawlzilla/workspace/"
   sudo mkdir /home/crawler/crawlzilla/workspace/
   sudo chown crawler:crawler /home/crawler/crawlzilla/workspace/
   sudo chmod 777 /home/crawler/crawlzilla/workspace/
 else
   echo "\"crawlzilla on \\var\\log\\ \" existing..."
 fi
 sudo su crawler -c "/opt/crawlzilla/nutch/bin/hadoop namenode -format"
 sudo su crawler -c "/opt/crawlzilla/nutch/bin/start-all.sh"

 sudo ln -sf /opt/crawlzilla/main/crawlzilla /usr/bin/crawlzilla
}

function do_update ( ) 
{
  echo "update info "
  sudo rm -rf /opt/crawlzilla/main
  sudo svn export $SvnCrawlzillaIns/main /opt/crawlzilla/main

  # below would replace correct info to default !!
  #if [ "$?" == "0" ];then echo "[main] --> /opt/crawlzilla/main " ; fi
  #sudo cp $SvnCrawlzillaIns/conf/crawlzilla_conf/*-* /etc/init.d/
  #if [ "$?" == "0" ];then echo "[init.d] --> /etc/init.d " ; fi
  #sudo cp $SvnCrawlzillaIns/conf/tomcat_conf/* /opt/crawlzilla/tomcat/conf/
  #if [ "$?" == "0" ];then echo "[tomcat] --> /opt/crawlzilla/tomcat/conf " ; fi
  #sudo cp $SvnCrawlzillaIns/conf/nutch_conf/* /opt/crawlzilla/nutch/conf/
  #if [ "$?" == "0" ];then echo "[nutch] --> /opt/crawlzilla/nutch/conf " ; fi

  if [ -e $SvnCrawlzillaIns/web/crawlzilla.war ];then
    sudo su crawler -c "/opt/crawlzilla/tomcat/bin/shutdown.sh"
    sudo rm /opt/crawlzilla/tomcat/webapps/crawlzilla.war
    sudo rm -rf /opt/crawlzilla/tomcat/webapps/crawlzilla
    sudo su crawler -c "cp $SvnCrawlzillaIns/web/crawlzilla.war /opt/crawlzilla/tomcat/webapps/"
    sudo su crawler -c "/opt/crawlzilla/tomcat/bin/startup.sh"
  fi

  sudo chown -R crawler:crawler /home/crawler/crawlzilla/
  sudo chown -R crawler:crawler /opt/crawlzilla/
  if [ "$?" == "0" ];then echo "[chown] " ; fi
}

function do_remove ( ) 
{
  echo "removeing ..." 
  if [ -e "/opt/crawlzilla/nutch/bin/stop-all.sh" ];then
    sudo su crawler -c "/opt/crawlzilla/nutch/bin/stop-all.sh"
  fi
  if [ -e "/etc/init.d/crawlzilla-master" ];then
  sudo rm /etc/init.d/crawlzilla-master
    if [ "$?" == "0" ];then echo "[rm] /etc/init.d/crawlzilla-master " ; fi
  fi
  if [ -e "/etc/init.d/crawlzilla-slave" ];then
  sudo rm /etc/init.d/crawlzilla-slave
    if [ "$?" == "0" ];then echo "[rm] /etc/init.d/crawlzilla-slave " ; fi
  fi

#  if [ -d "/home/crawler/crawlzilla/workspace" ];then
#    sudo rm -rf /home/crawler/crawlzilla/workspace/
#    if [ "$?" == "0" ];then echo "[rm] /home/crawler/crawlzilla/workspace/ " ; fi
#  fi
  if [ -d "/home/crawler/crawlzilla" ];then
    sudo rm -rf /home/crawler/crawlzilla
    if [ "$?" == "0" ];then echo "[rm] /home/crawler/crawlzilla " ; fi
  fi
  if [ -d "/var/log/crawlzilla" ];then
    sudo rm -rf /var/log/crawlzilla 
    if [ "$?" == "0" ];then echo "[rm] /var/log/crawlzilla/ " ; fi
  fi

  if [ -d /opt/crawlzilla/ ];then
    sudo rm -rf /opt/crawlzilla
    if [ "$?" == "0" ];then echo "[rm] /opt/crawlzilla " ; fi
  fi
 sudo rm /usr/bin/crawlzilla
}

function make_war ( ) 
{
 echo "make war"
 if [ -d "$SvnCrawlzilla/web-src/" ];then
   ant -f $SvnCrawlzilla/web-src/build.xml clean
   ant -f $SvnCrawlzilla/web-src/build.xml
   if [ "$?" == "0" ];then
      echo "[ok] crawlzilla.war --> ./ "
   fi
   if [ -e $SvnCrawlzilla/web-src/tmp/crawlzilla.war ];then
      mv $SvnCrawlzilla/web-src/tmp/crawlzilla.war $SvnCrawlzillaIns/web
   fi
 else 
   echo "make sure jsp files is on $SvnCrawlzilla/web-src"
 fi
}
case "$Job" in
build)
  do_build;exit 0;
  ;;
update)
  do_update; exit 0;
  ;;
remove)
  do_remove; exit 0;
  ;;
web)
  make_war; exit 0;
  ;;
*)
  echo " Usage : "
#  echo " sudo $0 build "
  echo " sudo $0 update "
#  echo " sudo $0 remove "
  echo " $0 web "
  exit 0;
;;
esac
