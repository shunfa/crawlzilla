package nchc.fslab.crawlzilla.servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import nchc.fslab.crawlzilla.bean.adminLoginBean;

public class userLogin extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public userLogin() {
		super();
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		String targetURL = "/index.jsp";
		adminLoginBean adLB = new adminLoginBean();

		String operation = request.getParameter("oper");
		String tranUrl = "index.jsp";

		if (operation.equals("admin_login")) {
			String passwd = request.getParameter("admin_password");
			if (adLB.adminLogin(passwd)) {
				HttpSession session = request.getSession(true);
				session.setAttribute("loginFlag", "true");
				if (passwd.equals("crawler")) {
					tranUrl = "changePW.jsp";
				}
//				response.sendRedirect(tranUrl);
				System.out.println(session.getAttribute("loginFlag").toString());
				System.out.println("login...");
			}
		}
		RequestDispatcher rd;
		rd = getServletContext().getRequestDispatcher(targetURL);
		rd.forward(request, response);
	}
}
