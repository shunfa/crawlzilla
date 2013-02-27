<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/i18n-1.0"
	prefix="i18n"%>
<%@ page import="java.util.*"%>
<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="cs" lang="cs">
<%
	String title = "index.jsp";
%>
<%@ include file="/include/header.jsp"%>

<%
	File passwd_file = new File(
			"/home/crawler/crawlzilla/user/admin/meta/passwd");
	if (!passwd_file.exists()) {

		session.setAttribute("loginFlag", "true");
		session.setAttribute("language", "en");
		session.setAttribute("userName", "admin");
		response.setHeader("Refresh", "0; URL=changeDefPW.jsp");
	}
	//# not login
	else if (session.getAttribute("loginFlag") != "true") {
%>
<br><i18n:message key="public_nonlogin" /></br>
<%
	response.setHeader("Refresh", "1; URL=login.jsp");
	}
	//# Login, display the home page
	else {

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
</div>
<!-- /strip -->
<div id="content">
	<div id=home>
		<div class="article">
			<h2>
				<i18n:message key="index_welcome" />
			</h2>
			<h3>
				<p class="info noprint">
					<i18n:message key="index_function" />
				</p>
			</h3>
			<p>
				<i18n:message key="index_crawl" />
			</p>
			<p>
				<i18n:message key="index_indexpool" />
			</p>
			<p>
				<i18n:message key="index_order" />
			</p>
			<p>
				<i18n:message key="index_slaveInstall" />
			</p>
			<p>
				<i18n:message key="index_systemSetup" />
			</p>
			<p class="info noprint">&nbsp;</p>
		</div>
		<!-- /article -->
	</div>
	<!-- home -->
	<!-- crawl -->
	<hr class="noscreen" />
	<hr class="noscreen" />
</div>
<!-- /content -->
<div id="col" class="noprint">
	<div id="col-in">
		<%@ include file="/include/rightside.jsp"%>
		<hr class="noscreen" />
	</div>
	<!-- /col-in -->
</div>
<!-- /col -->
</div>
<!-- /page-in -->
</div>
<!-- /page -->
<%@ include file="/include/footer.jsp"%>

</body>
</html>

<%
	}
%>