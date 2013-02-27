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
#   2011/04/01  waue    1.0
#   2010/12/01  waue    First release (0.3)


# prompt
if [ "$2" == "" ];then
    echo "Usage : fix <USERNAME> <JOB_NAME>";
    if /opt/crawlzilla/nutch/bin/hadoop dfs -test -d /user/crawler/$1 ;then
	echo " where JOB_NAME is one of: ";
	echo "==========="
	NN=$(/opt/crawlzilla/nutch/bin/hadoop dfs -ls /user/crawler/$1 |grep crawler |awk '{print $8}' | cut -d "/" -f 5)
	echo "$NN"
	echo "==========="
    else 
	echo " where USERNAME is one of: ";
        echo "==========="
        NN=$(/opt/crawlzilla/nutch/bin/hadoop dfs -ls /user/crawler |grep crawler |awk '{print $8}' | cut -d "/" -f 4)
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


source "/opt/crawlzilla/nutch/conf/hadoop-env.sh";
source "/opt/crawlzilla/main/log.sh" job_fix;

### local




### function
function check_info ( )
{
  if [ $? -eq 0 ];then
    show_info "[ok] $1";
  else
    echo "error: $1 broken" > "/home/crawler/crawlzilla/user/$USERNAME/tmp/$JNAME/meta/status"
    show_info "[error] $1 broken"
    #kill -9 $CPID
    exit 8
  fi
}

### program

# local para
JPID="/home/crawler/crawlzilla/user/$USERNAME/tmp/$JNAME/meta/go.pid" # go job pid 
JSTIME="/home/crawler/crawlzilla/user/$USERNAME/tmp/$JNAME/meta/starttime" # start 
STATUS_FILE="/home/crawler/crawlzilla/user/$USERNAME/tmp/$JNAME/meta/status" # status path

# no job to fix
if [ ! -d /home/crawler/crawlzilla/user/$USERNAME/tmp/$JNAME/meta ];then
    show_info "no job to fix; check /home/crawler/crawlzilla/user/$USERNAME/tmp/$JNAME/meta"
    exit 8;
fi
# job have not start
if ! /opt/crawlzilla/nutch/bin/hadoop dfs -test -d /user/crawler/$USERNAME/$JNAME/segments ;then
    show_info "job have not on hdfs; check hdfs:/user/crawler/$USERNAME/$JNAME/segments"
#    exit 8;
fi

if [ -f $JPID ];then
  JPID=$(cat $JPID)
  # process is running
  #ps $JPID >/dev/null 2>&1
  #if [ $? -eq 0 ];then
  #    show_info "process is running; check pid $JPID"
  #    exit 8;
  #fi

  # kill pid ( old method )
  ps $JPID >/dev/null 2>&1
  if [ $? -eq 0 ];then
    show_info "$JPID killing .." 
    kill -9 $JPID >/dev/null 2>&1
    if [ ! $? -eq 0 ];then debug_info "Warning!!! kill go.sh not work"; fi
  fi
fi

DATE=$(date +%Y%m%d)
show_info "Fix $JNAME BEGIN at $DATE"



# fix begin
echo "fixing" > $STATUS_FILE;

# check index had been downloaded or not
if [ ! -d /home/crawler/crawlzilla/user/$USERNAME/tmp/$JNAME/index ] ;then ## 0_bigin

show_info "fixing from hdfs"

SEGS=$(/opt/crawlzilla/nutch/bin/hadoop dfs -ls /user/crawler/$USERNAME/$JNAME/segments | grep  segments | awk '{print $8 }')

# checking the contents in $JNAME/segments/ , or hadoop will broken
# content , crawl_fetch , crawl_generate , crawl_parse , parse_data, parse_text

SEOK=""
SEBAD=""
for SE in $SEGS
do
 show_info "checking $SE"
 if /opt/crawlzilla/nutch/bin/hadoop dfs -test -d $SE/content && \
 /opt/crawlzilla/nutch/bin/hadoop dfs -test -d $SE/crawl_fetch && \
 /opt/crawlzilla/nutch/bin/hadoop dfs -test -d $SE/crawl_generate && \
 /opt/crawlzilla/nutch/bin/hadoop dfs -test -d $SE/crawl_parse && \
 /opt/crawlzilla/nutch/bin/hadoop dfs -test -d $SE/parse_data && \
 /opt/crawlzilla/nutch/bin/hadoop dfs -test -d $SE/parse_text ;then
   show_info "$SE .... [Fine] "
   SEOK="$SEOK "$SE
 else
   SEBAD="$SEBAD "$SE
 fi
done
debug_info "SEOK =[ $SEOK ]"
debug_info "SEBAD =[ $SEBAD ]"
## remove these bad segments files
/opt/crawlzilla/nutch/bin/hadoop dfs -rmr $SEBAD
show_info "/opt/crawlzilla/nutch/bin/hadoop dfs -rmr $SEBAD"

## [ Do FIX Process ] if at least one correct Segments in pool ##

if [ ! "$SEOK" == "" ];then # 1_begin

## unlock
if /opt/crawlzilla/nutch/bin/hadoop dfs -test -e /user/crawler/$USERNAME/$JNAME/linkdb/.locked; then
  /opt/crawlzilla/nutch/bin/hadoop dfs -rmr /user/crawler/$USERNAME/$JNAME/linkdb/.locked;
fi

## begin FIX
   
show_info "1 invertlinks"
/opt/crawlzilla/nutch/bin/nutch invertlinks /user/crawler/$USERNAME/$JNAME/linkdb -dir /user/crawler/$USERNAME/$JNAME/segments/
check_info "invertlinks "

show_info "2 index" 
if /opt/crawlzilla/nutch/bin/hadoop dfs -test -e /user/crawler/$USERNAME/$JNAME/index ;then /opt/crawlzilla/nutch/bin/hadoop dfs -rmr /user/crawler/$USERNAME/$JNAME/index
fi

/opt/crawlzilla/nutch/bin/nutch index /user/crawler/$USERNAME/$JNAME/index /user/crawler/$USERNAME/$JNAME/crawldb /user/crawler/$USERNAME/$JNAME/linkdb $SEOK
check_info "index DB "

show_info "3 dedup" 
/opt/crawlzilla/nutch/bin/nutch dedup /user/crawler/$USERNAME/$JNAME/index
check_info "dedup "


# download Index DB from hdfs 
$OptNutchBin/hadoop dfs -get $HdfsHome/$USERNAME/$JNAME/* $HomeUserTmp/$JNAME
#check_tmp_info "download Index DB"
check_info "download Index DB"

$OptNutchBin/hadoop dfs -get $HdfsHome/$USERNAME/${JNAME}_urls/* $HomeUserTmp/$JNAME/meta/urls.txt
#check_tmp_info "download url"
check_info "download url"

# check IDB then mv to old-dir
if [ -d $HomeUserIDB/$JNAME ]; then
   mv $HomeUserIDB/$JNAME $HomeUserDir/$USERNAME/old/${JNAME}_${BeginDate} ## move the same name at IDB
   #check_tmp_info "move old to $HomeUserDir/$USERNAME/old/${JNAME}_${BeginDate}"
   check_info "move old to $HomeUserDir/$USERNAME/old/${JNAME}_${BeginDate}"
fi

# check $USERNAME/tmp/$JNAME/index/part-00000/
if [ -d /home/crawler/crawlzilla/user/$USERNAME/tmp/$JNAME/index/part-00000/ ];then
    show_info "5 mv index files from part-00000"
    mv /home/crawler/crawlzilla/user/$USERNAME/tmp/$JNAME/index/part-00000/* /home/crawler/crawlzilla/user/$USERNAME/tmp/$JNAME/index/
    check_info "mv index files from part-00000 "
    rmdir /home/crawler/crawlzilla/user/$USERNAME/tmp/$JNAME/index/part-00000/
fi

fi # 1_end

## end if without /home/crawler/crawlzilla/user/$USERNAME/tmp/$JNAME/index
fi # 0_end

# check index is finish or not, otherwise don't work
if [ -d /home/crawler/crawlzilla/user/$USERNAME/tmp/$JNAME/index ]; then # index_check
 
# move the index-db from tmp to IDB
mv $HomeUserTmp/$JNAME $HomeUserIDB/$JNAME
#check_idb_info "mv indexDB from tmp to IDB"
check_info "mv indexDB from tmp to IDB"

# make web index if without web link
if [ ! -d $HomeUserWeb/$JNAME ];then
   # prepare $JNAME at tomcat
   cp -rf $OptWebapp/default $HomeUserWeb/$JNAME
   #check_idb_info "cp default to user/webs/$JNAME"
   check_info "cp default to user/webs/$JNAME"
   # inject the nutch-site.xml for linking webs and idb
   sed -i 's/XS_DIRX/'$USERNAME'\/IDB\/'$JNAME'/g' $HomeUserWeb/$JNAME/WEB-INF/classes/nutch-site.xml
   #check_idb_info "inject the nutch-site.xml for linking webs and idb"
   check_info "inject the nutch-site.xml for linking webs and idb"
fi

# clean link for tomcat reload
#if [ -e $OptWebapp/${USERNAME}_$JNAME ] || [ "$REDO" == "true" ]; then
if [ -e $OptWebapp/${USERNAME}_$JNAME ]; then
   rm $OptWebapp/${USERNAME}_$JNAME
fi
# link user/$USERNAME/webs/JNAME to tomcat/webapps/$USERNAME/JNAME
ln -sf $HomeUserWeb/$JNAME $OptWebapp/${USERNAME}_$JNAME
#check_idb_info "link to tomcat/webapps"
check_info "link to tomcat/webapps"

# clean meta-files
if [ -e $HomeUserIDB/$JNAME/meta/go.pid ];then
  rm "$HomeUserIDB/$JNAME/meta/go.pid"
fi

$OptNutchBin/hadoop dfs -test -e $HdfsHome/$USERNAME/$JNAME
if [ $? -eq 0 ]; then
  $OptNutchBin/hadoop dfs -rmr $HdfsHome/$USERNAME/$JNAME
  $OptNutchBin/hadoop dfs -rmr $HdfsHome/$USERNAME/${JNAME}_urls
  #check_idb_info "rmr $JNAME and ${JNAME}_bek on hdfs"
  check_info "rmr $JNAME and ${JNAME}_bek on hdfs"
fi

echo "Fixed" > $HomeUserIDB/$JNAME/meta/status; 

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

fi # index_check
