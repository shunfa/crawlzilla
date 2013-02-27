<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n"%>
<%@ page import="java.util.*"%>
<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="cs" lang="cs">
<jsp:useBean id="login" class="org.nchc.crawlzilla.bean.LoginBean" scope="session" /> 
<jsp:useBean id="memberListBean" class="org.nchc.crawlzilla.bean.memberListBean" scope="session" /> 
<%@ include file="/include/header.jsp"%>
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
<%
String loginFormURL = "login.jsp";
String user = (String) session.getAttribute("userName");
if (session.getAttribute("loginFlag") == "true") {
		String userName = session.getAttribute("userName").toString();
		String lang = session.getAttribute("language").toString();
		Locale locale = new Locale(lang);
%>
<i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang"
		locale="<%=locale%>" id="bundle" />
<hr class="noscreen" />
<p id="breadcrumbs">&nbsp;</p>
<hr class="noscreen" />
</div> <!-- /strip -->

<div id="content">
	<div id=home>
		<div class="article">
		<div id="accordion">
		<h3><a href="#"><i18n:message key="changePW_changePW" /></a></h3>
		<div>
        	<% if(userName.equals("admin") && login.checkFristLogin()){ %>
        		<p><i18n:message key="changePW_defultPW" /></p>
        		<i18n:message key="changePW_sugges" />
        	<% } %>
        	<p></p>
            <form id="form1" method="post" action="Login.do">
            	<table width="449" border="10">
                	<tr>
                    	<td><i18n:message key="changePW_user" />：</td>
                    	<td><% out.print(userName); %></td>
                    	<input type="hidden" name="operation" value="changePW" />
                    	<input type="hidden" name="userName" value="<% out.print(userName); %>" />
                    	
                  	</tr>
                  	<tr>
                    	<td width="131"><i18n:message key="changePW_oriPW" />
                    	<label for="textfield2"></label>
                    	：</td>
                    	<td width="178">
                      	<input type="password" name="passwd" id="textfield" />
                    	</td>
                  	</tr>
                  	<tr>
                    	<td><i18n:message key="changePW_newPW" />：</td>
                    	<td><span class="info noprint">
                      	<input type="password" name="newpasswd" id="textfield2" />
                    	</span></td>
                  	</tr>
                  	<tr>
                    	<td><i18n:message key="changePW_conPW" />：</td>
                    	<td><span class="info noprint">
                      	<input type="password" name="confpasswd" id="textfield3" />
                    	</span></td>
                  	</tr>
                  	<tr>
                    	<td colspan="2"><div align="center"><span class="info noprint">
                      	<input type="submit" name="button" id="button" value="Submit" />
                      	<input type="reset" name="button2" id="button2" value="Reset" />
                    	</span></div></td>
                  	</tr>
                </table>

              </form>
              </div>
              
              <h3><a href="#"><i18n:message key="changePW_editEMail" /></a></h3>
				<div>
            		<form id="form2" method="post" action="Login.do">
            			<table width="449" border="10">
                		<tr>
                    		<td><i18n:message key="changePW_user" />：</td>
                    		<td><% out.print(userName); %></td>
                    		<input type="hidden" name="operation" value="editEmail" />
                    		<input type="hidden" name="userName" value="<% out.print(userName); %>" />
                  		</tr>
                  		<tr>
                    		<td width="131"><i18n:message key="changePW_oriPW" />
                    			<label for="textfield2"></label>
                    		：</td>
                    		<td width="178">
                      			<% out.print(memberListBean.showEmail("/home/crawler/crawlzilla/user/"+ userName + "/meta/email" )); %>
                    		</td>
                  		</tr>
                  		<tr>
                    		<td><i18n:message key="changePW_newMail" />：</td>
                    		<td><span class="info noprint">
                      		<input type="text" name="newEmail" id="newEmail" onBlur="return verifyAddress(this);" />
                    		</span></td>
                  		</tr>
                  		<tr>
                    		<td colspan="2"><div align="center"><span class="info noprint">
                      		<input type="submit" name="button" id="button" value="Submit" />
                      		<input type="reset" name="button2" id="button2" value="Reset" />
                    	</span></div></td>
                  	</tr>
                </table>
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <p>&nbsp;</p>
              </form>
              </div>
           </div> 
           </div>
	</div> 
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
<%
	} else { 
%>
		<br><i18n:message key="public_nonlogin" /></br>
<%
response.setHeader("Refresh", "5; URL=" + loginFormURL);
	 }
%>

</body>
</html>