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
 * ChangeStrBean is used for change web login password
 * @web
 * http://code.google.com/p/crawlzilla 
 * @author Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
 */
package org.nchc.crawlzilla.bean;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class OperFileBean {
	private String FileStr;

	// private String filepath;

	public OperFileBean(String str, String filepath) throws IOException {
		this.FileStr = str;
		// this.filepath = filepath;

		setFileStr(str, filepath);

	}

	public OperFileBean(String filepath) throws IOException {

		// this.filepath = filepath;
		this.FileStr = readFileStr(filepath);
	}

	public void setFileStr(String str, String filepath) throws IOException {
		File fi = new File(filepath);
		if ( ! fi.exists()) {
			File dirpath = new File(fi.getParent());
			if ( ! dirpath.exists()){
				dirpath.mkdirs();
			}
			if ( ! fi.createNewFile()) {
				//this.FileStr = filepath + ": not found!";
				this.FileStr = "null";
				return ;
			}
		}
		FileWriter fw = new FileWriter(fi, false);
		fw.write(str);
		fw.close();
		// this.filepath = filepath;

	}

	public String readFileStr(String filepath) throws IOException {
		File fi = new File(filepath);
		if (fi.exists()) {
			FileReader NP;
			try {
				NP = new FileReader(filepath);
				BufferedReader stdin = new BufferedReader(NP);
				this.FileStr = new String(stdin.readLine());
				stdin.close();
				NP.close();
			} catch (FileNotFoundException e) {
				//this.FileStr = filepath + ": not found!";
				this.FileStr = "null";
			}

		} else {
//			this.FileStr = filepath + ": not found!";
			setFileStr("null", filepath);
			this.FileStr = "null";
		}
		return this.FileStr;
	}
	
	public String getFileStr(){
		return this.FileStr;
	}

	public static void main( String args[]) throws IOException{
		OperFileBean ofb = new OperFileBean("/home/crawler/crawlzilla/user/admin/meta/email");
		System.out.println(ofb.readFileStr("/home/crawler/crawlzilla/user/admin/meta/email"));
		System.out.println(ofb.readFileStr("/home/crawler/crawlzilla/meta/webAddr"));
	}
}
