package org.nchc.crawlzilla.bean;

public class crawlzillaBackupBean {
	public boolean backup(String path){
		/* backup system: crawlzillaBackup.sh backup local
		 * restore system: crawlzillaBackup.sh restore filePath
		 * usermode backup: crawlzillaBack.sh usermode backup username
		 * usermode backup: crawlzillaBack.sh usermode restore username filePath
		*/
		return true;
	}
}
