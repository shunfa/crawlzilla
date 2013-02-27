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

command=$1
tom_pids=$(ps x | grep -v "grep" | grep "tomcat" | awk '{print $1}')
Tomcat_HOME="/opt/crawlzilla/tomcat"
source "/home/nutchuser/crawlzilla/system/log.sh" tomcat_restart_sh;
if [ $command == "start" ];then
	$Tomcat_HOME/bin/startup.sh
	debug_info "$Tomcat_HOME/bin/startup.sh"
elif [ $command == "stop" ];then
	$Tomcat_HOME/bin/shutdown.sh
	debug_info "$Tomcat_HOME/bin/shutdown.sh"
	kill $tom_pids
	debug_info "kill $tom_pids"
else
	$Tomcat_HOME/bin/shutdown.sh
	debug_info "$Tomcat_HOME/bin/shutdown.sh"
	kill $tom_pids
	debug_info "kill $tom_pids"
	$Tomcat_HOME/bin/startup.sh	
	debug_info "$Tomcat_HOME/bin/startup.sh"
fi

