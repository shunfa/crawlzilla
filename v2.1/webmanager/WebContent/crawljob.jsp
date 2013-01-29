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
			<li class="active"><a href="crawljob.jsp">Crawl Job</a></li>
			<li><a href="searchManager.jsp">Search Engine Manager</a></li>
			<li><a href="settings.jsp">Settings</a></li>
			<li><a href="login.jsp">Login/Logout</a></li>
		</ul>
	</nav>

	<header class="ink-container ink-for-m ink-for-s">
		<div class="ink-vspace">
			<h1 class="">Crawlzilla Management</h1>
			<p>Make Your Own Search Engine Friendly!</p>
		</div>
	</header>

	<div class="ink-container ink-vspace">
		<h4>Create Search Engine:</h4>
		<form id="crawljob" method="post" action="crawljob.do">
			<table width="53%" height="258" border="0">
				<tr>
					<td align="center" valign="middle">DB Name:</td>
					<td align="center" valign="middle"><label> <input
							type="text" name="db_name" id="db_name">
					</label></td>
				</tr>
				<tr>
					<td align="center" valign="middle">Crawl URLs:</td>
					<td align="center" valign="middle"><textarea name="crawl_urls"
							id="crawl_urls" cols="30" rows="5"></textarea></td>
				</tr>
				<tr>
					<td align="center" valign="middle">Depth:</td>
					<td align="center" valign="middle"><label> <select
							name="depth" id="depth">
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="3">3</option>
								<option value="4">4</option>
								<option value="5">5</option>
								<option value="6">6</option>
								<option value="7">7</option>
						</select>
					</label></td>
				</tr>
				<tr>
					<td align="center" valign="middle">Mode:</td>
					<td align="center" valign="middle"><label> <input
							type="radio" name="radio" id="mode_www" value="mode_www">
							WWW Mode
					</label> <br>
					<label> <input type="radio" name="radio" id="mode_local"
							value="mode_local"> Local Mode
					</label></td>
				</tr>
				<tr>
					<td colspan="2" align="center" valign="middle"><input
						type="submit" name="submit" id="submit" value="Submit"> <input
						type="reset" name="reset" id="reset" value="Reset"></td>
				</tr>
			</table>
		</form>
		<p>
			<br>
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
