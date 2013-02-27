<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Crawl Status</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="http://code.jquery.com/mobile/1.0.1/jquery.mobile-1.0.1.min.css" />
<script type="text/javascript" language="javascript"
	src="js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" language="javascript"
	src="js/jquery.mobile-1.0.1.min.js"></script>
</head>
<body>
	<div data-role="page" class="type-interior">

		<div data-role="header" data-theme="f">
			<h1>Infomation</h1>
			<a href="index.jsp" data-icon="home" data-iconpos="notext"
				data-direction="reverse" class="ui-btn-right jqm-home">Home</a>
		</div>
		<!-- /header -->
		<div data-role="content">
			<div class="content-primary">
				<ul data-role="listview">
					<li data-role="list-divider">Crawl Status<span
						class="ui-li-count">info</span></li>
					<li><a href="indexpool.jsp">
							<h3>Setup has been submit !!! But, it need time to crawl !!!</h3>
							<p>
								<strong></strong>
							</p>
							<p>The crawling time depends on your system performance, URLs
								number, and depth.</p> </a></li>
				</ul>
			</div>
			<p></p>
			<!--/content-primary -->
			<div data-role="footer">
				<h4>
					<a href="index.jsp">Back </a>
				</h4>
			</div>
</body>
</html>