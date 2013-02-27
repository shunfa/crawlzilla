<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Crawlzilla Search Manager</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="http://code.jquery.com/mobile/1.0.1/jquery.mobile-1.0.1.min.css" />
<script type="text/javascript" language="javascript"
	src="js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" language="javascript"
	src="js/jquery.mobile-1.0.1.min.js"></script>
</head>
<body>
	<div data-role="page">

		<div data-role="header">
			<h1>Welcome to use Crawlzilla Search Engine Manager</h1>
		</div>
		<!-- /header -->
		<div data-role="content">
			<%
				if (session.getAttribute("loginFlag") == "true") {
					out.print("Hi, " + session.getAttribute("userName"));
				
			%>
		</div>


		<ul data-role="listview" data-inset="false" data-filter="false">
			<li><a href="home.jsp">Home&infomation</a>
			</li>
			<li><a href="crawl.jsp">Crawl</a>
			</li>
			<li><a href="indexpool.jsp">Index-pool Manage</a>
			</li>
			<li><a href="order.jsp">Crawl Processes Scheduling</a>
			</li>
			<li><a href="#">System Setup</a>
			</li>
			
			<li> <a href="logout.jsp">Logout</a> 
				<% } else { %><a href="login.jsp">Login/Registration</a> <% } %>
			</li>
		</ul>
	</div>
	
	<!-- /page -->
</body>
</html>