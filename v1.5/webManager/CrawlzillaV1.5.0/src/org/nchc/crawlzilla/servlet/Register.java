package org.nchc.crawlzilla.servlet;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.nchc.crawlzilla.bean.OperFileBean;
import org.nchc.crawlzilla.bean.RegisterBean;
import org.nchc.crawlzilla.bean.sendMailBean;

/**
 * Servlet implementation class Register
 */
public class Register extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Register() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		RegisterBean regNew = new RegisterBean();
		sendMailBean sendMail = new sendMailBean();

		String newUser = request.getParameter("newUser");
		String passwd = request.getParameter("setPasswd");
		String confPasswd = request.getParameter("confPasswd");
		String email = request.getParameter("userEmail");
		String targetURL = "/systemMessage.jsp";
		RequestDispatcher rd;
		String message = "";
		if (regNew.checkUserExist(newUser)) {
			// user existed
			message = newUser
					+ " has been existed: ！ <p> return to previous page</p>";
			System.out.println("user " + newUser + " exist!");
		} else if(_StringFilter(newUser)) {
			message = "Do not use symbol as account！ <p> return to previous page</p>";
			System.out.println("user " + newUser + " exist!");
			
			
		}else if (!passwd.equals(confPasswd) || passwd.equals("")
				|| passwd.equals(null)) {
			message = "passwd not match!</p>";
			
			System.out.println("passwd not match!");
		}
		else if (passwd.equals(confPasswd)) {
			OperFileBean operFile = new OperFileBean(
					"/home/crawler/crawlzilla/user/admin/meta/email");
			String adminEmail = operFile.getFileStr();
			String webAddr = operFile
					.readFileStr("/home/crawler/crawlzilla/meta/webAddr");
			//# check ceating file or not
			if (!regNew.regNewUser(newUser, passwd, email)) {
				//# some things error on /home/crawler/crawlzilla/applyUser/...
				
			} else {
				
				try {
					String mailMesg = "Hi, there is a new user \""
							+ newUser
							+ "\" want to join crawlzilla.\n\nPlease check the option of system setting to verify.\n\ncheck to: "
							+ webAddr;

					sendMail.sendMail("Apply User", adminEmail, mailMesg);

					message = newUser
							+ "Registration Success！ <p> please wait for admin to check！</p>";


				} catch (InterruptedException e) {
					message = e.getMessage();
					System.err.println(message);
				} catch (AddressException e) {
					message = e.getMessage();
					System.err.println(message);
				} catch (MessagingException e) {
					message = e.getMessage();
					System.err.println(message);
				}
			}
		} else {
			
			message = "Some time error!";
			System.err.println(message);
		}
		request.setAttribute("message", message);
		rd = getServletContext().getRequestDispatcher(targetURL);
		rd.forward(request, response);
	}
	public static boolean _StringFilter(String str) throws PatternSyntaxException {
		// String regEx = "[^a-zA-Z0-9]";
		String regEx = "[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]";
		boolean checkFlag = false;

		Pattern p = Pattern.compile(regEx);
		Matcher m = p.matcher(str);
		while(m.find()){
			checkFlag = true;
		}
		return checkFlag;
	}
}
