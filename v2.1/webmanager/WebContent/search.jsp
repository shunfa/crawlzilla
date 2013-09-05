<!DOCTYPE html>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="org.apache.naming.java.javaURLContextFactory"%>
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
	String strIDBName = "";
	if (request.getParameter("IDB") != null) {
		strIDBName = request.getParameter("IDB");
	}
%>
<script type="text/javascript">
	var url = window.location.toString();
	var str = "";
	var strIDBName = "";
	if (url.indexOf("?") != -1) {
		var ary = url.split("?")[1].split("&");
		for ( var i in ary) {
			str = ary[i].split("=")[0];
			if (str == "IDB") {
				strIDBName = decodeURI(ary[i].split("=")[1]);
			}
		}
	}

	function searchResultPage() {
		var keyWord = document.searchIN.searchKey.value;
		// &q="+keyWord+"&start=0&rows=10"

		// searchResult.jsp?IDB=wiki_1&q=國網&start=11&rows=10
		location.href = "searchResult.jsp?IDB=" + strIDBName + "&q=" + keyWord
				+ "&start=0&rows=10";
	}
</script>

<body>

	<!-- Add your site or application content here -->
	<header class="ink-container ink-for-l"> </header>
	<div class="searchUI" style="padding: 30px 60px 90px 120px;">
		<p>
			<a href="search.jsp?IDB=<%=strIDBName%>"><img
				src="imgs/crawlzilla-logo.png"></a>
		</p>
		<br>
		<form name="searchIN" action="javascript:searchResultPage()">

			<input type="text" name="searchKey" />
			<button type="button" onclick="searchResultPage()">Search</button>
		</form>
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
