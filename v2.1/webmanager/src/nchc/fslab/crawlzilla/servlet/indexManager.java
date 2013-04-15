package nchc.fslab.crawlzilla.servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nchc.fslab.crawlzilla.bean.dbOperBean;

public class indexManager extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public indexManager() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String targetURL = "/systemMassage.jsp";
		String tranPageFlag = "false";
   String tranPage = "searchManager.jsp";
		String strMessage = "In Processing, Please Wait...";
//		String operationJOB = request.getParameter("oper");
		String strDBName = request.getParameter("dbName");
		int operationVal = Integer.parseInt(request.getParameter("option"));
		dbOperBean dOB = new dbOperBean();
		
		switch (operationVal){
			case 1:
				// Fix
				System.out.println("fix Jobs from web.");
				dOB.fixDB(strDBName);
				break;
				
			case 2:
				// kill job
				dOB.killDB(strDBName);
				break;
				
			case 3:
				// delete
				dOB.deleteDB(strDBName);
				break;
				
				default:
					
		}
		
		request.setAttribute("tranPageFlag", tranPageFlag);
		request.setAttribute("strMessage", strMessage);
		request.setAttribute("tranPage", tranPage);
		RequestDispatcher rd;
		rd = getServletContext().getRequestDispatcher(targetURL);
		rd.forward(request, response);
	}
}
