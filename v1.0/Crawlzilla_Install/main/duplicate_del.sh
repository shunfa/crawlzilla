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

# Delete duplicating ip addresss in file
IPs=$(cat $1 | grep -v 'ip6' | grep -v '#' | grep -v '^$' | awk '{print $1}')

# 刪掉空白行
#sed -i '/^$/d' "$1"

cp -f "$1" "${1}.old"
#read -p "cp - f $1 ${1}.old ; $?"

for ip_add in $(echo $IPs)
do
    ip_nu=$(cat -n $1 | grep $ip_add | awk '{print $1}')
    ip_count=$(echo $ip_nu | wc -w)
  
    for (( i=1; i<$ip_count; i++ ))
    do
        del_line=$(echo $ip_nu | cut -d " " -f${i})
        sed -i "${del_line}d" $1
    done
done
  
# Dlete duplicating hostname in file
hostnames=$(cat $1 | grep -v ip6 | grep -v '#' | grep -v '^$' |awk '{print $2}')
for host in $(echo $hostnames)
do
    # line numbers
    host_nu=$(cat -n $1 | grep "$host\$" | awk '{print $1}')
    host_count=$(echo $host_nu | wc -w)
  
    for (( i=1; i<$host_count; i++ ))
    do
        del_line=$(echo $host_nu | cut -d " " -f${i})
        sed -i "${del_line}d" $1
    done                                                                                                                                                             
done

#cp -f "$1" "${1}.bak"
#read -p "cp -f $1 ${1}.bak ; $?"
