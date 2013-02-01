package nchc.fslab.crawlzilla.bean;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class infoOperBean {
	public String getStatus(String dbName) throws IOException {
		String strStatus = dbName + " not exist!";
		if (_checkDB(dbName)) {
			FileReader NP;
			NP = new FileReader("/opt/crawlzilla/crawlDB/" + dbName
					+ "/.meta/status");
			@SuppressWarnings("resource")
			BufferedReader stdin = new BufferedReader(NP);
			strStatus = new String(stdin.readLine());
		}
		return strStatus;
	}

	public String getSpendTime(String dbName) throws IOException {
		String spendTime = "0";
		int startTime, finishTime;
		if (_checkDB(dbName)) {
			FileReader frStartTime, frEndTime;
			frStartTime = new FileReader("/opt/crawlzilla/crawlDB/" + dbName
					+ "/.meta/start_time");
			frEndTime = new FileReader("/opt/crawlzilla/crawlDB/" + dbName
					+ "/.meta/finish_time");
			@SuppressWarnings("resource")
			BufferedReader stdinStart = new BufferedReader(frStartTime);
			@SuppressWarnings("resource")
			BufferedReader stdinFinish = new BufferedReader(frEndTime);
			startTime = Integer.parseInt(new String(stdinStart.readLine()));
			finishTime = Integer.parseInt(new String(stdinFinish.readLine()));
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

	public boolean _checkDB(String dbName) {
		File file = new File("/opt/crawlzilla/crawlDB/" + dbName);
		if (file.exists()) {
			return true;
		} else {
			return false;
		}
	}

	public void changeHideInfoFlag(String dbName, boolean infoSwitch)
			throws IOException {
		if (_checkDB(dbName)) {
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
		System.out.println(iOB.getStatus("NCHC_20130131-2"));
		System.out.println(iOB.getSpendTime("NCHC_20130131-2"));
		iOB.changeHideInfoFlag("NCHC_20130131-2", true);
	}
}
