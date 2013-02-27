package org.nchc.crawlzilla.bean;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;

import org.nchc.crawlzilla.bean.sendMailBean;
import org.nchc.crawlzilla.bean.OperFileBean;

public class RegisterBean {
	String home_user = "/home/crawler/crawlzilla/user/";
	String home_applyuser = "/home/crawler/crawlzilla/applyUser/";
	
	public boolean checkUserExist(String userName){
		File UserExists = new File(home_user + userName);
		File UserApplyExists = new File(home_applyuser + userName);
		if((UserExists.exists()) ){
			System.out.println("user exist!");
			return true;
		}
		if(UserApplyExists.exists()){
			System.out.println("user applying!");
			return true;
		}
		return false;
	}
	
	public boolean regNewUser(String newUser, String passwd, String email)  {
		
		if (checkUserExist(newUser)) {
			System.out.println("Can't register this user" + newUser);
			return false;
		}
		
		String home_applyuser_user = home_applyuser + newUser;
		
		/*
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
		Runtime.getRuntime().exec("cp /home/crawler/crawlzilla/user/admin/meta/weblang " + userPathHome + "/meta/");
		Thread.sleep(10);
		
		Thread.sleep(10);
		*/
		File dir_path;
		String[] dirs = {"/tmp", "/IDB", "/old", "/webs", "/meta"};
		for ( String dir : dirs){
			dir = home_applyuser_user + dir;
			dir_path = new File(dir);
			dir_path.mkdirs();
		}

		File user_home_passwd = new File( home_applyuser_user + "/meta/passwd");
		File user_home_email = new File( home_applyuser_user + "/meta/email");

		BufferedWriter foutWriter;
		try {
			foutWriter = new BufferedWriter(new FileWriter(user_home_passwd ));
			foutWriter.write(MD5(passwd));
			foutWriter.flush(); // passwd_file would be null without this line
			foutWriter = new BufferedWriter(new FileWriter(user_home_email));
			foutWriter.write(email);
			foutWriter.close();
			//# ok
			return true;
		} catch (IOException e) {
			System.err.println("RegisterBean.regNewUser:" +e.getMessage());
			return false;
		}
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
	    		System.err.print(e.getMessage());
	    		return null;
	    }
	}
	
	public boolean acceptUser(String userName) throws IOException, InterruptedException, AddressException, MessagingException{


		File UserExists = new File(home_applyuser + userName);
		if(UserExists.exists()){
			
			//send mail to user
			OperFileBean operFile1 = new OperFileBean(home_applyuser + userName + "/meta/email");
			String memberEmail = operFile1.getFileStr();
			String webAddr = operFile1.readFileStr("/home/crawler/crawlzilla/meta/webAddr");
			String msg = "We are pleased to inform you that your account has been accepted. " +
					" \n\nPlease visit " + webAddr +" to build your search engine! " +
					"\n\nThank you for use crawlzilla.\n\n";
			String title = "Your account has been accecpted "; 
			
			sendMailBean sendMail = new sendMailBean();
			System.out.println("send mail to : "+ memberEmail);
			sendMail.sendMail(title, memberEmail, msg);
			
			//# move directory
			String acceptcmd = "mv " + home_applyuser + userName + " " + home_user;
			
			Runtime.getRuntime().exec(acceptcmd);
			Thread.sleep(2);
			return true;
		}
		return false;
	}
	
	public boolean deleteUser(String userName) throws IOException, InterruptedException, AddressException, MessagingException{
		String userPath = home_user + userName;
		System.out.println(userPath);
		File UserExists = new File(userPath);
		if(UserExists.exists()){

			
			//send mail
			OperFileBean operFile1 = new OperFileBean(home_user + userName + "/meta/email");
			String memberEmail = operFile1.getFileStr();
			
			String webAddr = operFile1.readFileStr("/home/crawler/crawlzilla/meta/webAddr");
			String title = "Your account has been deleted ";
			String setMsg = "We are sorry about that to delete your account, \n\n" +
					"if you want to try crawlzilla again, \n\n" +
					"please visit " + webAddr +" and apply account again. \n\n" +
					"Thank you for use crawlzilla. \n\n";
			sendMailBean sendMail = new sendMailBean();
			
			System.out.println("send mail to : "+ memberEmail);
			sendMail.sendMail(title, memberEmail, setMsg);
			
			//# delete directory
			String deletecmd = "rm -rf " + userPath;
			System.out.println(deletecmd);
			Runtime.getRuntime().exec(deletecmd);
			Thread.sleep(1);
			
			return true;
		}
		return false;
	}
	
	public void callSendMail(String memberMail,String title, String setMsg) throws IOException, AddressException, MessagingException, InterruptedException{
		sendMailBean sendMail = new sendMailBean();
		sendMail.sendMail(title, memberMail, setMsg);
	}
	
	public static void main(String args[]) throws NoSuchAlgorithmException, IOException, InterruptedException, AddressException, MessagingException{
		RegisterBean test = new RegisterBean();
		
		String newuser = "weiyuchen";

		System.out.println("reg:" + test.regNewUser(newuser, "1234", "waue0920@gmail.com"));
		System.out.println("acc:" + test.acceptUser(newuser));
		System.out.println("del:" + test.deleteUser(newuser));

	}
}