package nchc.fslab.crawlzilla.bean;

import java.io.FileWriter;
import java.io.IOException;

public class crawlBean {

	public boolean crawlJob(String DBName, String urlsText, String depth)
			throws IOException {
		String urlFile = "/opt/crawlzilla/nutch/urls/seeds.txt";
		String cmd = "/opt/crawlzilla/bin/crawljob crawljob " + DBName + " "
				+ depth;
		try {
			FileWriter writeURLFile = new FileWriter(urlFile);
			writeURLFile.write("");
			writeURLFile.append(urlsText + "\n");
			writeURLFile.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

		Runtime.getRuntime().exec(cmd);
		System.out.println(cmd);
		return true;
	}

	public void deleteCrawlDB(String DBName) throws IOException {
		String delCMD = "/opt/crawlzilla/bin/crawljob delete " + DBName;
		Runtime.getRuntime().exec(delCMD);
		System.out.println(delCMD);
	}

	public static void main(String args[]) throws IOException {

		// test function ...
		// crawlBean crawlJobs = new crawlBean();
	}
}
