#!/bin/bash
# 此shell 可以用來把svn上的程式碼封裝成安裝壓縮包
# 請先設定 DELETE_LOCK 是否要刪除
# 以及安裝的時間版本 DATE_VER 

#DELETE_LOCK=0 # 1= 刪除 $InstallDir 資料夾
DATE_VER=`date +%y%m%d` # 年月日
CURRENT_VER=1.1 # 專案目前的版本
STABLE_VER=1 # increased manually if next stable version arrived

# for ant
SvnCrawlzilla=`dirname "$0"`
SvnCrawlzilla=`cd "$SvnCrawlzilla"; pwd`

DistDir=./packages
InstallDir=Crawlzilla_Install
ShellTar=Crawlzilla-$CURRENT_VER.$DATE_VER.tar.gz
StableTar=Crawlzilla-$CURRENT_VER.$STABLE_VER.tar.gz
FullTar=Crawlzilla-$CURRENT_VER.$DATE_VER-Full.tar.gz

function checkMethod(){
  if [ $? -eq 0 ];then
    echo "$1 is ok";
  else
    echo "$1 broken , exit ";
    exit 8
  fi
}
# 1. generate version and svn update 
echo "$CURRENT_VER.$DATE_VER" > $SvnCrawlzilla/Crawlzilla_Install/version
checkMethod 1.1
svn update;
checkMethod 1.2

# 2 create crawlzilla.war file
ant -f $SvnCrawlzilla/web-src/build.xml clean
ant -f $SvnCrawlzilla/web-src/build.xml
checkMethod 2.1

# 3 make dir for tmp and final

#cd $SvnProject


if [ ! -d $DistDir ];then
  mkdir $DistDir
  checkMethod 3.1
fi

# 4 package crawlzilla.war
#if [ -d "$InstallDir/web/" ];then rm -rf $InstallDir/web; fi
#if [ -d "$InstallDir/package/" ];then rm -rf $InstallDir/package; fi
#rm $InstallDir/crawlzilla*.log


#mkdir $InstallDir/web/
#checkMethod 4.2
if [ -e "$SvnCrawlzilla/web-src/tmp/crawlzilla.war" ];then
  cp $SvnCrawlzilla/web-src/tmp/crawlzilla.war $InstallDir/web/
  mv $SvnCrawlzilla/web-src/tmp/crawlzilla.war $DistDir/crawlzilla-$DATE_VER.war
  checkMethod 4.3
fi

# 5 tar file
cd $SvnCrawlzilla
tar -czvf $ShellTar $InstallDir --exclude=.svn
checkMethod 5.1

# 5.1 make full package  .. skip

# 6 reload dir
if [ -f $DistDir/$ShellTar ];then
  rm $DistDir/$ShellTar;
  checkMethod 6.0
fi

# 7  stable
echo "Is it stable version ?"
read -p "[y/n] :" stable_check

if [ "$stable_check" == "y" ];then
  if [ -f $DistDir/$StableTar ];then
    rm $DistDir/$StableTar;
    checkMethod 7.a
  fi
  cp $ShellTar $DistDir/$StableTar
  checkMethod 7.b
fi
mv $ShellTar $DistDir
checkMethod 7.1


# 8  DELETE_LOCK=1
#if [ $DELETE_LOCK -eq 1 ];then
#  rm -rf $InstallDir;
#  checkMethod 8.2
#fi

echo "完成，一切確認後，最後的檔案放在這個目錄內："
echo "  $DistDir "

# 9 upload to  source forge
echo "Upload to source forge ?"
read -p "[y/n] :" upload_sf
if [ "$upload_sf" == "y" ];then

    # 做local user 與 sf.net 上的user 對應, fafa 與 rock
    if [ $USER == "waue" ];then
        USER=waue0920;
    elif [ $USER == "rock" ];then
        USER=goldjay1231;
    fi
    # 上傳到sf.net
    # 不用把 version 也上傳道source forge 因為以改成 google code 
#    scp $InstallDir/version $USER,crawlzilla@frs.sourceforge.net:/home/frs/project/c/cr/crawlzilla/testing/

    scp $DistDir/$ShellTar $USER,crawlzilla@frs.sourceforge.net:/home/frs/project/c/cr/crawlzilla/testing/Crawlzilla-$CURRENT_VER/
    echo "最新的版本[ $ShellTar ]也同時上傳到sf.net囉"
    echo "http://sourceforge.net/downloads/crawlzilla/testing/Crawlzilla-$CURRENT_VER/"
fi

# 
