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

if [ "$1" == "" ]; then
 echo "1. 使用這個shell ，首先你需要有crawler這個使用者，並且hadoop 已經開始運作";
 echo "2. /home/crawler/crawlzilla/url/urls.txt 裡面有你要抓的網址";
 echo "3. 執行 ./go.sh [深度] [資料夾名稱] 即可，如：";
 echo "	./go.sh 3 crawlname"
 echo "4. 等nutch所有程序完成，則你的資料在 $ARCHIEVE_DIR/crawlname/ "
 exit
fi


Depth=$1
JNAME=$2
META_PATH="/home/crawler/crawlzilla/.metadata"
ARCHIEVE_DIR="/home/crawler/crawlzilla/archieve"
HADOOP_BIN="/opt/crawlzilla/nutch/bin"

source "/opt/crawlzilla/nutch/conf/hadoop-env.sh";
source "/home/crawler/crawlzilla/system/log.sh" crawl_go;

function check_info ( )
{
  if [ $? -eq 0 ];then
    show_info "[ok] $1";
  else
    echo "error: $1 broken" > "$META_PATH/$JNAME/status"
    show_info "[error] $1 broken"
    kill -9 $count_pid
    exit 8
  fi
}

# [ begin ] 
cd /home/crawler/crawlzilla/

# $ARCHIEVE_DIR/tmp 用來放該程序的狀態
if [ ! -e $META_PATH ];then
   mkdir $META_PATH
   check_info "mkdir .metadata"
fi

# 存儲crawling狀態及花費時間的資料夾
if [ ! -e "$META_PATH/$JNAME" ];then
   mkdir "$META_PATH/$JNAME"
   check_info "mkdir crawlStatusDir"
fi

echo $$ > "$META_PATH/$JNAME/go.pid"
check_info "$$ > $META_PATH/$JNAME/go.pid"

# 紀錄爬取深度
echo $1 > "$META_PATH/$JNAME/depth"

# 開始紀錄程序狀態
echo "begin" > "$META_PATH/$JNAME/status"
echo "0" > "$META_PATH/$JNAME/passtime"

# 呼叫counter.sh紀錄時間
/home/crawler/crawlzilla/system/counter.sh $JNAME &
sleep 5
count_pid=$(cat "$META_PATH/$JNAME/count.pid")

# check the replicate directory on HDFS ; $? : 0 = shoud be delete
$HADOOP_BIN/hadoop fs -test -e /user/crawler/$JNAME
if [ $? -eq 0 ]; then
  $HADOOP_BIN/hadoop dfs -rmr /user/crawler/$JNAME
  show_info "/user/crawler/$JNAME is deleted."
fi

$HADOOP_BIN/hadoop dfs -mkdir $JNAME
check_info "hadoop dfs -mkdir $JNAME"

$HADOOP_BIN/hadoop dfs -put /home/crawler/crawlzilla/urls $JNAME/urls
check_info "hadoop dfs -put urls"

# nutch crawl begining
echo "crawling" > "$META_PATH/$JNAME/status"

$HADOOP_BIN/nutch crawl $JNAME/urls -dir $JNAME -depth $Depth -topN 5000 -threads 1000
check_info "nutch crawl"
$HADOOP_BIN/hadoop dfs -get $JNAME $ARCHIEVE_DIR/$JNAME
check_info "download search"

# 製作 $JNAME 於 tomcat
cp -rf /opt/crawlzilla/tomcat/webapps/default /opt/crawlzilla/tomcat/webapps/$JNAME
check_info "cp default to "
sed -i '8s/search/'${JNAME}'/g' /opt/crawlzilla/tomcat/webapps/$JNAME/WEB-INF/classes/nutch-site.xml
check_info "sed"

# 完成搜尋狀態
cp $META_PATH/$JNAME/depth $ARCHIEVE_DIR/$JNAME/
cp $META_PATH/$JNAME/passtime $ARCHIEVE_DIR/$JNAME/

#if [ -d /home/crawler/crawlzilla/archieve/$JNAME/ ];then
#  cp -rf $META_PATH/$JNAME /home/crawler/crawlzilla/archieve/$JNAME/metadata
#fi

echo "finish" > "$META_PATH/$JNAME/status"

kill -9 $count_pid

