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
		
		String tranPageFlag = "false";
		String tranPage = "index.jsp";
		String strMessage = "In Processing, Please Wait...";
		String targetURL = "/systemMassage.jsp";
		
		adminLoginBean adLB = new adminLoginBean();

		String operation = request.getParameter("oper");

		if (operation.equals("admin_login")) {
			String passwd = request.getParameter("admin_password");
			if (adLB.adminLogin(passwd)) {
				HttpSession session = request.getSession(true);
				session.setAttribute("loginFlag", "true");
				if (passwd.equals("crawler")) {
					strMessage = "Login success, please change your password.";
					tranPage = "changePW.jsp";
				}
				System.out.println(session.getAttribute("loginFlag").toString());
				System.out.println("login...");
			}
		}
		
		if (operation.equals("changePW")) {
			String strNewPasswd = request.getParameter("newPassword");
			String strConNewPasswd = request.getParameter("newConPassword");

			if (!strNewPasswd.equals(strConNewPasswd)){
				strMessage = "Password is not identical, please check again";
				tranPage = "changePW.jsp";
			} else {
				try {
					adLB.changePW(strNewPasswd);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				strMessage = "Change Successful!";
				tranPage = "settings.jsp";
			}
		}
		
		request.setAttribute("tranPageFlag", tranPageFlag);
		request.setAttribute("strMessage", strMessage);
		request.setAttribute("tranPage", tranPage);
		RequestDispatcher rd;
		rd = getServletContext().getRequestDispatcher(targetURL);
		rd.forward(request, response);
	}
}
