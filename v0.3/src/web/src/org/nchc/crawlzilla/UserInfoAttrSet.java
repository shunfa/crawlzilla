package org.nchc.crawlzilla;
/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @guide
 * for UserInfo page set attrbuite
 * @web
 * http://code.google.com/p/crawlzilla 
 * @author Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
 */

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class UserInfoAttrSet {
	// infile is the nutch-site.xml
	private String nutch_site_attr_path = "/opt/crawlzilla/nutch/conf/nutch-site.xml";
	// temp file, maybe should consider the sync atom problem
	private String tmp_nutch_site_path = "/tmp/nutch_site_attr_tmp.txt";
	// orifile is used for backup if first time.
	private String nutch_site_ori_path = "/opt/crawlzilla/nutch/conf/nutch-site.xml.ori";
	// File userinfo = new File("/home/crawler/crawlzilla/system/.userinfo");
	private String userinfo_path = "/home/crawler/crawlzilla/system/.userinfo";
	
	private String EngineName;
	private String Email;
	public UserInfoAttrSet() throws IOException{
		get_att_from_file();
	}

	private void get_att_from_file() throws IOException {
		String str = "";
		File userinfo = new File(userinfo_path);
		
		if (userinfo.exists()){
			BufferedReader br = new BufferedReader(new FileReader(userinfo));
			while ((str = br.readLine()) != null) {
				if (str.contains("NAME")) {
					String[] arr = str.split("=");
					this.EngineName = arr[1].trim();

				} else if (str.contains("EMAIL")) {
					String[] arr = str.split("=");
					this.Email = arr[1].trim();

				} else {
					continue;
				}
			}
			br.close();
		}else{
			this.EngineName = "";
			this.Email = "";
		}
		
	}
	public boolean check_att(String str1, String str2) throws IOException {
		
		// # debug only , because the same as one line return 
		// boolean ret;
		//
		// if((EngineName.equals(str1)) && (Email.equals(str2))){
		// System.out.println("the same");
		// ret = true;
		// }else{
		//
		// System.out.println("name = " + EngineName);
		// System.out.println("str1 = " + str1);
		//				
		// System.out.println("email = " + Email);
		// System.out.println("str2 = " + str2);
		// ret = false;
		// }
		// return ret;
		return ((EngineName.equals(str1)) && (Email.equals(str2))) ? true : false;

	}
	
	public void set_nutch_site_attr(String adm, String eml) throws IOException {
		// infile is the nutch-site.xml
		File attrfile = new File(nutch_site_attr_path);
		// temp file, maybe should consider the sync atom problem
		File tmpfile = new File(tmp_nutch_site_path);
		// orifile is used for backup if first time.
		File orifile = new File(nutch_site_ori_path);
		BufferedReader in = new BufferedReader(new FileReader(attrfile));
		BufferedWriter bw = new BufferedWriter(new FileWriter(tmpfile, false));

		// parse nutch-site.xml and set parameter as a tmp file
		String str;
		while ((str = in.readLine()) != null) {
			if (str.contains("http.agent.name")) {
				bw.write(str + "\n");
				bw.write("  <value>" + adm + "</value>" + "\n");
				str = in.readLine();

			} else if (str.contains("http.agent.email")) {
				bw.write(str + "\n");
				bw.write("  <value>" + eml + "</value>" + "\n");
				str = in.readLine();
			} else {
				bw.write(str + "\n");
			}
		}
		bw.close();
		in.close();

		// let tmp file replace attr file
		boolean ret = true;
		if (orifile.exists()) {
			ret = attrfile.delete();
			if (ret == false)
				System.err.println("delete old error");
		} else {
			ret = attrfile.renameTo(orifile);
			if (ret == false)
				System.err.println("backup ori error");
		}
		if (!attrfile.exists()) {
			tmpfile.renameTo(attrfile);
			if (ret == false)
				System.err.println("write new error");
		} else {
			System.err.println("file existed error");
		}

	}
	
	public void set_userattr(String str1, String str2) throws IOException {
		File userinfo = new File(userinfo_path);
		BufferedWriter bw = new BufferedWriter(new FileWriter(userinfo, false));
		bw.write("NAME=" + str1 + "\n");
		bw.write("EMAIL=" + str2 + "\n");
		bw.close();
	}
	
	public String getEngineName(){
		return this.EngineName;
	}
	
	public String getEmail(){
		return this.Email;
	}

	public static void main(String arg[]) throws IOException {
		String name = "aabbbb";
		String mail = "waue@aaa.bbbc";
		
		UserInfoAttrSet xml = new UserInfoAttrSet();
		System.out.print("file's Engine = " + xml.getEngineName());
		System.out.print("file's email = " + xml.getEmail());

		
		if (xml.check_att(name, mail)) {
			System.out.println("the same, dont work");
		} else {
			System.out.println("set new attr, .. call set_nutch_site_attr");
			xml.set_nutch_site_attr(name, mail);
			xml.set_userattr(name, mail);
		}

	}

}
