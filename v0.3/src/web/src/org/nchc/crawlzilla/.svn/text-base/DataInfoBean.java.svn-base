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
 * 未完成，也還沒開始使用
 */

package org.nchc.crawlzilla;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;

import org.apache.lucene.index.IndexReader;

public class DataInfoBean {

	private String userName;
	private String indexPath;

	private int numDoc;
	private int maxDoc;
	private int numDeletedDoc;
	private int numTerm;
	private boolean hasDeletion;
	private boolean isOptimized;
	private String lastModified;
	private String indexVersion;
	private int fieldsCount;
	private String initURL;
	private IndexReader reader;
	private IndexInfo indexInfo;

//	private String fieldAll;
	private List<String> fieldNames;

	private String siteTopTerms;
	private String typeTopTerms;
	private String contentTopTerms;
	
	private int DBstatus = 1; // 1 = 資料為空
	
	
	public void setDBstatus(int st){
		// 0 = ok
		// 1 = index 資料為空
		// 2 = 資料壞損
		this.DBstatus = st;
	}
	
	public int getDBstatus(){
		return this.DBstatus;
	}
	
	// 主要設定
	public void setDataInfo(String Index_Path, String Url_Path)
			throws Exception, IOException {
		
		
		
		indexPath = Index_Path;
		userName = "crawler";

		reader = IndexReader.open(indexPath, false);
		indexInfo = new IndexInfo(reader, indexPath);

		fieldsCount = indexInfo.getFieldNames().size();

		numDoc = reader.numDocs();
		maxDoc = reader.maxDoc();
		numDeletedDoc = reader.numDeletedDocs();
		numTerm = indexInfo.getNumTerms();
		hasDeletion = reader.hasDeletions();
		isOptimized = reader.isOptimized();
		lastModified = indexInfo.getLastModified();
		indexVersion = indexInfo.getVersion();

		fieldNames = indexInfo.getFieldNames();

		setInitURL(Url_Path); // 設定 initURLs

		setSiteTopTerms(); // 列出最多五十個的引用網址
		setTypeTopTerms(); // 列出最多五十個的型態
		setContentTopTerms(); // 列出前五十個字串的內容
		// 設定狀態
		DBstatus = 0; // 0 = ok
	}
	
	// 轉成 html 語法
	String strToHTML(TermInfo[] tif) {
		String val = new String();
		val = "<td> 排序 </td>  <td> 內容 </td> <td> 引用次數 </td>";
		val = "<tr>" + val + " <td>    </td>" + val + "</tr>";

			for (int i = 0; i < tif.length; i++) {
				if ((i%2) == 0){
					val += "<tr><td>" + i + "</td>" + "<td>" + tif[i].term + "</td>"
					+ "<td>" + tif[i].docFreq + "</td><td>     </td>";				
				}else{
					val += "<td>" + i + "</td>" + "<td>" + tif[i].term + "</td>"
					+ "<td>" + tif[i].docFreq + "</td></tr>";					
				}
			}
		return val;
	}
	
	public void setContentTopTerms() throws Exception {
		String[] field = { "content" };
		TermInfo[] ti  = HighFreqTerms.getHighFreqTerms(this.reader, null,
				51, field);
		this.contentTopTerms = strToHTML(ti);
	}
	public void setSiteTopTerms() throws Exception {
		String[] field = { "site" };
		TermInfo[] ti  = HighFreqTerms.getHighFreqTerms(this.reader, null,
				51, field);
		this.siteTopTerms = strToHTML(ti);
	}

	public void setTypeTopTerms() throws Exception {
		String[] field = { "type" };
		TermInfo[] ti  = HighFreqTerms.getHighFreqTerms(this.reader, null,
				51, field);
		this.typeTopTerms = strToHTML(ti);
	}



	// TODO 改寫 setInitURLs() 初始路徑寫法
	private void setInitURL(String Url_Path) throws IOException {
		FileReader fr = new FileReader(Url_Path);
		BufferedReader fb = new BufferedReader(fr);
		String input = null;
		while ((input = fb.readLine()) != null) {
			if (initURL == null)
				initURL = input + "<br>";
			else
				initURL += input + " <br>";
		}
	}



	public String getUserName() {
		return userName;
	}

	public String getIndexPath() {
		return indexPath;
	}

	public List<String> getFieldNames() {
		return fieldNames;
	}

	public int getNumDoc() {
		return numDoc;
	}

	public int getMaxDoc() {
		return maxDoc;
	}

	public int getNumDeletedDoc() {
		return numDeletedDoc;
	}

	public int getNumTerm() {
		return numTerm;
	}

	public boolean getHasDeletion() {
		return hasDeletion;
	}

	public boolean getIsOptimized() {
		return isOptimized;
	}

	public String getLastModified() {
		return lastModified;
	}

	public String getIndexVersion() {
		return indexVersion;
	}

	public int getFieldsCount() {
		return fieldsCount;
	}

	public String getInitURL() {
		return initURL;
	}
	
	
	public String getContentTopTerms() throws Exception {
		return this.contentTopTerms;
	}

	public String getTypeTopTerms() throws Exception {
		return this.typeTopTerms;
	}

	public String getSiteTopTerms() throws Exception {
		return this.siteTopTerms;
	}
}