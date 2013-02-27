#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Program:
#   Delete duplicating ip $ hostname in file (for crawlzilla management interface).
# Author: 
#   Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
# Version:
#    1.0
# History:
#   2011/03/16  waue	release (1.0)
#   2010/06/07  Rock    First release (0.3)

USERNAME=$1
JNAME=$2
Depth=$3

#if [ "$4" != "" ];then REDO=true;fi

# env
OptWebapp="/opt/crawlzilla/tomcat/webapps"
OptNutchBin="/opt/crawlzilla/nutch/bin"
HomeUserDir="/home/crawler/crawlzilla/user"
HdfsHome="/user/crawler"

# local para
HomeUserTmp="$HomeUserDir/$USERNAME/tmp"
HomeUserIDB="$HomeUserDir/$USERNAME/IDB"
HomeUserWeb="$HomeUserDir/$USERNAME/webs"
HomeUserMeta="$HomeUserDir/$USERNAME/meta"


# logging to default when starting
source "/opt/crawlzilla/main/log.sh" crawl_go;
source "/opt/crawlzilla/nutch/conf/hadoop-env.sh";



if [ "$3" == "redo" ] && [ -d $HomeUserIDB/$JNAME ]; then 
    REDO=true;
    Depth=$(cat $HomeUserIDB/$JNAME/meta/depth)
    mkdir -p /home/crawler/crawlzilla/user/$USERNAME/tmp/$JNAME/meta/urls/
    cp $HomeUserIDB/$JNAME/meta/urls/urls.txt  $HomeUserTmp/$JNAME/meta/urls/urls.txt 
    source "/opt/crawlzilla/main/log.sh" recrawl_go;
fi

$HomeUserTmp/$JNAME/meta/urls/urls.txt

function check_tmp_info ( )
{
  if [ $? -eq 0 ];then
    show_tmp_info "[ok] $1";
  else
    echo "error: $1 broken" > "$HomeUserTmp/$JNAME/meta/status"
    show_tmp_info "[error] $1 broken"
    show_info $(cat $HomeUserTmp/$JNAME/meta/crawl.log)
    #cat $HomeUserTmp/$JNAME/meta/crawl.log >> $LOG_SH_TARGET 2>&1
    exit 8
  fi
}
    
function show_tmp_info ( ) 
{
    echo -e "\033[1;32;40m $1 \033[0m"
    echo "< $(date +%H:%M:%S) > $1" >> $HomeUserTmp/$JNAME/meta/crawl.log 2>&1 
}


function check_idb_info ( )
{
  if [ $? -eq 0 ];then
    show_idb_info "[ok] $1";
  else
    echo "error: $1 broken" > "$HomeUserIDB/$JNAME/meta/status"
    show_idb_info "[error] $1 broken"
    show_info $(cat $HomeUserIDB/$JNAME/meta/crawl.log)
    #cat $HomeUserIDB/$JNAME/meta/crawl.log >> $LOG_SH_TARGET 2>&1
    exit 8
  fi
}

function show_idb_info ( ) 
{
    echo -e "\033[1;32;40m $1 \033[0m"
    echo "< $(date +%H:%M:%S) > $1" >> $HomeUserIDB/$JNAME/meta/crawl.log 2>&1 
}

cd /home/crawler/crawlzilla/

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


# check urls and redo if true then copy
#if [ "$REDO" == "ture" ] && [ -e $HomeUserIDB/$JNAME/meta/url.txt ]; then 
#  cp $HomeUserIDB/$JNAME/meta/url.txt $HomeUserMeta/urls/url.txt
#fi

# check urls ## has done
#if [ ! -e $HomeUserMeta/urls/url.txt ];then 
#  show_info "[error] $HomeUserMeta/urls/url.txt is miss! please check.";
#  exit 0
#fi

# [ begin ] 
show_info " user=$USERNAME ,name= $JNAME , depth= $Depth "
show_info " url= $(cat $HomeUserTmp/$JNAME/meta/urls/urls.txt)"

BeginDate=$(date +%Y%m%d-%H:%M:%S)
s_time=`date '+%s'`

# make JNAME and its meta ## unnecessary
#if [ ! -e "$HomeUserTmp/$JNAME/meta" ];then
#   mkdir -p "$HomeUserTmp/$JNAME/meta"
#   check_tmp_info "mkdir crawlStatusDir"
#fi



# process id
echo $$ > "$HomeUserTmp/$JNAME/meta/go.pid"
check_tmp_info "$$ > $HomeUserTmp/$JNAME/meta/go.pid"

# depth
echo $Depth > "$HomeUserTmp/$JNAME/meta/depth"

# status
echo "begin" > "$HomeUserTmp/$JNAME/meta/status"

# start time
echo "$s_time" > "$HomeUserTmp/$JNAME/meta/starttime"
echo "$BeginDate" > "$HomeUserTmp/$JNAME/meta/begindate"


# make HDFS dir

$OptNutchBin/hadoop dfs -mkdir $HdfsHome/$USERNAME/$JNAME
check_tmp_info "hadoop dfs -mkdir $HdfsHome/$USERNAME/$JNAME"

# upload urls

$OptNutchBin/hadoop dfs -put $HomeUserTmp/$JNAME/meta/urls $HdfsHome/$USERNAME/${JNAME}_urls
check_tmp_info "hadoop dfs -put urls"

# nutch crawl begining
echo "crawling" > "$HomeUserTmp/$JNAME/meta/status"

show_tmp_info "nutch crawl $USERNAME $JNAME $Depth ..."
$OptNutchBin/nutch crawl $HdfsHome/$USERNAME/${JNAME}_urls -dir $HdfsHome/$USERNAME/$JNAME -depth $Depth -topN 50000 -threads 1000
check_tmp_info "nutch crawl finished"

# download Index DB from hdfs 
$OptNutchBin/hadoop dfs -get $HdfsHome/$USERNAME/$JNAME/* $HomeUserTmp/$JNAME
check_tmp_info "download Index DB"

$OptNutchBin/hadoop dfs -get $HdfsHome/$USERNAME/${JNAME}_urls/* $HomeUserTmp/$JNAME/meta/urls.txt
check_tmp_info "download url"

# check IDB then mv to old-dir
if [ -d $HomeUserIDB/$JNAME ]; then
   mv $HomeUserIDB/$JNAME $HomeUserDir/$USERNAME/old/${JNAME}_${BeginDate} ## move the same name at IDB
   check_tmp_info "move old to $HomeUserDir/$USERNAME/old/${JNAME}_${BeginDate}"
fi

# move the index-db from tmp to IDB
mv $HomeUserTmp/$JNAME $HomeUserIDB/$JNAME
check_idb_info "mv indexDB from tmp to IDB"


# make web index if without web link
if [ ! -d $HomeUserWeb/$JNAME ];then
   # prepare $JNAME at tomcat
   cp -rf $OptWebapp/default $HomeUserWeb/$JNAME
   check_idb_info "cp default to user/webs/$JNAME"
   # inject the nutch-site.xml for linking webs and idb
   sed -i 's/XS_DIRX/'$USERNAME'\/IDB\/'$JNAME'/g' $HomeUserWeb/$JNAME/WEB-INF/classes/nutch-site.xml
   check_idb_info "inject the nutch-site.xml for linking webs and idb"
fi

# clean link for tomcat reload
#if [ -e $OptWebapp/${USERNAME}_$JNAME ] || [ "$REDO" == "true" ]; then
if [ -e $OptWebapp/${USERNAME}_$JNAME ]; then
   rm $OptWebapp/${USERNAME}_$JNAME
fi
# link user/$USERNAME/webs/JNAME to tomcat/webapps/$USERNAME/JNAME
ln -sf $HomeUserWeb/$JNAME $OptWebapp/${USERNAME}_$JNAME
check_idb_info "link to tomcat/webapps"

# clean meta-files
rm "$HomeUserIDB/$JNAME/meta/go.pid"

$OptNutchBin/hadoop dfs -test -e $HdfsHome/$USERNAME/$JNAME
if [ $? -eq 0 ]; then
  $OptNutchBin/hadoop dfs -rmr $HdfsHome/$USERNAME/$JNAME
  $OptNutchBin/hadoop dfs -rmr $HdfsHome/$USERNAME/${JNAME}_urls
  check_idb_info "rmr $JNAME and ${JNAME}_bek on hdfs"
fi

# report status
echo "finish" > "$HomeUserIDB/$JNAME/meta/status"



# count pass time
f_time=`date '+%s'`
if [ "$s_time" == "" ] && [ -e $HomeUserTmp/$JNAME/meta/starttime ] ;then 
  s_time=$(cat $HomeUserTmp/$JNAME/meta/starttime )
fi
pass_time=$(expr $f_time - $s_time)
hours=$(expr $pass_time / 3600)
pass_time=$(expr $pass_time % 3600)
minutes=$(expr $pass_time / 60)
seconds=$(expr $pass_time % 60)
pass_time="$hours:$minutes:$seconds"
show_idb_info "it takes : $pass_time"
echo "$pass_time" > "$HomeUserIDB/$JNAME/meta/passtime"

cat $HomeUserIDB/$JNAME/meta/crawl.log >> $LOG_SH_TARGET 2>&1
