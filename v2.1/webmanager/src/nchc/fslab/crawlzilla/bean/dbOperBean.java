package nchc.fslab.crawlzilla.bean;

import java.io.IOException;

public class dbOperBean {

	public void deleteDB(String dbName) {
		// db had been checked by the web section
		String deleteDBCMD = "/opt/crawlzilla/bin/crawljob delete " + dbName;
		try {
			Runtime.getRuntime().exec(deleteDBCMD);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static void main(String args[]) {
		System.out.println("dbOperBean main");
	}

}
