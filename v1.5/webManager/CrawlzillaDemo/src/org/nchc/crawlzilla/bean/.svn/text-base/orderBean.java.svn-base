package org.nchc.crawlzilla.bean;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;

public class orderBean {
	public String parserConf(String user) throws IOException{
		File UserExists = new File("/home/crawler/crawlzilla/user/" + user + "/meta/orderlist");
		String tableContent = "";
		if(UserExists.exists()){
			String input = " ";	
			FileReader fr = new FileReader("/home/crawler/crawlzilla/user/" + user + "/meta/orderlist");
			BufferedReader fb = new BufferedReader(fr);
			while ((input = fb.readLine()) != null) {
				String readIN[] = input.split(" ");
				String con1 = readIN[6];
				String con2 = readIN[0] + "-" + readIN[1] + "-" + readIN[2] + " " + readIN[3] + ":" + readIN[4];
				String con3 = readIN[5];
				String con4 = "<button>Delete</button>";
				String f1 = "<td align=\"center\" valign=\"middle\"><div align=\"center\">"+ con1 + "</div></td>" ;
				String f2 = "<td align=\"center\" valign=\"middle\"><div align=\"center\">"+ con2 + "</div></td>" ;
				String f3 = "<td align=\"center\" valign=\"middle\"><div align=\"center\">"+ con3 + "</div></td>" ;
				String f4 = "<td align=\"center\" valign=\"middle\"><div align=\"center\">"+ con4 + "</div></td>" ;				
				String f5 = "<input type=\"hidden\" name=\"jobID\" value=\"" + readIN[7] +  "\">";
				String f6 = "<input type=\"hidden\" name=\"user\" value=\"" + user +  "\">";
				String formText = "<form id=\"delete\" method=\"get\" name=\"jobSchForm\" action=\"crawlSchedule.do\">";
				String formText2 =  "</form>";
				tableContent = tableContent + formText +  "<tr>"+ f1 + f2 + f3 + f4 + f5 + f6 + "</tr>" + formText2 ;
			}
		}
		return tableContent ;
	}
	
	public void addOrder(String user, String info) throws IOException{
		String writeInfo = info.replaceAll("\n|\r","");
		File UserExists = new File("/home/crawler/crawlzilla/user/" + user + "/meta/orderlist");
		if(!UserExists.exists()){
			FileWriter writeURLFile = new FileWriter(UserExists);
			writeURLFile.write("");
			writeURLFile.close();
		}
		
		if(UserExists.exists()){
			Long currentSec=System.currentTimeMillis() / 1000;
			FileOutputStream fout = new FileOutputStream("/home/crawler/crawlzilla/user/" + user + "/meta/orderlist", true);
			writeInfo = writeInfo + " " + String.valueOf(currentSec) + "\n";
			System.out.println(writeInfo);
			fout.write(writeInfo.getBytes());
			fout.close();
		}
	}
	
	public void tranOrder(String user, String info, String IDBName, String depth) throws IOException{
		if (depth.equals("redo")){
			
		}
		File UserExists = new File("/home/crawler/crawlzilla/user/" + user + "/meta/crontab.conf");
		if(!UserExists.exists()){
			FileWriter writeURLFile = new FileWriter(UserExists);
			writeURLFile.write("");
			writeURLFile.close();
		}
		
		if(UserExists.exists()){
			String doJob = "/opt/crawlzilla/main/go.sh " + user + " " + IDBName + " " + depth ; 
			if (depth.equals("redo")){
				File depthExists = new File("/home/crawler/crawlzilla/user/" + user + "/IDB/" + IDBName + "/meta/depth");
				if (depthExists.exists()){
					FileReader NP = new FileReader("/home/crawler/crawlzilla/user/" + user + "/IDB/" + IDBName + "/meta/depth");
					BufferedReader stdin = new BufferedReader(NP);
					String redoDepth = new String(stdin.readLine());
					depth = redoDepth;
					NP.close();
				}
				doJob = "/opt/crawlzilla/main/lib_crawl_go.sh " + user + " " + IDBName + " redo" ;
			}
			
			FileOutputStream fout = new FileOutputStream("/home/crawler/crawlzilla/user/" + user + "/meta/crontab.conf", true);
			String crontab[] = info.split(" ");
			String crontabWrite = "";
			//2011 04 01 17 20 test1 weekly
			if(crontab[5].equals("once")){
				crontabWrite = "call at" ;
				crontabWrite = crontab[4] + "\t" + crontab[3] + "\t" + crontab[2] + "\t" + crontab[1] + "\t*";
			} else if(crontab[5].equals("daily")){
				crontabWrite = crontab[4] + "\t" + crontab[3] + "\t*\t*\t*";
			} else if(crontab[5].equals("weekly")){
				int y = Integer.valueOf(crontab[0]);
		        int m = Integer.valueOf(crontab[1]);
		        int d = Integer.valueOf(crontab[2]);		       
		        int e[] = new int[]{0,3,3,6,1,4,6,2,5,0,3,5};
		        int w = (d - 1 + e[m-1] + y + (y >> 2) - y/100 + y/400);
		        if(m < 3 && ((y&3) == 0 && y%100!=0 || y%400 == 0) && y!=0){
		        	--w;
		        }
		        w %= 7;
				crontabWrite = crontab[4] + "\t" + crontab[3] + "\t*\t*\t" + String.valueOf(w);
			} else if(crontab[6].equals("monthly")){
				crontabWrite = crontab[4] + "\t" + crontab[3] + "\t" + crontab[2] + "\t*\t*";
			}
			Long currentSec=System.currentTimeMillis() / 1000;
			crontabWrite = crontabWrite+ "\t" + doJob + " #" + currentSec.toString() + "\n";
			fout.write(crontabWrite.getBytes());
			fout.close();
		}
	}
	
	public void deleteOrder(String user, String jobID) throws IOException, InterruptedException{

		String line = "";
		String line2 = "";
		String crontabLineNO[] = {"/bin/bash", "-c", "cat -n /home/crawler/crawlzilla/user/" + user + "/meta/crontab.conf | grep " + jobID + " | awk '{print $1}'"};
		Process pl = Runtime.getRuntime().exec(crontabLineNO);
        BufferedReader p_in = new BufferedReader(new InputStreamReader(pl.getInputStream()));
        while((line = p_in.readLine()) != null){
                System.out.println("crontab = " + line);
                String crontabDeleteLine[] = {"/bin/bash", "-c", "sed -i '" + line +"d' " + "/home/crawler/crawlzilla/user/" + user + "/meta/crontab.conf"};
                System.out.println(crontabDeleteLine[2]);
                pl = Runtime.getRuntime().exec(crontabDeleteLine);
        }
        
		String orderlistLineNO[] = {"/bin/bash", "-c", "cat -n /home/crawler/crawlzilla/user/" + user + "/meta/orderlist | grep " + jobID + " | awk '{print $1}'"};
		Process pl2 = Runtime.getRuntime().exec(orderlistLineNO);
		
		BufferedReader p_in2 = new BufferedReader(new InputStreamReader(pl2.getInputStream()));
        while((line2 = p_in2.readLine()) != null){
                System.out.println("order =  " + line2);
                String orderlistDeleteLine[] = {"/bin/bash", "-c", "sed -i '" + line2 +"d' " + "/home/crawler/crawlzilla/user/" + user + "/meta/orderlist"};
        		System.out.println(orderlistDeleteLine[2]);
        		pl = Runtime.getRuntime().exec(orderlistDeleteLine);
        }

		p_in.close();
		p_in2.close();
		Thread.sleep(1000);
	}
	
	public void mergrAll() throws IOException, InterruptedException{
		String userHomePath = "/home/crawler/crawlzilla/user/";
		String metaPath = "/meta/crontab.conf";
		String mergeFiles = "";
		String mergeCmd = "";
		String cronftabCmd = "crontab /home/crawler/crawlzilla/meta/crontab.conf";
		
		File filePath = new File(userHomePath); 
		File files[];
		
		files = filePath.listFiles();
		int num = files.length;
		for (int i=0; i<num; i++){
			File crontabExists = new File(userHomePath + files[i].getName() + metaPath);
			if(crontabExists.exists()){
				mergeFiles = mergeFiles + " " + userHomePath + files[i].getName() + metaPath;
				System.out.println(userHomePath + files[i].getName() + metaPath);
			}
		}
		mergeCmd = "cat " + mergeFiles + " > /home/crawler/crawlzilla/meta/crontab.conf";
		String[] fileMergeCmd = { "/bin/bash", "-c" ,mergeCmd};
		String[] crontabMergeCmd = {"/bin/bash", "-c",cronftabCmd};
		Runtime.getRuntime().exec(fileMergeCmd);
		Thread.sleep(10);
		Runtime.getRuntime().exec(crontabMergeCmd);
		System.out.println(mergeCmd);
		System.out.println(cronftabCmd);
		
	}
	public static void main(String args[]) throws IOException, InterruptedException{
		orderBean test = new orderBean();
		test.mergrAll();
	}
}
