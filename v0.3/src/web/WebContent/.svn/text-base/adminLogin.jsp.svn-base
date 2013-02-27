<!--
  Copyright 2004 The Apache Software Foundation

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0"
	prefix="i18n"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="checkFristLogin" class="org.nchc.crawlzilla.CheckFristLogin" /> 
<jsp:setProperty name="checkFristLogin" property="*" /> 

<%
		String sIPAddress = request.getServerName();
		String lang = (String) session.getAttribute("lang");
		if (lang == null) {
			lang = pageContext.getResponse().getLocale().toString();
			session.setAttribute("lang", lang);
		}
		Locale locale = new Locale(lang, "");
%>
<i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang"
	locale="<%=locale%>" id="bundle" />

<%@ include file="/include/header.jsp"%>
<div id="navcontainer">
<ul id="navlist">
	<li><a href="index.jsp"><i18n:message key="title_Home" /></a></li>
	<li><a href="crawl.jsp"><i18n:message key="title_Crawl" /></a></li>
	<li><a href="nutch_DB.jsp"><i18n:message key="title_DbManage" /></a></li>
	<li><a href="sysinfo.jsp"><i18n:message	key="title_SysInfo" /></a></li>
	<li><a href="usersetup.jsp"><i18n:message key="title_UserSetup" /></a></li>
	<%
		if (session.getAttribute("confirm") == "true") {
	%>
	<li><a href="logout.jsp"><i18n:message key="title_Logout" /></a></li>
	<%
		} else {
	%>
	<li><a href="adminLogin.jsp"><i18n:message key="title_Login" /></a></li>
	<%
		}
	%>
</ul>
</div></div>

<div class='featurebox_center'>
<%@ include file="/include/right_side.jsp" %>

<div id="content">

<h3><i18n:message key="admLogin_login" /></h3>


<form name="login" method="post" action="login.jsp">
  <p><i18n:message key="admLogin_inputPasswd" /></p>
    <p>
      <label>
         <input type="password" name="passWord" >
      </label>
  </p>
    <p>
      <label>
        <input type="submit" name="login" id="login" value="<i18n:message key="button_submit" />" />
        </label>
      <label>
        <input type="reset" name="cancel" id="cancel" value="<i18n:message key="button_reset" />" />
        </label>
      </p>
      <%
if (checkFristLogin.fristLogin()){
	String cgangePW = "change_PW.jsp"; 
	response.setHeader("Refresh", "0.5; URL=" + cgangePW); 
}
%>
  </form>
<%@ include file="/include/foot.jsp" %>