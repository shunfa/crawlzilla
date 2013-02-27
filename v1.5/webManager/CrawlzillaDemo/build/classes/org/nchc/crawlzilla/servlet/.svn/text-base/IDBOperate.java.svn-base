package org.nchc.crawlzilla.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.nchc.crawlzilla.bean.IDBOperateBean;


/**
 * Servlet implementation class IDBOperate
 */
public class IDBOperate extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public IDBOperate() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession(true);
		String userName = session.getAttribute("userName").toString();
		String statusDBname = request.getParameter("statusDBName");
		String statusOper = request.getParameter("statusOper");
		System.out.println(statusOper);
		System.out.println(statusDBname);
		IDBOperateBean op = new IDBOperateBean();
		if(statusOper.equals("deleteStatus")){
			try {
				op.deleteDBStatus(userName, statusDBname);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			catch (NullPointerException e){
				System.out.println("catch NullPointerException");
			}

		}		
		
		if(statusOper.equals("fixdb")){
			try {
				op.fixDB(userName, statusDBname);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			System.out.println(statusDBname + " fixdb...");
		}
		
		response.sendRedirect("indexpool.jsp");	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		String operOption = request.getParameter("operSelect");
		String operIDBName = request.getParameter("operIDBName");
		//String userName = request.getParameter("userName");
		HttpSession session = request.getSession(true);
		String userName = session.getAttribute("userName").toString();
		IDBOperateBean op = new IDBOperateBean();
		if(operOption.equals("recrawl")){			
			try {
				op.recrawl(userName, operIDBName);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			System.out.println("IDB Name = " + operIDBName + "; operate = " + operOption);
		} else if(operOption.equals("preview")){
			try {
				op.preview(operIDBName);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			System.out.println("IDB Name = " + operIDBName + "; operate = " + operOption);
		} else if(operOption.equals("delete")){
			try {
				op.deleteDB(userName, operIDBName);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}	
			System.out.println("IDB Name = " + operIDBName + "; operate = " + operOption);
		} else {
			System.out.println("IDB Name = " + operIDBName + "; operate = " + operOption);
		}
		response.sendRedirect("crawlstatus.jsp");	
	}
}
