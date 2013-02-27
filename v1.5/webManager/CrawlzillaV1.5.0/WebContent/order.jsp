<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n"%>
<%@ page import="java.util.*"%>
<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="cs" lang="cs">
<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.text.SimpleDateFormat"%>
<jsp:useBean id="nutchDBNum" class="org.nchc.crawlzilla.bean.NutchDBNumBean" scope="session" /> 
<jsp:useBean id="nutchDBStatus" class="org.nchc.crawlzilla.bean.NutchDBStatusBean" scope="session" /> 
<jsp:useBean id="orderinfo" class="org.nchc.crawlzilla.bean.orderBean" scope="session" /> 

<% String title = "order.jsp"; %>
<%@ include file="/include/header.jsp"%>
<%
String loginFormURL = "login.jsp";
String user = (String) session.getAttribute("userName");
	if (session.getAttribute("loginFlag") == "true") {
		System.out.println("has been login!");
		String userName = session.getAttribute("userName").toString();
		String lang = session.getAttribute("language").toString();
		Locale locale = new Locale(lang);
		
%>
<i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang"
		locale="<%=locale%>" id="bundle" />
<title><i18n:message key="order_systemSch" /></title>
<script>
	$(function() {
		$( "#datepicker" ).datepicker();
		$( "#format" ).change(function() {
			$( "#datepicker" ).datepicker( "option", "dateFormat", $( this ).val() );
		});
	});
</script>
<style>
	.toggler { width: 500px; height: 200px; }
	#button { padding: .5em 1em; text-decoration: none; }
	#effect { width: 480px; height: 170px; padding: 0.4em; position: relative; }
	#effect h3 { margin: 0; padding: 0.4em; text-align: center; }
	</style>
<script>
	$(function() {
		function runEffect() { 
			var selectedEffect = "bounce";
			var options = {};
			$( "#effect" ).show( selectedEffect, options, 500, callback );
		};

		function callback() {
			setTimeout(function() {
				$( "#effect:visible" ).removeAttr( "style" ).fadeOut();
			}, 30000 );
		};

		$( "#button" ).click(function() {
			runEffect();
			return false;
		});

		$( "#effect" ).hide();
	});
</script>
<%
	 	// 變數宣告-爬取完成之清單
 		// TODO 目前僅寫單人admin version
 		String IDBfolderPath="/home/crawler/crawlzilla/user/" + userName +"/IDB";
 		nutchDBNum.setNum(IDBfolderPath);
 		int IDBNum = nutchDBNum.getNum();
 		nutchDBStatus.setFolders(IDBfolderPath);
 		File IDBfoldersName[] = nutchDBStatus.getFolders();
 		String masterIPAddress = request.getServerName();
 		String orders = orderinfo.parserConf(userName);
 %> 
<hr class="noscreen" />
<p id="breadcrumbs">&nbsp;</p>
<hr class="noscreen" />
</div> <!-- /strip -->
<div id="content">
	<div id=home>
		<div class="article">
        	<h2><i18n:message key="order_crawlOrder" /></h2>
            <p class="info noprint"><i18n:message key="order_orderInfo" /></p>
            
            <table width="380" border="1">
            	<tr>
                	<th width="30%" align="center" valign="middle" scope="col"><i18n:message key="order_IDBName" /></th>
                    <th width="30%" align="center" valign="middle" scope="col"><i18n:message key="order_crawlTime" /></th>
                    <th width="20%" align="center" valign="middle" scope="col"><i18n:message key="order_freq" /></th>
                    <th width="20%" align="center" valign="middle" scope="col"><i18n:message key="order_delOrder" /></th>
                </tr>
                <% out.print(orders); %>
            </table>
                
            <p>&nbsp;</p>
            <h2><i18n:message key="order_newOrder" /></h2>
            <form id="form1" method="post" action="crawlSchedule.do">
            <p class="info noprint"><i18n:message key="order_IDBselect" /><label for="IDBName"></label>
            <select name="IDBName" id="IDBName">
             	<option selected="selected">select</option>
             	<% 
             		// implement IDB list
             		for (int j = 0; j < IDBNum; j++) {		
             			try{
             				out.print("<option value=\"" + IDBfoldersName[j].getName() +"\">" + IDBfoldersName[j].getName() + "</option>");
             			}
						catch (NullPointerException e){
							out.print("<option value=\"null\"> no indexpool</option>");
						}
                	}
             	%>
			</select></p>
			<p class="info noprint"><i18n:message key="order_orderDate" /> 
			<input id="datepicker" name="scheduleDate" type="text">
			</p>
			<p class="info noprint"><i18n:message key="order_orderTime" /> 
  			<label for="scheduleTime"></label>
  			<select name="scheduleTimeHr" size="1" id="scheduleTimeHr">  
  			<%
  				for(int i=0; i <= 23; i++){
  					out.print("<option value=\"" + i + "\">" + ((i < 10)? "0" : "") +  i +"</option>");
  				}
 			%>
  			</select>
  			時 
  			<label for="scheduleTimeMin"></label>
  			<select name="scheduleTimeMin" id="scheduleTimeMin">
  			<%
  				for(int i=0; i <= 60; i++){
  					out.print("<option value=\"" + i + "\">" + ((i < 10)? "0" : "") +  i +"</option>");
  				}
  			%>
  			</select> 
  			分
			</p>
            <p class="info noprint"><i18n:message key="order_freq" />
			<label for="crawlFreq"></label>
            <select name="crawlFreq" id="crawlFreq">
            	<option value="once"><i18n:message key="order_once" /> </option>
                <option value="daily"><i18n:message key="order_daily" /> </option>
                <option value="weekly"><i18n:message key="order_weekly" /> </option>
                <option value="monthly"><i18n:message key="order_monthly" /> </option>
            </select>
            <a href="#" id="button" class="ui-state-default ui-corner-all"><i18n:message key="order_ex" /> </a>
            <p class="info noprint">	<div id="effect" class="ui-widget-content ui-corner-all">
			<h3 class="ui-widget-header ui-corner-all"><i18n:message key="order_freqEx" /> </h3>
			<p> <i18n:message key="order_onceEx" /> </p>
        	<p> <i18n:message key="order_dailyEx" /> </p>
        	<p> <i18n:message key="order_weeklyEx" /> </p>
        	<p> <i18n:message key="order_monthEx" /> </p>
		</div>            
		<p>
        	<input type="submit" name="button3" id="button3" value="Submit" />
        	<input type="reset" name="button2" id="button2" value="Reset" />
        </p>
        </form>
	</div> 
</div> <!-- home --><!-- crawl -->       
<hr class="noscreen" />                    
<hr class="noscreen" />
</div> <!-- /content -->
<div id="col" class="noprint">
	<div id="col-in">
		<!-- Category -->
		<h3 ><i18n:message key="order_SEList" /></h3>
		<ul id="category">
		<%
		try{
			for(int j=0; j < IDBNum; j++){
				out.print("<li><a href=http://" + masterIPAddress + ":8080/" + userName + "_" + IDBfoldersName[j].getName()+ ">" + IDBfoldersName[j].getName() + "</a></li>");
			}
		}
		catch(NullPointerException e){
			
		}
			
		%> 
		</ul>
		<h3 ><i18n:message key="order_nodeStatus" /></h3>
		<ul id="category">
		<li><a target="_new" href=<%out.print("http://" + masterIPAddress + ":50030");%>><i18n:message key="order_jobtrackerStatus" /></a>              </li>
		<li><a target="_new" href=<%out.print("http://" + masterIPAddress + ":50070");%>><i18n:message key="order_namenodeStatus" /></a>              </li>
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