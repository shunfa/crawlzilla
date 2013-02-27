<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@ page import="java.util.*"%>
<%
	String message = (String) request.getAttribute("message");
%>
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
<body>
	<div data-role="page">

		<div data-role="header">
			<h1>System Message</h1>
		</div>
		<!-- /header -->

		<div data-role="content">
			<p>
				<%
					out.print(message);
				%>
			</p>
		</div>
		<!-- /content -->

		<div data-role="footer">
			<h4>
				<a href="javascript:history.back();">Back </a>
			</h4>
		</div>
		<!-- /footer -->
	</div>
	<!-- /page -->


</body>
</html>