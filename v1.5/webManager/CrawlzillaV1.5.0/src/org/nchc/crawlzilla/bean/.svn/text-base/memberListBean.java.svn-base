package org.nchc.crawlzilla.bean;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class memberListBean {
	private File files[];
	private File folders[];
	private int num;
	String path = "/home/crawler/crawlzilla/user";
	
	public void setFiles(String path){
		File filePath = new File(path); 
		files = filePath.listFiles();
	}
	
	public void setFolders(String path){
		File folderPath = new File(path);
		setFolders(folderPath.listFiles());
	}
	
	public int setNum(String path) throws IOException{
		File filePath = new File(path);
		if(filePath.exists()){
			files = filePath.listFiles();	
			num = files.length;
			return num;
		}
		return 0;				
	}
	
	public String showEmail(String emailPath) throws IOException{
//		FileReader NP = new FileReader(emailPath);
//		BufferedReader stdin = new BufferedReader(NP);
//		String email = new String(stdin.readLine());
		OperFileBean ofb = new OperFileBean(emailPath);
		return ofb.getFileStr();
	}
	
	public File[] getFiles(){
		return files;
	}

	public void setFolders(File folders[]) {
		this.folders = folders;
	}

	public File[] getFolders() {
		return folders;
	}	
	
	public static void main (String args []) throws IOException{
		memberListBean abc = new memberListBean();
		abc.setFolders("/home/crawler/crawlzilla/user");
		File abcName[] = abc.getFolders();
		int a = abc.setNum("/home/crawler/crawlzilla/user");
		for (int i=0; i<a;i++){
			System.out.println(abcName[i].getName());
			System.out.println(abc.showEmail("/home/crawler/crawlzilla/user/" + abcName[i].getName() + "/meta/email"));
		}
		
	}
}
