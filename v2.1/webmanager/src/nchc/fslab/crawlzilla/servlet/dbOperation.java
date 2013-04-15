package nchc.fslab.crawlzilla.servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nchc.fslab.crawlzilla.bean.dbOperBean;
import nchc.fslab.crawlzilla.bean.infoOperBean;

public class dbOperation extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public dbOperation() {
		super();
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String tranPageFlag = "false";
		String tranPage = "searchManager.jsp";
		String strMessage = "In Processing, Please Wait...";
		String operationCMD = request.getParameter("oper");
		String targetURL = "/systemMassage.jsp";
		if (operationCMD.equals("hideMesg")) {
			String DBName = request.getParameter("dbName");
			infoOperBean iOB = new infoOperBean();
			iOB.changeHideInfoFlag(DBName, false);
			targetURL = "/searchManager.jsp";
		}

		if (operationCMD.equals("deleteDB")) {
			String DBName = request.getParameter("dbName");
			dbOperBean dbOB = new dbOperBean();
			dbOB.deleteDB(DBName);
			System.out.println("delete: " + DBName);
			targetURL = "/searchManager.jsp";
		}

		request.setAttribute("tranPageFlag", tranPageFlag);
		request.setAttribute("strMessage", strMessage);
		request.setAttribute("tranPage", tranPage);
		RequestDispatcher rd;
		rd = getServletContext().getRequestDispatcher(targetURL);
		rd.forward(request, response);
	}
}
