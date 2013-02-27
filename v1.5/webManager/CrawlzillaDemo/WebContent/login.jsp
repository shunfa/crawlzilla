<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n"%>
<%@ page import="java.util.*"%>
<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="cs" lang="cs">

<% String title = "login.jsp"; %>
<%@ include file="/include/header.jsp"%>
<title><i18n:message key="login_loginReg" /></title>
<script src="js/jquery.validationEngine.js" type="text/javascript"></script>
<script>
	$(function() {
		$( "#accordion" ).accordion();
	});
	
	$.fx.speeds._default = 1000;
	$(function() {
		$( "#dialog" ).dialog({
			autoOpen: false,
			show: "blind",
			hide: "explode"
		});

		$( "#opener" ).click(function() {
			$( "#dialog" ).dialog( "open" );
			return false;
		});
	});
	
	function verifyAddress(obj){
		var email = obj.value;
		var pattern = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(\.[a-zA-Z0-9_-])+/;
		flag = pattern.test(email);
		if(flag){
			//alert("Right e-mail format!");
			return true;
		}
		else {
			alert("Wrong e-mail format!");
			return false;
		}
	} 
</script>

<hr class="noscreen" />
<p id="breadcrumbs">&nbsp;</p>
<hr class="noscreen" />
</div> <!-- /strip -->
<div id="content">
	<div id=home>
		<div class="article">
			<div class="demo">
				<div id="accordion">
					<h3><a href="#"><i18n:message key="login_login" /></a></h3>
						<div>
               	 			<form id="login" method="post" action="Login.do">
                			<p class="info noprint"><i18n:message key="login_account" />
            				<label for="textfield"></label>
                    		<input type="text" name="user" id="user" />
                  			</p>
							<p class="info noprint"><i18n:message key="login_password" /><label for="textfield"></label>
                   	 		<input type="password" name="passwd" id="passwd" /></p>
                   	 		<input type="hidden" name="operation" value="login" />
                    		<input type="submit" name="button" id="button" value="Submit" />
  							<input type="reset" name="button2" id="button2" value="Reset" /></form>
						</div>
                  	<h3><a href="#"><i18n:message key="login_userReg" /></a></h3>
					<div>
						<table width="350" border="0" align="center">
						<form id="register" method="post" action="Register.do">
  						<tr>
    						<td width="137"><i18n:message key="login_newAccount" /></td>
    						<td width="201"><label for="textfield2"></label>
      						<input type="text" name="newUser" id="username" /></td>
  						</tr>
  						<tr>
    						<td><i18n:message key="login_passwd" /></td>
    						<td><label for="textfield3"></label>
      						<input type="password" name="setPasswd" id="password-clear" /></td>
  						</tr>
  						<tr>
    						<td><i18n:message key="login_conPasswd" /></td>
    						<td><label for="textfield4"></label>
      						<input type="password" name="confPasswd" id="password-password" /></td>
  						</tr>
  						<tr>
    						<td><i18n:message key="login_email" /></td>
    						<td><label for="textfield5"></label>
      						<input type="text" name="userEmail" id="userEmail" onBlur="return verifyAddress(this);"/></td>
  							
  						</tr>
						</table>
  						<input type="submit" name="button" id="button" value="Submit" />
  						<input type="reset" name="button2" id="button2" value="Reset" />
  						</form>  						
					</div>
				</div>
			</div>
			<div align="center"></div>
	  
			</div> <!-- /article -->
	</div> <!-- home --><!-- crawl -->    
 <h3>道歉啟事：
 <p>Demo網站於2011/11/08因更新失誤，造成所有會員帳號資料遺失，需要重新註冊使用，造成不便請見諒。</p></h3>
       	<hr class="noscreen" />                    
        <hr class="noscreen" />           
</div> <!-- /content -->
<div id="col" class="noprint">
	<div id="col-in">
		<%@ include file="/include/rightside.jsp"%>
		<hr class="noscreen" />
    </div> <!-- /col-in -->
</div> <!-- /col -->
</div> <!-- /page-in -->
</div> <!-- /page -->
<%@ include file="/include/footer.jsp"%>
</body>
</html>