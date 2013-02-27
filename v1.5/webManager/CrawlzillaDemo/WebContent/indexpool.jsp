<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n"%>
<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.text.SimpleDateFormat"%>
<% String title = "indexpool.jsp"; %>
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
<jsp:useBean id="nutchDBNum" class="org.nchc.crawlzilla.bean.NutchDBNumBean" scope="session" /> 
<jsp:useBean id="nutchDBStatus" class="org.nchc.crawlzilla.bean.NutchDBStatusBean" scope="session" /> 

<title><i18n:message key="indexpool_manage" /></title>
<hr class="noscreen" />
<p id="breadcrumbs">&nbsp;</p>
<hr class="noscreen" />            
</div>


<div id="dialog-confirm" title="Dtelte this item?" style="display: none">
	<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>These items will be permanently deleted and cannot be recovered. Are you sure?</p>
</div>



<div id="content">
	<div id=home>
    	<div class="article">
        	<h2><i18n:message key="indexpool_manage" /></h2>
        	<div class="demo">          
        		<p class="info noprint"><i18n:message key="indexpool_systemCrawlStatus" /></p>
        		<div id="dataDisplay">
        		
				<%
					// 變數宣告(爬取中的清單)
					// TODO 目前僅寫單人admin version
					//userName="admin";
 					String folderPath="/home/crawler/crawlzilla/user/"+ userName +"/tmp/";
 					nutchDBNum.setNum(folderPath);
 					int statusNum = nutchDBNum.getNum();
 					nutchDBStatus.setFolders(folderPath);
 					File foldersName[] = nutchDBStatus.getFolders();
 		
 					// 變數宣告-爬取完成之清單
 					String IDBfolderPath="/home/crawler/crawlzilla/user/"+ userName +"/IDB/";
 					nutchDBNum.setNum(IDBfolderPath);
 					int IDBNum = nutchDBNum.getNum();
 					nutchDBStatus.setFolders(IDBfolderPath);
 					File IDBfoldersName[] = nutchDBStatus.getFolders();
 					String masterIPAddress = request.getServerName();
 				%> 
				<!-- 印出狀態的表格框架 -->
                <table width="473" border="1">
                	<tr>
                    	<th width="110" align="center" valign="middle" scope="col"><div align="center"><i18n:message key="indexpool_IDBName" /></div></th>
                    	<th width="93" align="center" valign="middle" scope="col"><div align="center"><i18n:message key="indexpool_crawlStatus" /></div></th>
                    	<th width="126" align="center" valign="middle" scope="col"><div align="center"><i18n:message key="indexpool_crawlTime" /></div></th>
                    	<th width="61" align="center" valign="middle" scope="col"><div align="center"><i18n:message key="indexpool_deleteStatus" /></div></th>
                  	</tr>
					<%
					String folderName = "";
					for (int j = 0; j < statusNum; j++) {		
						//IDB name
						File statusExist = new File(folderPath + foldersName[j].getName() + "/meta/status");
						File starttimeExist = new File(folderPath + foldersName[j].getName() + "/meta/starttime");
						if(statusExist.exists() && starttimeExist.exists()){
							try {								
								folderName = foldersName[j].getName();								
								out.println("<form method=\"get\" id=\"dbstatusForm" + j + "\" action=\"IDBOperate.do\">");
								out.println("<tr>");
								out.println("<td align=\"center\" valign=\"middle\"><div align=\"center\">");
								out.println(folderName);
							} catch (NullPointerException e){
							
							} 
							out.println("</div> </td>");

							//TODO if(status=="finish") then "delete"
							// ps status
							try{
							FileReader fr = new FileReader(folderPath + foldersName[j].getName() + "/meta/status");
							FileReader fr2 = new FileReader(folderPath + foldersName[j].getName() + "/meta/starttime");
							BufferedReader br = new BufferedReader(fr);
							BufferedReader br2 = new BufferedReader(fr2);
							String ps_runtime = br2.readLine();
							String ps_status = br.readLine();
							out.print("<td align=\"center\" valign=\"middle\"><div align=\"center\">");
							out.print(ps_status);
							if(ps_status.equals("finish")){
								out.println("<input type=\"hidden\" name=\"statusDBName\" value=\"" + foldersName[j].getName() +  "\">");
								out.println(" -this status should be kill");
							}
							out.print("</div> </td>");
							br.close();
							fr.close();

							// running time
							
							
		
							Date t = new Date();
							Long currentSec=System.currentTimeMillis() / 1000;
							int totalSec = (int)(currentSec - Long.parseLong(ps_runtime));
							int psHour = totalSec / 3600;
							int psMin = (totalSec % 3600) / 60 ;
							int psSec = (totalSec % 3600) % 60 ;
							out.println("<td align=\"center\" valign=\"middle\"><div align=\"center\">");
							out.println(psHour + "h:" + psMin + "m:" + psSec + "s");
							out.println("</div> </td>");
							br2.close();
							fr2.close();	
					
							out.println("<td align=\"center\" valign=\"middle\"><div align=\"center\">");
							String[] ps_tmp = ps_runtime.split("h:");
							int ps_hour = Integer.parseInt(ps_tmp[0]);
							
							
							if (psHour > 2 && (ps_status.equals("crawling"))){
									out.println("<input type=\"submit\" name=\"Fix\" value=\"Fix Job\" onclick=\"fixDB(" + j + ")\" />");
									out.println("<input type=\"hidden\" name=\"statusDBName\" value=\"" + foldersName[j].getName() +  "\">");
									out.println("<input type=\"hidden\" name=\"statusOper\" value=\"fixdb\">");						
							}	
						
							// delete status
							if ( ps_status.equals("finish") | ps_status.equals("stop") | ps_status.startsWith("error")){
								out.println("<input type=\"button\" name=\"Delete\" value=\"Delete Status\" call=\"true\" callForm=\"dbstatusForm" + j + "\" />");
								out.println("<input type=\"hidden\" name=\"statusDBName\" value=\"" + foldersName[j].getName() +  "\">");
								out.println("<input type=\"hidden\" name=\"statusOper\" value=\"deleteStatus\">");
							}
							out.println("</div> </td>");
							out.println("</tr>"); 	
							out.println("</form>");
							}
							catch (NullPointerException e){
								
							}
						}
						
				}
				%>
				</table></div>
	<!-- 索引庫操作 -->
                <p class="info noprint">&nbsp;</p>
              </div>
		</div>
		<p class="info noprint"><i18n:message key="indexpool_IDBList" /></p>
		<table width="507" border="1">
  			<tr>
    			<th width="61" align="center" valign="middle" scope="col"><div align="center"><i18n:message key="indexpool_IDBName" /></div></th>
    			<th width="82" align="center" valign="middle" scope="col"><div align="center"><i18n:message key="indexpool_createTime" /></div></th>
   				<th width="106" align="center" valign="middle" scope="col"><div align="center"><i18n:message key="indexpool_crawlTime" /></div></th>
  				<th width="40" align="center" valign="middle" scope="col"><div align="center"><i18n:message key="indexpool_crawlDepth" /></div></th>
  				<th width="118" align="center" valign="middle" scope="col"><div align="center"><i18n:message key="indexpool_IDBOper" /></div></th>
  				<th width="60" align="center" valign="middle" scope="col"><div align="center"><i18n:message key="indexpool_submit" /></div></th>
 			</tr>
	        <%
	        try{
				for (int j = 0; j < IDBNum; j++) {		
					out.println("<form name=\"runForm\" method=\"post\" action=\"IDBOperate.do\">");
					//IDB name
					out.println("<input type=\"hidden\" name=\"operIDBName\" value=\"" + IDBfoldersName[j].getName() +  "\">");
					out.println("<input type=\"hidden\" name=\"operIDBName\" value=\"" + userName +  "\">");
					//out.print("<form method=\"get\" name=\"idbOperateForm\" >");
					out.println("<tr>");
					out.println("<td align=\"center\" valign=\"middle\"><div align=\"center\">");
					request.setAttribute("poolIDBName",IDBfoldersName[j].getName());
					out.println("<a href=\"IDBDetial.jsp?IDB="+ IDBfoldersName[j].getName() + "&USERNAME="+ userName + "\">" + IDBfoldersName[j].getName() + "</a>");		
					out.println("</div> </td>");
	
					// IDB建立時間
					out.print("<td>");
					Date lastModified = new Date(IDBfoldersName[j].lastModified());
					SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					out.println(dateFormat.format(lastModified));
					out.println("</td>");
	
					// 爬取時間
					FileReader frIDBPasstime = new FileReader(IDBfoldersName[j] + "/meta/passtime");
					BufferedReader br3 = new BufferedReader(frIDBPasstime);
					String IDBPasstime = br3.readLine();
					out.println("<td align=\"center\" valign=\"middle\"><div align=\"center\">");
					out.println(IDBPasstime);
					out.println("</div> </td>");
					br3.close();
					frIDBPasstime.close();
		
					// 爬取深度
					FileReader frIDBDepth = new FileReader(IDBfoldersName[j] + "/meta/depth");
					BufferedReader br2 = new BufferedReader(frIDBDepth);
					String IDBDepth = br2.readLine();
					out.println("<td align=\"center\" valign=\"middle\"><div align=\"center\">");
					out.println(IDBDepth);
					out.println("</div> </td>");
					br2.close();
					frIDBDepth.close();	
	
					// 索引庫操作
					// 傳IDBName給Servlet 
					out.println("<td align=\"center\" valign=\"middle\"><div align=\"center\"><select name=\"operSelect\" id=\"select" + j + "\">\"");
					out.println("<option value=unchoose>Select</option>");
					out.println("<option value=\"recrawl\">Re-Crawl</option>");
					out.println("<option value=\"delete\">Delete IDB</option>");
					out.println("</select></div></td>");

					//執行鈕		
					out.println("<td><button>Run</button> </td>"); 
					out.println("</form>");
		  		} 
	        }
	        catch(IOException e){
				out.println("<td width=\"180\"align=\"center\" valign=\"middle\"><div align=\"center\"> No file exist! </td>");
		 	}
			catch(NullPointerException e){	
				out.println("<td width=\"180\"align=\"center\" valign=\"middle\"><div align=\"center\"> No indexpool exist! </td>");
		 	}
			%>

		</div>
				</td>
 			 </tr>
		</table>
		<p class="info noprint">&nbsp;</p>
		<p>&nbsp;</p>
	</div>    
    <hr class="noscreen" />                    
    <hr class="noscreen" />
</div> <!-- /content -->
<div id="col" class="noprint">
	<div id="col-in">
		<h3 ><i18n:message key="indexpool_SEList" /></h3>
		<ul id="category">
		<%
		try{
			for(int j=0; j < IDBNum; j++){
				out.println("<li><a href=http://" + masterIPAddress + "/" + userName + "_" +IDBfoldersName[j].getName()+ ">" + IDBfoldersName[j].getName() + "</a></li>");
			}
		}
		catch(NullPointerException e){
			out.println("No indexpool exist!");
	 	}
		%> 
		</ul>
		<h3 ><i18n:message key="indexpool_nodeStstus" /></h3>
		<ul id="category">
			<li>
			<a target="_new" href=<%out.println("http://" + masterIPAddress + ":50030");%>><i18n:message key="indexpool_jobtrackerStatus" /></a>              </li>
			<li>
			<a target="_new" href=<%out.println("http://" + masterIPAddress + ":50070");%>><i18n:message key="indexpool_namenodeStatus" /></a>              </li>
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

<div id="backmark" style="index: -9999; position:absolute; display:none; background-color: #EAEAEA; filter:alpha(opacity=25); -moz-opacity:0.25; opacity: 0.25;">
<div class='featurebox_center'>
<script>
	setInterval( "SANAjax();", 5000 );  ///////// 10 seconds
	$(function() {
		SANAjax = function(){
			//window.location.reload();
			$('#dataDisplay').location.reload();
			//$('#dataDisplay').fadeOut('slow').load('indexpool.jsp').fadeIn('slow');
		}
	});

	$(document).ready(function() {
		// initial
		//$( "#dialog:ui-dialog" ).dialog( "destroy" );
		var submitForm;
		$("#dialog-confirm").dialog({
			autoOpen : false,
			resizable : false,
			height : 170,
			modal : true,
			buttons : {
				"Delete all items" : function() {
					//$( this ).dialog( "close" );
					//alert(submitForm);
					$("#" + submitForm).submit();
					//return true;
				},
				Cancel : function() {
					$( this ).dialog( "close" );
					//return false;
				}
			}
		});
		
		// event
		$('input[type="button"][call="true"]').click(function() {
			submitForm = $(this).attr("callForm");
			$('#dialog-confirm').dialog("open");
			return false;
		});
	});
</script>
</body>
</html>