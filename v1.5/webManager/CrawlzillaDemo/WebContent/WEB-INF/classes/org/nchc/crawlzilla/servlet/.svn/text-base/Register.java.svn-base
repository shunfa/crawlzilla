package org.nchc.crawlzilla.servlet;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.nchc.crawlzilla.bean.RegisterBean;

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
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		RegisterBean regNew = new RegisterBean();		
		String newUser = request.getParameter("newUser");
		String passwd = request.getParameter("setPasswd");
		String confPasswd = request.getParameter("confPasswd");
		String email = request.getParameter("userEmail");
		String targetURL="/systemMessage.jsp";
		
		if (regNew.checkUserExist(newUser)){
			String message = "系統已存在" + newUser + "！ <p> 請返回上一頁重新輸入</p>";
			request.setAttribute("message", message);
			RequestDispatcher rd;
	        rd = getServletContext().getRequestDispatcher(targetURL);
	        rd.forward(request, response);
			System.out.println("user " + newUser + " exist!");
		} else if (passwd.equals(confPasswd)){
				try {
					regNew.regNewUser(newUser, passwd, email);
				} catch (NoSuchAlgorithmException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				String message = newUser + "註冊成功！ <p> 請等待管理員啟動帳號後即可登入！</p>";
				request.setAttribute("message", message);
				RequestDispatcher rd;
				rd = getServletContext().getRequestDispatcher(targetURL);
				rd.forward(request, response);
				System.out.println("Register Success!");	
			} else if(!passwd.equals(confPasswd) || passwd.equals("") || passwd.equals(null)){
				String message = "密碼輸入不一致 <p> 請返回上一頁重新輸入！</p>";
				request.setAttribute("message", message);
				RequestDispatcher rd;
		        rd = getServletContext().getRequestDispatcher(targetURL);
		        rd.forward(request, response);
				System.out.println("passwd not match!");
			}
		}
	}
