package nchc.fslab.crawlzilla.bean;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.security.MessageDigest;

public class adminLoginBean {
	public boolean adminLogin(String passwd) {
		if (_MD5(passwd).equals(_getPasswd())) {
			System.out.println("Password OK!");
			return true;
		}
		return false;
	}

	public String _getPasswd() {
		FileReader NP;
		String adminPasswd = null;
		try {
			NP = new FileReader("/opt/crawlzilla/.meta/passwd");
			BufferedReader stdin = new BufferedReader(NP);
			adminPasswd = new String(stdin.readLine());
			NP.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		System.out.println(adminPasswd);
		return adminPasswd;
	}

	public final static String _MD5(String s) {
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

	public void changePW(String newPW) throws IOException, InterruptedException {
		String passwdPath = "/opt/crawlzilla/.meta/passwd";
		File passwdFile = new File(passwdPath);
		Thread.sleep(10);
		FileWriter fout = new FileWriter(passwdFile);
		BufferedWriter foutWriter = new BufferedWriter(fout);
		foutWriter.write(_MD5(newPW));
		foutWriter.newLine();
		foutWriter.close();
	}

	public static void main(String args[]) throws IOException,
			InterruptedException {
		adminLoginBean aLB = new adminLoginBean();
		System.out.println(aLB.adminLogin("crawler"));
	}
}
