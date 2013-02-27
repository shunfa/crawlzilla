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

####### parameter section###########
User_HOME=/home/crawler/crawlzilla
Crawlzilla_HOME=/opt/crawlzilla
Nutch_HOME=$Crawlzilla_HOME/nutch
Tomcat_HOME=$Crawlzilla_HOME/tomcat
Index_DB=$User_HOME/search
Admin_email=crawler@crawlzilla
# Work_Path=(define on install)
Install_Dir=`cd "$Work_Path/../"; pwd`
MasterIP_Address=`/sbin/ifconfig eth0 | grep 'inet addr' |  sed 's/^.*addr://g' | sed 's/Bcast.*$//g' | sed 's/ .*// '` 
net_MacAddr=`/sbin/ifconfig eth0 | grep 'HW' | sed 's/^.*HWaddr //g'`

######function section#######
function load_default_lang ( )
{
 # if you want force english to install, you can type
 # sudo LANGUAGE=en ./install
lang=$(locale | grep 'LANGUAGE=' | cut -d "=" -f2 | cut -d ":" -f1 )
if [ "$lang" == "zh_TW" ] || [ "$lang" == "zh_TW.utf8" ] || \
   [ "$lang" == "zh_TW:zh" ];then
    source $Work_Path/lang/lang_zh_TW
else
    source $Work_Path/lang/lang_en_US
fi
}


function check_hostname_localhost ( )
{
HName=$(hostname)
if [ "$HName" == "localhost" ] || [ "$HName" == "local" ] ;then
    show_info "Error! hostname CANNOT be \"localhost\" or \"local\"";
    show_info "You can type the following instruction to change hostname : " ;
    show_info "    hostname MyLinuxName ";
    show_info "And Re-Login , then install crawlzilla! Thank you";
    exit 8;
else
    debug_info "hostname = $HName is fine!";
fi
unset HName;
}

function check_root ( ){

#  bb=`sudo cat /etc/shadow |grep "root"`
#  bb=`echo $bb |awk 'BEGIN {FS=":"} {print $2}'`
#  if [ "$bb" == "*" ];then
#    show_info "!!! root's password have not been set !!!"
#    show_info "press \"Enter\" key to continue"
#    read ;
#  fi


  debug_info "check_root"
  if [ $USER != "root" ]; then
    show_info "$MI_check_root_1"
    exit
  fi
  show_info "$MI_check_root_2"
}

function check_systemInfo ( )
{
  debug_info "$MI_check_sys_1"
  show_info "$MI_check_sys_2"
  Linux_Distribution=$(lsb_release -a 2> /dev/null | grep "Distributor ID:" | awk '{print $3}')
  Linux_Version=$(lsb_release -a 2> /dev/null | grep "Release" | awk '{print $2}')
  if [ "$Linux_Distribution" == "" ]; then
    Linux_Distribution=$(cat /etc/*-release | uniq | awk '{print $1}')
    Linux_Version=`cat /etc/*-release | uniq | awk '{print $3}'`
  fi
  Linux_bit=$(uname -m)
  show_info "$Linux_Distribution , $Linux_Version"
}

function install_packages ( ) 
{


debug_info "$MI_install_pack_2"

## prepare
install_array="";
install_java_p="0";

java_info=$(java -version 2>&1 |grep "Java(TM)")
if [ "$java_info" == "" ];then 
   install_array="sun-java6-jdk"; 
   install_java_p="1"; # 1 is into install progress, 0 is not
fi
if [ ! -e /usr/bin/ssh ] ; then install_array=$install_array" ssh"; fi
if [ ! -e /usr/sbin/sshd ]; then install_array=$install_array" openssh-server"; fi
if [ ! -e /usr/bin/dialog ]; then install_array=$install_array" dialog";fi
if [ ! -e /usr/bin/expect ]; then install_array=$install_array" expect";fi

## install
if [ -z "$install_array" ] ;then
    ## nothing to install
    show_info "$MI_install_pack_1"
    debug_info "install nothing because install_array=[$install_array]" ;
else
    ## $install_array is needed to install 
    show_info "$MI_install_pack_2 $install_array"

  # deb 系列系統
  if [ "$Linux_Distribution" == "Ubuntu" ]; then
        if [ "$Linux_Version" == "10.04" ]; then
            show_info "\n Ubuntu 10.04 $install_pack_if_1 $install_array" 
            if [ "$install_java_p" == "1" ]; then 
		add-apt-repository "deb http://archive.canonical.com/ lucid partner";
		debug_info "add-apt-repository deb http://archive.canonical.com/ lucid partner";
                apt-get update
	    fi
            apt-get install -y $install_array
            update-java-alternatives -s java-6-sun
        elif [ "$Linux_Version" == "10.10" ]; then
            show_info "\n Ubuntu 10.10 $install_pack_if_1 $install_array"
            if [ "$install_java_p" == "1" ]; then 
		add-apt-repository "deb http://archive.canonical.com/ubuntu maverick partner"
		debug_info "add-apt-repository deb http://archive.canonical.com/ubuntu maverick partner";
		apt-get update
	    fi
            debug_info "install -y $install_array"
            apt-get install -y $install_array
            update-java-alternatives -s java-6-sun
        else
            show_info "\n Ubuntu $install_pack_if_1 $install_array"
            # apt-get update # maybe not needed
            debug_info "apt-get install -y $install_array"
            apt-get install -y $install_array
        fi

  # deb system (Debian)
  elif [ "$Linux_Distribution" == "Debian" ]; then
        show_info "\n debian $install_pack_if_1 $install_array"
        apt-get update
        aptitude install $install_array
        debug_info "aptitude install $install_array"

  # rpm system
  elif [ "$Linux_Distribution" == "Fedora" ] ;then
        show_info "\n Fedora $install_pack_if_1 $install_array"
        if [ "$Linux_bit" != "x86_64" ]; then
            Linux_bit="i386"
        fi
        # yum update
        #/etc/init.d/sshd restart
        debug_info "yum install -y expect dialog wget"
        yum install -y expect dialog wget

      # install sun java
      if [ "$Linux_bit" == "x86_64" ]; then
	debug_info "yum_install_sun_java_x86_64"
          yum_install_sun_java_x86_64
      else
	debug_info "yum_install_sun_java_i586"
          yum_install_sun_java_i586
      fi
  
  elif [ "$Linux_Distribution" == "CentOS" ] ;then
    show_info "\n CentOS $install_pack_if_1 $install_array"
    if [ $Linux_bit != "x86_64" ]; then  
        Linux_bit="i386"                 
    fi 

    yum update
    yum -y install expect openssh dialog
    debug_info "yum -y install expect openssh dialog"

    # install sun java
    if [ "$Linux_bit" == "x86_64" ]; then    
        debug_info "yum_install_sun_java_x86_64"
        yum_install_sun_java_x86_64
    else
        debug_info "yum_install_sun_java_i586"
        yum_install_sun_java_i586
    fi

  elif [ "$Linux_Distribution" == "SUSE" ] ;then
    show_info "\n CentOS $install_pack_if_1 $install_array"
    debug_info "zypper install -n expect openssh dialog java-1_6_0-sun"
    zypper install -n expect openssh dialog java-1_6_0-sun
    #opensuse default sun java is /usr/lib/jvm/java-1.6.0-sun-1.6.0/bin/java
    debug_info "/usr/sbin/update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-1.6.0-sun-1.6.0/bin/java 1"
    /usr/sbin/update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-1.6.0-sun-1.6.0/bin/java 1

    debug_info "/usr/sbin/update-alternatives --set java /usr/lib/jvm/java-1.6.0-sun-1.6.0/bin/java"
    /usr/sbin/update-alternatives --set java /usr/lib/jvm/java-1.6.0-sun-1.6.0/bin/java

  else
    show_info "$MI_install_pack_if_2 $install_array" 
  fi

 fi
}

function mkdir_Home_Var ( )
{
    chmod 711 /home/crawler # Fedora will set home as 700, other user can't execute crawlzilla or crawlzilla_remove
    su crawler -c "mkdir /home/crawler/crawlzilla"
    su crawler -c "mkdir /home/crawler/crawlzilla/urls"
    su crawler -c "touch /home/crawler/crawlzilla/urls/urls.txt"
    su crawler -c "mkdir /home/crawler/crawlzilla/archieve"
    su crawler -c "mkdir /home/crawler/crawlzilla/source"
    su crawler -c "mkdir /home/crawler/crawlzilla/system"
    su crawler -c "mkdir /home/crawler/crawlzilla/.metadata"
    su crawler -c "mkdir /home/crawler/crawlzilla/.tmp"
   if [ ! -d "/var/log/crawlzilla" ]; then
     mkdir /var/log/crawlzilla
   fi
   if [ ! -d "/var/lib/crawlzilla" ]; then
     mkdir /var/lib/crawlzilla
   fi
    mkdir /var/log/crawlzilla/tomcat-logs
    mkdir /var/log/crawlzilla/hadoop-logs

}

function link_Chown ( )
{
ln -sf /var/log/crawlzilla/tomcat-logs /opt/crawlzilla/tomcat/logs
ln -sf /var/log/crawlzilla/hadoop-logs /opt/crawlzilla/nutch/logs
ln -sf /home/crawler/crawlzilla/system/crawlzilla /usr/bin/crawlzilla
ln -sf /home/crawler/crawlzilla/system/master_remove /usr/bin/crawlzilla_remove
ln -sf /var/log/crawlzilla /home/crawler/crawlzilla/logs
ln -sf /opt/crawlzilla/nutch /home/crawler/crawlzilla/nutch
ln -sf /var/lib/crawlzilla /opt/crawlzilla/nutch/hadoop_runspace
chown -R crawler:crawler /opt/crawlzilla
chown -R crawler:crawler /var/log/crawlzilla
chown -R crawler:crawler /var/lib/crawlzilla
}

function unzip_nV2_pack ( ) 
{
  local pac_name=crawlzilla-0.2pack-current.tar.gz
  if [ ! -d "$Install_Dir/package" ];then
    mkdir $Install_Dir/package
  fi
  if [ ! -e "$Install_Dir/package/$pac_name" ];then
    # wget "http://crawlzilla.googlecode.com/files/$pac_name"; # google code 
    wget "http://sourceforge.net/projects/crawlzilla/files/stable/package/$pac_name/download" -O $pac_name; # source-forge
#    wget "http://sourceforge.net/downloads/crawlzilla/stable/package/$pac_name"; # source-forge
  if [ $? -eq 0 ];then
	mv $pac_name $Install_Dir/package;
        chmod -R 777 $Install_Dir/package;
	debug_info "move $pac_name ==> $Install_Dir/package/";
    else
	show_info "$pac_name not found, installation was not finished!";
	exit 8;
    fi
  fi
  debug_info "unpack tomcat and nutch to /opt/crawlzilla"
  debug_info "tar -zxvf $Install_Dir/package/$pac_name -C /opt/ >> $LOG_SH_TARGET"
  tar -zxvf $Install_Dir/package/$pac_name -C /opt/ >> /dev/null
  if [ $? -eq 0 ];then
     show_info "unpack success!"
  else
     show_info "unpack error!";
     exit 8;
  fi
  # work_path = this bin dir , conf_path = bin/../conf
  local Conf_Path=$Work_Path/../conf
  # change nutch-conf to /opt/crawlzilla/nutch/conf
  if [ -d "$Conf_Path" ];then
     if [ -d "$Conf_Path/nutch_conf" ];then
	debug_info " $Conf_Path/nutch_conf .. found !"
	  if [ -d /opt/crawlzilla/nutch/conf ];then
	    debug_info "del /opt/crawlzilla/nutch/conf "
	    rm -rf /opt/crawlzilla/nutch/conf
	  fi
	  cp -rf $Conf_Path/nutch_conf /opt/crawlzilla/nutch/conf
	  if [ $? -eq 0 ];then
	    debug_info " Update the nutch:conf ok!"
	  else
	    debug_info "[error!] nutch:conf error ! please check"
	  fi
    fi

	  # change tomcat-conf to /opt/crawlzilla/nutch/conf

     if [ -d "$Conf_Path/tomcat_conf" ];then
        debug_info " $Conf_Path/tomcat_conf .. found !"
	  if [ -d /opt/crawlzilla/tomcat/conf ];then
	    debug_info "del /opt/crawlzilla/tomcat/conf "
	    rm -rf /opt/crawlzilla/tomcat/conf
	  fi
	  cp -rf $Conf_Path/tomcat_conf /opt/crawlzilla/tomcat/conf
	  if [ $? -eq 0 ];then
	    debug_info "Update the tomcat:conf ok!"
	  else
	    debug_info "[error!] tomcat:conf error ! please check"
	  fi
    fi
  fi
  
   # change sun-jre home path to each linux os
  
  if [ "$Linux_Distribution" == "SUSE" ] ;then
    if [ -d /usr/lib/jvm/java-1.6.0-sun-1.6.0 ] ;then
	debug_info "Change JAVA_HOME=/usr/lib/jvm/java-1.6.0-sun-1.6.0"
	sed -i 's/java-6-sun/java-1.6.0-sun-1.6.0/' /opt/crawlzilla/nutch/conf/hadoop-env.sh
    fi
  elif [ "$Linux_Distribution" == "CentOS" ] ;then
    if [  -d /usr/java/jdk1.6.0_21/ ] ;then
    debug_info "Change JAVA_HOME=/usr/java/jdk1.6.0_21/"
    sed -i 's/\/usr\/lib\/jvm\/java-6-sun/\/usr\/java\/jdk1.6.0_21\//' /opt/crawlzilla/nutch/conf/hadoop-env.sh
    ln -sf /usr/java/jdk1.6.0_21/bin/jps /usr/bin/jps
    fi
  elif [ "$Linux_Distribution" == "Fedora" ] ;then
    if [  -d /usr/java/jdk1.6.0_21/ ] ;then
    debug_info "Change JAVA_HOME=/usr/java/jdk1.6.0_21/"
    sed -i 's/\/usr\/lib\/jvm\/java-6-sun/\/usr\/java\/jdk1.6.0_21\//' /opt/crawlzilla/nutch/conf/hadoop-env.sh
    ln -sf /usr/java/jdk1.6.0_21/bin/jps /usr/bin/jps
    fi
  fi
    
    

}

function yum_install_sun_java_i586 ( )
{
wget -nc 'https://sourceforge.net/projects/crawlzilla/files/other/jdk-6u21-linux-i586-rpm.bin/download' -O $Install_Dir/jdk-6u21-linux-i586-rpm.bin
echo y | bash $Install_Dir/jdk-6u21-linux-i586-rpm.bin
rpm -Uvh $Install_Dir/jdk-6u21-linux-i586.rpm
/usr/sbin/alternatives --install /usr/bin/java java /usr/java/jdk1.6.0_21/bin/java 1
/usr/sbin/alternatives --set java /usr/java/jdk1.6.0_21/bin/java
}

function yum_install_sun_java_x86_64 ( )
{
wget -nc 'https://sourceforge.net/projects/crawlzilla/files/other/jdk-6u21-linux-x64-rpm.bin/download' -O $Install_Dir/jdk-6u21-linux-x64-rpm.bin
echo y | bash $Install_Dir/jdk-6u21-linux-x64-rpm.bin               
rpm -Uvh $Install_Dir/jdk-6u21-linux-amd64.rpm
/usr/sbin/alternatives --install /usr/bin/java java /usr/java/jdk1.6.0_21/bin/java 1
/usr/sbin/alternatives --set java /usr/java/jdk1.6.0_21/bin/java                                                                                                               
}

function check_crawlzilla_installed ( )
{
  debug_info "$MI_check_crawlzilla_1"
  if [ -d "/opt/crawlzilla" ] || [ -e "/home/crawler" ] ; then
    show_info "$MI_check_crawlzilla_2"
    exit
  else
    show_info "$MI_check_crawlzilla_3"
  fi
}

function check_sunJava ( )
{
  debug_info "$MI_check_sunJava_1"


  javaPath="/usr"
  yesno="no"
  choice="3"

  if [ -e $javaPath/bin/java ]; then
    JAVA_org=$($javaPath/bin/java -version 2>&1 | grep "Java(TM)")
    JAVA_version=$($javaPath/bin/java -version 2>&1 | grep "java version" | \
    awk '{print $3}' | cut -d "." -f1-2 | cut -d "\"" -f2)

  if [ "$JAVA_org" == "" ]; then
    show_info "$MI_check_sunJava_2"
    show_info "$MI_check_sunJava_if_1"
    show_info "$MI_check_sunJava_if_2"
    show_info "$MI_check_sunJava_if_3"
    show_info "$MI_check_sunJava_if_4" 
    read choice
    case $choice  in
      "1")
        show_info "$MI_check_sunJava_if_5"
        exit
        ;;
      "2")
        show_info "$MI_check_sunJava_if_6"
	read javaPath
        ;;
        "*")
        exit
        ;;
        esac

        if [ $choice == "2" ]; then
          JAVA_org=$($javaPath/bin/java -version 2>&1 | grep "Java(TM)")
          JAVA_version=$($javaPath/bin/java -version 2>&1 | grep "java version" | \
          awk '{print $3}' | cut -d "." -f1-2 | cut -d "\"" -f2)

          if [ "$JAVA_org" == "" ]; then
            show_info "$MI_check_sunJava_if_7"
            exit
            fi
          fi
        fi

      large16=$(echo "$JAVA_version >= 1.6" | bc)
      if [ "${large16}" == 0 ]; then
        show_info "$MI_check_sunJava_if_8"
        exit
      fi

      show_info "$MI_check_sunJava_if_9"
  else
    show_info "$MI_check_sunJava_if_10"
    exit
  fi

  unset JAVA_org
  unset JAVA_version
}

# check openssh, openssh-server
function check_ssh ( )
{
  debug_info "$MI_check_ssh_1"
  if [ -e /usr/bin/ssh ]; then
    show_info "$MI_check_ssh_2"
  else
    show_info "$MI_check_ssh_3"
    exit
  fi

  if [ -e /usr/sbin/sshd ]; then
    show_info "$MI_check_ssh_4"
  else
    show_info "$MI_check_ssh_5"
    exit
  fi
  # check service is running or not
  if [ -e /etc/init.d/sshd ]; then
    STATUS=$(/etc/init.d/sshd status | grep running )
    if [ "$STATUS" == "" ]; then
	/etc/init.d/sshd start
	show_info "Start your sshd"
    fi
  elif [ -e /etc/init.d/ssh ]; then
    STATUS=$(/etc/init.d/ssh status | grep running )
    if [ "$STATUS" == "" ]; then
	/etc/init.d/ssh start
	show_info "Start your sshd"
    fi
  else 
    show_info "Please check your ssh is running manually!"
  fi
  unset STATUS;
}


# check dialog
function check_dialog ( )
{
  debug_info "$MI_check_dialog_1"
  if [ -e /usr/bin/dialog ]; then
    show_info "$MI_check_dialog_2"
  else
    show_info "$MI_check_dialog_3"
    exit
  fi
}

function set_install_information ( ) 
{ 
  set_crawler_passwd
  select_eth
  MasterIP_Address=$net_address
}

function set_crawler_passwd ( )
{
  show_info "$MI_set_crawler_passwd_echo_1"
  read -sp "password:" Crawler_Passwd
# read -sp "Please enter crawler's password :  " Crawler_Passwd
  echo -e "\n"
  show_info "$MI_set_crawler_passwd_echo_2"
  read -sp "password:" Crawler_Passwd2
# read -sp "Please enter crawler's password again:  " Crawler_Passwd2
  echo -e "\n"
  if [ $Crawler_Passwd != $Crawler_Passwd2 ]; then
    set_crawler_passwd
  fi
}

# add crawler account Crawler_Passwd
function creat_crawler_account ( )
{
  debug_info "$create_crawler_d1"

  while [ "$Crawler_Passwd" != "$Crawler_Passwd2" ]
  do
      echo -e "\n"
      show_info "$create_crawler_1" 
      read -s Crawler_Passwd
      echo 
      show_info "$create_crawler_2"
      read -s Crawler_Passwd2
      echo 
        if [ "$Crawler_Passwd" == "$Crawler_Passwd2" ]; then
          show_info "$create_crawler_3"
        else
          show_info "$create_crawler_4"
        fi
  done                                                                                  
  unset Crawler_Passwd2

  if [ $(cat /etc/passwd | grep crawler) ]; then
    show_info "$create_crawler_s1"
    expect -c "spawn passwd crawler
    set timeout 1
    expect \"*: \"
    send \"$Crawler_Passwd\r\"
    expect \"*: \"
    send \"$Crawler_Passwd\r\"
    expect eof"
    else
      show_info "$create_crawler_s2"
      /usr/sbin/useradd -m crawler -s /bin/bash
      expect -c "spawn passwd crawler
      set timeout 1
      expect \"*: \"
      send \"$Crawler_Passwd\r\"
      expect \"*: \"
      send \"$Crawler_Passwd\r\"
      expect eof"
  fi
  # fix opensuse 
  if [ "$Linux_Distribution" == "SUSE" ] ;then 
    groupadd crawler;
    chown -R crawler:crawler /home/crawler
  fi
#  if [ -e /bin/bash ];then
#    exec ssh-agent /bin/bash
#  else 
#    exec ssh-agent /usr/bin/bash
#  fi
#  su crawler -c 'ssh-add /home/crawler/.ssh/id_rsa'
}

function select_eth ( ) 
{
  net_interfaces=$(/sbin/ifconfig | grep ^eth | cut -d " " -f1)
  net_nu=$(echo $net_interfaces | wc -w)

  # when only one eth interface
  if [ "$net_nu" == "1" ]; then
    net_address=$(/sbin/ifconfig $net_interfaces | grep "inet addr:" | sed 's/^.*inet addr://g' | cut -d " " -f1)
    net_MacAddr=$(/sbin/ifconfig $net_interfaces | grep 'HW' | sed 's/^.*HWaddr //g')

  # encounter to multiple eth interface
  else
    declare -i i=1
    show_info "$MI_select_eth_echo_1"
#   show_info  "\nSystem have multiple network device, which network use for this machine: "

    for net in $net_interfaces
      do
        show_info "($i)  $net  $(/sbin/ifconfig $net | grep "inet addr:" | sed 's/^.*inet addr://g' | cut -d " " -f1)"
        i=i+1
      done
      show_info "$MI_select_eth_echo_2"
      read net_choice
#     read -p "Please choice(1/2/3...): " net_choice
    if [ -z $net_choice ]; then
      net_choice=1
    fi
    shoe_info "$MI_select_eth_echo_6"
    show_info "$MI_select_eth_echo_3 $net_choice"
#   show_info "Your choice is $net_choice"
    net_interface=$(echo $net_interfaces | cut -d " " -f $net_choice)
    #ifconfig $net_interface | grep "inet addr:" | sed 's/^.*inet addr://g' | cut -d " " -f1
    net_address=$(/sbin/ifconfig $net_interface | grep "inet addr:" | sed 's/^.*inet addr://g' | cut -d " " -f1)
    net_MacAddr=$(/sbin/ifconfig $net_interface | grep 'HW' | sed 's/^.*HWaddr //g')

#    show_info "$MI_select_eth_echo_4 $net_address"
#   show_info "net_address is $net_address"
#    show_info "$MI_select_eth_echo_5 $net_MacAddr"
#   show_info "net_MacAddr is $net_MacAddr"
  fi
}


function show_master_info ( )
{
  show_info "$MI_show_master_info_echo_1 $MasterIP_Address"
  show_info "$MI_show_master_info_echo_2 $net_MacAddr"

#  show_info "The Master IP Address is $MasterIP_Address"
#  show_info "The Master MacAddr is $net_MacAddr"
}

function make_ssh_key () {
  debug_info "$MI_make_ssh_key_echo_1"
# debug_info "Make ssh key(begin...)"
  su crawler -c 'ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ""'
  su crawler -c "cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys"
  su crawler -c "ssh-add /home/crawler/.ssh/id_rsa"
  debug_info "$MI_make_ssh_key_echo_2"
# debug_info "Make ssh key(done!)"
}


function set_haoop-site ( )
{
  debug_info "$MI_set_haoop_site_echo_1"
# debug_info "set hadoop-site.xml(begin...)"
  cd $Nutch_HOME/conf/
  cat > hadoop-site.xml << EOF
<configuration>
  <property>
    <name>fs.default.name</name>
    <value>hdfs://$MasterIP_Address:9000</value>
  </property>
  <property>
    <name>mapred.job.tracker</name>
    <value>$MasterIP_Address:9001</value>
  </property>
  <property>
    <name>hadoop.tmp.dir</name>
    <value>/var/lib/crawlzilla/nutch-crawler</value>
  </property>
</configuration>
EOF
  debug_info "$MI_set_haoop_site_echo_2"
# debug_info "set hadoop-site.xml(done!)"
}

function set_auto_slave ( )
{
  Line_NO=`cat $Work_Path/slave_install | grep -n 'Crawler_Passwd="xxxxxxxxxx"' | sed 's/:.*//g'`
  sed -i ''$((Line_NO+1))'d' $Work_Path/slave_install
  sed -i ''$Line_NO'a Crawler_Passwd='$Crawler_Passwd'' $Work_Path/slave_install

  Line_NO=`cat $Work_Path/slave_install | grep -n 'autoSlaveInstallFlag' | sed 's/:.*//g'`
  sed -i ''$((Line_NO+1))'d' $Work_Path/slave_install
  sed -i ''$Line_NO'a autoSlaveInstallFlag="yes";' $Work_Path/slave_install  
}

# 修改nutch-site.xml中-http.agent.url, http.agent.email
function set_nutch-site ( )
{
  debug_info "$MI_set_nutch_site_echo_1"
# debug_info "set nutch-site.xml(begin...)"
  Line_NO=`cat $Nutch_HOME'/conf/nutch-site.xml' | grep -n 'http.agent.url' | sed 's/:.*//g'`
  debug_info "$MI_set_nutch_site_echo_2"
# debug_info "debug...http.agent.url line number = $Line_NO..."
  sed -i ''$((Line_NO+1))'d' $Nutch_HOME/conf/nutch-site.xml
  debug_info "$MI_set_nutch_site_echo_3"
# debug_info "debug...edit http.agent.url delete line $((Line_NO+1))..."
  sed -i ''$Line_NO'a <value>'$MasterIP_Address'</value>' $Nutch_HOME/conf/nutch-site.xml
  debug_info "$MI_set_nutch_site_echo_4"
# debug_info "debug...edit http.agent.url done..."

  Line_NO=`cat $Nutch_HOME'/conf/nutch-site.xml' | grep -n 'http.agent.email' | sed 's/:.*//g'`
  debug_info "$MI_set_nutch_site_echo_5"
# debug_info "debug...http.agent.email line number = $Line_NO..."

  sed -i ''$((Line_NO+1))'d' $Nutch_HOME/conf/nutch-site.xml
  debug_info "$MI_set_nutch_site_echo_6"
# debug_info "debug...edit http.agent.email delete line $((Line_NO+1))..."
  sed -i ''$Line_NO'a <value>'$Admin_email'</value>' $Nutch_HOME/conf/nutch-site.xml
  debug_info "$MI_set_nutch_site_echo_7"
# debug_info "debug...edit http.agent.email done..."
  debug_info "$MI_set_nutch_site_echo_8"
# debug_info "set nutch-site.xml(done!)"
}

function format_HDFS ( )
{
  show_info "$MI_format_HDFS_echo_1"
  su crawler -c "$Nutch_HOME/bin/hadoop namenode -format"
  debug_info "$MI_format_HDFS_echo_2"
}

function start_up_Crawlzilla ( )
{
  show_info "$MI_start_up_Crawlzilla_echo_1"
  # start namenode
  su crawler -c "$Nutch_HOME/bin/hadoop-daemon.sh --config $Nutch_HOME/conf start namenode"
  if [ $? -eq 0 ];then
    debug_info "namenode ok"
    # if ok , start jobtracker
    show_info "$MI_start_up_Crawlzilla_echo_2"
    su crawler -c "$Nutch_HOME/bin/hadoop-daemon.sh --config $Nutch_HOME/conf start jobtracker"
    if [ $? -eq 0 ];then
      debug_info "jobtracker ok"
      su crawler -c "$Nutch_HOME/bin/hadoop-daemon.sh --config $Nutch_HOME/conf start datanode"
      su crawler -c "$Nutch_HOME/bin/hadoop-daemon.sh --config $Nutch_HOME/conf start tasktracker"
      debug_info "start datanode and tasktracker"
    fi
  else 
    show_info "!!! Hadoop startup error !!!"
    show_info "you can see /var/log/crawlzilla/shell-logs/ for more infomation!"
  fi
}


# check /etc/hosts , cp to home dir ,  chown , then set ip-hostname mapping
function check_set_hosts ( )
{
  if [ -f /etc/hosts ];then
    debug_info "$MI_set_hosts_echo_1"
    cp /etc/hosts /home/crawler/crawlzilla/system/hosts.bak
    cp -f /etc/hosts /home/crawler/crawlzilla/system/
    # chown the /home/crawler/crawlzilla/system/hosts to crawler
    chown crawler:crawler /home/crawler/crawlzilla/system/hosts

    # add ip <-> hostname to hosts file
    # Line_NO is hostname line number at hosts
    Line_NO=`cat /home/crawler/crawlzilla/system/hosts | grep -n $(hostname) | sed 's/:.*//g'`
    if [ "$Line_NO" == "" ];then
      # hosts without hostname 
      debug_info "hostname do not exist in /etc/hosts ";
    else
      # comment the original-hostname-line 
      content=$(cat /home/crawler/crawlzilla/system/hosts | awk 'NR=='$Line_NO'{printf "# " ; print}' )
      sed -i ""$Line_NO"c $content" /home/crawler/crawlzilla/system/hosts
    fi
    # set ip-hostname to /home/crawler/crawlzilla/system/hosts
    sed -i '1i '$MasterIP_Address' '$(hostname)'' /home/crawler/crawlzilla/system/hosts
    if [ $? -eq 0 ]; then
	ln -sf /home/crawler/crawlzilla/system/hosts /etc/hosts
	show_info " Check and Set /etc/hosts finished."
    else
	show_info " There is some error in your /etc/hosts file. Please check!"
    fi
  else
    show_info "No /etc/hosts exists.. please check!!"
    show_info "Crawlzilla would not work if \"/etc/hosts\" does not exist. "
    show_info "Installation failed"
    exit 8
  fi
}

function install_Nutch ( )
{
# copy crawlzilla.war to /opt/crawlzilla/tomcat/webapps
  cp $Install_Dir/web/crawlzilla.war /opt/crawlzilla/tomcat/webapps/crawlzilla.war
  debug_info "$MI_install_Nutch_echo_1 $MasterIP_Address "
# debug_info "MasterIP_Address=$MasterIP_Address"
  debug_info "$MI_install_Nutch_echo_2 $(hostname)"
# debug_info "Master_Hostname=$(hostname)"
  su crawler -c "ssh -o StrictHostKeyChecking=no localhost echo $net_address $(hostname) $net_MacAddr \>\> ~/crawlzilla/system/crawl_nodes"
  #set_hosts > up to install->main function
  set_haoop-site
  set_nutch-site
}


function slave_PassMasterIPAddr ( ) 
{
  cd $Work_Path
  Line_NO=`cat slave_install | grep -n '# Master IP here' | sed 's/:.*//g'`
  debug_info "$MI_slave_PassMasterIPAddr_echo_1"
# debug_info "debug...Master IP here line number = $Line_NO..."
  sed -i ''$((Line_NO+1))'d' slave_install
  debug_info "$MI_slave_PassMasterIPAddr_echo_2"
# debug_info "debug...edit Master IP at line $((Line_NO+1))..."
  sed -i ''$Line_NO'a Master_IP_Address='$MasterIP_Address'' slave_install
  debug_info "$MI_slave_PassMasterIPAddr_echo_3"
# debug_info "edit slave_install done..."
}


function slave_PassMaster_Hostname ( )
{
  cd $Work_Path
  Line_NO=`cat slave_install | grep -n '# Master Hostname here' | sed 's/:.*//g'`
  debug_info "$MI_slave_PassMaster_Hostname_echo_1"
# debug_info "debug...Master hostname here line number = $Line_NO..."
  sed -i ''$((Line_NO+1))'d' slave_install
  debug_info "$MI_slave_PassMaster_Hostname_echo_2"
# debug_info "debug...edit Master Hostname at line $((Line_NO+1))..."
  sed -i ''$Line_NO'a Master_Hostname='$(hostname)'' slave_install
  debug_info "$MI_slave_PassMaster_Hostname_echo_3"
# debug_info "edit slave_install done..."
}

function slave_PassMasterIPAddr_for_Remove ( ) 
{
  cd $Work_Path
  Line_NO=`cat slave_remove | grep -n "# Master IP here" | sed 's/:.*//g'`
  sed -i ''$((Line_NO+1))'d' slave_remove
  sed -i ''$Line_NO'a Master_IP_Address='$MasterIP_Address'' slave_remove
}


function slave_PassMasterIPAddr_for_deploy ( ) 
{
  cd $Work_Path
  Line_NO=`cat slave_deploy.sh | grep -n "# Master IP here" | sed 's/:.*//g'`
  sed -i ''$((Line_NO+1))'d' slave_deploy.sh
  sed -i ''$Line_NO'a Master_IP_Address='$MasterIP_Address'' slave_deploy.sh
}

function make_slave_install ( ) 
{
  # 建立資料夾(用來存放slave的安奘檔)

   if [ ! -d "$User_HOME/source" ]; then
     su crawler -c "mkdir $User_HOME/source"
   fi


  # package the Master_IP_Address for slave
 
  show_info "$MI_make_slave_install_echo_1"
# debug_info "function make_slave_install..."

  slave_PassMasterIPAddr
  slave_PassMaster_Hostname
  slave_PassMasterIPAddr_for_Remove
  slave_PassMasterIPAddr_for_deploy
  cd /opt/crawlzilla/
  su crawler -c "tar -cvzf CrawlzillaSlaveOf_$MasterIP_Address.tar.gz  nutch" >> /dev/null
  
  # copy files to $User_HOME/source and system directory 
  mv CrawlzillaSlaveOf_$MasterIP_Address.tar.gz /home/crawler/crawlzilla/source
  cp $Work_Path/slave_install $Work_Path/version $Work_Path/slave_install_func.sh $Work_Path/slave_remove $Work_Path/slave_deploy.sh $Work_Path/log.sh /home/crawler/crawlzilla/source
  cp -r $Work_Path/lang  /home/crawler/crawlzilla/source
  cp -r $Work_Path/lang /home/crawler/crawlzilla/system
  cp $Work_Path/crawlzilla $Work_Path/add_hosts $Work_Path/duplicate_del $Work_Path/tomcat_restart.sh  $Work_Path/master_remove $Work_Path/go.sh $Work_Path/log.sh $Work_Path/rm_DB.sh $Work_Path/counter.sh $Work_Path/re_crawl.sh $Work_Path/version $Work_Path/fix.sh /home/crawler/crawlzilla/system 
  
  # copy crawlzilla/source to user

   if [ ! -d "$Install_Dir/Client_Install_DIR" ]; then
     mkdir $Install_Dir/Client_Install_DIR
   fi
   cp -rf /home/crawler/crawlzilla/source/* $Install_Dir/Client_Install_DIR/
   chmod -R 777 $Install_Dir/Client_Install_DIR
   
}

function start_up_tomcat ( ) 
{
  show_info "$MI_start_up_tomcat_echo_1"
# debug_info "start up tomcat..."
  su crawler -c "$Tomcat_HOME/bin/startup.sh"
  i=5
  debug_info "$MI_start_up_tomcat_echo_2"
  until [ $i -lt 1 ]
    do
      sleep 1s
      echo -ne ".";
      i=`expr $i - 1`
    done
  echo ""
  #su crawler -c "$Tomcat_HOME/bin/startup.sh"
  show_info "$MI_start_up_tomcat_echo_3"
# debug_info "tomcat has been started..."
}

# slave easy step
function slave_install_commands ( ) 
{
  show_info "$MI_slave_install_commands_echo_1"
  show_info "$MI_slave_install_commands_echo_20$MasterIP_Address$MI_slave_install_commands_echo_25"
  show_info "$MI_slave_install_commands_echo_2"
  show_info "$MI_slave_install_commands_echo_3"
}

function generateReadme ( )
{
  cat > $Install_Dir/Client_Install_DIR/README.txt << EOF
$MI_slave_install_commands_echo_1
1. $MI_slave_install_commands_echo_20$MasterIP_Address$MI_slave_install_commands_echo_25
2. $MI_slave_install_commands_echo_3
EOF

  cp $Install_Dir/Client_Install_DIR/README.txt /home/crawler/crawlzilla/source/

}

function change_ownship( )
{
chown -R $1.$1 $2
} 


add_crawlzilla_to_initd() {
show_info "$add_crawlzilla_to_initd_1"
show_info "$add_crawlzilla_to_initd_2"
# for master
linux_dist=$(lsb_release -i | awk '{print $3}')
local Conf_Path=$Work_Path/../conf
# for debian system
if [ "$linux_dist" = "Ubuntu" ] || [ "$linux_dist" = "Debian" ]; then
    cp -f $Conf_Path/crawlzilla_conf/crawlzilla-master /etc/init.d/crawlzilla
    chown crawler.crawler /etc/init.d/crawlzilla
    update-rc.d crawlzilla defaults
# for rpm system
elif [ "$linux_dist" = "CentOS" ] || [ "$linux_dist" = "Fedora" ] || [ "$linux_dist" = "SUSE" ]; then
    cp -f $Conf_Path/crawlzilla_conf/crawlzilla-master_chkconfig /etc/init.d/crawlzilla
    chown crawler.crawler /etc/init.d/crawlzilla
    chkconfig --add crawlzilla
else 
    show_info "Please delete /etc/init.d/ crawlzilla file manually."
fi
# for slave (because slave_deploy.sh will tar nutch directory to slave)
cp -f $Conf_Path/crawlzilla_conf/* $Nutch_HOME/conf/

}
