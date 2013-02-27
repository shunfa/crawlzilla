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
#   Add crawl_nodes to /etc/hosts (for crawlzilla management interface).
#   $1=/home/crawler/crawlizlla/system/crawl_nodes
##   $2=/etc/hosts # changed
#   $2=/home/crawler/crawlizlla/system/hosts
# Author: 
#   Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
# Version:
#    1.0
# History:
#   2010/03/08  waue    (1.0)
#   2010/06/07  Rock    (0.3)

#Crawlzilla_HOME="/home/crawler/crawlzilla"

IPs=$(cat $1 | awk '{print $1}')
HOSTNAMEs=$(cat $1 | awk '{print $2}')

# 刪除相同的 ip 在 /etc/hosts 和 crawl_nodes
for ip_addr in $(echo $IPs)
do
    jude=0
    cat $2 | grep $ip_addr || jude=1

    if [ $jude == 0 ]; then
        del_line=$(cat -n $2 | grep $ip_addr | awk '{print $1}')
        sed -i "${del_line}d" $2
    fi
done

# 刪除相同的 hostname 在 /etc/hosts 和 crawl_nodes
for host_name in $(echo $HOSTNAMEs)
do
    jude=0
    cat $2 | grep $host_name || jude=1

    if [ $jude == 0 ]; then
        del_line=$(cat -n $2 | grep $host_name | awk '{print $1}')
        sed -i "${del_line}d" $2
    fi
done

# Backup /etc/hosts
#cp -f "$2" "$2.bak"

# attache Crawl_nodes to hosts
sed -i '/# Crawlzilla add/d' $2
sed -i '/# Crawlzilla End/d' $2
#echo "# Crawlzilla add" >>$2
#cat $1 | grep -v '#' >>$2
echo "# Crawlzilla add" >/home/crawler/crawlzilla/meta/hosts.tmp
cat $1 | grep -v '#' >>/home/crawler/crawlzilla/meta/hosts.tmp
echo "# Crawlzilla End" >>/home/crawler/crawlzilla/meta/hosts.tmp
cat $2 >> /home/crawler/crawlzilla/meta/hosts.tmp
cp /home/crawler/crawlzilla/meta/hosts.tmp $2
rm /home/crawler/crawlzilla/meta/hosts.tmp

