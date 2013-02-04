package nchc.fslab.crawlzilla.trashBean;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class getDBInfoBean {
	public String getDBCreateTime(String DBName) throws IOException {
		String filePath = "/opt/crawlzilla/crawlDB/" + DBName
				+ "/.meta/create_time";
		String retMes = null;
		if (_checkDB(DBName, "create_time")) {
			FileReader createTime = new FileReader(filePath);
			@SuppressWarnings("resource")
			String strCreateTime = new String(
					new BufferedReader(createTime).readLine());
			retMes = strCreateTime;
		}
		return retMes;
	}
	
	public String getDepth(String DBName){
		
		return null;
	}
	
	public String getURLs(String DBName){
		
		return null;
	}

	public boolean _checkDB(String dbName, String metaFile) {
		File file = new File("/opt/crawlzilla/crawlDB/" + dbName + "/.meta/"
				+ metaFile);
		if (file.exists()) {
			return true;
		} else {
			return false;
		}
	}

	public static void main(String args[]) throws IOException {
		getDBInfoBean gDBIB = new getDBInfoBean();
		System.out.println(gDBIB.getDBCreateTime("NCHC_20130131-2"));
	}

}
