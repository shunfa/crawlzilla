<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n"%>
<%@ page import="java.util.*"%>
<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="cs" lang="cs">

<% String title = "slave.jsp"; %>
<%@ include file="/include/header.jsp"%>
<%
String loginFormURL = "login.jsp";
String user = (String) session.getAttribute("userName");
	if (session.getAttribute("loginFlag") == "true") {
		System.out.println("has been login!");
		String userName = session.getAttribute("userName").toString();
		String lang = session.getAttribute("language").toString().trim();
		System.out.println("session="+lang);
		Locale locale = new Locale(lang);
%>
<i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang"
		locale="<%=locale%>" id="bundle" />
<title><i18n:message key="slave_newNode" /></title>
<script>
	$(function() {
		$( "button, input:submit, a", ".demo" ).button();
		$( "a", ".demo" ).click(function() { return false; });
	});
	</script>
<hr class="noscreen" />
            <p id="breadcrumbs">&nbsp;</p>
            <hr class="noscreen" />
        </div> <!-- /strip -->
        <div id="content">
          <div id=home>
            <div class="article">
              <h2><i18n:message key="slave_newNode" /></h2>
                <p class="info noprint"><i18n:message key="slave_steps" /></p>
                
                  <p class="info noprint">Step1：   
          <a href="../slave_deploy.sh"><i18n:message key="slave_download" /></a></p>
                <p class="info noprint">Step2：<i18n:message key="slave_run" /></p>
            </div> <!-- /article -->
		</div> <!-- home --><!-- crawl -->       
            <hr class="noscreen" />                    
          <hr class="noscreen" />      
        </div> <!-- /content -->
        <div id="col" class="noprint">
            <div id="col-in">
<%@ include file="/include/rightside.jsp"%>
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