#!/bin/bash
# 此shell 可以用來把svn上的程式碼封裝成安裝壓縮包
# 請先設定 DELETE_LOCK 是否要刪除
# 以及安裝的時間版本 DATE_VER 

DELETE_LOCK=1 # 1= 刪除 $TmpDir 資料夾
DATE_VER=`date +%y%m%d` # 年月日
CURRENT_VER=0.3 # 專案目前的版本
MINOR_VER=0
# for ant

if [ -d "opt/svn_project/crawlzilla" ]; then
    GoogleCodeCrawlzilla="/opt/svn_project/crawlzilla"
else
    GoogleCodeCrawlzilla=`pwd "$0"`
fi

TmpDir=Crawlzilla_Install
ShellTar=Crawlzilla-$CURRENT_VER-$DATE_VER-Shell.tar.gz
StableTar=Crawlzilla-$CURRENT_VER.$MINOR_VER.tar.gz
FullTar=Crawlzilla-$CURRENT_VER-$DATE_VER-Full.tar.gz

function checkMethod(){
  if [ $? -eq 0 ];then
    echo "$1 is ok";
  else
    echo "$1 broken , exit ";
    exit 8
  fi
}
# 1 同步資料與編譯web資料

cd $GoogleCodeCrawlzilla; svn update;
checkMethod 1.1
ant -f $GoogleCodeCrawlzilla/src/web/build.xml clean
ant -f $GoogleCodeCrawlzilla/src/web/build.xml
echo "$CURRENT_VER.$MINOR_VER-$DATE_VER" > $GoogleCodeCrawlzilla/src/shell/version
checkMethod 1.2

# 2 開始目錄以及生成暫存目錄

#cd $SvnProject

if [ -d $TmpDir ];then
  rm -rf $TmpDir;
  checkMethod 2.1
fi
mkdir $TmpDir
mkdir $GoogleCodeCrawlzilla/dist 2> /dev/null
# 2.5 打包 crawlzilla.war
mkdir $TmpDir/web/
checkMethod 2.2
cp $GoogleCodeCrawlzilla/src/web/dist/crawlzilla.war $TmpDir/web/
echo $GoogleCodeCrawlzilla/src/web/dist/crawlzilla.war $TmpDir/web/
mv $GoogleCodeCrawlzilla/src/web/dist/crawlzilla.war $GoogleCodeCrawlzilla/dist/crawlzilla-$DATE_VER.war
checkMethod 2.3


# 3 複製資料夾

cp -rf $GoogleCodeCrawlzilla/src/shell $TmpDir/bin
checkMethod 3.1
cp -rf $GoogleCodeCrawlzilla/docs $TmpDir/
checkMethod 3.2
cp -rf $GoogleCodeCrawlzilla/conf $TmpDir/
checkMethod 3.3

# 4 複製與鍊結檔案

cp $GoogleCodeCrawlzilla/LICENSE.txt $TmpDir/
checkMethod 4.1
cd $TmpDir
ln -sf docs/README.en.txt README.txt
ln -sf bin/install install

# 5 先壓縮精簡包
cd $GoogleCodeCrawlzilla
tar -czvf $ShellTar $TmpDir --exclude=.svn
checkMethod 5.1

# 6 製作full package 檔
echo "Make full-package, skip ..."
checkMethod 6.1
# mkdir $TmpDir/package
# cp $GoogleCodeNutcheEz/src/package/crawlzilla-pack-current.tar.gz $TmpDir/package/
# checkMethod 6.1
# 6.2 壓縮完整包
# tar -czvf $FullTar $TmpDir --exclude=.svn
# checkMethod 6.2
# 6.3 複製到 trac 的 package
#if [ ! -d $SvnProject/dist ];then
#  mkdir $SvnProject/dist
#  checkMethod 6.3
#fi
# 先不做fulltar
#if [ -f $SvnProject/dist/$FullTar ];then
#  rm $SvnProject/dist/$FullTar;
#  checkMethod 6.4
#fi
#mv $FullTar $SvnProject/dist
#checkMethod 6.5

# 7 將製作好的安裝檔放在保存的資料夾
if [ -f $GoogleCodeCrawlzilla/dist/$ShellTar ];then
  rm $GoogleCodeCrawlzilla/dist/$ShellTar;
  checkMethod 7.0
fi
if [ -f $GoogleCodeCrawlzilla/dist/$StableTar ];then
  rm $GoogleCodeCrawlzilla/dist/$StableTar;
  checkMethod 7.0
fi
cp $ShellTar $GoogleCodeCrawlzilla/dist/$StableTar
mv $ShellTar $GoogleCodeCrawlzilla/dist
checkMethod 7.1
# 7.2 刪除 DELETE_LOCK=1
if [ $DELETE_LOCK -eq 1 ];then
  rm -rf $TmpDir;
  checkMethod 7.2
fi

echo "完成，一切確認後，最後的檔案放在這個目錄內："
echo "  $GoogleCodeCrawlzilla/dist/$StableTar "

echo "Upload to source forge ?"
read -p "[y/n] :" upload_sf
if [ "$upload_sf" == "y" ];then
    # 8 上傳到 source forge
    # 做local user 與 sf.net 上的user 對應, fafa 與 rock
    if [ $USER == "waue" ];then
        USER=waue0920;
    elif [ $USER == "rock" ];then
        USER=goldjay1231;
    fi
    # 上傳到sf.net
    scp $GoogleCodeCrawlzilla/dist/$ShellTar $USER,crawlzilla@frs.sourceforge.net:/home/frs/project/c/cr/crawlzilla/testing/Crawlzilla-$CURRENT_VER/
    echo "最新的版本[ $ShellTar ]也同時上傳到sf.net囉"
    echo "http://sourceforge.net/downloads/crawlzilla/testing/Crawlzilla-$CURRENT_VER/"
fi

# 
