<%@page import="java.io.File"%>
<hr class="noscreen" />
<jsp:useBean id="nutchDBNum" class="org.nchc.crawlzilla.bean.NutchDBNumBean" scope="session" /> 
<jsp:useBean id="nutchDBStatus" class="org.nchc.crawlzilla.bean.NutchDBStatusBean" scope="session" /> 

<%
	String sIPAddress = request.getServerName();
 	// TODO 目前僅寫單人admin version
 	String IDBfolderPath="/home/crawler/crawlzilla/user/admin/IDB";
 	nutchDBNum.setNum(IDBfolderPath);
 	int IDBNum = nutchDBNum.getNum();
 	nutchDBStatus.setFolders(IDBfolderPath);
 	File IDBfoldersName[] = nutchDBStatus.getFolders();
 	String masterIPAddress = request.getServerName();
 %>
 <%
 	for(int j=0; j < IDBNum; j++){
		out.print("<li><a href=http://" + sIPAddress + "/" + IDBfoldersName[j].getName()+ ">" + IDBfoldersName[j].getName() + "</a></li>");
	}
 %> 