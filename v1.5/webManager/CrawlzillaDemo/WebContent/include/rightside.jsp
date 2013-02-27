<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<jsp:useBean id="nutchDBNum" class="org.nchc.crawlzilla.bean.NutchDBNumBean" scope="session" /> 
<jsp:useBean id="nutchDBStatus" class="org.nchc.crawlzilla.bean.NutchDBStatusBean" scope="session" /> 
<%
	String sIPAddress = request.getServerName();
 	// TODO 目前僅寫單人admin version
 	String userNames = "admin";
 	String portNO = "8080";
 	if (session.getAttribute("loginFlag") == "true") {
 		userNames = session.getAttribute("userName").toString();
 			
 		String IDBfolderPath="/home/crawler/crawlzilla/user/" + userNames + "/IDB";
 		nutchDBNum.setNum(IDBfolderPath);
 	 	int IDBNum = nutchDBNum.getNum();
 	 	nutchDBStatus.setFolders(IDBfolderPath);
 	 	File IDBfoldersName[] = nutchDBStatus.getFolders();
 	 	String masterIPAddress = request.getServerName();
 	    try{
 	    	portNO = session.getAttribute("portNO").toString();
 	    	if(!session.getAttribute("userName").toString().isEmpty()){
 	     		userNames = session.getAttribute("userName").toString();
 	     	}
 	    } 
 	    catch(NullPointerException e){
 	 		System.out.print("Catch PointerException!");
 	 	}%>
 	 	<!-- Category -->
<h3 ><i18n:message key="rightside_engineList" /></h3>
<ul id="category">
<%
	for(int j=0; j < IDBNum; j++){
		try{
			out.print("<li><a href=http://" + sIPAddress + ":" + "8080" +"/" + userNames + "_" +IDBfoldersName[j].getName()+ ">" + IDBfoldersName[j].getName() + "</a></li>");
		}
		catch(NullPointerException e){
			
		}
	}
%> 
<% }
 	String IDBfolderPath="/home/crawler/crawlzilla/user/" + userNames + "/IDB";
 %>

</ul>
<h3 ><i18n:message key="rightside_computingNd" /></h3>
<ul id="category">
<li><a target="_new" href=<%out.print("http://" + sIPAddress + ":50030");%>><i18n:message key="rightside_jobtracker" /></a>              </li>
<li><a target="_new" href=<%out.print("http://" + sIPAddress + ":50070");%>><i18n:message key="rightside_namenode" /></a>              </li>
</ul>
<hr class="noscreen" />
