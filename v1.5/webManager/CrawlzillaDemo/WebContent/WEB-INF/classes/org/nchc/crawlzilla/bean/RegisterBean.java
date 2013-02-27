package org.nchc.crawlzilla.bean;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class RegisterBean {
	
	public boolean checkUserExist(String userName){
		File UserExists = new File("/home/crawler/crawlzilla/user/" + userName);
		File UserApplyExists = new File("/home/crawler/crawlzilla/applyUser/" + userName);
		if((UserExists.exists()) || (UserApplyExists.exists())){
			System.out.println("user exist!");
			return true;
		}
		return false;
	}
	
	public void regNewUser(String newUser, String passwd, String email) throws IOException, NoSuchAlgorithmException, InterruptedException {
		String userPathHome = "/home/crawler/crawlzilla/applyUser/" + newUser;
		String userPath = "/home/crawler/crawlzilla/applyUser/" + newUser + "/meta";		
		Runtime.getRuntime().exec("mkdir -p " + userPathHome);
		Thread.sleep(10);
		Runtime.getRuntime().exec("mkdir -p " + userPathHome + "/tmp");
		Thread.sleep(10);
		Runtime.getRuntime().exec("mkdir -p " + userPathHome + "/IDB");
		Thread.sleep(10);
		Runtime.getRuntime().exec("mkdir -p " + userPathHome + "/old");
		Thread.sleep(10);
		Runtime.getRuntime().exec("mkdir -p " + userPathHome + "/webs");
		Thread.sleep(10);
		Runtime.getRuntime().exec("mkdir -p " + userPathHome + "/meta");
		Thread.sleep(10);
		File passwdFile = new File(userPath + "/passwd");
		Thread.sleep(10);
		FileWriter fout = new FileWriter(passwdFile);
		BufferedWriter foutWriter = new BufferedWriter(fout);
		foutWriter.write(MD5(passwd));
		foutWriter.newLine();
		foutWriter.close();
			
		File emailFile = new File(userPath + "/email");
		FileWriter fout2 = new FileWriter(emailFile);
		BufferedWriter foutWriter2 = new BufferedWriter(fout2);
		foutWriter2.write(email);
		foutWriter2.newLine();
		foutWriter2.close();
	}
	
	public final static String MD5(String s) {
	    try {
	    	byte[] btInput = s.getBytes();
	    	MessageDigest mdInst = MessageDigest.getInstance("MD5");
	    	mdInst.update(btInput);
	    	byte[] md = mdInst.digest();
	    	StringBuffer sb = new StringBuffer();
	    	for (int i = 0; i < md.length; i++) {
	    		int val = ((int) md[i]) & 0xff;
	    		if (val < 16)
	    			sb.append("0");
	    			sb.append(Integer.toHexString(val));
	    		}
	    		return sb.toString();
	    	} catch (Exception e) {
	    		return null;
	    }
	}
	
	public boolean acceptUser(String userName) throws IOException, InterruptedException{
		String userApplyPath = "/home/crawler/crawlzilla/applyUser/" + userName;
		System.out.println(userApplyPath);
		File UserExists = new File(userApplyPath);
		if(UserExists.exists()){
			String userPathHome = "/home/crawler/crawlzilla/user/";
			String acceptcmd = "mv " + userApplyPath + " " + userPathHome;
			System.out.println(acceptcmd);
			Runtime.getRuntime().exec(acceptcmd);
			Thread.sleep(10);
			return true;
		}
		return false;
	}
	
	public boolean deleteUser(String userName) throws IOException, InterruptedException{
		String userPath = "/home/crawler/crawlzilla/user/" + userName;
		System.out.println(userPath);
		File UserExists = new File(userPath);
		if(UserExists.exists()){
			String deletecmd = "rm -rf " + userPath;
			System.out.println(deletecmd);
			Runtime.getRuntime().exec(deletecmd);
			Thread.sleep(10);
			return true;
		}
		return false;
	}
	
	public static void main(String args[]) throws NoSuchAlgorithmException, IOException, InterruptedException{
		RegisterBean test = new RegisterBean();
		System.out.println("aaa");
		test.deleteUser("shunfatest");
	}
}