#!/bin/bash
export CRAWLZILLA_HOME="/opt/crawlzilla"
export PACKAGES_HOME="/opt/crawlzilla/packages"
export NUTCH_PKG="apache-nutch-1.6-bin.tar.gz"
export SOLR_PKG="apache-solr-4.0.0.tgz"
export CRAWLDB="/opt/crawlzilla/crawlDB"
export NUTCH_HOME="/opt/crawlzilla/nutch"
export TOMCAT_HOME="/opt/crawlzilla/tomcat"
export SOLR_HOME="/opt/crawlzilla/solr"
export META_HOME="/opt/crawlzilla/.meta"
export URLS="/opt/crawlzilla/nutch/urls"


## Package URLs
export NUTCH_PKG_LINK="http://sourceforge.net/projects/crawlzilla/files/original-package/apache-nutch-1.6-bin.tar.gz/download"
export SOLR_PKG_LINK="http://sourceforge.net/projects/crawlzilla/files/original-package/apache-solr-4.0.0.tgz/download"
export TOMCAT_LINK=""
export CZL_WEB_LINK=""

function show_echo(){
  echo -e "\033[1;32;40m $1 \033[0m"
}
