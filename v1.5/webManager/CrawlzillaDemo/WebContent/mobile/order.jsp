<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>System Message</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="http://code.jquery.com/mobile/1.0.1/jquery.mobile-1.0.1.min.css" />
<script type="text/javascript" language="javascript"
	src="js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" language="javascript"
	src="js/jquery.mobile-1.0.1.min.js"></script>
<link type="text/css"
	href="http://dev.jtsage.com/cdn/datebox/latest/jquery.mobile.datebox.min.css"
	rel="stylesheet" />
<script type="text/javascript"
	src="http://dev.jtsage.com/cdn/datebox/latest/jquery.mobile.datebox.min.js"></script>
</head>
<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.text.SimpleDateFormat"%>
<jsp:useBean id="nutchDBNum"
	class="org.nchc.crawlzilla.bean.NutchDBNumBean" scope="session" />
<jsp:useBean id="nutchDBStatus"
	class="org.nchc.crawlzilla.bean.NutchDBStatusBean" scope="session" />
<jsp:useBean id="orderinfo" class="org.nchc.crawlzilla.bean.orderBean"
	scope="session" />
<%
	//String loginFormURL = "login.jsp";
	//String user = (String) session.getAttribute("userName");
	String userName = "admin";
	//	if (session.getAttribute("loginFlag") == "true") {
	//		System.out.println("has been login!");
	//		String userName = session.getAttribute("userName").toString();
	//		String lang = session.getAttribute("language").toString();
	//		Locale locale = new Locale(lang);
%>
<%
	// 變數宣告-爬取完成之清單
	// TODO 目前僅寫單人admin version
	String IDBfolderPath = "/home/crawler/crawlzilla/user/" + userName
			+ "/IDB";
	nutchDBNum.setNum(IDBfolderPath);
	int IDBNum = nutchDBNum.getNum();
	nutchDBStatus.setFolders(IDBfolderPath);
	File IDBfoldersName[] = nutchDBStatus.getFolders();
	String masterIPAddress = request.getServerName();
	String orders = orderinfo.parserConf(userName);
%>
<body>

	<div data-role="content">
		<h2>Index-pool Scheduling</h2>

		<form id="form1" method="post" action="xxx.do">
			<p class="info noprint">
				Select the index database： <select name="IDBName" id="IDBName">
					<option selected="selected">select</option>
					<%
						// implement IDB list
						for (int j = 0; j < IDBNum; j++) {
							try {
								out.print("<option value=\"" + IDBfoldersName[j].getName()
										+ "\">" + IDBfoldersName[j].getName() + "</option>");
							} catch (NullPointerException e) {
								out.print("<option value=\"null\"> no indexpool</option>");
							}
						}
					%>
				</select>
			</p>
			<div data-role="fieldcontain">
				<label for="mydate">Date</label><p></p><input name="mydate" id="mydate"
					type="date" data-role="datebox"
					data-options='{"mode": "calbox","dateFormat": "mm/dd/YYYY"}'>
			</div>
			<label for="scheduleTime"></label>
			<p></p>
			<div data-role="fieldcontain">
				時: <select name="scheduleTimeHr" size="0" id="scheduleTimeHr">

					<%
						for (int i = 0; i <= 23; i++) {
							out.print("<option value=\"" + i + "\">"
									+ ((i < 10) ? "0" : "") + i + "</option>");
						}
					%>
				</select> <label for="scheduleTimeMin"></label>
			</div>
			<div data-role="fieldcontain">
				分 <select name="scheduleTimeMin" id="scheduleTimeMin">
					<%
						for (int i = 0; i <= 60; i++) {
							out.print("<option value=\"" + i + "\">"
									+ ((i < 10) ? "0" : "") + i + "</option>");
						}
					%>
				</select>
			</div>
			</p>
		</form>
		<p>
			<input type="submit" name="button3" id="button3" value="Submit" />
		</p>
		<!-- TODO: Scheduling -->
	</div>



	<div data-role="footer">
		<h4>
			<a href="javascript:history.back();">Back </a>
		</h4>
	</div>
</body>
</html>