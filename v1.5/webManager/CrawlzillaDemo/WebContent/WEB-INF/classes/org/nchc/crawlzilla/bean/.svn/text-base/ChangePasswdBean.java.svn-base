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
 * ChangePasswdBean is used for change web login password
 * @web
 * http://code.google.com/p/crawlzilla 
 * @author Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
 */
package org.nchc.crawlzilla.bean;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class ChangePasswdBean {
	private String oldPasswd;
	private String newPasswd;
	private String checkNewPassword;
	private String passwdPath = "/home/crawler/crawlzilla/system/.passwd";
	public boolean editPasswd() throws IOException {
		FileReader NP = new FileReader(passwdPath);
		BufferedReader stdin = new BufferedReader(NP);
		String crawlerPasswd = new String(stdin.readLine());
		
		if(crawlerPasswd.equals(oldPasswd) && newPasswd.equals(checkNewPassword)){
			File editNP = new File(passwdPath);
			FileWriter fw = new FileWriter(editNP , false);
			fw.write(newPasswd);
			fw.close();
			NP.close();
			return true;
		}
		else {
			NP.close();
			return false;
		}		
	}
	
	public void setOldPasswd(String oldPasswd) {
		this.oldPasswd = oldPasswd;
	}
	public String getOldPasswd() {
		return oldPasswd;
	}
	public void setNewPasswd(String newPasswd) {
		this.newPasswd = newPasswd;
	}
	public String getNewPasswd() {
		return newPasswd;
	}
	public void setCheckNewPassword(String checkNewPassword) {
		this.checkNewPassword = checkNewPassword;
	}
	public String getCheckNewPassword() {
		return checkNewPassword;
	}
}
