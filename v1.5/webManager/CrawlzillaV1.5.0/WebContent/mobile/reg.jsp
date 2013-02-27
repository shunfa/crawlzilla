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
		<h2>Registration</h2>

		<form id="form1" method="post" action="Login.do">
			<p class="info noprint">
				Username： <label for="textfield"></label> 
				<input type="text" name="newUser" id="username" />
			</p>
			<p class="info noprint">Password:
				<label for="textfield2"></label> 
				<input type="password" name="Password" id="textfield2" />
			</p>
			<p class="info noprint">Re Type-in Password:
				<label for="textfield3"></label> 
				<input type="password" name="confPasswd" id="textfield3" />
			</p>
			<p class="info noprint">email:
				<label for="textfield4"></label> 
				<input type="text" name="userEmail" id="userEmail" />
			</p>
		</form>
		<p>
			<input type="hidden" name="operation" value="login" /> 
			<input type="submit" name="button3" id="button3" value="Submit" />
		</p>
	</div>
	<!-- /content -->
</body>
</html>