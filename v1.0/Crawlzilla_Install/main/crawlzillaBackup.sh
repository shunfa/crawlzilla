#!/bin/bash
# crawlzillaBack.sh backup/restore 帳號＠備份位址/local 路徑
# 測試指令 <1>sudo ./crawlzillaBackup.sh backup shunfa@140.110.134.198 ~
# 測試指令 <2>sudo ./crawlzillaBackup.sh backup local
# 測試指令 <3>sudo ./crawlzillaBackup.sh restore /home/crawler/backup/crawlzillaBackup-12-02-03-1436.tar.gz 
# 2012-02-03 <電腦A> 備份還原到 <電腦B> ...ok
# todo: 客製化備份

tomcatPath="/opt/crawlzilla/tomcat/webapps"
homePath="/home/crawler/crawlzilla"
date=$(date +%y-%m-%d-%H%M)

function backupProcess (){
    echo "start backup process!";

    if [[ $storeagePath ==  "" ]] ; then
	storeagePath="/home/crawler/backup"
	if [ ! -d "/home/crawler/backup" ]; then
	    mkdir -p /home/crawler/backup;
	fi
    fi

    # 打包程序, 存儲至/tmp/路徑下
    # 1. 打包檔案
    echo "$date: backup process start" >> /var/log/crawlzilla/shell-logs/backup.log
    touch $homePath/meta/$date.backup.flag
    tar -zpcv -f /tmp/crawlzillaBackup-$date.tar.gz $homePath/applyUser $homePath/meta $homePath/user $tomcatPath
    rm $homePath/meta/$date.backup.flag

    # 2. 傳送至儲存位址
    if [[ $userAndipAddress == "local" ]]; then
	cp /tmp/crawlzillaBackup-$date.tar.gz $storeagePath
	chown -R crawler:crawler $storeagePath
	chmod -R 755 $storeagePath
	echo "store path: $storeagePath";
	echo "backup finished!" >> /var/log/crawlzilla/shell-logs/backup.log
    else	
	scp /tmp/crawlzillaBackup-$date.tar.gz $userAndipAddress:$storeagePath
    fi
}

function restoreProcess(){
    echo "start restore process!";
    echo "restore file: $storeagePath ...";
    echo "$date: restore process" >> /var/log/crawlzilla/shell-logs/restore.log    
    restoreDate=$(echo $storeagePath | cut -d '-' -f 2,3,4,5 | cut -d '.' -f 1);

    # rename 
    mv $homePath/applyUser $homePath/applyUser-bak
    mv $homePath/meta $homePath/meta-bak
    mv $homePath/user $homePath/user-bak
    mv $tomcatPath $tomcatPath-bak

    tar -zxvf $storeagePath  -C /
    # check flag
    if [[ ! -e $homePath/meta/$restoreDate.backup.flag ]]; then
	echo "restore process failured!" >> /var/log/crawlzilla/shell-logs/restore.log;
	rm -rf $homePath/applyUser $homePath/meta $homePath/user $tomcatPath 
	# 還原之前狀態
        mv $homePath/applyUser-bak $homePath/applyUser
	mv $homePath/meta-bak $homePath/meta
	mv $homePath/user-bak $homePath/user
	mv $tomcatPath-bak $tomcatPath
        exit 1;
    fi

    rm $homePath/meta/$restoreDate.backup.flag;
    # write message to log
    chown -R crawler:crawler $homePath
    chown -R crawler:crawler $tomcatPath
    chmod -R 755 $homePath
    chmod -R 755 $tomcatPath
    echo "$date: restore process finished!" >> /var/log/crawlzilla/shell-logs/restore.log
}

function userBackup(){
# 指令 ./crawlzillaBackup usermode backup userName
    echo "$date: user $userName backup process start!" >> /var/log/crawlzilla/shell-logs/restore.log

# 檢查使用者是否存在
    if [[ ! -d "$homePath/user/$userName" ]]; then
	echo "$homePath/user/$userName"
	echo "Can't find user!"
        echo "Can't find user!" >> /var/log/crawlzilla/shell-logs/restore.log
	exit 1;
    fi

    echo "$date: user $userName backup process start!" >> /var/log/crawlzilla/shell-logs/restore.log
    touch $homePath/meta/$date.$userName.backup.flag
    tar -zpcv -f /tmp/crawlzillaBackup-$date.$userName.tar.gz $homePath/user/$userName
    cp /tmp/crawlzillaBackup-$date.$userName.tar.gz /home/crawler/backup/
# 建立連結檔供使用者下載
    if [[ ! -d $tomcatPath/crawlzillaBackup ]];then
	mkdir -p $tomcatPath/crawlzillaBackup
    fi

    if [[ -e /home/crawler/backup/crawlzillaBackup-$date.$userName.tar.gz ]]; then
	ln -sf /home/crawler/backup/crawlzillaBackup-$date.$userName.tar.gz $tomcatPath/crawlzillaBackup/crawlzillaBackup-$date.$userName.tar.gz
    fi

    echo "$date: user $userName backup process finished!" >> /var/log/crawlzilla/shell-logs/restore.log
}

function userRestore(){
# 指令 ./crawlzillaBackup usermode restore userName
     echo "$date: user $userName restore process start!"
     echo "$date: user $userName restore process start!" >> /var/log/crawlzilla/shell-logs/restore.log
     if [[ ! -d /tmp/crawlzillatmp/ ]]; then 
	mkdir -p /tmp/crawlzillatmp/ 
     fi
     tar -zxvf $storeagePath  -C /tmp/crawlzillatmp/
     	if [[ ! -d /tmp/crawlzillatmp/home/crawler/crawlzilla/user/$userName ]]; then
		echo "user not found";
		exit 1;
	fi
	cp -r /tmp/crawlzillatmp/home/crawler/crawlzilla/user/$userName /home/crawler/crawlzilla/user/
	# 移除webapps下的捷徑
       	rm /opt/crawlzilla/tomcat/webapps/"$userName"_*
       
       	# 建立捷徑
	list=$(ls /home/crawler/crawlzilla/user/"$userName"/webs/)
	for var in $list; do
	    ln -sf /home/crawler/crawlzilla/user/$userName/webs/$var /opt/crawlzilla/tomcat/webapps/$userName"_"$var	
	done	
	# 清除暫存檔
       	rm -rf /tmp/crawlzillatmp/
	echo "restore process finished!" >> /var/log/crawlzilla/shell-logs/restore.log     
}

function main(){
    case $1 in
	"backup")
	    if [[ $2 == "" ]] || [[ $2 != "local" ]] && [[ $3 == "" ]]  ; then
		echo "備份至其他主機：crawlzillaBack.sh backup/restore 帳號＠備份位址/local 路徑";
                echo "備份至本機：crawlzillaBack.sh backup/restore local 本機路徑(預設為"/home/crawler/backup")";
                exit 1;
	    fi
            if [[ $2 == "local" ]]; then
                userAndipAddress=$2
                storeagePath=$3
                backupProcess
                exit 1;
            fi
	;;

	"restore")
            if [[ $2 == ""  ]]; then
	        echo "restore type: crawlzillaBack.sh restore 還原檔路徑及檔名";
                exit 1;
   	    fi
	   
            storeagePath=$2;
	    if [[ ! -e $storeagePath ]]; then
                echo "$storeagePath file not found";
                exit 1;
            fi
	    restoreDate=$(echo $storeagePath | cut -d '-' -f 2,3,4,5| cut -d '.' -f 1);
            restoreProcess;
	;;

	"usermode")
	    if [[ $4 == "" ]] && [[ $2 != "backup" ]]; then
		echo "usermode type: crawlzillaBack.sh usermode backup/restore username 還原檔路徑及檔名";
		exit 1;
            fi
	    
	    # 參數指派
	    userName=$3

            if [[ $2 == "backup" ]]; then
		echo "user $userName backup process...";
	 	userBackup
		exit 1;   
	    fi

	    if [[ $2 == "restore" ]]; then
                filePath=$4
		if [[ ! -e $filePath ]]; then
                    echo "File not found!"
                    exit 1;
        	fi
	
		userRestore
		echo "user $userName restore process..."

		exit 1;
	    fi
	;;
	* )
	    echo "備份至其他主機：crawlzillaBack.sh backup/restore 帳號＠備份位址/local 路徑";
            echo "備份至本機：crawlzillaBack.sh backup/restore local 本機路徑(預設為"/home/crawler/backup")"
	;;
    esac
}

main $1 $2 $3
