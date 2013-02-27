<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div id="right_side">
    <h3><i18n:message key="rSide_Link" /></h3>
      <p><a href="../default"><i18n:message key="rSide_Example" /></a></p>
      <%@ include file="/include/DB_list.jsp" %>
    <% if(session.getAttribute("confirm") == "true") { %>
    <h3><i18n:message key="rSide_Function" /></h3>
      <p><a href="change_PW.jsp"><i18n:message key="rSide_ChangePw" /></a></p>
    <% } %>
    <h3><i18n:message key="rSide_Related" /></h3>
      <p><a href="http://code.google.com/p/crawlzilla/">CrawlZilla@GoogleCode</a></p>
</div>
