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
<%@ include file="/include/header.jsp" %>

<div id="navcontainer">
<ul id="navlist">
<li><a href="index.jsp">HOME</a></li>
<li id="active"><a href="crawl.jsp" id="current">Crawl</a></li>
<li id="active"><a href="nutch_DB.jsp" >&#36039;&#26009;&#24235;&#31649;&#29702;</a></li>
<li><a href="sysinfo.jsp">&#31995;&#32113;&#29376;&#24907;</a></li>
<% if(session.getAttribute("confirm") == "true") { %>
<li><a href="logout.jsp">&#30331;&#20986;&#31995;&#32113;</a></li>
<%} else { %>	
<li><a href="adminLogin.jsp">&#31649;&#29702;&#32773;&#30331;&#20837;</a></li>
<% } %>


</ul>
</div>

</div>
<%@ include file="/include/right_side.jsp" %>

<h3>Crawl Status</h3>
<% 
    String loginFormURL = 
               "adminLogin.jsp";  
    if(session.getAttribute("confirm") == "true") { %>
<div class='featurebox_center'>

<div class="crawl_status">

	<fieldset id="fieldset_crawl">
	<legend>Crawl Setup Status</legend>
	<b>URL: </b>
	<% 
	String crawl_url = request.getParameter("name_crawl_url");
	out.println(crawl_url);
	%>
	<br />
	
	<b>Depth: </b>${param.name_crawl_depth}<br />
	<br />
	<p><span class="crawl_status_p"></>Setup Success !!! But, it need time to crawl !!!</span></p>
	<div class="blackfont">
	(ex. 4URLs with 1 depth -> 10~20 minute<br />
	     4URLs with 2 depth -> 40~80 minute<br />
	     100URLs with 10 depth -> very very long)<br />
	     <br />
	</div>
	     <span class="redfont">The crawling time depends on your system performance, URLs number, and depth.</span>
	</fieldset>
	<br />
	<br />
	<img id="wait_img" src="img/ajax-loader.gif"></br>
	<P id="wait_num"></P> 
	If you don't want to wait, click below link !!!<br />
	(1)<a href="sysinfo.jsp">Crawl operation page</a><br />
	(2)<a href="index.jsp">Mian page</a><br />
	    <% } 
    else {
		response.setHeader("Refresh", "0; URL=" + loginFormURL);  } %>

</div>

<!-- //logout 
//session.invalidate(); --> 
</div>
<%@ include file="/include/foot.jsp" %>