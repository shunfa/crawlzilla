<!--
  Copyright 2004 The Apache Software Foundation

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0"
	prefix="i18n"%>
<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>

<%
	String loginFormURL = "adminLogin.jsp";
	String user = (String) session.getAttribute("user");
	if (session.getAttribute("confirm") == "true") {
		String sIPAddress = request.getServerName();
		String lang = (String) session.getAttribute("lang");
		if (lang == null) {
			lang = pageContext.getResponse().getLocale().toString();
			session.setAttribute("lang", lang);
		}
		Locale locale = new Locale(lang, "");
%>
<i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang"
	locale="<%=locale%>" id="bundle" />

<%@ include file="/include/header.jsp"%>
<div id="navcontainer">
<ul id="navlist">
	<li><a href="index.jsp"><i18n:message key="title_Home" /></a></li>
	<li><a href="crawl.jsp"><i18n:message key="title_Crawl" /></a></li>
	<li><a href="nutch_DB.jsp"><i18n:message key="title_DbManage" /></a></li>
	<li><a href="sysinfo.jsp" id="current"><i18n:message
		key="title_SysInfo" /></a></li>
	<li><a href="usersetup.jsp"><i18n:message
		key="title_UserSetup" /></a></li>
	<%
		if (session.getAttribute("confirm") == "true") {
	%>
	<li><a href="logout.jsp"><i18n:message key="title_Logout" /></a></li>
	<%
		} else {
	%>
	<li><a href="adminLogin.jsp"><i18n:message key="title_Login" /></a></li>
	<%
		}
	%>
</ul>
</div>
</div>
<%@ include file="/include/right_side.jsp"%>

<div id="content">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<script type="text/javascript">
	function _refresh() {//alert('test');
		window.location.reload();
	}
	var timer = window.setTimeout(_refresh, 15 * 1000);
</script>

<h3><i18n:message key="title_SysInfo" /></h3>
<div class='featurebox_center'><jsp:useBean id="nutchDBNum"
	class="org.nchc.crawlzilla.NutchDBNumBean" scope="session" /> <jsp:useBean
	id="nutchDBStatus" class="org.nchc.crawlzilla.NutchDBStatusBean"
	scope="session" /> <%
 	nutchDBStatus.setFiles("/home/crawler/crawlzilla/.metadata/");
 		File statusName[] = nutchDBStatus.getFiles();
 		nutchDBNum.setNum("/home/crawler/crawlzilla/.metadata/");
 		int statusNum = nutchDBNum.getNum();
 %> <i18n:message key="sysinfo_DbStatus" /><br>


<table>
	<tr>
		<th><i18n:message key="sysinfo_DbName" /></th>
		<th><i18n:message key="sysinfo_CrawlStatus" /></th>
		<th><i18n:message key="sysinfo_PassTime" /></th>
		<th><i18n:message key="sysinfo_Delete" /></th>
	</tr>
<%
for (int j = 0; j < statusNum; j++) {
	out.print("<form method=\"get\" name=\"dbstatusForm\" >");
	out.print("<tr>");
	// name ( with link url + hidden value)
	out.print("<td>");
	out.print("<a href=\"../" + statusName[j].getName() + "\">");
	out.print("<input type=\"hidden\" name=\"fileName\" value=\""
					+ statusName[j].getName() + " \" >");
	out.print(statusName[j].getName() + "</a>");
	out.print("</td>");
	
	// ps status
	out.print("<td>");
	//FileReader fr = new FileReader(statusName[j] + "/" + statusName[j].getName()); //old
	FileReader fr = new FileReader(statusName[j] + "/status");
	BufferedReader br = new BufferedReader(fr);
	String ps_status = br.readLine();
	out.print(ps_status);
	br.close();
	fr.close();
	out.print("</td>");

	// running time
	out.print("<td>");
	FileReader fr2 = new FileReader(statusName[j] + "/passtime");
	BufferedReader br2 = new BufferedReader(fr2);
	String ps_runtime = br2.readLine();
	out.print(ps_runtime);
	br2.close();
	fr2.close();
	out.print("</td>");
	
	out.print("<td>");
	// fix button if hour > 3 and status  = crawling
	String[] ps_tmp = ps_runtime.split("h:");
	int ps_hour = Integer.parseInt(ps_tmp[0]);
	if ( ps_hour > 2 ){
		if ( ps_status.equals("crawling")){
			out.print("<input type=\"submit\" name=\"Fix\" value=\"Fix Job\" onclick=\"fixDB("
					+ j + ")\" />");
		}
	}	
	
	// delete status
	if ( ps_status.equals("finish") | ps_status.equals("stop") | ps_status.startsWith("error")){
	out.print("<input type=\"submit\" name=\"Delete\" value=\"Delete Status\" onclick=\"deleteDBStatus("
					+ j + ")\" />");
	}
	out.print("</td>");

	out.print("</tr>"); 	
	out.print("</form>");

}
%>
</table>
<body onload="window.scrollTo(0,0);">

<br />
<i18n:message key="sysinfo_JtStatus" />
(
<a target="_new" href=<%out.print("http://" + sIPAddress + ":50030");%>>New
Window</a>
)
<br>
<br>
<iframe id=JobTracker height="350" width="100%" marginheight="0"
	marginwidth="0" scrolling="auto"
	src=<%out.print("http://" + sIPAddress
						+ ":50030/jobtracker.jsp#running_jobs");%>></iframe>
<br>
<br>
<br>
<i18n:message key="sysinfo_NnStatus" />
(
<a target="_new" href=<%out.print("http://" + sIPAddress + ":50070");%>>New
Window</a>
)
<br>
<br>
<iframe height="350" width="100%" marginheight="0" marginwidth="0"
	scrolling="auto" src=<%out.print("http://" + sIPAddress + ":50070");%>></iframe>
<br>
</div>
<%
	} else {
		response.setHeader("Refresh", "0; URL=" + loginFormURL);
	}
%>
<p>&nbsp;</p>
<p>&nbsp;</p>
</div>

<%@ include file="/include/foot.jsp"%>
