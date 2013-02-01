package nchc.fslab.crawlzilla.bean;

import java.io.File;
import java.io.IOException;

public class getDBListBean {
	private File files[];
	private File folders[];
	private int num;

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

	public static void main(String args[]) throws IOException {
		getDBListBean abc = new getDBListBean();
		abc.setFolders("/opt/crawlzilla/crawlDB");
		File abcName[] = abc.getFolders();
		int a = abc.setNum("/opt/crawlzilla/crawlDB");
		for (int i = 0; i < a; i++) {
			System.out.println(abcName[i].getName());
		}
	}
}
