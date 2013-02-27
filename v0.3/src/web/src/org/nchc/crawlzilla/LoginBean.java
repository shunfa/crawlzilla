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
 * javabean for setting or getting password
 * @web
 * http://code.google.com/p/crawlzilla 
 * @author Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
 */
package org.nchc.crawlzilla;/**

 * 
 * 
 * @web
 * <a href="http://code.google.com/p/crawlzilla/">http://code.google.com/p/crawlzilla </a>
 * 
 * @author Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
 * 
 */
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class LoginBean {
	private String passWord;
	private boolean ChangePasswdFlag = false;

	public boolean getConfirm() throws IOException {
		FileReader NP = new FileReader("/home/crawler/crawlzilla/system/.passwd");
		BufferedReader stdin = new BufferedReader(NP);
		String crawlerPasswd = new String(stdin.readLine());
		if (crawlerPasswd.equals(passWord)
				&& crawlerPasswd.equals("crawler")) {
			ChangePasswdFlag = true;
		}

		if (crawlerPasswd.equals(passWord)) {
			NP.close();
			return true;
		} else {
			NP.close();
			return false;
		}		
	}

	public void setPassWord(String passWord) {
		this.passWord = passWord;
	}

	public String getPassWord() {
		return passWord;
	}

	public void setChangePasswdFlag(boolean ChangePasswdFlag) {
		this.ChangePasswdFlag = ChangePasswdFlag;
	}

	public boolean getChangePasswdFlag() {
		return ChangePasswdFlag;
	}
}
