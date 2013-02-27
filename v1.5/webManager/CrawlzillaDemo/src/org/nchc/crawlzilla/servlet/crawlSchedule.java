package org.nchc.crawlzilla.servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.nchc.crawlzilla.bean.orderBean;

/**
 * Servlet implementation class crawlSchedule
 */
public class crawlSchedule extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public crawlSchedule() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String jobID = request.getParameter("jobID").toString();
		String user = request.getParameter("user").toString();
		System.out.println("Job ID = " + jobID);	
		System.out.println("user = " + user);	
		
		orderBean deleteJob = new orderBean();		
		try {
			deleteJob.deleteOrder(user, jobID);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		response.sendRedirect("order.jsp");	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		orderBean addOrder = new orderBean();
		HttpSession session = request.getSession(true);
		String user = session.getAttribute("userName").toString();
		String IDBName = request.getParameter("IDBName").toString();
		String scheduleDate = request.getParameter("scheduleDate").toString();
		String scheduleTimeHr = request.getParameter("scheduleTimeHr").toString();
		String scheduleTimeMin = request.getParameter("scheduleTimeMin").toString();
		String crawlFreq = request.getParameter("crawlFreq").toString();
		String date[] = scheduleDate.split("/");
		
		if (Integer.valueOf(scheduleTimeHr) < 10){
			scheduleTimeHr = "0" + scheduleTimeHr;
		}
		
		if (Integer.valueOf(scheduleTimeMin) < 10){
			scheduleTimeMin = "0" + scheduleTimeMin;
		}		
		//TODO date == null!!
		
		
		if (scheduleDate == ""){
			String targetURL="/systemMessage.jsp";
			String message = "排成日期不得為空 <p> 請回上一頁重新輸入 </p>";
			request.setAttribute("message", message);
			RequestDispatcher rd;
	        rd = getServletContext().getRequestDispatcher(targetURL);
	        rd.forward(request, response);
			System.out.print("Date is null!");
		} else {
			//2011 04 01 17 20 test1 weekly
			String scheduleInfo = date[2] + " " + date[0] + " " + date[1] + " " + scheduleTimeHr + " " + scheduleTimeMin + " " + crawlFreq + " " + IDBName + "\n";
			System.out.println(scheduleInfo);
			
			addOrder.addOrder(user, scheduleInfo);
			addOrder.tranOrder(user, scheduleInfo, IDBName, "redo");
			try {
				addOrder.mergrAll();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			response.sendRedirect("order.jsp");	
		}
	}
}
