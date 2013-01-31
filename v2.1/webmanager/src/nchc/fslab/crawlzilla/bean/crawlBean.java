package nchc.fslab.crawlzilla.bean;

import java.io.FileWriter;
import java.io.IOException;

public class crawlBean {

	boolean crawlJob(String DBName, String urlsText, String depth)
			throws IOException {
		String urlFile = "/opt/crawlzilla/nutch/urls/seeds.txt";
		String cmd = "";
		try {
			FileWriter writeURLFile = new FileWriter(urlFile);
			writeURLFile.write("");
			writeURLFile.append(urlsText + "\n");
			writeURLFile.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

		Runtime.getRuntime().exec(cmd);
		System.out.println(cmd);
		_makeSolrIndex(DBName);
		return true;
	}

	// use shellscript replace this
	boolean _makeSolrIndex(String solrName) throws IOException {
		String cmdCpConf = "cp -r /opt/crawlzilla/solr/example/solr/collection1 /opt/crawlzilla/solr/example/solr/"
				+ solrName;
		// edit /opt/crawlzilla/solr/example/solr/solr.xml
		// <core schema="schema.xml" instanceDir="nchc-from-bean/"
		// name="nchc-from-bean" config="solrconfig.xml" dataDir="data"/>
		Runtime.getRuntime().exec(cmdCpConf);
		String cmd = "/opt/crawlzilla/nutch/bin/nutch solrindex http://127.0.0.1:8983/solr/"
				+ solrName
				+ " /opt/crawlzilla/crawlDB/"
				+ solrName
				+ "/crawldb -linkdb /opt/crawlzilla/crawlDB/"
				+ solrName
				+ "/linkdb /opt/crawlzilla/crawlDB/" + solrName + "/segments/*";
		System.out.println(cmd);
		return true;
	}

	public static void main(String args[]) throws IOException {

		// test function ...
		crawlBean crawlJobs = new crawlBean();
	}
}
