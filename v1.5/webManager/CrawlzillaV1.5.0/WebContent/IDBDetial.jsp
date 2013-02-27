<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n"%>
<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.text.SimpleDateFormat"%>
<% String title = "IDBDetial.jsp"; %>
<%@ include file="/include/header.jsp"%>
<!-- <jsp:useBean id="nutchDBNum" class="org.nchc.crawlzilla.bean.NutchDBNumBean" scope="session" /> -->
<!-- <jsp:useBean id="nutchDBStatus" class="org.nchc.crawlzilla.bean.NutchDBStatusBean" scope="session" /> --> 
<jsp:useBean id="iDBDetail" class="org.nchc.crawlzilla.bean.mIDBDetailBean" scope="session" />
<script>
	$(function() {
		$( "#accordion" ).accordion({
				autoHeight: false,
				navigation: true
		});
	});
	$(function() {
		$( "#accordion2" ).accordion({
				autoHeight: false,
				navigation: true
		});
	});
</script>
<%
String loginFormURL = "login.jsp";
String portNO = "8080";
String user = (String) session.getAttribute("userName");
	if (session.getAttribute("loginFlag") == "true") {
		System.out.println("has been login!");
		String userName = session.getAttribute("userName").toString();
		//portNO = session.getAttribute("portNO").toString();
		String lang = session.getAttribute("language").toString();
		Locale locale = new Locale(lang);
%>
<i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang"
		locale="<%=locale%>" id="bundle" />
<title><i18n:message key="IDBDetial_IDBinfo" /></title>
<% 

String BaseDir = "/home/crawler/crawlzilla/user/";
String IDBName = request.getParameter("IDB").trim();
String UserName = request.getParameter("USERNAME").trim();
String masterIPAddress = request.getServerName();

//String UserName = "admin";
//String IDBName = "0412_1";
//iDBDetail.setTopNum(101); // default is 101 in IDBDetailBean.java
iDBDetail.initIDBDetail(BaseDir, UserName, IDBName);
String IDB_Path = BaseDir+ UserName + "/IDB/" + IDBName +"/"; 
int st = iDBDetail.getDBstatus();
String StatusExplaintion ;
if (st == 0 ){
	StatusExplaintion = "OK";
}else if( st == 1 ){
	StatusExplaintion = "Meta Error <br> please check meta path :"+ IDB_Path+ "meta";
}else if( st == 2 ){
	StatusExplaintion = "Index Error <br> please check index path :" + IDB_Path+ "index";
}else if ( st == 3){
	StatusExplaintion = "DB Error <br> please check Index DB path :" + IDB_Path ;
}else {
	StatusExplaintion = "[bug] Status Error!";
}

%>

<hr class="noscreen" />
 </div>
<!-- Breadcrumbs -->
<p id="breadcrumbs">&nbsp;</p>
<hr class="noscreen" />           
        <!-- Content -->
<div id="content">
	<div id=home>
		<div class="article">
			<h2><a><i18n:message key="IDBDetial_about" /><% out.println(IDBName); %></a></h2>
          		<div class="demo">
          		
            		<div id="accordion">                     
              			<h3><a href="#"><i18n:message key="IDBDetial_basicInfo" /></a></h3>
              			<div> 
              				<p><i18n:message key="IDBDetial_IDBName" /> <%= IDBName %></p>
              				<p><i18n:message key="IDBDetial_website" /> ${ iDBDetail.indexPath}
              				<p><i18n:message key="IDBDetial_status" /> <%= StatusExplaintion %></p>
              				<p><i18n:message key="IDBDetial_depth" /> ${iDBDetail.depth }</p>
              				<p><i18n:message key="IDBDetial_createTime" /> ${iDBDetail.createTime}</p>
              				<p><i18n:message key="IDBDetial_runTime" /> ${iDBDetail.exeTime}</p>
              				<p><i18n:message key="IDBDetial_start" /> ${iDBDetail.initURL}</p>
              			</div>
                            
              			<h3><a href="#"><i18n:message key="IDBDetial_embedded" /></a></h3>	
              			<div>
              				<h3><p class="info noprint"><i18n:message key="IDBDetial_searchEngine" /></p></h3>
              				<p> <img src="http://<% out.print(masterIPAddress); %>:<% out.print(portNO); %>/default/img/logo.png" ><form name="search" action="http://<% out.print(masterIPAddress); %>:<% out.print(portNO); %>/narl/search.jsp" method="get"><input name="query" size=15></form></p>
              				<p class="info noprint"></p>
              				<h3><p class="info noprint"><i18n:message key="IDBDetial_syntax" /></p></h3>
              				<p> &lt;img src="http://<% out.print(masterIPAddress); %>:<% out.print(portNO); %>/default/img/logo.png" &gt;</p>
              				<p> &lt;form name="search" action="http://<% out.print(masterIPAddress); %>:<% out.print(portNO); %>/<% out.print(UserName + "_" + IDBName ); %>/search.jsp" method="get"&gt;</p>
              				<p> &lt;input name="query" size=15&gt;&lt;/form&gt;</p>              
            	  		</div>
              
			  			<!-- 
			  			<h3><a href="#">排程資訊</a></h3>	
			  			<div>
              				<p class="info noprint">執行日期及時間：</p>
              				<p class="info noprint"></p>
              				<p class="info noprint">執行週期：</p>
              			</div>
              			 -->                            
             	 </div>
			</div>
		</div>
		
		<div class="article">
			<h2><a> <i18n:message key="IDBDetial_content" />  <% out.println(IDBName); %></a></h2>
          		<div class="demo">
          		
            		<div id="accordion2">                   
              			<h3><a href="#"><i18n:message key="IDBDetial_overall" /></a></h3>	
						<div>
    						<p><i18n:message key="IDBDetial_words" /> ${iDBDetail.numTerm }</p>
    						<p><i18n:message key="IDBDetial_files" /> ${iDBDetail.numDoc }</p>
    						<p><i18n:message key="IDBDetial_updateDate" /> ${iDBDetail.lastModified }</p>
     						<p class="info noprint"></p>
						</div>  
                            
              			<h3><a href="#"><i18n:message key="IDBDetial_parseWebsites" /> </a></h3>	
             			<div>
              				<table width="100%" border="0">
								<jsp:getProperty name="iDBDetail" property="siteTopTerms" />
			  				</table>
             				<p class="info noprint"></p>
              			</div>         
              
			  			<h3><a href="#"><i18n:message key="IDBDetial_docType" /> </a></h3>	
						<div>
              				<table width="100%" border="0">
								<tr>
								<jsp:getProperty name="iDBDetail" property="typeTopTerms" />
								</tr>
			  				</table>
              				<p></p>
              				<p class="info noprint"></p>
						</div>

        				<h3><a href="#"><i18n:message key="IDBDetial_top50Words" /> </a></h3>	
						<div>
							<table width="100%" border="0">
								<jsp:getProperty name="iDBDetail" property="contentTopTerms" />
							</table>	
        				</div>                          
             	 </div>
			</div>
		</div>
	</div>
</div>

<div id="col" class="noprint">
	<div id="col-in">
		<h3 ><i18n:message key="IDBDetial_nodeStatus" /> </h3>
		<ul id="category">
			<li><a target="_new" href=<%out.print("http://" + masterIPAddress + ":50030");%>><i18n:message key="IDBDetial_jobtrackerStatus" /></a></li>
			<li><a target="_new" href=<%out.print("http://" + masterIPAddress + ":50070");%>><i18n:message key="IDBDetial_namenodeStatus" /></a></li>
		</ul>
		<hr class="noscreen" />
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
