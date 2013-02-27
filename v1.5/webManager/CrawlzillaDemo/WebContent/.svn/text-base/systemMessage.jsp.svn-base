<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n"%>
<%@ page import="java.util.*"%>
<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="cs" lang="cs">
<% String title = "systemMessage.jsp"; %>
<%@ include file="/include/header.jsp"%>
<% 
	String message=(String)request.getAttribute("message");
%>
<title><i18n:message key="systemMessage_Message" /></title>
<hr class="noscreen" />
            <!-- Breadcrumbs -->
            <p id="breadcrumbs">&nbsp;</p>
            <hr class="noscreen" />
        </div> <!-- /strip -->
        <div id="content">
          <div id=home>
            <div class="article">
                <h2><i18n:message key="systemMessage_Message" /></h2>
                <p class="info noprint"> <% out.print(message); %></p>
                <a href="javascript:history.back();"><i18n:message key="systemMessage_goBack" /></a>
          </div> <!-- /article -->
		</div> <!-- home --><!-- crawl -->       
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
</body>
</html>