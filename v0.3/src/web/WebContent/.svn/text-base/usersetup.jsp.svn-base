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
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n" %>

<%@page import="java.util.*" %>
<%@page import="org.nchc.crawlzilla.UserInfoAttrSet" %>
<%
	String loginFormURL = "adminLogin.jsp";
	String user = (String) session.getAttribute("user");
	
	if (session.getAttribute("confirm") == "true") {
		UserInfoAttrSet xml = new UserInfoAttrSet();
     	String lang = (String) session.getAttribute("lang"); 
     	Locale locale =new Locale(lang,"");
     	if (lang == null) {
     		lang = pageContext.getResponse().getLocale().toString();
     		session.setAttribute("lang", lang);
     	}
%>

 <i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang" locale="<%=locale%>" id="bundle" />

<%@ include file="/include/header.jsp" %>
<div id="navcontainer">
<ul id="navlist">
	<li><a href="index.jsp"><i18n:message key="title_Home" /></a></li>
	<li><a href="crawl.jsp"><i18n:message key="title_Crawl" /></a></li>
	<li><a href="nutch_DB.jsp"><i18n:message key="title_DbManage" /></a></li>
	<li><a href="sysinfo.jsp"><i18n:message key="title_SysInfo" /></a></li>
	<li><a href="usersetup.jsp" id="current"><i18n:message key="title_UserSetup" /></a></li>
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
</div>
</div>
<%@ include file="/include/right_side.jsp" %>
<div id="content">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<h3><i18n:message key="title_UserSetup" /></h3>

<form action="usersetupset.jsp"><i18n:message
	key="usersetup_EngineName" /><br>
<input type="text" class="haha" id="enginename" name="enginename" value=<%=xml.getEngineName()%>></input><br>
<i18n:message key="usersetup_AdminEmail" /><br>
<input type="text" class="haha" id="email" name="email" value=<%=xml.getEmail()%>></input><br>

<i18n:message key="usersetup_Language" /><br>
<select name="language">
	<option value="1">English</option>
	<option value="2">中文</option>
</select> <BR><BR>
<input type="submit" value="<i18n:message key="button_submit" />"></input></form>
<%
	} else {
		response.setHeader("Refresh", "0; URL=" + loginFormURL);
%>

<%
	}
%>
<p>&nbsp;</p>
<p>&nbsp;</p>
</div>

<%@ include file="/include/foot.jsp"%>