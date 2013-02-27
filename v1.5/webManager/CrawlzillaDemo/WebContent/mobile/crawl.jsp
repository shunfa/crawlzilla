<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Crawl Setup</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="http://code.jquery.com/mobile/1.0.1/jquery.mobile-1.0.1.min.css" />
<script type="text/javascript" language="javascript"
	src="js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" language="javascript"
	src="js/jquery.mobile-1.0.1.min.js"></script>
</head>
<body>
	<div data-role="content">
		<h2>Crawl-Build Searchengine</h2>

		<form id="form1" method="post" action="Crawl.do">
			<p class="info noprint">
				Indexpool Name： <label for="textfield"></label> <input type="text"
					name="IDBName" id="textfield" />
			</p>
			<p class="info noprint">Input Crawl website urls(Support
				multi-line):
			<p class="info noprint">
				<label for="textfield2"></label>
				<textarea name="crawlUrls" cols="80" rows="10" id="textfield2"></textarea>
			</p>
			<p class="info noprint">
				Setup Crawl Depth: <label for="select"></label> <select name="depth"
					id="select">
					<%
						for (int i = 1; i <= 6; i++) {
							out.print("<option value=\"" + i + "\">" + i + "</option>");
						}
					%>
				</select>
			</p>

			<p>
				<input type="hidden" name="mobileMode" value="true" /> <input
					type="submit" name="button3" id="button3" value="Submit" />
			</p>
		</form>
		<!-- TODO: Scheduling 
		<h3>Show Scheduling setup pages:</h3>
		<p>
			<a href="#two" data-role="button">Scheduling Setup</a>
		</p>
	</div>
	-->
	<!-- /content -->
	<div data-role="footer">
		<h4>
			<a href="javascript:history.back();">Back </a>
		</h4>
	</div>
</body>
</html>