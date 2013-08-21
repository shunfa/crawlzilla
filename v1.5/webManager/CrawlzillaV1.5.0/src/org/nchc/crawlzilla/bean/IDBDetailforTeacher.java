package org.nchc.crawlzilla.bean;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.lucene.index.IndexReader;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.getopt.luke.HighFreqTerms;
import org.getopt.luke.IndexInfo;
import org.getopt.luke.TermInfo;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class IDBDetailforTeacher {

	JSONObject termJSONA = new JSONObject();
	JSONObject termJSONB = new JSONObject();
	JSONObject termNode = new JSONObject();
	JSONArray intermJSArray = new JSONArray();
	// Path
	private String Index_Path;
	private String Url_Path;
	private String CreateTime_Path;
	private String Depth_Path;
	private String ExeTime_Path;
	private String JobStatus_Path;

	// this db status
	private int DBstatus;
	// name
	private String userName;
	private String jobName;

	// db info
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
	private String CreateTime;
	private String Depth;
	private String ExeTime;
	private IndexReader reader;
	private IndexInfo indexInfo;

	// private String fieldAll;
	private List<String> fieldNames;

	// list terms with html
	private int topNum; // default = 101
	private String siteTopTerms;
	private String typeTopTerms;
	private String contentTopTerms;

	public void initIDBDetail(String BaseDir, String UserName, String JobName) {

		this.userName = UserName;
		this.jobName = JobName;
		String IDB_Path = BaseDir + UserName + "" + JobName + "/";

		this.Index_Path = IDB_Path + "index";
		this.Url_Path = IDB_Path + "meta/urls/urls.txt";
		this.CreateTime_Path = IDB_Path + "meta/begindate"; // 設定
		// create
		// time
		this.Depth_Path = IDB_Path + "meta/depth"; // 設定
		// depth
		this.ExeTime_Path = IDB_Path + "meta/passtime"; // 設定
		// exetime
		this.JobStatus_Path = IDB_Path + "meta/status";

		this.topNum = 2500;
		this.DBstatus = checkDBstatus();

		try {
			setIDBDetail();
		} catch (IOException e) {
			System.err.println(e.getMessage());
			e.printStackTrace();
		} catch (Exception e) {
			System.err.println(e.getMessage());
			e.printStackTrace();
		}

	}

	public int checkDBstatus() {
		// 0 = ok
		// 1 = meta資料壞損
		// 2 = index 無index 資料夾
		// 3 = 全壞，請檢查目錄是否正常

		// 檢查在meta中的檔案是否完整
		// boolean MetaOK = true;
		int status = 0;
		String[] metafilepath = { this.Url_Path, this.CreateTime_Path,
				this.Depth_Path, this.ExeTime_Path, this.JobStatus_Path };
		for (String i : metafilepath) {
			File file = new File(i);
			if (file.exists() == false)
				status = 1;
		}

		// 檢查是否有 index
		File file = new File(this.Index_Path);
		if (!file.isDirectory())
			status += 2;

		return status;
	}

	public int getDBstatus() {
		return this.DBstatus;
	}

	public int getTopNum() {
		return this.topNum;
	}

	public void setTopNum(int num) {
		this.topNum = num;
	}

	// 主要設定
	// public void setIDBDetail(String Index_Path, String Url_Path)
	public void setIDBDetail() throws Exception, IOException {

		// value in file and method with fault tolerance
		setCreateTime(CreateTime_Path); // 設定 create time
		setDepth(Depth_Path); // 設定 depth
		setExeTime(ExeTime_Path); // 設定 exetime
		setInitURL(Url_Path); // 設定 urls

		// value extracted from index
		if (this.DBstatus < 2) {
			Directory indexPathDir = FSDirectory.open(new File(Index_Path));

			this.reader = IndexReader.open(indexPathDir, false);
			this.indexInfo = new IndexInfo(reader, Index_Path);
			this.fieldsCount = indexInfo.getFieldNames().size();
			this.numDoc = reader.numDocs();
			this.maxDoc = reader.maxDoc();
			this.numDeletedDoc = reader.numDeletedDocs();
			this.numTerm = indexInfo.getNumTerms();
			this.hasDeletion = reader.hasDeletions();
			this.isOptimized = reader.isOptimized();
			this.lastModified = indexInfo.getLastModified();
			this.indexVersion = indexInfo.getVersion();
			this.fieldNames = indexInfo.getFieldNames();
			setSiteTopTerms(); // 列出最多五十個的引用網址
			setTypeTopTerms(); // 列出最多五十個的型態
			setContentTopTerms(); // 列出前五十個字串的內容

		} else {
			this.reader = null;
			this.indexInfo = null;
			this.fieldsCount = 0;
			this.numDoc = 0;
			this.maxDoc = 0;
			this.numDeletedDoc = 0;
			this.numTerm = 0;
			this.hasDeletion = false;
			this.isOptimized = false;
			this.lastModified = "not found";
			this.indexVersion = "not found";
			this.fieldNames = null;
			this.siteTopTerms = "not found";
			this.typeTopTerms = "not found";
			this.contentTopTerms = "not found";
		}

	}

	// 轉成 html 語法
	String strToHTML(TermInfo[] tif) {
		String val = new String();
		val = "<td width=\"10%\"> Order </td>  <td width=\"30%\"> Contents </td> <td width=\"10%\"> Counts </td>";
		val = "<tr>" + val + " <td>    </td>" + val + "</tr>";

		for (int i = 0; i < tif.length; i++) {
			if ((i % 2) == 0) {
				val += "<tr><td>" + i + "</td>" + "<td>" + tif[i].term
						+ "</td>" + "<td>" + tif[i].docFreq
						+ "</td><td>     </td>";
			} else {
				val += "<td>" + i + "</td>" + "<td>" + tif[i].term + "</td>"
						+ "<td>" + tif[i].docFreq + "</td></tr>";
			}
		}
		return val;
	}

	String strToLine(TermInfo[] tif) {
		String val = new String();
		int count = 0;
		for (int i = 1; i < tif.length; i++) {
			if (((tif[i].term.toString().length() > 9) && (count < 300))
					&& !checkDig(splitString(tif[i].term.toString()))) {
				count++;
				val += "Top " + count + ": "
						+ splitString(tif[i].term.toString()) + "\t 出現次數: "
						+ tif[i].docFreq + " "
						+ (tif[i].term.toString().length() - 8) + "\n";

				try {
					_putTermNode(splitString(tif[i].term.toString()),
							tif[i].docFreq);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				System.out.println("_putTermNode("
						+ splitString(tif[i].term.toString()) + ", "
						+ tif[i].docFreq + ");");

			}
		}

		return val;
	}

	String splitString(String strs) {
		String splitString = strs;
		String[] res = splitString.split("content:");
		return res[1];
	}

	boolean checkDig(String str) {
		boolean res = false;
		// char[] str2 = str.toCharArray();
		// for (int index = 0; index < str.length(); index++) {
		// if (Character.isDigit(str2[index])) {
		// res = true;
		// break;
		// }
		// }

		String patternStr = "[0-9a-zA-Z]";
		Pattern pattern = Pattern.compile(patternStr);
		Matcher matcher = pattern.matcher(str);

		boolean matchFound = matcher.find();
		while (matchFound) {
			// System.out.println(matcher.start() + "-" + matcher.end());
			for (int i = 0; i <= matcher.groupCount(); i++) {
				String groupStr = matcher.group(i);
				// System.out.println(i + ":" + groupStr +
				// " is a int or string.");
				res = true;
				break;
			}
			if (matcher.end() + 1 <= str.length()) {
				matchFound = matcher.find(matcher.end());
			} else {
				res = true;
				break;
			}
		}

		return res;
	}

	public void setContentTopTerms() throws Exception {
		String[] field = { "content" };
		TermInfo[] ti = HighFreqTerms.getHighFreqTerms(this.reader, null,
				topNum, field);
		// this.contentTopTerms = strToHTML(ti);
		this.contentTopTerms = strToLine(ti);
	}

	public void setSiteTopTerms() throws Exception {
		String[] field = { "site" };
		TermInfo[] ti = HighFreqTerms.getHighFreqTerms(this.reader, null,
				topNum, field);
		this.siteTopTerms = strToHTML(ti);
	}

	public void setTypeTopTerms() throws Exception {
		String[] field = { "type" };
		TermInfo[] ti = HighFreqTerms.getHighFreqTerms(this.reader, null,
				topNum, field);
		this.typeTopTerms = strToHTML(ti);
	}

	private void setCreateTime(String CreateTime_Path) throws IOException {
		this.CreateTime = readFile(CreateTime_Path);
	}

	private void setDepth(String Depth_Path) throws IOException {
		this.Depth = readFile(Depth_Path);
	}

	private void setExeTime(String ExeTime_Path) throws IOException {
		this.ExeTime = readFile(ExeTime_Path);
	}

	private void setInitURL(String Url_Path) throws IOException {
		this.initURL = readFile(Url_Path);
	}

	private String readFile(String filepath) {
		FileReader fr;
		try {
			fr = new FileReader(filepath);
			BufferedReader fb = new BufferedReader(fr);
			String value = "";
			String input = null;
			while ((input = fb.readLine()) != null) {
				if (value == "")
					value = input;
				else
					value += "<br>" + input;
			}
			fb.close();
			return value;
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			return "not found";
		} catch (IOException e) {
			return "value error";
		}

	}

	public String getUserName() {
		return this.userName;
	}

	public String getIndexPath() {
		return this.Index_Path;
	}

	public List<String> getFieldNames() {
		return this.fieldNames;
	}

	public int getNumDoc() {
		return this.numDoc;
	}

	public int getMaxDoc() {
		return this.maxDoc;
	}

	public int getNumDeletedDoc() {
		return this.numDeletedDoc;
	}

	public int getNumTerm() {
		return this.numTerm;
	}

	public boolean getHasDeletion() {
		return this.hasDeletion;
	}

	public boolean getIsOptimized() {
		return this.isOptimized;
	}

	public String getLastModified() {
		return this.lastModified;
	}

	public String getIndexVersion() {
		return this.indexVersion;
	}

	public int getFieldsCount() {
		return this.fieldsCount;
	}

	public String getCreateTime() {
		return this.CreateTime;
	}

	public String getDepth() {
		return this.Depth;
	}

	public String getExeTime() {
		return this.ExeTime;
	}

	public String getInitURL() {
		return this.initURL;
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

	public void _putTermNode(String name, int size) throws JSONException {
		termNode = new JSONObject();
		termJSONB = new JSONObject();
		termJSONB.put("name", name);
		termNode.put("name", name);
		termNode.put("size", size);
		intermJSArray.put(termNode);
		termJSONA.put("children", intermJSArray);
	}

	public void _setJSON() throws JSONException {
		termJSONA.put("name", "flare");
		System.out.println(termJSONA.toString());
	}

	public static void main(String[] args) throws Exception {
		IDBDetailforTeacher idbt = new IDBDetailforTeacher();
		// idbt.setIDBDetail("/home/waue/0401_6/index","/home/waue/0401_6/meta/urls/urls.txt");
		idbt.initIDBDetail("/home/shunfa/dic_index/wiki", "", "");
		System.out.println(idbt.getContentTopTerms());
		idbt._setJSON();
		System.out.println(idbt.indexInfo.getNumTerms());
		// startLuke(indexpath);
	}

}