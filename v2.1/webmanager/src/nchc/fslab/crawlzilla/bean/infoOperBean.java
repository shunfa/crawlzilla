package nchc.fslab.crawlzilla.bean;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class infoOperBean {
	public String getStatus(String dbName) throws IOException {
		String strStatus = dbName + " not exist!";
		if (_checkDB(dbName)) {
			FileReader NP;
			NP = new FileReader("/opt/crawlzilla/crawlDB/" + dbName + "/.meta/status");
			@SuppressWarnings("resource")
			BufferedReader stdin = new BufferedReader(NP);
			strStatus = new String(stdin.readLine());
		}
		return strStatus;
	}

	public boolean _checkDB(String dbName) {
		File file = new File("/opt/crawlzilla/crawlDB/" + dbName);
		if (file.exists()) {
			return true;
		} else {
			return false;
		}
	}

	public static void main(String args[]) throws IOException {
		infoOperBean iOB = new infoOperBean();
		System.out.println(iOB.getStatus("NCHC_20130131-2"));
	}
}
