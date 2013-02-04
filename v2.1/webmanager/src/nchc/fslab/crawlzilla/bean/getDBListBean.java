package nchc.fslab.crawlzilla.bean;

import java.io.File;
import java.io.IOException;

public class getDBListBean {
	private File files[];
	private File folders[];
	private int num;
	String strWebDBList, strWebRunningJobs;

	public getDBListBean() throws IOException {
		setFolders("/opt/crawlzilla/crawlDB");
		setNum("/opt/crawlzilla/crawlDB");
	}
	public void setFiles(String path) {
		File filePath = new File(path);
		files = filePath.listFiles();
	}

	public void setFolders(String path) {
		File folderPath = new File(path);
		setFolders(folderPath.listFiles());
	}

	public int setNum(String path) throws IOException {
		File filePath = new File(path);
		if (filePath.exists()) {
			files = filePath.listFiles();
			num = files.length;
			return num;
		}
		return 0;
	}

	public File[] getFiles() {
		return files;
	}

	public void setFolders(File folders[]) {
		this.folders = folders;
	}

	public File[] getFolders() {
		return folders;
	}
	
	public int getDBNum(){
		return num;
	}

	public static void main(String args[]) throws IOException {
		getDBListBean abc = new getDBListBean();
		File abcName[] = abc.getFolders();
		for (int i = 0; i < abc.getDBNum(); i++) {
			System.out.println(abcName[i].getName());
		}
	}
}
