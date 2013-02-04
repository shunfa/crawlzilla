package nchc.fslab.crawlzilla.bean;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class infoOperBean {

	public String getSpendTime(String dbName) throws IOException {
		String spendTime = "0";
		String startTime, finishTime;
		startTime = getMessage(dbName, "start_time");
		finishTime = new String(getMessage(dbName, "finish_time"));
		System.out.println(spendTime);
		if (!startTime.equals("null") && !finishTime.equals("null")) {
			int sHr, sMin, sSec, start, finish;
			start = Integer.parseInt(startTime);
			finish = Integer.parseInt(finishTime);
			System.out.println("" + (finish - start));
			sHr = (finish - start) / 3600;
			sMin = (finish - start) / 60;
			sSec = (finish - start) % 60;
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
		String retMes = "null";
		if (_checkDB(DBName, fileName)) {
			FileReader fileNameReader = new FileReader(filePath);
			@SuppressWarnings("resource")
			String strTemp = new String(
					new BufferedReader(fileNameReader).readLine());
			retMes = strTemp;
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
		System.out.println(iOB.getSpendTime("NCHC_3"));
		iOB.changeHideInfoFlag("NCHC_20130131-2", true);
	}
}
