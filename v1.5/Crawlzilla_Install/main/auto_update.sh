#!/bin/bash

[ $USER != "crawler" ] && echo "please enter crawler's password"  && exec su crawler -c "$0" "$@"

Update_Dir="/opt/crawlzilla/update"
VER_CURR=$(cat /opt/crawlzilla/version)
echo "This Crawlzilla is version: $VER_CURR"

if [ -d $Update_Dir ];then
  # "Clean Previous Update Files"
  rm -rf $Update_Dir/*
else
  mkdir -p $Update_Dir
fi

#wget http://sourceforge.net/projects/crawlzilla/files/testing/version/download -O $Update_Dir/version > /dev/null 2>&1
wget http://crawlzilla.googlecode.com/svn/trunk/v1.0/Crawlzilla_Install/version -O $Update_Dir/version > /dev/null 2>&1

if [ ! -f $Update_Dir/version ];then
  echo "[Error] Check Online Version Failed!"
  exit 8
fi

VER_NEW=$(cat $Update_Dir/version)
echo "The latest online version : $VER_NEW"

if [ "$VER_NEW" == "$VER_CURR" ];then
  echo "Crawlzilla $VER_CURR is latest."
  exit 0
fi

wget http://sourceforge.net/projects/crawlzilla/files/testing/Crawlzilla-1.1/Crawlzilla-$VER_NEW.tar.gz/download -O $Update_Dir/crawlzilla-update.tar.gz > /dev/null 2>&1

if [ ! -f $Update_Dir/crawlzilla-update.tar.gz ];then
  echo "[Error] Download Crawlzilla-$VER_NEW.tar.gz Failed!"
  exit 8
else
  echo "Download Crawlzilla-$VER_NEW.tar.gz Finish!" 
fi

tar -xzvf $Update_Dir/crawlzilla-update.tar.gz -C $Update_Dir/  > /dev/null 2>&1
if [ "$?" != "0" ];then echo " Untar error !";exit 1; fi

Work_Dir="$Update_Dir/Crawlzilla_Install"
cp -rf $Work_Dir/main/*  /opt/crawlzilla/main/
if [ $? == "0" ];then echo " Update main code"; fi

cp $Work_Dir/version  /opt/crawlzilla/
# copy crawlzilla.war to /opt/crawlzilla/tomcat/webapps
mv /opt/crawlzilla/tomcat/webapps/crawlzilla.war $Update_Dir/
mv /opt/crawlzilla/tomcat/webapps/crawlzilla $Update_Dir/crawlzilla-web
cp $Work_Dir/web/crawlzilla.war /opt/crawlzilla/tomcat/webapps/crawlzilla.war
if [ $? == "0" ];then echo " Update Crawlzill websites"; fi
cp -rf $Work_Dir/web/tomcat_default/patch/* /opt/crawlzilla/tomcat/webapps/default/
if [ $? == "0" ];then echo " Update webpage"; fi

#chown -R crawler /opt/crawlzilla/main/
#chown -R crawler /opt/crawlzilla/tomcat/webapps/

echo "Crawlizlla have been updated to version : $VER_NEW"
