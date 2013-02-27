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
#   2010/06/07  Rock    First release (1.0)


SHELLNAME=$1
DATE=`date +%y%m%d`
TIME=`date +%Y/%m/%d-%H:%M:%S`
if [ -f "/opt/crawlzilla/version" ]; then
    SYS_VER=`cat /opt/crawlzilla/version`
fi
export LOG_SH_TARGET=/var/log/crawlzilla/shell-logs/$SHELLNAME-$DATE.log

##########  echo function  ##########
function debug_info () {
    echo -e "< $(date +%H:%M:%S) > [DEBUG] - $1 " >> $LOG_SH_TARGET 2>&1
}


function show_info () {
    echo -e "\033[1;32;40m $1 \033[0m"
    echo "< $(date +%H:%M:%S)> - $1" >> $LOG_SH_TARGET 2>&1
}

#########end echo function ##########


if [ ! -e "/var/log/crawlzilla/shell-logs/" ]; then
    mkdir -p "/var/log/crawlzilla/shell-logs/";
fi
# file descriptor 4 prints to STDOUT and to TARGET
#exec 4> >(while read a; do echo $a; echo $a >> $LOG_SH_TARGET; done)
# now STDOUT is redirected
#exec 1>&4
#exec 2>&4

echo "" >> $LOG_SH_TARGET;
echo "*****************************************************" 	>> $LOG_SH_TARGET;
echo "* $TIME => $SHELLNAME begin   *" 				>> $LOG_SH_TARGET;
echo "* System Version: $SYS_VER    *"                          >> $LOG_SH_TARGET;
echo "*****************************************************" 	>> $LOG_SH_TARGET;
