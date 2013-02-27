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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- Meta Data -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="description" content="Crawlzilla Management" />
<meta name="keywords" content="nutch, crawlzilla, cloud computing, Hadoop, search engine" />
<meta name="author" content="Waue(waue@nchc.org.tw), Shunfa(shunfa@nchc.org.tw) , Rock(rock@nchc.org.tw)" />

<link rel=stylesheet type="text/css" href="css/Crawl.css"> 
<link href="css/style.css" type="text/css" rel="stylesheet" />
<title>NutchEZ&#32178;&#38913;&#31649;&#29702;&#31995;&#32113;</title>
</head>
<body>

<div id="page_wrapper">

<div id="header_wrapper">

<div id="header">

<h1>Crawlzilla&#32178;&#38913;&#31649;&#29702;&#20171;&#38754;</h1>

</div>

<div id="navcontainer">
<ul id="navlist">
<li><a href="index.jsp">HOME</a></li>
<li id="active"><a href="crawl.jsp" id="current">Crawl</a></li>
<li id="active"><a href="nutch_DB.jsp" >&#36039;&#26009;&#24235;&#31649;&#29702;</a></li>
<li><a href="sysinfo.jsp">&#31995;&#32113;&#29376;&#24907;</a></li>
<% if(session.getAttribute("confirm") == "true") { %>
<li><a href="logout.jsp">&#30331;&#20986;&#31995;&#32113;</a></li>
<%} else { %>	
<li><a href="login.html">&#31649;&#29702;&#32773;&#30331;&#20837;</a></li>
<% } %>


</ul>
</div>

</div>
<div id="right_side">
  <h3>&#30456;&#38364;&#36039;&#28304;</h3>
  <p>* Crawlzilla&#23560;&#26696;&#32178;&#22336;</p>
  <p>* &#32218;&#19978;&#25903;&#25588;</p>
</div>

<h3>Crawl Error</h3>
<% 
    String loginFormURL = 
               "login.html";  
    if(session.getAttribute("confirm") == "true") { %>
<div class='featurebox_center'>

Error: DataBase name "<span class="redfont">${param.name_crawl_db}</span>" is duplication.<br />
You can click below choose !!!<br/>
(1) <a href="crawl.jsp">Input other DataBase Name</a>
(2) <a href="nutch_DB.jsp">Delete prior DataBase</a>
	
	    <% } 
    else {
		response.setHeader("Refresh", "3; URL=" + loginFormURL); %>
          
    	<% } %>
	
</div>
<!-- //logout 
//session.invalidate(); --> 
</div>
<!-- <div class='featurebox_center'>some information here...</div> -->
<p>&nbsp;</p>
<p>&nbsp;</p>


<div id="footer">
copyright &copy; 2010 Free Software Lab@NCHC 
<br />
Template provided by: 
<a href="http://www.designsbydarren.com" target="_blank">DesignsByDarren.com</a>
</div>

</div>
</body>
</html>