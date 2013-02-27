#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ] || [ "$3" == "" ]; then
 echo "1. 使用這個shell ，首先你需要有crawler這個使用者，並且hadoop 已經開始運作";
 echo "2. 在本地建一個 urls.txt 檔，內放url，如：http://www.nchc.org.tw/tw/"
 echo "3. 執行 $0 <使用者> <Job名稱> <url 檔>"
 echo " ex : prepare_go.sh admin mycrawljob urls.txt" 
 exit
fi

USERNAME=$1
JNAME=$2
URLS=$3

# env
OptMain="/opt/crawlzilla/main"
OptWebapp="/opt/crawlzilla/tomcat/webapps"
OptNutchBin="/opt/crawlzilla/nutch/bin"
HomeUserDir="/home/crawler/crawlzilla/user"
HdfsHome="/user/crawler"

# local para
HomeUserTmp="$HomeUserDir/$USERNAME/tmp"
HomeUserIDB="$HomeUserDir/$USERNAME/IDB"
HomeUserWeb="$HomeUserDir/$USERNAME/webs"
HomeUserMeta="$HomeUserDir/$USERNAME/meta"

if [ ! -e $URLS ];then echo "please check urls file"; exit; fi

[ $USER != "crawler" ] && echo "please enter crawler's password"  && exec su crawler -c "$0 $USERNAME $JNAME $Depth"

mkdir -p $HomeUserTmp/$JNAME/meta/urls/
#echo $URLS > $HomeUserTmp/$JNAME/meta/urls/urls.txt
cp $URLS $HomeUserTmp/$JNAME/meta/urls/urls.txt
echo " [ OK ] $HomeUserTmp/$JNAME/meta/urls/urls.txt ==>"
cat $HomeUserTmp/$JNAME/meta/urls/urls.txt

read -p "Launch go.sh ? [yes = y]" ANS
if [ "$ANS" == "y" ] || [ "$ANS" == "y" ] ;then
    read -p "深度 ? 僅填數字 " Depth
    $OptMain/go.sh $USERNAME $JNAME $Depth
fi
