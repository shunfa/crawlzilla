package nchc.fslab.crawlzilla.bean;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class infoOperBean {

	public String getSpendTime(String dbName) throws IOException {
		String spendTime = "0";
		int startTime, finishTime;
		startTime = Integer.parseInt(new String(
				getMessage(dbName, "start_time")));
		finishTime = Integer.parseInt(new String(getMessage(dbName,
				"finish_time")));
		if (startTime > 0 && finishTime > 0) {
			int sHr, sMin, sSec;
			System.out.println("" + (finishTime - startTime));
			sHr = (finishTime - startTime) / 3600;
			sMin = (finishTime - startTime) / 60;
			sSec = (finishTime - startTime) % 60;
			spendTime = (sHr > 0 ? sHr : "0" + sHr) + ":"
					+ (sMin > 0 ? sMin : "0" + sMin) + ":"
					+ (sSec > 0 ? sSec : "0" + sSec);
		}
		return spendTime;
	}

	public boolean _checkDB(String dbName, String filePath) {
		File file = new File("/opt/crawlzilla/crawlDB/" + dbName + "/.meta/"
				+ filePath);
		if (file.exists()) {
			return true;
		} else {
			return false;
		}
	}

	public String getMessage(String DBName, String fileName) throws IOException {
		String filePath = "/opt/crawlzilla/crawlDB/" + DBName + "/.meta/"
				+ fileName;
		String retMes = null;
		if (_checkDB(DBName, fileName)) {
			FileReader fileNameReader = new FileReader(filePath);
			@SuppressWarnings("resource")
			String strCreateTime = new String(
					new BufferedReader(fileNameReader).readLine());
			retMes = strCreateTime;
		}
		return retMes;
	}

	public void changeHideInfoFlag(String dbName, boolean infoSwitch)
			throws IOException {
		if (_checkDB(dbName, "show_status_flag")) {
			String fPath = "/opt/crawlzilla/crawlDB/" + dbName
					+ "/.meta/show_status_flag";
			FileReader fr = new FileReader(fPath);
			BufferedReader br = new BufferedReader(fr);
			String newContent = "";

			while (br.readLine() != null) {
				newContent = infoSwitch + "";
			}
			FileWriter fw = new FileWriter(fPath);
			fw.write(newContent);
			br.close();
			fr.close();
			fw.close();
		}
	}

	public static void main(String args[]) throws IOException {
		infoOperBean iOB = new infoOperBean();
		System.out.println(iOB.getMessage("NCHC_20130131-2", "status"));
		System.out.println(iOB.getSpendTime("NCHC_20130131-2"));
		iOB.changeHideInfoFlag("NCHC_20130131-2", true);
	}
}
