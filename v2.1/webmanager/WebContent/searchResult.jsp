<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8"%>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>Crawlzilla Search Engine</title>
<meta name="description" content="">
<meta name="viewport"
	content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;">
<meta name="HandheldFriendly" content="True">
<meta name="MobileOptimized" content="320">

<!-- Favicon.ico placeholder -->
<link rel="shortcut icon" href="imgs/ink-favicon.ico">

<!-- Apple icon placeholder -->
<link rel="apple-touch-icon-precomposed" href="imgs/touch-icon.57.png">
<link rel="apple-touch-icon-precomposed" sizes="72x72"
	href="imgs/touch-icon.72.png">
<link rel="apple-touch-icon-precomposed" sizes="114x114"
	href="imgs/touch-icon.114.png">

<!-- Apple splash screen placeholder -->
<link rel="apple-touch-startup-image" href="imgs/splash.320x460.png"
	media="screen and (min-device-width: 200px) and (max-device-width: 320px) and (orientation:portrait)">
<link rel="apple-touch-startup-image" href="imgs/splash.768x1004.png"
	media="screen and (min-device-width: 481px) and (max-device-width: 1024px) and (orientation:portrait)">
<link rel="apple-touch-startup-image" href="imgs/splash.1024x748.png"
	media="screen and (min-device-width: 481px) and (max-device-width: 1024px) and (orientation:landscape)">

<!-- Stylesheets -->
<link rel="stylesheet" href="./css/ink.css">
<jsp:useBean id="getDBInfoBean"
	class="nchc.fslab.crawlzilla.bean.infoOperBean" scope="session" />
<jsp:useBean id="getSearchResultBean"
	class="nchc.fslab.crawlzilla.bean.searchUIBean" scope="session" />
<!--[if IE]>
			<link rel="stylesheet" href="./css/ink-ie.css" type="text/css" media="screen" title="no title" charset="utf-8">
		<![endif]-->

</head>
<%
	response.setContentType("text/html; charset=utf-8");
	request.setCharacterEncoding("utf-8");
	String strIPAddress = getDBInfoBean.getIPAddr();
	String strIDBName = request.getParameter("IDB");
	String strQuery = request.getParameter("q");
	int intStart = Integer.parseInt(request.getParameter("start"));
	int intRows = Integer.parseInt(request.getParameter("rows"));
	int intEndRecord = intStart + intRows;
	if (intEndRecord > getSearchResultBean.getNumberFound()) {
		intEndRecord = getSearchResultBean.getNumberFound();
	}
	if (intStart == 0) {
		intStart++;
	}
	getSearchResultBean.initAndSetup(strIPAddress, "8983", strIDBName,
			strQuery, intStart, intRows);
	// getSearchResultBean.parseJSON(strJSSON);
	//out.println("strIDBName = " + getSearchResultBean.connect(strIPAddress, "8983",
	//	strIDBName, strQuery, intStart, intRows));
	//out.println("getSearchResultBean.connect(" + strIPAddress
	//		+ ", \"8983\",	" + strIDBName + ", " + strQuery + ", "
	//		+ intStart + ", " + intRows + ");");
%>
<body>

	<!-- Add your site or application content here -->

	<header class="ink-container ink-for-l">
		<div class="ink-vspace">
			<h1 class="">
				<a href="search.jsp"><img
					src="imgs/crawlzilla-header-signbo.png"></a>
			</h1>
			<p>Your Own Search Engine Here!</p>
		</div>
	</header>

	<div class="displayResult"
		style="padding: 30px 60px 90px 120px; border: 0px solid;">
		<h1>
			KeyWord:
			<%=strQuery%>, total Result:
			<%=getSearchResultBean.getNumberFound()%>, Spent:
			<%=getSearchResultBean.getQTime()%>ms
		</h1>
		<h2>
			Record <i><%=intStart%></i> to <i><%=intEndRecord%></i>
			</h1>
			<div class="pages">
				<p align="center">
					<%=getSearchResultBean.getPageInfo()%>
				</p>
			</div>
			<%=getSearchResultBean.getResultHTML()%>
	</div>
	<div class="pages">
		<p align="center">
			<%=getSearchResultBean.getPageInfo()%>
		</p>

	</div>
	<footer>
		<div class="ink-container">
			<nav class="ink-navigation">
				<ul class="ink-footer-nav">
					<li><a href="https://github.com/shunfa/crawlzilla">Crawlzilla@GitHub</a></li>
					<li><a href="http://nutch.apache.org/">Nutch</a></li>
					<li><a href="http://lucene.apache.org/solr/">Solr</a></li>
				</ul>
			</nav>
			<p class="copyright">
				Power by Free Software Lab <a href="http://www.nchc.org.tw/tw/">NCHC
					Taiwan</a>.<br> Template by Stuff.
			</p>
		</div>
	</footer>
</body>
</html>
