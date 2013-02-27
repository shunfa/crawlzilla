package org.nchc.crawlzilla.bean;

import java.io.IOException;
import java.util.List;




public class IDBOperateBean {
	public List getBrands(String operate){
		return null;		
	}

	public void preview(String DBName) throws IOException, InterruptedException{
		// TODO 
		Process process = Runtime.getRuntime().exec("touch /home/crawler/crawlzilla/shunfa/preview..."+ DBName);
		System.out.println(DBName + " preview...");
		process.waitFor();
		process.destroy();
	}
	
	public void recrawl(String userName, String DBName) throws IOException, InterruptedException{
		String goFilePath = "/opt/crawlzilla/main/lib_crawl_go.sh";
		String recrawlCmd = goFilePath + " " + userName + " " + DBName + " redo" ;
		System.out.println(DBName + " recrawling...");
		System.out.println(recrawlCmd);
		Process pl = Runtime.getRuntime().exec(recrawlCmd);
		try {
			pl.waitFor();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		pl.destroy();
	}
	
	public void deleteDB(String userName, String DBName) throws IOException, InterruptedException{
		try {
			Process process = Runtime.getRuntime().exec("rm -rf /home/crawler/crawlzilla/user/"+ userName + "/IDB/"+DBName);
			process.waitFor();
			process.destroy();

			Process process2 = Runtime.getRuntime().exec("rm -rf /home/crawler/crawlzilla/user/"+ userName + "/webs/"+DBName);
			process2.waitFor();
			process2.destroy();
		
			Process process3 = Runtime.getRuntime().exec("rm -rf /opt/crawlzilla/tomcat/webapps/" + userName + "_" + DBName);
			process3.waitFor();
			process3.destroy();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		System.out.println(userName + " delete");
	}
	
	public void deleteDBStatus(String userName, String DBName) throws IOException, InterruptedException{
		System.out.println(DBName + " deleteDBStatus...");
		Process process = Runtime.getRuntime().exec("rm -rf /home/crawler/crawlzilla/user/" + userName + "/tmp/"+DBName);
		process.waitFor();
		process.destroy();
	}
	
	public void fixDB(String userName, String DBName) throws IOException, InterruptedException{
		Runtime.getRuntime().exec("/opt/crawlzilla/main/fix.sh " + userName + " "+DBName);
		System.out.println("/opt/crawlzilla/main/fix.sh " + userName + " "+DBName);
	}
}
	
