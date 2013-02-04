<!DOCTYPE html>
<%@page import="java.io.File"%>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>Crawlzilla Management - v2.1</title>
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
<jsp:useBean id="getDBListBean"
	class="nchc.fslab.crawlzilla.bean.getDBListBean" scope="session" />
<jsp:useBean id="getDBInfoBean"
	class="nchc.fslab.crawlzilla.bean.infoOperBean" scope="session" />
<!--[if IE]>
			<link rel="stylesheet" href="./css/ink-ie.css" type="text/css" media="screen" title="no title" charset="utf-8">
		<![endif]-->

</head>
<body>
	<%
		File dbName[] = getDBListBean.getFolders();
	%>
	<header class="ink-container ink-for-l">
		<div class="ink-vspace">
			<h1 class="">Crawlzilla Management</h1>
			<p>Make Your Own Search Engine Friendly!</p>
		</div>
	</header>

	<nav class="ink-container ink-navigation">
		<ul class="horizontal menu">
			<li><a href="index.jsp">Home</a></li>
			<li><a href="crawljob.jsp">Crawl Job</a></li>
			<li class="active"><a href="searchManager.jsp">Search Engine
					Manager</a></li>
			<li><a href="settings.jsp">Settings</a></li>
			<li><a href="login.jsp">Login/Logout</a></li>
		</ul>
	</nav>

	<header class="ink-container ink-for-m ink-for-s">
		<div class="ink-vspace"></div>
	</header>

	<div class="ink-container ink-vspace">
		<h1 class="">Seaech Engine List</h1>
		<table width="100%" height="121" border="0">
			<tr>
				<td align="center" valign="middle"><strong>CrawlDB
						Name</strong></td>
				<td align="center" valign="middle"><strong>Create Time</strong></td>
				<td align="center" valign="middle"><strong>Spend(H:M:S)</strong></td>
				<td align="center" valign="middle"><strong>Depth</strong></td>
				<td align="center" valign="middle"><strong>Operation</strong></td>
			</tr>
			<%
				for (int i = 0; i < getDBListBean.getDBNum(); i++) {
			%>
			<tr>
				<form id="db_opera" method="post" action="dbopera.do">
					<td align="center" valign="middle"><%=dbName[i].getName()%></td>
					<td align="center" valign="middle"><%=getDBInfoBean.getMessage(dbName[i].getName(),
						"create_time")%></td>
					<td align="center" valign="middle"><%=getDBInfoBean.getSpendTime(dbName[i].getName())%></td>
					<td align="center" valign="middle"><%=getDBInfoBean.getMessage(dbName[i].getName(), "depth")%></td>
					<td align="center" valign="middle"><label> <select
							name="operation" id="operation">
								<option value="0">Choose</option>
								<option value="1">Detial</option>
								<option value="2">Re-Crawl</option>
								<option value="3">Schdeule</option>
								<option value="4">Delete</option>
						</select> <input type="submit" name="opera_submit" id="opera_submit"
							value="Submit">
					</label></td>
				</form>
			</tr>
			<%
				}
			%>
			<tr>
				<form id="db_opera" method="post" action="dbopera.do">
					<td align="center" valign="middle">NCHC_4</td>
					<td align="center" valign="middle">2012-12-26 10:30</td>
					<td align="center" valign="middle">5:05:30</td>
					<td align="center" valign="middle">4</td>
					<td align="center" valign="middle"><label> <select
							name="operation" id="operation">
								<option value="0">Choose</option>
								<option value="1">Detial</option>
								<option value="2">Re-Crawl</option>
								<option value="3">Schdeule</option>
								<option value="4">Delete</option>
						</select> <input type="submit" name="opera_submit" id="opera_submit"
							value="Submit">
					</label></td>
				</form>
			</tr>
		</table>
	</div>
	<div class="ink-container ink-vspace">
		<h1 class="">Running Jobs</h1>
		<table width="100%" height="121" border="0">
			<tr>
				<td align="center" valign="middle"><strong>CrawlDB
						Name</strong></td>
				<td align="center" valign="middle"><strong>Create Time</strong></td>
				<td align="center" valign="middle"><strong>Spend(H:M:S)</strong></td>
				<td align="center" valign="middle"><strong>Depth</strong></td>
				<td align="center" valign="middle"><strong>Status</strong></td>
			</tr>
			<tr>
				<form id="db_opera2" method="post" action="dbopera.do">
					<td align="center" valign="middle">NCHC_3</td>
					<td align="center" valign="middle">2012-12-25 18:30</td>
					<td align="center" valign="middle">2:04:30</td>
					<td align="center" valign="middle">3</td>
					<td align="center" valign="middle"><label> Rinning <input
							type="submit" name="opera_submit2" id="opera_submit2"
							value="Delete">
					</label></td>
				</form>
			</tr>
			<tr>
				<form id="db_opera2" method="post" action="dbopera.do">
					<td align="center" valign="middle">NCHC_4</td>
					<td align="center" valign="middle">2012-12-26 10:30</td>
					<td align="center" valign="middle">5:05:30</td>
					<td align="center" valign="middle">4</td>
					<td align="center" valign="middle"><label>Scussed <input
							type="submit" name="opera_submit2" id="opera_submit2"
							value="Delete">
					</label></td>
				</form>
			</tr>
		</table>
		<p>&nbsp;</p>
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
