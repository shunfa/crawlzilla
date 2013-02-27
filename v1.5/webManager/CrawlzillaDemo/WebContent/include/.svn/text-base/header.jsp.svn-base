<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.text.SimpleDateFormat"%>
﻿<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="cs" lang="cs">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="content-language" content="cs" />
    <meta name="robots" content="all,follow" />

    <meta name="author" content="All: ... [Nazev webu - www.url.cz]; e-mail: info@url.cz" />
    <meta name="copyright" content="Design/Code: Vit Dlouhy [Nuvio - www.nuvio.cz]; e-mail: vit.dlouhy@nuvio.cz" />
    
    <meta name="description" content="..." />
    <meta name="keywords" content="..." />
    
    <link rel="index" href="./" title="Home" />
    <link rel="stylesheet" media="screen,projection" type="text/css" href="./css/main.css" />
    <link rel="stylesheet" media="screen,projection" type="text/css" href="./css/Crawl.css" />
    <link rel="stylesheet" media="print" type="text/css" href="./css/print.css" />
    <link rel="stylesheet" media="aural" type="text/css" href="./css/aural.css" />
    <link type="text/css" href="./css/ui-lightness/jquery-ui-1.8.10.custom.css" rel="stylesheet" />	
    <script type="text/javascript" language="javascript" src="js/jquery-1.4.4.min.js"></script>
    <script type="text/javascript" language="javascript" src="js/jquery-ui-1.8.10.custom.min.js"></script>
</head>

<% 
	FileReader langfr = new FileReader("/home/crawler/crawlzilla/user/admin/meta/weblang");
	BufferedReader langbr = new BufferedReader(langfr);
    String langDef = langbr.readLine();
	Locale localeDef = new Locale(langDef);
	if (session.getAttribute("loginFlag") == "true") {
		localeDef = new Locale(session.getAttribute("language").toString());
	}
%>
<%
String titles = request.getRequestURI().toString();
try{
	titles = titles.substring(titles.lastIndexOf("/")+1, titles.lastIndexOf(".jsp"));
} catch (Exception e) {
	titles = "index";
}
//out.println(titles);
%>
<i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang" 
		locale="<%=localeDef%>" id="bundle" />

<body id="www-url-cz">
<!-- Main -->
<div id="main" class="box">
    <!-- Header -->
    <div id="header">
        <!-- Logotyp -->
        <h1 id="logo" name="logo"><a href="./" title="CrystalX [Go to homepage]">Crawlzilla Search Engine Hands-on Display</a></h1>
<hr class="noscreen" />          

        <!-- Quick links -->
        <div class="noscreen noprint">
            <p><em>Quick links: <a href="#content">content</a>, <a href="#tabs">navigation</a>, <a href="#search">search</a>.</em></p>
            <hr />
        </div>

        <!-- Search -->
        <div id="search" class="noprint"></div> <!-- /search -->

    </div> <!-- /header -->

     <!-- Main menu (tabs) -->
     <div id="tabs" class="noprint">
            <h3 class="noscreen">Navigation</h3>
            <ul class="box">

<div id="tabs">
            <ul>
            <!-- 完成實做id="active" -->
            <li <% if (titles.equals("index")) out.print("id=active"); %>><a href="index.jsp">Home</a></li>
            <li <% if (titles.equals("crawl")) out.print("id=active"); %>><a href="crawl.jsp">Crawl</a></li> 
            <li <% if (titles.equals("indexpool")) out.print("id=active"); %>><a href="indexpool.jsp"><i18n:message key="header_indexpoolManage" /></a></li>
            <li <% if (titles.equals("order")) out.print("id=active"); %>><a href="order.jsp"><i18n:message key="header_systemOrder" /></a></li>
            <li <% if (titles.equals("slave")) out.print("id=active"); %>><a href="slave.jsp"><i18n:message key="header_slaveInstall" /></a></li>
            <li <% if (titles.equals("setup")) out.print("id=active"); %>><a href="setup.jsp"><i18n:message key="header_setup" /></a></li>
            <% 
            if (session.getAttribute("loginFlag") == "true") { %>
            	<li><a href="logout.jsp"><i18n:message key="header_logout" /></a></li>
            <% } else { %>
            	 <li <% if (titles.equals("login")) out.print("id=active"); %>><a href="login.jsp"><i18n:message key="header_login" /></a></li>
                 </ul>
            
            <%} %>
</div>
        <hr class="noscreen" />     
</div>
    <!-- Page (2 columns) -->
    <div id="page" class="box">
    <div id="page-in" class="box">
        <div id="strip" class="box noprint">
