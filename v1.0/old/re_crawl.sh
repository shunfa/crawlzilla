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



# prompt
if [ "$1" == "" ];then
    echo "Usage : re_crawl <JOB_NAME>";
    echo " where JOB_NAME is one of: ";
    echo "==========="
	ls "/home/crawler/crawlzilla/user/admin/IDB/"
    echo "==========="
    exit 9;
fi

# begin

JNAME=$1
LOGFILE=/var/log/crawlzilla/shell-logs/crawl_re.log
DEPTH=$(cat /home/crawler/crawlzilla/user/admin/IDB/$JNAME/depth)
DATE=$(date +%y-%m-%d)

echo "ReCrawl $JNAME BEGIN at $DATE" >> $LOGFILE

echo "0 kill ps" >> $LOGFILE
kill -9 $JPID

Job_Flag=0

if [ -d /home/crawler/crawlzilla/user/admin/IDB/$JNAME ]; then
  echo "1. copy urls" >> $LOGFILE
    if [ -f /home/crawler/crawlzilla/user/admin/meta/urls/urls.txt ]; then
	rm /home/crawler/crawlzilla/user/admin/meta/urls/urls.txt
    fi
  cp /home/crawler/crawlzilla/user/admin/IDB/$JNAME/urls/urls.txt /home/crawler/crawlzilla/user/admin/meta/urls
  if [ ! $? -eq 0 ];then echo "Error! copy urls.txt broken" >> $LOGFILE ; fi

  echo "2. remove $JNAME metadata" >> $LOGFILE
  rm -rf /home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta
  if [ ! $? -eq 0 ];then echo "Error! " >> $LOGFILE ; fi

  echo "3. remove /opt/crawlzilla/tomcat/webapps/$JNAME" >> $LOGFILE
  rm -rf /opt/crawlzilla/tomcat/webapps/$JNAME
  if [ ! $? -eq 0 ];then echo "Error!" >> $LOGFILE ; fi

  echo "4. remove hdfs /user/crawler/$JNAME " >> $LOGFILE
  /opt/crawlzilla/nutch/bin/hadoop fs -rmr /user/crawler/$JNAME
  if [ ! $? -eq 0 ];then echo "Error! " >> $LOGFILE ; fi

  echo "5. rename the pase index-pool files." >> $LOGFILE
  mv /home/crawler/crawlzilla/user/admin/IDB/$JNAME /home/crawler/crawlzilla/user/admin/IDB/$JNAME"_recrawling("$DATE")"

  echo "6. go.sh $DEPTH $JNAME " >> $LOGFILE
  /opt/crawlzilla/main/go.sh $DEPTH $JNAME
  
  echo "7. ReCrawl finish at $DATE" >> $LOGFILE
  Job_Flag=1
else
  echo "ERROR! $JNAME not found!" >> $LOGFILE
fi

# 利用Job_Flag判斷是否執行成功，若成功則將舊索引資料移除，失敗則還原舊索引資料
if [ $Job_Flag == "1"  ]; then
  rm -rf /home/crawler/crawlzilla/user/admin/IDB/$JNAME"_recrawling("$DATE")"
else 
  mv /home/crawler/crawlzilla/user/admin/IDB/$JNAME"_recrawling("$DATE")" /home/crawler/crawlzilla/user/admin/IDB/$JNAME
fi
