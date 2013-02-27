<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@page import="java.io.File" %>
<%@page import="java.util.Date" %>
<%@page import="java.text.DateFormat" %>
<%@page import="java.text.SimpleDateFormat" %>

<jsp:useBean id="nutchDBNum1" class="org.nchc.crawlzilla.NutchDBNumBean" scope="session" />
<jsp:useBean id="dataInfo1" class="org.nchc.crawlzilla.DataInfoBean" scope="session" />

<%
	nutchDBNum1.setFiles("/home/crawler/crawlzilla/archieve/");
    nutchDBNum1.setNum("/home/crawler/crawlzilla/archieve/");

	File files1[] = nutchDBNum1.getFiles();
	int num1=nutchDBNum1.getNum();
%>

<%
	
	for (int i=0 ; i<num1 ;i++){
		out.print("<p><a href=\"../"+files1[i].getName()+"\">");
		out.print(files1[i].getName()+"</a></p>");
	}
%>