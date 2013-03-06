#!/bin/bash
export JAVA_HOME="/usr/lib/jvm/java-6-sun/"
export CRAWLZILLA_HOME="/opt/crawlzilla"
export PACKAGES_HOME="/opt/crawlzilla/packages"
export NUTCH_PKG="apache-nutch-1.6-bin.tar.gz"
export SOLR_PKG="apache-solr-4.0.0.tgz"
export TOMCAT_PKG="apache-tomcat-7.0.37.tar.gz"
export CZL_WAR="crawlzilla.war"
export CRAWLDB="/opt/crawlzilla/crawlDB"
export NUTCH_HOME="/opt/crawlzilla/nutch"
export TOMCAT_HOME="/opt/crawlzilla/tomcat"
export SOLR_HOME="/opt/crawlzilla/solr"
export META_HOME="/opt/crawlzilla/.meta"
export URLS="/opt/crawlzilla/nutch/urls"
export LOG_HOME="/var/log/crawlzilla/v2.1"

## Package URLs
export NUTCH_PKG_LINK="http://sourceforge.net/projects/crawlzilla/files/original-package/apache-nutch-1.6-bin.tar.gz/download"
export SOLR_PKG_LINK="http://sourceforge.net/projects/crawlzilla/files/original-package/apache-solr-4.0.0.tgz/download"
export TOMCAT_PKG_LINK="http://sourceforge.net/projects/crawlzilla/files/original-package/apache-tomcat-7.0.37.tar.gz/download"
export CZL_WAR_LINK="https://sourceforge.net/projects/crawlzilla/files/original-package/crawlzillaV2.1-2013-03-06.war/download"

function show_echo(){
  echo -e "\033[1;32;40m $1 \033[0m"
}

function log_echo(){
  # $1= message
  # $2= log file path
  if [  -f $2 ]; then
      touch $2
  fi 
  echo `date +%Y-%m-%d" "%H:%M:%S" - "`$1 >> $2
}
