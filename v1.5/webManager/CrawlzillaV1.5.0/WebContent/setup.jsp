<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n"%>
<%@ page import="java.util.*"%>
<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="cs" lang="cs">

<% String title = "setup.jsp"; %>
<%@ include file="/include/header.jsp"%>
<%
String loginFormURL = "login.jsp";
//String user = (String) session.getAttribute("userName");
	if (session.getAttribute("loginFlag") == "true") {
		String userName = session.getAttribute("userName").toString();
		String lang = session.getAttribute("language").toString().trim();
		System.out.println("session="+lang);
		Locale locale = new Locale(lang);
%>
<i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang"
		locale="<%=locale%>" id="bundle" />
<title><i18n:message key="setup_systemSetup" /></title>
<hr class="noscreen" />
            <p id="breadcrumbs">&nbsp;</p>
            <hr class="noscreen" />
        </div> <!-- /strip -->
        <div id="content">
          <div id=home>
            <div class="article">
                <h2><i18n:message key="setup_systemSetup" /></h2>
              <form id="form1" method="post" action="setupset.jsp">
                <p class="info noprint"><i18n:message key="setup_langSetup" />：
                  <label for="select"></label>
                    <select name="language" id="language">
                    <% 
                    if (lang.equals("zh_TW") ){
                    	out.println("<option value=\"1\" >English</option><option value=\"2\" SELECTED>中文</option>");
                    }
                    else{
                    	out.println("<option value=\"2\" SELECTED>English</option><option value=\"2\" >中文</option>");
                    }
                    
                    %>
                      
                    </select>
                  </p>
                  <p class="info noprint">
				  <input type="submit" name="button" id="button" value="Submit" />
				  <input type="reset" name="button2" id="button" value="Reset" />
				</p>
<p class="info noprint"><a href="changePW.jsp"><i18n:message key="setup_editPersonalInfo" /></a></p>
<% if(userName.equals("admin")){ %>
<p class="info noprint"><a href="memberManagement.jsp"><i18n:message key="setup_userManage" /></a></p>
<% } %>

<p>&nbsp;</p>
              </form>
            </div> 
		</div> <!-- home --><!-- crawl -->       
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