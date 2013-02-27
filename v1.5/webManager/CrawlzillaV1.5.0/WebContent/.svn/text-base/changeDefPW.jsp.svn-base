<%@page import="org.nchc.crawlzilla.bean.LoginBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0"
	prefix="i18n"%>
<%@ page import="java.util.*"%>
<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="cs" lang="cs">
<%
	String title = "changePW.jsp";
%>
<jsp:useBean id="login" class="org.nchc.crawlzilla.bean.LoginBean"
	scope="session" />
<jsp:useBean id="memberListBean"
	class="org.nchc.crawlzilla.bean.memberListBean" scope="session" />
<%@ include file="/include/header.jsp"%>

<%
	String loginFormURL = "login.jsp";

	String userName = "admin";
	String lang = session.getAttribute("language").toString();
	Locale locale = new Locale(lang);
%>
<i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang"
	locale="<%=locale%>" id="bundle" />
<hr class="noscreen" />
<p id="breadcrumbs">&nbsp;</p>
<hr class="noscreen" />
</div>
<!-- /strip -->

<div id="content">
	<div id=home>
		<div class="article">
			<div id="accordion">
				<h3>
					<a href="#"><i18n:message key="changePW_changePW" /> </a>
				</h3>
				<div>
					<%
						if (userName.equals("admin") && login.checkFristLogin()) {}
					%>
					<p>
						<i18n:message key="changePW_defultPW" />
					</p>
					<i18n:message key="changePW_sugges" />
					<p></p>
					<form id="form1" method="post" action="Login.do">
						<table width="449" border="10">
							<tr>
								<td><i18n:message key="changePW_user" />：</td>
								<td>
									<%
										out.print(userName);
									%>
								</td>
							</tr>
							<tr>
								<td><i18n:message key="changePW_newPW" />：</td>
								<td><span class="info noprint"> <input
										type="password" name="newpasswd" id="newpasswd" /> </span>
								</td>
							</tr>
							<tr>
								<td><i18n:message key="changePW_conPW" />：</td>
								<td><span class="info noprint"> <input
										type="password" name="confpasswd" id="confpasswd" /> </span>
								</td>
							</tr>
							<%
								if ((new File("/home/crawler/crawlzilla/user/" + userName
										+ "/meta/email")).exists()) {
							%><tr>
								<td><i18n:message key="changePW_oriMail" />：</td>
                    			<td width="178">
                      			<%
                      			String email_str = login.getEmail(userName);
                      			out.print(email_str);
                      			//out.print(memberListBean.showEmail("/home/crawler/crawlzilla/user/"+ userName + "/meta/email" )); 
                      			%>

                    			</td>
							</tr>
							<%
								}
							%>
							<tr>
								<td><i18n:message key="changePW_newMail" />：</td>
								<td>
								<span class="info noprint"> 
								<input type="text" name="newEmail" id="newEmail" value="<%out.print(login.getEmail(userName));%>"/> 
								</span>
								</td>
							</tr>
							<tr>
								<td><i18n:message key="setup_langSetup" />
								</td>
								<td><label for="select"></label> <select name="language"
									id="language">
										<%
											if (lang.equals("zh_TW")) {
										%><option value=1 >English</option>
										<option value=2 SELECTED>中文</option>
										<%
											} else {
										%><option value=1 SELECTED>English</option>
										<option value=2 >中文</option>
										<%
											}
										%>

								</select></td>
							</tr>
							<tr>
								<td colspan="2"><div align="center">
								<span class="info noprint"> 
								<input type="hidden" name="operation" value="firstLogin" />
								<input type="hidden" name="userName" value="<%out.print(userName);%>" />
								<input type="hidden" name="operation" value="editEmail" /> 
								<input type="submit" name="button" id="button" value="Submit" /> 
								<input type="reset" name="button2" id="button2" value="Reset" /> 
								</span>
								</div></td>
							</tr>

						</table>

					</form>
				</div>
			</div>
		</div>
	</div>
	<hr class="noscreen" />
	<hr class="noscreen" />
</div>
<!-- /content -->
<div id="col" class="noprint">
	<div id="col-in">

		<%@ include file="/include/rightside.jsp"%>


		<hr class="noscreen" />
	</div>
	<!-- /col-in -->
</div>
<!-- /col -->
</div>
<!-- /page-in -->
</div>
<!-- /page -->
<%@ include file="/include/footer.jsp"%>


</body>
</html>