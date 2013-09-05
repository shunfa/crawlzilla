package nchc.fslab.crawlzilla.bean;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class searchUIBean {
	int intQtime = 0, intStatus = 0, intNumberFound = 0, intStart = 0,
			intEnd = 0, intRowNOs = 0;
	public String strHTML = "";
	public String strInfoHTML = "";
	public String strPagesHTML = "";
	public String strKeyWord = "";
	public String strIDBName = "";
	public String strQuery = "";
	private URLConnection connection;

	public String _connect(String strIPAddress, String strPortNO,
			String strIDBName, String strQuery, int intStart, int intRowNO) {
		try {

			String urlString = "http://" + strIPAddress + ":" + strPortNO
					+ "/solr/" + strIDBName + "/select?q=" + strQuery
					+ "&start=" + intStart + "&rows=" + intRowNO + "&wt=json";
			this.intRowNOs = intRowNO;
			this.strKeyWord = strQuery;
			this.strQuery = strQuery;
			this.strIDBName = strIDBName;
			URL url = new URL(urlString);
			connection = url.openConnection();
			// System.out.println(connection.getClass());
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return _readContents();
	}

	private String _readContents() {
		BufferedReader in = null;
		String inputLine = "";
		String inputJSONLine = "";
		int intLineNo = 0;
		try {
			in = new BufferedReader(new InputStreamReader(
					connection.getInputStream()));

			String htmlstr = "";
			int wordcount = 0;
			while ((inputLine = in.readLine()) != null) {
				if (intLineNo == 0) {
					inputJSONLine = inputLine;
					// System.out.println("====" + inputJSONLine);
				}
				inputLine += inputLine;
				htmlstr = htmlstr + inputLine;
				wordcount = wordcount + inputLine.length();
				intLineNo++;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}

		return inputJSONLine;
	}

	public void _parseJSON(String strJSON) throws JSONException,
			UnsupportedEncodingException {

		String strContent = "", strTitle = "", strURL = "", strTS = "";
		// System.out.println("--strJSON---" + strJSON);
		JSONObject jsonObjResult = new JSONObject(strJSON);
		JSONObject jsonObjResponseHeader = new JSONObject();
		JSONObject jsonObjResponse = new JSONObject();
		JSONObject jsonObjDocContent = new JSONObject();
		JSONObject jsonObjParams = new JSONObject();
		JSONArray jsonArrayDoc = new JSONArray();
		jsonObjResponseHeader = jsonObjResult.getJSONObject("responseHeader");
		jsonObjResponse = jsonObjResult.getJSONObject("response");
		jsonArrayDoc = jsonObjResponse.getJSONArray("docs");
		jsonObjParams = jsonObjResponseHeader.getJSONObject("params");
		this.intStatus = jsonObjResponseHeader.getInt("status");
		this.intQtime = jsonObjResponseHeader.getInt("QTime");
		this.intNumberFound = jsonObjResponse.getInt("numFound");
		this.intStart = jsonObjResponse.getInt("start") + 1;
		this.intEnd = intStart + this.intRowNOs;
		System.out.println("jsonArrayDoc length = " + jsonArrayDoc.length());
		for (int i = 0; i < jsonArrayDoc.length(); i++) {
			jsonObjDocContent = jsonArrayDoc.getJSONObject(i);
			if (jsonObjDocContent.has("content")) {
				strContent = jsonObjDocContent.getString("content");
			} else {
				strContent = " no content";
			}
			if (jsonObjDocContent.has("title")) {
				strTitle = jsonObjDocContent.getString("title");
			} else {
				strTitle = " no title";
			}
			if (jsonObjDocContent.has("url")) {
				strURL = jsonObjDocContent.getString("url");
			} else {
				strURL = "#";
			}
			if (jsonObjDocContent.has("tstamp")) {
				strTS = jsonObjDocContent.getString("tstamp");
			} else {
				strTS = "no tstamp";
			}
			if (jsonObjDocContent.getString("content").length() > 30) {
				strContent = jsonObjDocContent.getString("content").substring(
						0, 300)
						+ "...<br>";
			}
			System.out.println("strTitle = " + strTitle + ", strContent = "
					+ strContent + ", strURL = " + strURL + ", strTS = "
					+ strTS);
			_addResult(strURL, strContent, strTS, strTitle);

		}
		System.out.println("Q-" + jsonObjParams.get("q"));
		System.out.println("Q-utf8: "
				+ URLEncoder.encode((String) jsonObjParams.get("q"), "UTF-8"));
		_setPageInfo(this.strIDBName, this.strQuery, this.intStart,
				this.intEnd, this.intRowNOs, this.intNumberFound);

	}

	public void _addResult(String strURL, String strContent, String strTS,
			String strTitle) {
		this.strHTML += "<p>" + "<a href=\"" + strURL + "\">" + strTitle
				+ "</a><br> <a	href=\"" + strURL + "\"><font	color=\"green\">"
				+ strURL + "</font></a><br>" + strContent
				+ "<font size=\"2pt\"><i>" + strTS + "</i></font><br><br></p>";
	}

	public String getInfoHTML() {
		String a = "<h1>KeyWord: " + this.strKeyWord + ", total Result: "
				+ this.intNumberFound + " Spent: " + intQtime
				+ "ms</h1>		<h2> 	Record <i>" + this.intStart + "</i> to <i>"
				+ this.intEnd + "</i>	</h1>";
		return a;
	}

	public String _setPageInfo(String stIDBName, String strQuery, int inStart,
			int inEnd, int inRows, int intTotal) {
		String strNextHref = "";
		String strPreHref = "Previous";
		int intPrePage = 0;
		if (inEnd < intTotal) {
			strNextHref = "<a	href=\"searchResult.jsp?IDB=" + stIDBName + "&q="
					+ strQuery + "&start=" + (inStart + inRows - 1) + "&rows="
					+ inRows + "\">Next</a>";
		} else {
			strNextHref = "Next";
		}

		if (inStart > 1) {
			intPrePage = inStart - inRows;
			if (intPrePage < 0) {
				intPrePage = 0;
			}
			strPreHref = "<a href=\"searchResult.jsp?IDB=" + stIDBName + "&q="
					+ strQuery + "&start=" + intPrePage + "&rows=" + inRows
					+ "\">Previous</a>";
		} else if (inStart < 1) {
			strPreHref = "Previous";
		}
		this.strPagesHTML = strPreHref + " ------ Records ------ "
				+ strNextHref;

		return this.strPagesHTML;
	}

	public void initAndSetup(String strIPAddress, String strPortNO,
			String strIDBName, String strQuery, int intStart, int intRowNO)
			throws JSONException, UnsupportedEncodingException {
		this.strInfoHTML = "";
		this.strHTML = "";
		this.strPagesHTML = "";
		// TODO: check solr service
		// String strQueryt = new String(strQuery.getBytes("BIG5"));

		_parseJSON(_connect(strIPAddress, strPortNO, strIDBName, strQuery,
				intStart, intRowNO));
	}

	public String getResultHTML() {
		return this.strHTML;
	}

	public String getPageInfo() {
		return this.strPagesHTML;
	}

	public int getStatus() {
		return this.intStatus;
	}

	public int getQTime() {
		return this.intQtime;
	}

	public int getNumberFound() {
		return this.intNumberFound;
	}

	public int getStart() {
		return this.intStart;
	}

	public static void main(String args[]) throws IOException, JSONException {
		searchUIBean sUI = new searchUIBean();
		sUI.initAndSetup("140.110.102.61", "8983", "wiki_1", "中", 0, 20);
		// System.out.println("getStatus = " + sUI.getStatus() + ", getQTime = "
		// + sUI.getQTime() + ", Number Found = " + sUI.getNumberFound());
		System.out.println(sUI.getResultHTML());
		// System.out.println(sUI.strPagesHTML);
	}
}
