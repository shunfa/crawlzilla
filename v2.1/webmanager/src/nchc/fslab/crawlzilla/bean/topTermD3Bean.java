package nchc.fslab.crawlzilla.bean;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.lucene.index.IndexReader;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.getopt.luke.HighFreqTerms;
import org.getopt.luke.IndexInfo;
import org.getopt.luke.TermStats;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class topTermD3Bean {
	IndexReader indexRder;
	IndexInfo indexInfo;
	int intMaxTermNum;
	JSONObject jsonLv1 = new JSONObject();
	JSONArray jsonLv2 = new JSONArray();
	JSONArray jsonLv3 = new JSONArray();

	@SuppressWarnings("deprecation")
	public void init(String strIndexName) throws Exception {
		String strIndexPath = "/opt/crawlzilla/solr/example/solr/"
				+ strIndexName + "/data/index";
		Directory indexPathDir = FSDirectory.open(new File(strIndexPath));
		indexRder = IndexReader.open(indexPathDir);
		indexInfo = new IndexInfo(indexRder, strIndexPath);
		intMaxTermNum = indexInfo.getNumTerms();
		System.out.println(indexInfo.getIndexPath());
		System.out.println(indexInfo.getNumTerms());
		System.out.println("");
		_getTopTerms(100);
		_genJSONFile(strIndexName);
	}

	public void _getTopTerms(int intNumber) throws Exception {
		jsonLv1.put("name", "flare");
		String[] field = { "content" };
		String[] strArrField;
		int intTOPNum = 0;
		TermStats[] tsSite = HighFreqTerms.getHighFreqTerms(this.indexRder,
				intNumber, field);
		System.out.println("Lenth: " + tsSite.length);
		for (int i = 0; i < tsSite.length; i++) {
			// System.out.println(tsSite[i].docFreq);

			strArrField = tsSite[i].toString().split(":");
			System.out.println("Content:" + strArrField[1] + ", Count:"
					+ strArrField[2]);
			if (!checkDig(strArrField[1])) {
				intTOPNum++;
				System.out.println("TOP: " + intTOPNum + ", Content:"
						+ strArrField[1] + ", Count:" + strArrField[2]);
				jsonLv3.put(_genNameSizeNode(strArrField[1], strArrField[2]));
				jsonLv2.put(_genNameArrNode(strArrField[1], jsonLv3));
				jsonLv3 = new JSONArray();
			}
		}
		jsonLv1.put("children", jsonLv2);
	}

	@SuppressWarnings("unused")
	static boolean checkDig(String str) {
		boolean res = false;
		String patternStr = "[0-9]";
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

	public String getD3JSON() {
		return jsonLv1.toString();
	}

	public static JSONObject _genNameSizeNode(String strName, String strCount2)
			throws JSONException {
		JSONObject returnObj = new JSONObject();
		returnObj.put("name", strName);
		returnObj.put("size", strCount2);
		return returnObj;
	}

	public static JSONObject _genNameArrNode(String strName, JSONArray arr)
			throws JSONException {
		JSONObject returnObj = new JSONObject();
		returnObj.put("name", strName);
		returnObj.put("children", arr);
		return returnObj;
	}

	public void _genJSONFile(String strIDBName) throws IOException {
		File saveFile = new File("/opt/crawlzilla/tomcat/webapps/crawlzilla/"+strIDBName + ".json");
		FileWriter fwriter = new FileWriter(saveFile);
		fwriter.write(jsonLv1.toString());
		fwriter.close();
	}
	
	public String getJSONStr(String strIDBName) throws IOException {
		return jsonLv1.toString();
	}

	public static void main(String args[]) throws Exception {
		topTermD3Bean tTD = new topTermD3Bean();
		tTD.init("wiki_1");
		System.out.println("Max Term Number = " + tTD.intMaxTermNum);
//		tTD.genJSONFile("wiki_1");
	}
}