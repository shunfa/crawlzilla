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
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n"%>
<%@page import="java.util.*"%>

<%
String loginFormURL = "adminLogin.jsp";
String user = (String) session.getAttribute("user");
String cgangePW = "change_PW.jsp";
if ((session.getAttribute("confirm") == "true")
		&& (session.getAttribute("changePasswdFlag") == "true")) {
	response.setHeader("Refresh", "0.5; URL=" + cgangePW);
	out.println("Please change your default password");
} else if (session.getAttribute("confirm") == "true") {

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
	<li><a href="index.jsp"  id="current"><i18n:message key="title_Home" /></a></li>
	<li><a href="crawl.jsp"><i18n:message key="title_Crawl" /></a></li>
	<li><a href="nutch_DB.jsp"><i18n:message key="title_DbManage" /></a></li>
	<li><a href="sysinfo.jsp" ><i18n:message
		key="title_SysInfo" /></a></li>
	<li><a href="usersetup.jsp"><i18n:message
		key="title_UserSetup" /></a></li>
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
<%@ include file="/include/right_side.jsp"%>

<div id="content">

<div class='featurebox_center'>
<h3><i18n:message key="index_Intro" /></h3>
<p>* <a href="crawl.jsp"><i18n:message key="index_Crawl_h" /></a> :
<i18n:message key="index_Crawl" /></p>
<p>* <a href="nutch_DB.jsp"><i18n:message key="index_DbManage_h" /></a>
: <i18n:message key="index_DbManage" /></p>
<p>* <a href="sysinfo.jsp"><i18n:message
	key="index_SystemStatus_h" /></a> : <i18n:message key="index_SystemStatus" /></p>
<p>* <a href="usersetup.jsp"><i18n:message
	key="index_UserSetup_h" /></a> : <i18n:message key="index_UserSetup" /></p>
<p>* <a href="change_PW.jsp"><i18n:message key="index_SetPasswd" /></a></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</div>


<%
	} else {
		response.setHeader("Refresh", "0; URL=" + loginFormURL);
	}
%>



<p>&nbsp;</p>
<p>&nbsp;</p>
</div>

<%@ include file="/include/foot.jsp"%>
