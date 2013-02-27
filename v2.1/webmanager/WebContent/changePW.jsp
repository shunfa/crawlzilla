<!DOCTYPE html>
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
<jsp:useBean id="getDBInfoBean"
	class="nchc.fslab.crawlzilla.bean.infoOperBean" scope="session" />
<!--[if IE]>
			<link rel="stylesheet" href="./css/ink-ie.css" type="text/css" media="screen" title="no title" charset="utf-8">
		<![endif]-->

</head>
<body>

	<!-- Add your site or application content here -->

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
			<li><a href="searchManager.jsp">Search Engine Manager</a></li>
			<li class="active"><a href="settings.jsp">Settings</a></li>
			<li><a
				href="http://<%=getDBInfoBean.getIPAddr()%>:8983/solr/#/"
				target="_blank">Solr Admin</a></li>
			<%
if (session.getAttribute("loginFlag") != "true") {
%>
			<li><a href="login.jsp">Login</a></li>
			<% } else { %>
			<li><a href="logout.jsp">Logout</a></li>
			<% }  %>
		</ul>
	</nav>

	<header class="ink-container ink-for-m ink-for-s">
		<div class="ink-vspace">
			<h1 class="">Crawlzilla Management</h1>
			<p>Make Your Own Search Engine Friendly!</p>
		</div>
	</header>
<%
if (session.getAttribute("loginFlag") != "true") {
%>
<div class="ink-container ink-vspace">
<br>Please Login First!
<br><a href="login.jsp">Login</a>
</div>
<%
	response.setHeader("Refresh", "1; URL=login.jsp");
	}
	//# Login, display the home page
	else {
%>
	<div class="ink-container ink-vspace">
		<h4>Change Password	</h4>
		<table width="70%" height="113" border="0">
		  <tr>
		    <td align="center" valign="middle">Please Typing Infos:</td>
            <form id="change" method="post" action="changePasswd.do" >
		      </td>
	      </tr>
		  <tr>
		    <td align="center" valign="middle">&nbsp;</td>
		    <td align="center" valign="middle">&nbsp;</td>
	      </tr>
		  <tr>
		    <td align="center" valign="middle">&nbsp;</td>
		    <td align="center" valign="middle">&nbsp;</td>
	      </tr>
	  </table>
<br>
	</div>
	<% } %>
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
