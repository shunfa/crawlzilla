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

# Master IP here
Master_IP_Address=140.110.102.56

Work_Path=`dirname "$0"`
Work_Path=`cd "$Work_Path"; pwd`

if [ -e /usr/bin/ssh ]; then
  echo "checking ssh ... found"
else
  echo "Please Install \"ssh\" as /usr/bin/ssh"
  exit
fi

if [ -e /usr/sbin/sshd ]; then
  echo "checking sshd ... found"
else
  echo "Please Install \"sshd\" as /usr/sbin/sshd"
  exit
fi
if [ -e $Work_Path/crawlzilla_slave_install ];then
  rm -rf $Work_Path/crawlzilla_slave_install
fi
mkdir $Work_Path/crawlzilla_slave_install
scp -r -o StrictHostKeyChecking=no crawler@$Master_IP_Address:/opt/crawlzilla/slave/* $Work_Path/crawlzilla_slave_install/
exec $Work_Path/crawlzilla_slave_install/slave_install
