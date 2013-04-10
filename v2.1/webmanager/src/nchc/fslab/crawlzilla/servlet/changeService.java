package nchc.fslab.crawlzilla.servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nchc.fslab.crawlzilla.bean.infoOperBean;

public class changeService extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public changeService() {
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String targetURL = "/settings.jsp";
		String oper = request.getParameter("oper");
		infoOperBean iOB = new infoOperBean();
		if (oper.equals("solrService")) {
			int intOption = Integer.parseInt(request.getParameter("option"));
			switch (intOption) {
			case 1:
				iOB.changeSolrService("start");
				break;
			case 2:
				iOB.changeSolrService("stop");
				break;
			}
		}
		RequestDispatcher rd;
		rd = getServletContext().getRequestDispatcher(targetURL);
		rd.forward(request, response);
	}
}
