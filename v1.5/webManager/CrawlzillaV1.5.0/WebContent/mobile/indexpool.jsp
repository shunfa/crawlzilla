<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Index Database Management</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="http://code.jquery.com/mobile/1.0.1/jquery.mobile-1.0.1.min.css" />
<script type="text/javascript" language="javascript"
	src="js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" language="javascript"
	src="js/jquery.mobile-1.0.1.min.js"></script>
</head>
<jsp:useBean id="nutchDBNum" class="org.nchc.crawlzilla.bean.NutchDBNumBean" scope="session" /> 
<jsp:useBean id="nutchDBStatus" class="org.nchc.crawlzilla.bean.NutchDBStatusBean" scope="session" /> 

<body>
<%
String loginFormURL = "login.jsp";
String user = (String) session.getAttribute("userName");
	if (session.getAttribute("loginFlag") == "true") {
		System.out.println("has been login!");
		String userName = session.getAttribute("userName").toString();
		String lang = session.getAttribute("language").toString();
		Locale locale = new Locale(lang);
		
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
	<div data-role="content">
		<h2>Index Database list</h2>
		<div class="content-primary">
			<ul data-role="listview">
			<%
	        try{
				for (int j = 0; j < IDBNum; j++) {		
					//IDB name
					request.setAttribute("poolIDBName",IDBfoldersName[j].getName());

					// IDB建立時間
					Date lastModified = new Date(IDBfoldersName[j].lastModified());
					SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
					// 爬取時間
					FileReader frIDBPasstime = new FileReader(IDBfoldersName[j] + "/meta/passtime");
					BufferedReader br3 = new BufferedReader(frIDBPasstime);
					String IDBPasstime = br3.readLine();
					br3.close();
					frIDBPasstime.close();
		
					// 爬取深度
					FileReader frIDBDepth = new FileReader(IDBfoldersName[j] + "/meta/depth");
					BufferedReader br2 = new BufferedReader(frIDBDepth);
					String IDBDepth = br2.readLine();
					
					out.println("<li data-role=\"list-divider\">" + IDBfoldersName[j].getName() + "</span>");
					out.println("</li><li><a href=\"IDBDetial.jsp?IDB=" + IDBfoldersName[j].getName()+ "&&USERNAME=" + userName + "\">");
					out.println("<p>Create Time: <strong>" + dateFormat.format(lastModified) +"</strong></p><p>	Crawling Time: <strong>" + IDBPasstime + "</strong></p>	<p>	Crawling Depth: <strong>" + IDBDepth + "</strong> </p> </a></li>");
					
					br2.close();
					frIDBDepth.close();	
		  		} 
	        }
	        catch(IOException e){
				//out.println("<td width=\"180\"align=\"center\" valign=\"middle\"><div align=\"center\"> No file exist! </td>");
		 	}
			catch(NullPointerException e){	
				//out.println("<td width=\"180\"align=\"center\" valign=\"middle\"><div align=\"center\"> No indexpool exist! </td>");
		 	}
			%>
			

			</ul>
			</dvi>

			<h2>State of the system crawling</h2>
			<div class="content-primary">
				<ul data-role="listview">
				
				<%
					String folderName = "";
					for (int j = 0; j < statusNum; j++) {		
						//IDB name
						File statusExist = new File(folderPath + foldersName[j].getName() + "/meta/status");
						File starttimeExist = new File(folderPath + foldersName[j].getName() + "/meta/starttime");
						if(statusExist.exists() && starttimeExist.exists()){
							try {								
								folderName = foldersName[j].getName();								
								out.println("<li data-role=\"list-divider\">" + folderName + "</li>");
							} catch (NullPointerException e){
							
							} 
							try{
							FileReader fr = new FileReader(folderPath + foldersName[j].getName() + "/meta/status");
							FileReader fr2 = new FileReader(folderPath + foldersName[j].getName() + "/meta/starttime");
							BufferedReader br = new BufferedReader(fr);
							BufferedReader br2 = new BufferedReader(fr2);
							String ps_runtime = br2.readLine();
							String ps_status = br.readLine();
							out.print("<li><p> Crawling status: <p></p> <strong>" + ps_status + "</strong> </p>");
							//out.print(ps_status);
							if(ps_status.equals("finish")){
								out.println("<input type=\"hidden\" name=\"statusDBName\" value=\"" + foldersName[j].getName() +  "\">");
								out.println(" -this status should be kill");
							}
							br.close();
							fr.close();

							// running time

							Date t = new Date();
							Long currentSec=System.currentTimeMillis() / 1000;
							int totalSec = (int)(currentSec - Long.parseLong(ps_runtime));
							int psHour = totalSec / 3600;
							int psMin = (totalSec % 3600) / 60 ;
							int psSec = (totalSec % 3600) % 60 ;
							out.println("<li><p>Crawling Time: <p></p><strong>" + psHour + "h:" + psMin + "m:" + psSec + "s" + "</strong></p></li>");
							br2.close();
							fr2.close();	
					
							String[] ps_tmp = ps_runtime.split("h:");
							int ps_hour = Integer.parseInt(ps_tmp[0]);
							
							
							if (psHour > 2 && (ps_status.equals("crawling"))){
									//out.println("<input type=\"submit\" name=\"Fix\" value=\"Fix Job\" onclick=\"fixDB(" + j + ")\" />");
									//out.println("<input type=\"hidden\" name=\"statusDBName\" value=\"" + foldersName[j].getName() +  "\">");
									//out.println("<input type=\"hidden\" name=\"statusOper\" value=\"fixdb\">");						
							}	
						
							// delete status
							if ( ps_status.equals("finish") | ps_status.equals("stop") | ps_status.startsWith("error")){
								//out.println("<input type=\"button\" name=\"Delete\" value=\"Delete Status\" call=\"true\" callForm=\"dbstatusForm" + j + "\" />");
								//out.println("<input type=\"hidden\" name=\"statusDBName\" value=\"" + foldersName[j].getName() +  "\">");
								//out.println("<input type=\"hidden\" name=\"statusOper\" value=\"deleteStatus\">");
							}
							}
							catch (NullPointerException e){
								
							}
						}
				}
				%>
				
	
				</ul>
				</dvi>
			</div>
			<p></p>
			<p></p>
			<div data-role="footer">
				<h4>
					<a href="index.jsp">Back </a>
				</h4>
			</div>
			<% } %>
</body>
</html>