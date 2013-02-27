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
#   remove shell script for slave uninstall
# Author:
#   Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
# Version:
#    1.0
# History:
#   2011 07 07 add JAVA_HOME and  JRE_HOME 

#Tomcat_HOME="/opt/crawlzilla/tomcat"
if [ -e "/usr/lib/jvm/java-6-sun" ];then
    export JAVA_HOME="/usr/lib/jvm/java-6-sun"
    export JRE_HOME=$JAVA_HOME"/jre"
else
    if [ -d /usr/lib/jvm/java-1.6.0-sun-1.6.0 ];then
        ln -sf /usr/lib/jvm/java-1.6.0-sun-1.6.0 /usr/lib/jvm/java-6-sun
	export JAVA_HOME="/usr/lib/jvm/java-6-sun"
        export JRE_HOME=$JAVA_HOME"/jre"
    elif [ -d /usr/java/jdk1.6.0_21 ];then
	ln -sf /usr/java/jdk1.6.0_21 /usr/lib/jvm/java-6-sun
	export JAVA_HOME="/usr/lib/jvm/java-6-sun"
        export JRE_HOME=$JAVA_HOME"/jre"
    else
	debug_info "There is no JAVA_HOME and JRE_HOME "
    fi
fi

command=$1
tom_pids=$(ps x | grep -v "grep" | grep "tomcat" | awk '{print $1}')

source "/opt/crawlzilla/main/log.sh" tomcat_restart_sh;
if [ "$command" == "start" ];then
	/opt/crawlzilla/tomcat/bin/startup.sh
	debug_info "/opt/crawlzilla/tomcat/bin/startup.sh"
elif [ "$command" == "stop" ];then
	/opt/crawlzilla/tomcat/bin/shutdown.sh
	debug_info "/opt/crawlzilla/tomcat/bin/shutdown.sh"
	kill $tom_pids
	debug_info "kill $tom_pids"
else
	/opt/crawlzilla/tomcat/bin/shutdown.sh
	debug_info "/opt/crawlzilla/tomcat/bin/shutdown.sh"
	kill $tom_pids
	debug_info "kill $tom_pids"
	/opt/crawlzilla/tomcat/bin/startup.sh	
	debug_info "/opt/crawlzilla/tomcat/bin/startup.sh"
fi

