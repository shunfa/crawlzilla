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


<%
	String loginFormURL = "adminLogin.jsp";
	String user = (String) session.getAttribute("user");
	if (session.getAttribute("confirm") == "true") {
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
	<li><a href="crawl.jsp" id="current"><i18n:message
		key="title_Crawl" /></a></li>
	<li><a href="nutch_DB.jsp"><i18n:message key="title_DbManage" /></a></li>
	<li><a href="sysinfo.jsp"><i18n:message key="title_SysInfo" /></a></li>
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
<h3><i18n:message key="title_Crawl" /></h3>

<div class='featurebox_center'>
<form method="post" action="Crawl.do">
<fieldset onmousemove= nuHiddlen(); onmouseout= nuHiddlen();>
<legend><i18n:message key="crawl_How" /></legend>
<ol id="how_to" class="nuHiddlen">
	<li><span class="redfont"><i18n:message
		key="crawl_InputDbName" /></span></li>
	<li><span class="redfont"><i18n:message
		key="crawl_InputUrl" /></span><br />
	<img src="img/crawl_file.png" alt="crawl_file.png" /></li>
	<li><span class="redfont"><i18n:message
		key="crawl_ChooseDepth" /></span></li>
</ol>
</fieldset>
<br />

<fieldset><legend><i18n:message key="crawl_DbName" /></legend>
<label for="id_crawl_db"><i18n:message key="crawl_CrawlUrlSetup" /></label>
<input type="text" class="haha" id="id_crawl_db" name="name_crawl_db"></input>
</fieldset>
<br />

<fieldset><legend><i18n:message
	key="crawl_InputCrawlUrl" /></legend> <label for="id_crawl_url"><i18n:message
	key="crawl_InputCrawlUrl" /></label> <textarea class="haha" id="id_crawl_url"
	name="name_crawl_url" rows="7" cols="50"></textarea></fieldset>
<br />

<fieldset title="Crawl Depth Setup"><legend><i18n:message
	key="crawl_CrawlDepthSetup" /></legend> <label for="id_crawl_depth"><i18n:message
	key="crawl_ChooseCrawlDepth" /></label> <select size="1" id="id_crawl_depth"
	name="name_crawl_depth">
	<option>1</option>
	<option>2</option>
	<option>3</option>
	<option>4</option>
	<option>5</option>
	<option>6</option>
</select><br />
</fieldset>
<input type="submit" value="<i18n:message key="button_submit" />" name="Submit" 	onmouseover= check_null();>
<input type="reset" value="<i18n:message key="button_reset" />" name="Rset">

</form>


<%
	} else {
		response.setHeader("Refresh", "0; URL=" + loginFormURL);
	}
%> <%@ include file="/include/foot.jsp"%>
