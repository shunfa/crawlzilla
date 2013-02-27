<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0" prefix="i18n"%>
<%@ page import="java.util.*"%>
<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="cs" lang="cs">
<%@ include file="/include/header.jsp"%>

<%
String loginFormURL = "login.jsp";
String user = (String) session.getAttribute("userName");
String cgangePW = "change_PW.jsp";
	
if (session.getAttribute("loginFlag") == "true") {
	System.out.println("has been login!");
	String lang = session.getAttribute("language").toString();
	Locale locale = new Locale(lang);
	
%>
<i18n:bundle baseName="org.nchc.crawlzilla.i18n.lang"
		locale="<%=locale%>" id="bundle" />
<title>Crawlzilla Search Engine Manager</title>
<hr class="noscreen" />
            <!-- Breadcrumbs -->
            <p id="breadcrumbs">&nbsp;</p>
            <hr class="noscreen" />
        </div> <!-- /strip -->
        <div id="content">
          <div id=home>
            <div class="article">
                <h2><i18n:message key="index_welcome" /></h2>
                <h3><p class="info noprint"><i18n:message key="index_function" /></p></h3>
                <h3><p><i18n:message key="index_crawl" /></p>
                <p><i18n:message key="index_indexpool" /></p>
                <p><i18n:message key="index_order" /></p>
                <p><i18n:message key="index_slaveInstall" /></p>
                <p><i18n:message key="index_systemSetup" /></p></h3>
                <h2>體驗網站使用注意事項</h2>
                <h3><p>1. 本網站設置目的為用戶體驗及提供軟體之壓力測試，體驗帳號有資料遺失之風險。</p>
                <p>2. 若於使用中有任何問題及建議，歡迎提供意見。</p>
                <p>3. 因負載有限，體驗網站僅提供單一會員建立三個搜尋引擎</p>
                <p>4. 架設環境請參考官方網站(http://crawlzilla.info)之說明文件。</p></h3>
                <h2>開發人員及聯絡方式</h2>
                <h3><p>陳威宇 	waue@nchc.org.tw / waue0920@gmail.com</p>
                <p>楊順發 	shunfa@nchc.org.tw / shunfa@gmail.com </p></h3>
                <p class="info noprint">&nbsp;</p>
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
<%
	} else { 
%>
		<br><i18n:message key="public_nonlogin" /></br>
<%	response.setHeader("Refresh", "5; URL=" + loginFormURL);
	 }
%>


</body>
</html>