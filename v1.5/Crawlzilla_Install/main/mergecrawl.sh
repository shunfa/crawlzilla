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
#   2011/07/26  waue    1.0

## process description

#1. mergedb	A c1 c2 .. cn	# cn=crawldb
#2. mergelinkdb	B l1 l2 ..ln	# ln=linkdb
#3. mergesegs	C s1 s2 .. sn	# sn=segments
#4. inverlinks	B -dir C
#5. index	E A B C
#6. dedup	F E
#7. merge	I F

# prompt

if [ "$1" == "" ];then
  echo "Usage : mergecrawl <USERNAME> <NEW_DB_NAME> <DB_1> <DB_2> {...<DB_N>}";
  echo " where USERNAME is one of: ";
  echo "==========="
  NN=$(ls /home/crawler/crawlzilla/user)
  echo "$NN"
  echo "==========="
  exit 9;
fi

if [ "$4" == "" ];then
  echo "Usage : mergecrawl <USERNAME> <NEW_DB_NAME> <DB_1> <DB_2> {...<DB_N>}";
  if [ -d /home/crawler/crawlzilla/user/$1 ];then
    echo " <DB_1> and <DB_2> are : ";
    echo "==========="
    NN=$(ls /home/crawler/crawlzilla/user/$1/IDB/)
    echo "$NN"
    echo "==========="
  fi
  
  exit 9;
fi
  
# define

USERNAME=$1
JNAME=$2

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

# local para
local_crawl_dir=$HomeUserTmp/$JNAME
JPID=${local_crawl_dir}/meta/go.pid # go job pid 
JSTIME=${local_crawl_dir}/meta/starttime # start 
STATUS_FILE=${local_crawl_dir}/meta/status # status path

# crawl job para

crawl_dir="${HdfsHome}/${USERNAME}/${JNAME}"
## todo ## fix only two paras
local_crawl_1=${HomeUserIDB}/$3
local_crawl_2=${HomeUserIDB}/$4
hdfs_tmp=${HdfsHome}/temp
crawl_1=$hdfs_tmp/$3
crawl_2=$hdfs_tmp/$4
webdb_dir=$crawl_dir/crawldb
segments_dir=$crawl_dir/segments
linkdb_dir=$crawl_dir/linkdb
index_dir=$crawl_dir/index

source "/opt/crawlzilla/nutch/conf/hadoop-env.sh";
source "/opt/crawlzilla/main/log.sh" job_fix;



### function
function _checkInfo ( )
{
  if [ $? -eq 0 ];then
    show_info "[ok] $1";
  else
    echo "error: $1 broken" > "${local_crawl_dir}/meta/status"
    show_info "[error] $1 broken"
    #kill -9 $CPID
    exit 8
  fi
}


### check ###

# 
if [ -d $local_crawl_dir ]; then
  echo "error: dir already exists! $crawl_dir"
  exit 8
fi
if [ ! -d $local_crawl_1 ]||[ ! -d $local_crawl_2 ] ; then
  echo "error: no dir ! $crawl_1 or $crawl_2 "
  exit 8
fi
if $OptNutchBin/hadoop dfs -test -d $hdfs_tmp 2&>1; then
   $OptNutchBin/hadoop dfs -rmr $hdfs_tmp;
fi

### program

DATE=$(date +%Y%m%d)
show_info "Merge $JNAME BEGIN at $DATE"

# mkdir ${local_crawl_dir}/meta/
mkdir -p ${local_crawl_dir}/meta/

# log starttime
echo $(date '+%s') > $JSTIME

# Job begin
echo "merging" > $STATUS_FILE;


# mkdir 
${OptNutchBin}/hadoop dfs -mkdir $crawl_dir $hdfs_tmp

# upload input dirs
${OptNutchBin}/hadoop dfs -put $local_crawl_1 $crawl_1
${OptNutchBin}/hadoop dfs -put $local_crawl_2 $crawl_2


# check upload paths
if ${OptNutchBin}/hadoop dfs -test -d $crawl_1 && ${OptNutchBin}/hadoop dfs -test -d $crawl_2 ;then
  echo "[info] $crawl_1 ";
  echo "[info] $crawl_2 ";
else
  echo "${OptNutchBin}/hadoop dfs -test -d $crawl_1 $crawl_1";
  echo "error: $crawl_1 and $crawl_2 not exists!"
  exit 8
fi


### merge code begin

${OptNutchBin}/nutch mergelinkdb $linkdb_dir $crawl_1/linkdb $crawl_2/linkdb
_checkInfo "Merge linkdb"


${OptNutchBin}/nutch mergedb $webdb_dir $crawl_1/crawldb $crawl_2/crawldb
_checkInfo "Merge crawldb"

echo Merge segments 
#segments_1=`ls -d $crawl_1/segments/*`
segments_1=$(${OptNutchBin}/hadoop dfs -ls ${crawl_1}/segments/ |awk '{print $8}')
 #echo 1 $segments_1

 #segments_2=`ls -d $crawl_2/segments/*`
segments_2=$(${OptNutchBin}/hadoop dfs -ls ${crawl_2}/segments/ |awk '{print $8}')

 #echo 2 $segments_2

debug_info "[check] ${OptNutchBin}/nutch mergesegs $segments_dir $segments_1 $segments_2"
${OptNutchBin}/nutch mergesegs $segments_dir $segments_1 $segments_2
_checkInfo "Merge crawldb"


# From there, identical to recrawl.sh

debug_info " ${OptNutchBin}/nutch invertlinks $linkdb_dir -dir $segments_dir"
${OptNutchBin}/nutch invertlinks $linkdb_dir -dir $segments_dir
_checkInfo "Update segments"


new_indexes=${crawl_dir}/newindexes
segment=$(${OptNutchBin}/hadoop dfs -ls $segments_dir/ |awk '{print $8}')
debug_info " ${OptNutchBin}/nutch index $new_indexes $webdb_dir $linkdb_dir $segment"
${OptNutchBin}/nutch index $new_indexes $webdb_dir $linkdb_dir $segment
_checkInfo "Index segments"


${OptNutchBin}/nutch dedup $new_indexes
_checkInfo "De-duplicate indexes"


${OptNutchBin}/nutch merge $index_dir $new_indexes
_checkInfo "Merge indexes"


show_info "Merge Job finished!"

${OptNutchBin}/hadoop dfs -get $crawl_dir /home/crawler/$new_crawl_dir_name
_checkInfo "Download"

### merge code ok

# download Index DB from hdfs 
$OptNutchBin/hadoop dfs -get $crawl_dir/* $local_crawl_dir
#check_tmp_info "download Index DB"
_checkInfo "download Index DB"


# "merge url"
cp ${local_crawl_1}/meta/urls.txt $local_crawl_dir/meta/
cat ${local_crawl_2}/meta/urls.txt >> $local_crawl_dir/meta/urls.txt
_checkInfo "merge url"

# "merge depth"
cp ${local_crawl_1}/meta/depth $local_crawl_dir/meta/
_checkInfo "merge depth"

# check index is finish or not, otherwise don't work
if [ ! -d ${local_crawl_dir}/index ]; then 
  show_info "[error] not existed! ${local_crawl_dir}/index"
  exit 8;
fi
# index_check
 
# move the index-db from tmp to IDB
mv ${local_crawl_dir} $HomeUserIDB/$JNAME
#check_idb_info "mv indexDB from tmp to IDB"
_checkInfo "mv indexDB from tmp to IDB"

# make web index if without web link
if [ ! -d $HomeUserWeb/$JNAME ];then
  # prepare $JNAME at tomcat
  cp -rf $OptWebapp/default $HomeUserWeb/$JNAME
  #check_idb_info "cp default to user/webs/$JNAME"
  _checkInfo "cp default to user/webs/$JNAME"
  # inject the nutch-site.xml for linking webs and idb
  sed -i 's/XS_DIRX/'$USERNAME'\/IDB\/'$JNAME'/g' $HomeUserWeb/$JNAME/WEB-INF/classes/nutch-site.xml
  #check_idb_info "inject the nutch-site.xml for linking webs and idb"
  _checkInfo "inject the nutch-site.xml for linking webs and idb"
fi

# clean link for tomcat reload
#if [ -e $OptWebapp/${USERNAME}_$JNAME ] || [ "$REDO" == "true" ]; then
if [ -e $OptWebapp/${USERNAME}_$JNAME ]; then
  rm $OptWebapp/${USERNAME}_$JNAME
fi
# link user/$USERNAME/webs/JNAME to tomcat/webapps/$USERNAME/JNAME
ln -sf $HomeUserWeb/$JNAME $OptWebapp/${USERNAME}_$JNAME
#check_idb_info "link to tomcat/webapps"
_checkInfo "link to tomcat/webapps"

# clean meta-files
if [ -e $HomeUserIDB/$JNAME/meta/go.pid ];then
  rm "$HomeUserIDB/$JNAME/meta/go.pid"
fi

$OptNutchBin/hadoop dfs -test -e $crawl_dir
if [ $? -eq 0 ]; then
  $OptNutchBin/hadoop dfs -rmr $crawl_dir
  $OptNutchBin/hadoop dfs -rmr $hdfs_tmp
  _checkInfo "rmr $JNAME and temp on hdfs"
fi

echo "finish" > $HomeUserIDB/$JNAME/meta/status; 

f_time=`date '+%s'`
if [ -e $HomeUserIDB/$JNAME/meta/starttime ] ;then
  s_time=$(cat $HomeUserIDB/$JNAME/meta/starttime)
  pass_time=$(expr $f_time - $s_time)
  hours=$(expr $pass_time / 3600)
  pass_time=$(expr $pass_time % 3600)
  minutes=$(expr $pass_time / 60)
  seconds=$(expr $pass_time % 60)
  pass_time="$hours:$minutes:$seconds"
  #show_idb_info "it takes : $pass_time"
  show_info "it takes : $pass_time"
  echo "$pass_time" > "$HomeUserIDB/$JNAME/meta/passtime"
fi

if [ -e $HomeUserIDB/$JNAME/meta/crawl.log ] && [ -e $LOG_SH_TARGET ];then
  cat $HomeUserIDB/$JNAME/meta/crawl.log >> $LOG_SH_TARGET 2>&1
fi

