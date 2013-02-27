package org.nchc.crawlzilla.bean;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

public class crawlBean {

	public boolean checkEqual(String userName, String IDBName)
			throws IOException {
		String IDBfolderPath = "/home/crawler/crawlzilla/user/" + userName
				+ "/IDB";

		NutchDBNumBean nutchDBNum = new NutchDBNumBean();
		nutchDBNum.setNum(IDBfolderPath);
		int num = nutchDBNum.getNum();
		File files[] = nutchDBNum.getFiles();
		for (int i = 0; i < num; i++) {
			if (files[i].getName().equalsIgnoreCase(IDBName)) {
				return false;
			}
		}
		return true;
	}

	public void writeUrls(String userName, String urlsText, String IDBName) {
		String folderPath = "/home/crawler/crawlzilla/user/" + userName
				+ "/tmp/" + IDBName + "/meta/urls/";
		String urlFile = "/home/crawler/crawlzilla/user/" + userName + "/tmp/"
				+ IDBName + "/meta/urls/urls.txt";
		File iDBFolder = new File(folderPath);
		if (!iDBFolder.exists()) {
			iDBFolder.mkdirs();
		}

		try {
			FileWriter writeURLFile = new FileWriter(urlFile);
			writeURLFile.write("");
			writeURLFile.append(urlsText + "\n");
			writeURLFile.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public boolean crawlJob(String userName, String IDBName, String depth,
			boolean currentDo) throws IOException {
		String goFilePath = "/opt/crawlzilla/main/go.sh";

		if (currentDo) {
			goFilePath = "/opt/crawlzilla/main/lib_crawl_go.sh";
		}

		File goFile = new File(goFilePath);
		if (goFile.exists() && currentDo) {
			String cmd = goFilePath + " " + userName + " " + IDBName + " "
					+ depth;
			Runtime.getRuntime().exec(cmd);
			return true;
		} else {
			System.out.println("non go!");
			return false;
		}
	}

	public void schedule(String user, String IDBName, String date, String hour,
			String min, String freq, String depth) throws IOException,
			InterruptedException {
		System.out.println("Schedule...");
		System.out.println("Date:" + date);
		System.out.println("Time:" + hour + ":" + min);
		System.out.println("Freq:" + freq);
		String splitDate[] = date.split("/");
		if (Integer.valueOf(hour) < 10) {
			hour = "0" + hour;
		}

		if (Integer.valueOf(min) < 10) {
			min = "0" + min;
		}

		String scheduleInfo = splitDate[2] + " " + splitDate[0] + " "
				+ splitDate[1] + " " + hour + " " + min + " " + freq + " "
				+ IDBName + "\n";
		orderBean addSch = new orderBean();
		addSch.addOrder(user, scheduleInfo);
		addSch.tranOrder(user, scheduleInfo, IDBName, depth);
		addSch.mergrAll();
	}

	public static boolean StringFilter(String str) throws PatternSyntaxException {
		// String regEx = "[^a-zA-Z0-9]";
		String regEx = "[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]";
		boolean checkFlag = false;

		Pattern p = Pattern.compile(regEx);
		Matcher m = p.matcher(str);
		while(m.find()){
			checkFlag = false;
		}
		return checkFlag;
	}

	public static void main(String args[]) {
		String str = "*adCVs*34_a _09_b5*[/435^*&城池()^$$&*).{}+.|.)%%*(*.中国}34{45[]12.fd'*&999下面是中文的字符￥……{}【】。，；’“‘”？";
		str = "admin";
		System.out.println(str);
		System.out.println(StringFilter(str));
	}
}
