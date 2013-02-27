<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Index Database Information</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="http://code.jquery.com/mobile/1.0.1/jquery.mobile-1.0.1.min.css" />
<script type="text/javascript" language="javascript"
	src="js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" language="javascript"
	src="js/jquery.mobile-1.0.1.min.js"></script>
<jsp:useBean id="miDBDetail"
	class="org.nchc.crawlzilla.bean.mIDBDetailBean" scope="session" />
<%
	String loginFormURL = "login.jsp";
	String portNO = "8080";
	String user = (String) session.getAttribute("userName");
	if (session.getAttribute("loginFlag") == "true") {
		System.out.println("has been login!");
		String userName = session.getAttribute("userName").toString();
		//portNO = session.getAttribute("portNO").toString();
		String lang = session.getAttribute("language").toString();
		Locale locale = new Locale(lang);
	}
%>

<%
	String BaseDir = "/home/crawler/crawlzilla/user/";
	String IDBName = request.getParameter("IDB").trim();
	String UserName = request.getParameter("USERNAME").trim();
	String masterIPAddress = request.getServerName();

	//String UserName = "admin";
	//String IDBName = "0412_1";
	//iDBDetail.setTopNum(101); // default is 101 in IDBDetailBean.java
	miDBDetail.initIDBDetail(BaseDir, UserName, IDBName);
	String IDB_Path = BaseDir + UserName + "/IDB/" + IDBName + "/";
	int st = miDBDetail.getDBstatus();
	String StatusExplaintion;
	if (st == 0) {
		StatusExplaintion = "OK";
	} else if (st == 1) {
		StatusExplaintion = "Meta Error <br> please check meta path :"
				+ IDB_Path + "meta";
	} else if (st == 2) {
		StatusExplaintion = "Index Error <br> please check index path :"
				+ IDB_Path + "index";
	} else if (st == 3) {
		StatusExplaintion = "DB Error <br> please check Index DB path :"
				+ IDB_Path;
	} else {
		StatusExplaintion = "[bug] Status Error!";
	}
%>
</head>
<body>
	<div data-role="content">
		<div class="content-primary">
			<div class="content-primary">
				<ul data-role="listview">
					<h2>About Search Engine NCHC_3</h2>
					<li data-role="list-divider">
						<h3>Basic Information</h3>
						<ul>
							<li>Index Database Name: <%=IDBName%></li>
							<li>Search engine links: ${ miDBDetail.indexPath}</li>
							<li>Search Engine Status: <%=StatusExplaintion%></li>
							<li>Crawl Depth: ${miDBDetail.depth }</li>
							<li>Create Time: ${miDBDetail.createTime}</li>
							<li>Execution time: ${miDBDetail.exeTime}</li>
							<li>Start Links:
								<p>
									<strong><p>${miDBDetail.initURL}</p> </strong>
								</p>
							</li>
							<li><a href="javascript:history.back();">Back </a></li>
					</li>
				</ul>
				</li>
				<h3>Indexed database content NCHC_3</h3>
				<li data-role="list-divider">
					<h3>Data Overview</h3>
					<ul>
						<li>Total number of words: ${miDBDetail.numTerm }</li>
						<li>The number of document file: ${miDBDetail.numDoc }</li>
						<li>Index Library Update Date: ${miDBDetail.lastModified }</li>
						<li><a href="javascript:history.back();">Back </a></li>
					</ul></li>
				<li data-role="list-divider">
					<h3>Search Analysis of Websites</h3>
					<ul>
						<jsp:getProperty name="miDBDetail" property="siteTopTerms" />
						<li><a href="javascript:history.back();">Back </a></li>
					</ul></li>
				<li data-role="list-divider">
					<h3>Analysis of the Document Types</h3>
					<ul>
						<jsp:getProperty name="miDBDetail" property="typeTopTerms" />
						<li><a href="javascript:history.back();">Back </a></li>
					</ul></li>
				<li data-role="list-divider">
					<h3>Top 100 Words</h3>
					<ul>
						<jsp:getProperty name="miDBDetail" property="contentTopTerms" />
						<li><a href="javascript:history.back();">Back </a></li>
					</ul></li>
				<h3>Operations</h3>
				<label for="oper"></label> <select name="oper" id="oper">
					<option value="0">Select</option>
					<option value="1">Re-Crawl</option>
					<option value="2">Delete IDB</option>
				</select>

				</ul>
				</dvi>
			</div>
		</div>
		<p></p><p></p><p></p><p></p>
		<div data-role="footer">		
			<h4>
				<a href="javascript:history.back();">Back </a>
			</h4>
			
		</div>
</body>
</html>