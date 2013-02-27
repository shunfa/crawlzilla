<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>login</title>
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
		<h2>Login</h2>

		<form id="login" method="post" action="Login.do">
			<p class="info noprint">
				Username： <label for="textfield"></label> <input type="text"
					name="user" id="user" />
			</p>
			<p class="info noprint">
				Password: <label for="textfield"></label> <input type="password"
					name="passwd" id="passwd" />
			</p>

			<p>
				<input type="hidden" name="operation" value="login" /> 
				<input type="hidden" name="mobileMode" value="true" /> 
				<input
					type="submit" name="button3" id="button3" value="Submit" />
		</form>
		</p>
		<!-- TODO: Scheduling -->
		<h3>Show Registration Page:</h3>
		<p>
			<a href="reg.jsp" data-role="button">Registration</a>
		</p>
		<div data-role="footer">
			<h4>
				<a href="javascript:history.back();">Back </a>
			</h4>
		</div>
	</div>
	<!-- /content -->
</body>
</html>