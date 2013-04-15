package nchc.fslab.crawlzilla.bean;

import java.io.IOException;

public class dbOperBean {

	public void deleteDB(String dbName) {
		String deleteDBCMD = "/opt/crawlzilla/bin/crawljob delete " + dbName;
		try {
			Runtime.getRuntime().exec(deleteDBCMD);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void deleteFailDB(String dbName) {
		String deleteFailDBCMD = "/opt/crawlzilla/bin/crawlJobServ delete "
				+ dbName;
		try {
			Runtime.getRuntime().exec(deleteFailDBCMD);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void killDB(String dbName) {
		String killDBCMD = "/opt/crawlzilla/bin/crawlJobServ kill " + dbName;
		try {
			Runtime.getRuntime().exec(killDBCMD);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void fixDB(String dbName) {
		String fixDBCMD = "/opt/crawlzilla/bin/crawljob reindex " + dbName;
		try {
			Runtime.getRuntime().exec(fixDBCMD);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static void main(String args[]) {
		System.out.println("dbOperBean main");
	}

}
