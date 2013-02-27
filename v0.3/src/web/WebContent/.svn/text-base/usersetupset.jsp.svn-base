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

String language = (String) request.getParameter("language");
String email = (String) request.getParameter("email");
String name = (String) request.getParameter("enginename");

if (language != null ) {			
	int lan_int = Integer.parseInt(language);
	switch (lan_int) {
	case 1:
		language = "en";
		break;
	case 2:
		language = "zh_TW";
		break;
	}
	session.setAttribute("lang", language);
}

UserInfoAttrSet xml = new UserInfoAttrSet();
if (!xml.check_att(name, email)) {	
	xml.set_nutch_site_attr(name, email);
	xml.set_userattr(name, email);
}
response.setHeader("Refresh", "0; URL=./usersetup.jsp");
%>
