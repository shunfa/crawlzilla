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
#   Functions for slave_install.sh
# Author: 
#   Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw

function load_default_lang ( )
{

lang=$(locale | grep 'LANGUAGE=' | cut -d "=" -f2 | cut -d ":" -f1 )
echo $lang
if [ "$lang" == "zh_TW" ] || [ "$lang" == "TW" ] || [ "$lang" == "tw" ];then
    . $Work_Path/lang/lang_zh_TW
else
    . $Work_Path/lang/lang_en_US
fi
## Default: source english
# . $Work_Path/lang/lang_en_US
# if locale is zh then source chinese
# echo $lang | grep 'zh' >> /dev/null && source $Work_Path/lang/lang_zh_TW
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

# 檢查執行這個程式的是否為root權限
function check_root(){
  debug_info "check_root"
  if [ $USER != "root" ]; then
    show_info "$check_root_1"
    exit
  fi
  show_info "$check_root_2"
}


# 查出此主機的作業系統,以及版本
function check_systemInfo(){
  debug_info "$check_sys_1"
  show_info "$check_sys_2"
  Linux_Distribution=$(lsb_release -a 2> /dev/null | grep "Distributor ID:" | awk '{print $3}')
  Linux_Version=$(lsb_release -a 2> /dev/null | grep "Release" | awk '{print $2}')
  if [ "$Linux_Distribution" == "" ]; then
    Linux_Distribution=$(cat /etc/*-release | uniq | awk '{print $1}')
    Linux_Version=`cat /etc/*-release | uniq | awk '{print $3}'`
  fi
  show_info "$Linux_Distribution , $Linux_Version"
  Linux_bit=$(uname -m)
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

function yum_install_sun_java_i586(){
wget -nc 'https://sourceforge.net/projects/crawlzilla/files/other/jdk-6u21-linux-i586-rpm.bin/download'
echo y | bash jdk-6u21-linux-i586-rpm.bin
rpm -Uvh jdk-6u21-linux-i586.rpm
/usr/sbin/alternatives --install /usr/bin/java java /usr/java/jdk1.6.0_21/bin/java 1
/usr/sbin/alternatives --set java /usr/java/jdk1.6.0_21/bin/java
}

function yum_install_sun_java_x86_64(){
wget -nc 'https://sourceforge.net/projects/crawlzilla/files/other/jdk-6u21-linux-x64-rpm.bin/download'
echo y | bash jdk-6u21-linux-x64-rpm.bin
rpm -Uvh jdk-6u21-linux-amd64.rpm
/usr/sbin/alternatives --install /usr/bin/java java /usr/java/jdk1.6.0_21/bin/java 1
/usr/sbin/alternatives --set java /usr/java/jdk1.6.0_21/bin/java
}

# 檢查之前是否有安裝Crawlzilla
# 目前先檢查是否有/opt/crawlzilla 這個資料夾即可
function check_crawlzilla_installed ( )
{
  debug_info "$check_crawlzilla_1"
  if [ -d "/opt/crawlzilla" ] || [ -e "/home/crawler" ] ; then
    show_info "$check_crawlzilla_2"
    exit 8
  else
    show_info "$check_crawlzilla_3"
  fi
}


# 檢查是否有安裝sun java ,並檢查是否為jdk 1.6 以上版本
# 4種判斷可能性 (1)系統沒安裝 JAVA (2)系統有安裝JAVA，但非sun版本 
# (3)系統有安裝但Sun Java 在非預設路徑下 (4)以正確安裝 Sun JAVA 預設路徑下
function check_sunJava(){
  show_info "$check_sunJava_1"
  show_info "$check_sunJava_2"

  javaPath="/usr"
  yesno="no"
  choice="3"

  if [ -e $javaPath/bin/java ]; then
    JAVA_org=$($javaPath/bin/java -version 2>&1 | grep "Java(TM)")
    JAVA_version=$($javaPath/bin/java -version 2>&1 | grep "java version" | \
    awk '{print $3}' | cut -d "." -f1-2 | cut -d "\"" -f2)
   
  if [ "$JAVA_org" == "" ]; then 
    show_info "$check_sunJava_if_1"
    show_info "$check_sunJava_if_2"
    show_info "$check_sunJava_if_3"
    read -p "$check_sunJava_if_4" choice
    case $choice  in
      "1")
        show_info "$check_sunJava_if_5"
        exit 
        ;;
      "2")
        read -p "$check_sunJava_if_6" javaPath
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
            show_info "$check_sunJava_if_7"
            exit
            fi
          fi
        fi  

      large16=$(echo "$JAVA_version >= 1.6" | bc)
      if [ "${large16}" == 0 ]; then
        show_info "$check_sunJava_if_8"
        exit
      fi  
      
      show_info "$check_sunJava_if_9"
  else
    show_info "$check_sunJava_if_10"
    exit
  fi

  unset JAVA_org
  unset JAVA_version
}


# 檢查是否有安裝openssh, openssh-server
function check_ssh(){
  debug_info "$check_ssh_1"
  if [ -e /usr/bin/ssh ]; then
    show_info "$check_ssh_2"
  else
    show_info "$check_ssh_3"
    exit
  fi

  if [ -e /usr/sbin/sshd ]; then
    show_info "$check_ssh_4"
  else
    show_info "$check_ssh_5"
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


# 檢查是否有安裝dialog
function check_dialog(){
  debug_info "$check_dialog_1"
  if [ -e /usr/bin/dialog ]; then
    show_info "$check_dialog_2"
  else
    show_info "$check_dialog_3"
    exit
  fi
}


# scp crawler@master_ip:~ 把.ssh/目錄複製下來
# 當使用者輸入crawler 密碼時，將此密碼紀錄到Crawler_Passwd
# 此步驟若無法連到 master 則跳出
function scp_master_crawler_sshkey(){
  debug_info "$scp_sshkey_d1"
  debug_info "$scp_sshkey_d2"
  mkdir -p /home/crawler/.ssh/
  rm -fr /home/crawler/.ssh/*
  #unset Crawler_Passwd2

  debug_info "$scp_sshkey_d3"
expect -c "spawn scp -r -o StrictHostKeyChecking=no crawler@$1:~/.ssh /home/crawler/
set timeout 5
sleep 5
expect \"*: \" { send \"$Crawler_Passwd\r\" }
expect \"*: \" { send_user \"$scp_sshkey_expect_1\" }
expect eof"

  if [ -e "/home/crawler/.ssh/authorized_keys" ]; then
    show_info "$scp_sshkey_s1"    
    else
      show_info "$scp_sshkey_s2"
    exit
  fi
  ssh-add /home/crawler/.ssh/id_rsa
  debug_info "$scp_sshkey_d4"
  chown -R crawler:crawler /home/crawler/.ssh
}

# 新增crawler 帳號時用 Crawler_Passwd 當密碼
function creat_crawler_account(){
  if [ "$Linux_Distribution" == "SUSE" ] ;then
      groupadd crawler
  fi
  debug_info "$create_crawler_d1"
#  while [ "$Crawler_Passwd" != "$Crawler_Passwd2" ]
#  do
#      echo -e "\n"
#      read -sp "$create_crawler_1" Crawler_Passwd
#      echo 
#      read -sp "$create_crawler_2" Crawler_Passwd2
#      echo 
#        if [ "$Crawler_Passwd" == "$Crawler_Passwd2" ]; then
#          show_info "$create_crawler_3"
#        else
#          show_info "$create_crawler_4"
#        fi
#  done                                                                         #  unset Crawler_Passwd2
  
  if [ "$autoSlaveInstallFlag" == "no" ]; then
    read -sp "$create_crawler_1" Crawler_Passwd
  fi 
 
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
}

# 用scp 複製 master 的設定與安裝資料
function scp_packages(){
  debug_info "$scp_packages_d1"
  mkdir /opt/crawlzilla
  mkdir /var/lib/crawlzilla
  if [ ! -e "/var/log/crawlzilla/shell-logs" ]; then
      mkdir -p "/var/log/crawlzilla/shell-logs";
  fi
  mkdir /var/log/crawlzilla/tomcat-logs
  mkdir /var/log/crawlzilla/hadoop-logs
  mkdir /home/crawler/crawlzilla
  mkdir /home/crawler/crawlzilla/source
  mkdir /home/crawler/crawlzilla/system
  debug_info "$scp_packages_d2"
  chown -R crawler:crawler /opt/crawlzilla
  chown -R crawler:crawler /var/log/crawlzilla
  chown -R crawler:crawler /var/lib/crawlzilla
  chown -R crawler:crawler /home/crawler/crawlzilla

  ln -sf /var/log/crawlzilla /home/crawler/crawlzilla/logs
  ln -sf /opt/crawlzilla/nutch /home/crawler/crawlzilla/nutch
  # make client remove link for easy use
  ln -sf /home/crawler/crawlzilla/system/slave_remove /usr/bin/crawlzilla_remove

  chmod 711 /home/crawler   # fedora = 700
  chmod 755 /opt/crawlzilla
  debug_info "$scp_packages_d3"
  if [ -e "$Work_Path/CrawlzillaSlaveOf_$Master_IP_Address.tar.gz" ];then
    mv $Work_Path/CrawlzillaSlaveOf_$Master_IP_Address.tar.gz /home/crawler/crawlzilla/source
  fi
 
  if [ ! -e "/home/crawler/crawlzilla/source/CrawlzillaSlaveOf_$Master_IP_Address.tar.gz" ];then
    su crawler -c "scp -r -o StrictHostKeyChecking=no crawler@$1:/home/crawler/crawlzilla/source/CrawlzillaSlaveOf_$Master_IP_Address.tar.gz /home/crawler/crawlzilla/source"
  fi
  cp -r $Work_Path/lang /home/crawler/crawlzilla/system
  cp $Work_Path/log.sh $Work_Path/version $Work_Path/slave_remove /home/crawler/crawlzilla/system
}


function install_nutch_package(){
  debug_info "$install_nutch_package_d1"
  tar -zxvf /home/crawler/crawlzilla/source/CrawlzillaSlaveOf_$Master_IP_Address.tar.gz -C /opt/crawlzilla >/dev/null 2>&1
  if [ ! -d /var/log/crawlzilla/hadoop-logs ]; then mkdir /var/log/crawlzilla/hadoop-logs ; chown crawler /var/log/crawlzilla/hadoop-logs ; fi
  ln -sf /var/log/crawlzilla/hadoop-logs /opt/crawlzilla/nutch/logs
  if [ ! -d /var/log/crawlzilla/hadoop-logs ]; then mkdir /var/lib/crawlzilla ; chown crawler /var/lib/crawlzilla ; fi
  ln -sf /var/lib/crawlzilla /opt/crawlzilla/nutch/hadoop_runspace

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
    
    # setup firewall
    echo "-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 50010 -j ACCEPT" >> /etc/sysconfig/iptables
    service iptables restart 

    fi
  elif [ "$Linux_Distribution" == "Fedora" ] ;then
    if [  -d /usr/java/jdk1.6.0_21/ ] ;then
    debug_info "Change JAVA_HOME=/usr/java/jdk1.6.0_21/"
    sed -i 's/\/usr\/lib\/jvm\/java-6-sun/\/usr\/java\/jdk1.6.0_21\//' /opt/crawlzilla/nutch/conf/hadoop-env.sh
    ln -sf /usr/java/jdk1.6.0_21/bin/jps /usr/bin/jps
    fi
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
    # set ip-hostname to /home/crawler/crawlzilla/system/hosts
    sed -i '1a '$Master_IP_Address' '$Master_Hostname'' /home/crawler/crawlzilla/system/hosts
    if [ $? -eq 0 ]; then
        # set link
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


function recall_hostname_ip(){
  debug_info "$recall_hostname_ip_d1"
  net_interfaces=$(/sbin/ifconfig | grep ^eth | cut -d " " -f1)
  net_nu=$(echo $net_interfaces | wc -w)
  # 若只有一個 eth　時
  if [ "$net_nu" == "1" ]; then
  # ifconfig $net_interfaces | grep "inet addr:" | sed 's/^.*inet addr://g' | cut -d " " -f1
  net_address=$(/sbin/ifconfig $net_interfaces | grep "inet addr:" | sed 's/^.*inet addr://g' | cut -d " " -f1)
  net_MacAddr=$(/sbin/ifconfig $net_interfaces | grep 'HW' | sed 's/^.*HWaddr //g')
  show_info "$recall_hostname_ip_1 $net_address"
  show_info "$recall_hostname_ip_2 $net_MacAddr"

  # 若有多個 eth 時
    else
      declare -i i=1
      show_info "$recall_hostname_ip_3"
       
      for net in $net_interfaces
      do  
        echo "($i)  $net  $(/sbin/ifconfig $net | grep "inet addr:" | sed 's/^.*inet addr://g' | cut -d " " -f1)"
        i=i+1
      done
       
      read -p "$recall_hostname_ip_4" net_choice
  if [ -z $net_choice ]; then
    net_choice=1
  fi   

  show_info "choice is $net_choice"
  net_interface=$(echo $net_interfaces | cut -d " " -f $net_choice)
  # config $net_interface | grep "inet addr:" | sed 's/^.*inet addr://g' | cut -d " " -f1
  net_address=$(/sbin/ifconfig $net_interface | grep "inet addr:" | sed 's/^.*inet addr://g' | cut -d " " -f1)
  net_MacAddr=$(/sbin/ifconfig $net_interface | grep 'HW' | sed 's/^.*HWaddr //g') 
  show_info "$recall_hostname_ip_1 $net_address"
  show_info "$recall_hostname_ip_2 $net_MacAddr"
  fi

  debug_info "$recall_hostname_ip_d2"
  su crawler -c "ssh -o StrictHostKeyChecking=no crawler@$1 echo $net_address $(hostname) $net_MacAddr \>\> ~/crawlzilla/system/crawl_nodes"
}

function startup_hadoop_service ( ) 
{
  show_info "Do you want to start hadoop service? "
  show_info "y = start now, n = later by yourself."
  read -p "[y/n]" start_serv
  if [ "$start_serv" == "y" ];then
    su crawler -c "/opt/crawlzilla/nutch/bin/hadoop-daemon.sh start datanode"
    su crawler -c "/opt/crawlzilla/nutch/bin/hadoop-daemon.sh start tasktracker"
  fi
}

function change_ownship ( )
{
chown -R $1.$1 $2
}

# add crawlzilla init.d script (make slave startup crawlzilla when booting)
function add_crawlzilla_to_initd ( ) 
{
linux_dist=$(lsb_release -i | awk '{print $3}')

# for debian system
if [ "$linux_dist" = "Ubuntu" ] || [ "$linux_dist" = "Debian" ]; then
    cp -f /opt/crawlzilla/nutch/conf/crawlzilla-slave /etc/init.d/crawlzilla
    chown crawler:crawler /etc/init.d/crawlzilla
    update-rc.d crawlzilla defaults
# for rpm system
elif [ "$linux_dist" = "CentOS" ] || [ "$linux_dist" = "Fedora" ] || [ "$linux_dist" = "SUSE" ]; then
    cp -f /opt/crawlzilla/nutch/conf/crawlzilla-slave_chkconfig /etc/init.d/crawlzilla
    chown crawler.crawler /etc/init.d/crawlzilla
    chkconfig --add crawlzilla
else
    show_info "Please delete /etc/init.d/ crawlzilla file manually."
fi
}
