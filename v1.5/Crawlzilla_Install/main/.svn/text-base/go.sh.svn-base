#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ] || [ "$3" == "" ]; then
 echo "1. 使用這個shell ，首先你需要有crawler這個使用者，並且hadoop 已經開始運作";
 echo "2. 執行 prepare_go.sh ";
 echo "3. 執行 $0 <使用者名稱> <資料夾名稱> <深度>"
 echo "4. 等nutch所有程序完成，則你的資料在 /home/crawler/crawlzilla/user/admin/IDB/crawlname/ "
 exit
fi

USERNAME=$1
JNAME=$2
Depth=$3

# env

OptMain="/opt/crawlzilla/main"
OptWebapp="/opt/crawlzilla/tomcat/webapps"
OptNutchBin="/opt/crawlzilla/nutch/bin"
HomeUserDir="/home/crawler/crawlzilla/user"
HdfsHome="/user/crawler"

# local para
HomeUserTmp="$HomeUserDir/$USERNAME/tmp"
HomeUserIDB="$HomeUserDir/$USERNAME/IDB"
HomeUserWeb="$HomeUserDir/$USERNAME/webs"
HomeUserMeta="$HomeUserDir/$USERNAME/meta"


[ $USER != "crawler" ] && echo "please enter crawler's password"  && exec su crawler -c "$0 $USERNAME $JNAME $Depth"

source "$OptMain/log.sh" sechedule;

# check the default url path in action !
if [ ! -e $HomeUserTmp/$JNAME/meta/urls/urls.txt ];then
   show_info "[error] $HomeUserTmp/$JNAME/meta/urls/urls.txt is not existed.";
   exit 8 ## exit if the same name in tmp/
fi

# check the replicate directory on HDFS ; $? : 0 = shoud be delete
$OptNutchBin/hadoop dfs -test -e $HdfsHome/$USERNAME/${JNAME}_urls
if [ $? -eq 0 ]; then
  $OptNutchBin/hadoop dfs -rmr $HdfsHome/$USERNAME/${JNAME}_urls
  check_info "clean hdfs:${USERNAME}/${JNAME}_urls"
fi
$OptNutchBin/hadoop dfs -test -e $HdfsHome/$USERNAME/$JNAME
if [ $? -eq 0 ]; then
  $OptNutchBin/hadoop dfs -rmr $HdfsHome/$USERNAME/$JNAME
  check_info "clean hdfs:${USERNAME}/${JNAME} "
fi

echo "prepare" > $HomeUserTmp/$JNAME/meta/status

# using at to run cronjob

cp $OptMain/lib_crawl_default.sh $OptMain/lib_crawl_tmp.sh

sed -i -e "s/USERNAME/$USERNAME/" $OptMain/lib_crawl_tmp.sh
sed -i -e "s/JOBNAME/$JNAME/" $OptMain/lib_crawl_tmp.sh
sed -i -e "s/DEPTH/$Depth/" $OptMain/lib_crawl_tmp.sh

at -f $OptMain/lib_crawl_tmp.sh now
