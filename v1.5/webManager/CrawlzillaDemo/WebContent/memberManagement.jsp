<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>
<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="cs" lang="cs">
<% String title = "changePW.jsp"; %>


<%@ include file="/include/header.jsp"%>
<%
String loginFormURL = "login.jsp";
String user = (String) session.getAttribute("userName");
	if ((session.getAttribute("loginFlag") == "true") && 
			(session.getAttribute("userName").toString().equals("admin")))  
	{
		System.out.println("has been login!");
		String userName = session.getAttribute("userName").toString();
		String lang = session.getAttribute("language").toString();
		Locale locale = new Locale(lang);	
%>
<i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang"
		locale="<%=locale%>" id="bundle" />
<title><i18n:message key="memberManagement_account" /></title>
<jsp:useBean id="memberListBean" class="org.nchc.crawlzilla.bean.memberListBean" scope="session" />  
<hr class="noscreen" />
<p id="breadcrumbs">&nbsp;</p>
<hr class="noscreen" />
</div> <!-- /strip -->
<div id="dialog-confirm" title="Dtelte this item?" style="display: none">
	<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>These items will be permanently deleted and cannot be recovered. Are you sure?</p>
</div>
<div id="content">
	<div id=home>
		<div class="article">
        	<h2><i18n:message key="memberManagement_userList" /></h2>
        	<%
				memberListBean.setFolders("/home/crawler/crawlzilla/user");
				File memberName[] = memberListBean.getFolders();
				int memberNum = memberListBean.setNum("/home/crawler/crawlzilla/user");
				int IDBNums = 0;
			%> 
        	<p></p>
            	<table width="450" border="10">
                	<tr>
                    	<th width="150" align="center" scope="col" valign="middle"><div align="center"> <i18n:message key="memberManagement_user" /></th>
                    	<th width="150" align="center" scope="col" valign="middle"><div align="center"> e-mail </th>
                    	<th width="150" align="center" scope="col" valign="middle"><div align="center"> <i18n:message key="memberManagement_SENO" /></th>
                    	<th width="150" align="center" scope="col" valign="middle"><div align="center"> <i18n:message key="memberManagement_delUser" /></th>
                  	</tr>
                  	<%
                  		for (int i=0; i < memberNum; i++){
                  			out.println("<form method=\"post\" id=\"userForm" + i + "\" action=\"memberManager.do\">");
        					out.println("<tr>");
        					out.println("<td align=\"center\" valign=\"middle\"><div align=\"center\">");
        					out.println(memberName[i].getName());
        					out.println("</div> </td>");
        					out.println("<td align=\"center\" valign=\"middle\"><div align=\"center\">");
        					out.println(memberListBean.showEmail("/home/crawler/crawlzilla/user/" + memberName[i].getName() + "/meta/email"));
        					out.println("</div> </td>");
        					out.println("<td align=\"center\" valign=\"middle\"><div align=\"center\">");
        					out.println(memberListBean.setNum("/home/crawler/crawlzilla/user/" + memberName[i].getName() + "/IDB/"));
        					IDBNums += memberListBean.setNum("/home/crawler/crawlzilla/user/" + memberName[i].getName() + "/IDB/");
        					out.println("</div> </td>");
        					out.println("<td align=\"center\" valign=\"middle\"><div align=\"center\">");
        					out.println("<input type=\"button\" name=\"operation\" value=\"Delete User\" call=\"true\" callForm=\"userForm" + i + "\" />");
        					out.println("<input type=\"hidden\" name=\"memberName\" value=\"" + memberName[i].getName() +  "\">");
        					out.println("<input type=\"hidden\" name=\"memberEmail\" value=\"" + memberListBean.showEmail("/home/crawler/crawlzilla/user/" + memberName[i].getName() + "/meta/email") +  "\">");
        					out.println("<input type=\"hidden\" name=\"operation\" value=\"delete\">");
        					out.println("</div> </td>");
    						out.println("</tr>"); 	
    						out.println("</form>");                			
                		}
                  	%>
                </table>
                <p></p>

                <h2><i18n:message key="memberManagement_acceptNew" /></h2>
                <p>&nbsp;</p>
            <%
				memberListBean.setFolders("/home/crawler/crawlzilla/applyUser");
				File applyName[] = memberListBean.getFolders();
				int applyNum = memberListBean.setNum("/home/crawler/crawlzilla/applyUser");
                if(applyNum == 0){
                	out.println("目前尚無未啟動之會員。");
                } else if( applyNum > 0 ) { 
            %>
                  	<table width="450" border="10">
                	<tr>
                    	<th width="150" align="center" scope="col" valign="middle"><div align="center"> <i18n:message key="memberManagement_user" /></th>
                    	<th width="150" align="center" scope="col" valign="middle"><div align="center"> e-mail </th>
                    	<th width="150" align="center" scope="col" valign="middle"><div align="center"> <i18n:message key="memberManagement_applyTime" /></th>
                    	<th width="150" align="center" scope="col" valign="middle"><div align="center"> <i18n:message key="memberManagement_confUser" /></th>
                  	</tr>
                  	<% 
                  		for (int i=0; i < applyNum; i++){
                  			out.println("<form method=\"post\" id=\"acceptUser" + i + "\" action=\"memberManager.do\">");
        					out.println("<tr>");
        					out.println("<td align=\"center\" valign=\"middle\"><div align=\"center\">");
        					out.println(applyName[i].getName());
        					out.println("</div> </td>");
        					out.println("<td align=\"center\" valign=\"middle\"><div align=\"center\">");
        					out.println(memberListBean.showEmail("/home/crawler/crawlzilla/applyUser/" + applyName[i].getName() + "/meta/email"));
        					out.println("</div> </td>");
        					out.println("<td align=\"center\" valign=\"middle\"><div align=\"center\">");
        					Date lastModified = new Date(applyName[i].lastModified());
        					SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        					out.println(dateFormat.format(lastModified));
        					out.println("</div> </td>");
        					out.println("<td align=\"center\" valign=\"middle\"><div align=\"center\">");
        					//out.println("<input type=\"button\" name=\"operation\" value=\"Accept User\" call=\"true\" callForm=\"acceptUser" + i + "\" />");
        					out.println("<button>Accept User</button>"); 
        					out.println("<input type=\"hidden\" name=\"memberName\" value=\"" + applyName[i].getName() +  "\">");
        					out.println("<input type=\"hidden\" name=\"operation\" value=\"accept\">");
        					out.println("</div> </td>");
    						out.println("</tr>"); 	
    						out.println("</form>");                			
                		}
                  	}
                  	%>
                </table>
                <p></p> 
                
              <h2>系統概況</h2>
              <p></p>
                	<table width="450" border="10">
                	<tr>
                    	<th width="150" align="center" scope="col" valign="middle"><div align="center"> 項目</th>
                    	<th width="150" align="center" scope="col" valign="middle"><div align="center"> 數量 </th>
                  	</tr>
                  	<tr>
                    	<td width="150" align="center" scope="col" valign="middle"><div align="center"> 會員人數</td>
                    	<td width="150" align="center" scope="col" valign="middle"><div align="center"> <% out.println(memberNum); %> </td>
                  	</tr>
                  	<tr>
                    	<td width="150" align="center" scope="col" valign="middle"><div align="center"> 搜尋引擎總數 </td>
                    	<td width="150" align="center" scope="col" valign="middle"><div align="center"> <% out.println(IDBNums); %> </td>
                  	</tr>                
                  	</table>
              <p class="info noprint"><label for="textfield2"></label></p>
           </div> 
	</div> 
    <hr class="noscreen" />                    
    <hr class="noscreen" />
</div> <!-- /content -->
<div id="col" class="noprint">
	<div id="col-in">
	
		<%@ include file="/include/rightside.jsp"%>
		
		
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
<script>

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

		$('form[name="runForm"]').submit( function(){
			
			//alert("sumbmit");
			var w = $(window.document).width();
			var h = $(window.document).height();
			//alert(w+","+h);
			$('#backmark').width(w);
			$('#backmark').height(h);
			$('#backmark').css('left','0px');
			$('#backmark').css('top','0px');
			$('#backmark').css('position','absolute')
			$('#backmark').show("fast");
			
			return true;
		});
	});
</script>
</html>